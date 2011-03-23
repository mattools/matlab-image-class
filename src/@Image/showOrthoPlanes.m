function showOrthoPlanes(this, varargin)
%SHOWORTHOPLANES Show three orthogonal slices in separate axes
%
%   this.showOrthoPlanes(POS)
%   POS is 1*3 row vector containing position of slices intersection point,
%   in image index coordinate between 0 and size(img)-1.
%
%   Example
%     data = analyze75read(analyze75info('brainMRI.hdr'));
%     img = Image3D(data);
%     figure(1); clf; hold on;
%     img.showOrthoPlanes([60 80 13]);
%     axis(img.getPhysicalExtent());       % setup axis limits
%     axis equal;                          % to have equal sizes
%
%   See also
%   showOrthoSlices, showXSlice, showYSlice, showZSlice, getSlice
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Extract input arguments

% if no position is specified, use the center of image
if isempty(varargin)
    siz = this.getSize();
    pos = floor(siz/2);
else
    pos = varargin{1};
end


%% Extract data

% extract each slice
sliceXY = squeeze(this.getSlice(3, pos(3)));
sliceZY = squeeze(this.getSlice(1, pos(1)))';
sliceXZ = squeeze(this.getSlice(2, pos(2)));

% get spatial calibration
xdata = this.getXData();
ydata = this.getYData();
zdata = this.getZData();

% coordinate of reference point
xPos = xdata(pos(1));
yPos = ydata(pos(2));
zPos = zdata(pos(3));

% physical size of image in each dimension
wx = xdata([1 end]);
wy = ydata([1 end]);
wz = zdata([1 end]);

% amount of space used by each axis
width1  = wx / (wx + wz);
width2  = wz / (wx + wz);
height1 = wy / (wy + wz);
height2 = wz / (wy + wz);


%% Display XY Slice

subplot(2, 2, 1); hold on;

% refresh figure
hf = gcf; clf;


% create XY axis
axes('parent', hf, 'units', 'normalized', 'visible', 'off', ...
    'position', [0 height2 width1 height1]);
hSliceXY = show(sliceXY, 'xdata', xdata, 'ydata', ydata);

hLineXYx = line([xdata(1) xdata(end)], [yPos yPos], 'color', 'r');
hLineXYy = line([xPos xPos], [ydata(1) ydata(end)], 'color', 'r');

% set up slice data
data.handle = hSliceXY;
data.fig    = hf;
data.dir    = 3;
data.dir1   = 1;
data.dir2   = 2;
data.index  = pos(3);
data.xdata  = xdata;
data.ydata  = ydata;
set(hSliceXY, 'UserData', data);

% set up mouse listener
set(hSliceXY, 'ButtonDownFcn', @startDragCrossLine);


%% Display ZY Slice

% create ZY axis
axes('parent', hf, 'units', 'normalized', 'visible', 'off', ...
    'position', [width1 height2 width2 height1]);
hSliceZY = show(sliceZY, 'xdata', zdata, 'ydata', ydata);

hLineZYz = line([zdata(1) zdata(end)], [yPos yPos], 'color', 'r');
hLineZYy = line([zPos zPos], [ydata(1) ydata(end)], 'color', 'r');

% set up slice data
data.handle = hSliceZY;
data.fig    = hf;
data.dir    = 1;
data.dir1   = 3;
data.dir2   = 2;
data.index  = pos(1);
data.xdata  = zdata;
data.ydata  = ydata;
set(hSliceZY, 'UserData', data);

% set up mouse listener
set(hSliceZY, 'ButtonDownFcn', @startDragCrossLine);


%% Display XZ Slice

% create XY axis
axes('parent', hf, 'units', 'normalized', 'visible', 'off', ...
    'position', [0 0 width1 height2]);
hSliceXZ = show(sliceXZ, 'xdata', xdata, 'ydata', zdata);

hLineXZx = line([xdata(1) xdata(end)], [zPos zPos], 'color', 'r');
hLineXZz = line([xPos xPos], [zdata(1) zdata(end)], 'color', 'r');

% set up slice data
data.handle = hSliceXZ;
data.fig    = hf;
data.dir    = 2;
data.dir1   = 1;
data.dir2   = 3;
data.index  = pos(2);
data.xdata  = xdata;
data.ydata  = zdata;
set(hSliceXZ, 'UserData', data);

% set up mouse listener
set(hSliceXZ, 'ButtonDownFcn', @startDragCrossLine);



%% Display Orthoslices

axes('parent', hf, 'units', 'normalized', 'visible', 'off', ...
    'position', [width1 0 width2 height2], ...
    'ydir', 'reverse', 'zdir', 'reverse');
[hSlice3dXY hSlice3dYZ hSlice3dXZ] = this.showOrthoSlices(pos);

% show orthogonal lines
hLine3dX = line([xdata(1) xdata(end)], [yPos yPos], [zPos zPos], 'color', 'r');
hLine3dY = line([xPos xPos], [ydata(1) ydata(end)], [zPos zPos], 'color', 'r');
hLine3dZ = line([xPos xPos], [yPos yPos], [zdata(1) zdata(end)], 'color', 'r');

view([-20 30]);

axis equal;


%% Create GUI for figure

% clear struct
data = struct;

% general data common to all displays
data.img = this;
data.pos = pos;

% spatial basis
data.bases  = {xdata, ydata, zdata};

% handles to image displays
data.hSliceXY = hSliceXY;
data.hSliceZY = hSliceZY;
data.hSliceXZ = hSliceXZ;

% handles to 3D slice displays
data.hSlice3dXY = hSlice3dXY;
data.hSlice3dYZ = hSlice3dYZ;
data.hSlice3dXZ = hSlice3dXZ;

% handles to ortho lines 
data.hLineXYx = hLineXYx;
data.hLineXYy = hLineXYy;
data.hLineZYz = hLineZYz;
data.hLineZYy = hLineZYy;
data.hLineXZx = hLineXZx;
data.hLineXZz = hLineXZz;

data.hLine3dX = hLine3dX;
data.hLine3dY = hLine3dY;
data.hLine3dZ = hLine3dZ;

% will contain current callback object
data.src = [];


set(hf, 'UserData', data);



function startDragCrossLine(src, event) %#ok<INUSD>
%STARTDRAGGING  One-line description here, please.
%
%   output = startDragging(input)
%
%   Example
%   startDragging
%
%   See also
%


data = get(src, 'UserData');

% direction of slicing (normal to the slice)
dir1 = data.dir1;
dir2 = data.dir2;
%disp(['Click on orthoslice - ' num2str(dir1) num2str(dir2)]);


hFig = gcbf();
dataFig = get(hFig, 'UserData');
pos = dataFig.pos;

point = get(gca, 'CurrentPoint');
point = point(1, 1:2);

% convert indices to physical coordinates
xdata = dataFig.bases{dir1};
ydata = dataFig.bases{dir2};
[mini pos(dir1)] = min((xdata - point(1)).^2); %#ok<ASGLU>
[mini pos(dir2)] = min((ydata - point(2)).^2); %#ok<ASGLU>


dataFig.pos = pos;
dataFig.src = src;

set(hFig, 'UserData', dataFig);


updateDisplay(hFig);

% set up listeners for figure object
set(hFig, 'WindowButtonMotionFcn', @dragCrossLine);
set(hFig, 'WindowButtonUpFcn', @stopDragCrossLine);


function stopDragCrossLine(src, event) %#ok<INUSD>
%stopDragCrossLine  One-line description here, please.
%
%   output = stopDragCrossLine(input)
%
%   Example
%   stopDragCrossLine
%
%   See also
%


% remove figure listeners
hFig = src;
set(hFig, 'WindowButtonUpFcn', '');
set(hFig, 'WindowButtonMotionFcn', '');


function dragCrossLine(src, event) %#ok<INUSD>
%DRAGSLICE  One-line description here, please.
%
%   output = dragSlice(input)
%
%   Example
%   dragSlice
%
%   See also
%


% extract handle to image object
data = get(src, 'UserData');
hImg = data.src;
pos = data.pos;

% position of last click
point = get(gca, 'CurrentPoint');
point = point(1, 1:2);

% main directions of current slice
imgData = get(hImg, 'UserData');
dir1 = imgData.dir1;
dir2 = imgData.dir2;

% convert indices to physical coordinates
xdata = data.bases{dir1};
ydata = data.bases{dir2};
[mini pos(dir1)] = min((xdata - point(1)).^2); %#ok<ASGLU>
[mini pos(dir2)] = min((ydata - point(2)).^2); %#ok<ASGLU>

% update data for current figure
data.pos = pos;
set(src, 'UserData', data);

% redraw
updateDisplay(src);


function updateDisplay(hFig)

% get dat of current image
data = get(hFig, 'UserData');
img = data.img;
pos = data.pos;

% extract each slice
sliceXY = squeeze(img.getSlice(3, pos(3)));
sliceZY = squeeze(img.getSlice(1, pos(1)));
sliceXZ = squeeze(img.getSlice(2, pos(2)));

% get spatial calibration
xdata = img.getXData();
ydata = img.getYData();
zdata = img.getZData();

% coordinate of reference point
xpos = xdata(pos(1));
ypos = ydata(pos(2));
zpos = zdata(pos(3));


% update planar image displays
buf = sliceXY.getBuffer;
set(data.hSliceXY, 'CData', buf);
set(data.hSlice3dXY, 'CData', buf);

buf = sliceZY.getBuffer;
set(data.hSliceZY, 'CData', permute(buf, [2 1 3]));
set(data.hSlice3dYZ, 'CData', buf);

buf = sliceXZ.getBuffer;
set(data.hSliceXZ, 'CData', buf);
set(data.hSlice3dXZ, 'CData', buf);

% update position of orthogonal lines
set(data.hLineXYx, 'YData', [ypos ypos]);
set(data.hLineXYy, 'XData', [xpos xpos]);
set(data.hLineZYz, 'YData', [ypos ypos]);
set(data.hLineZYy, 'XData', [zpos zpos]);
set(data.hLineXZx, 'YData', [zpos zpos]);
set(data.hLineXZz, 'XData', [xpos xpos]);

% update position of 3D orthogonal lines
set(data.hLine3dX, 'YData', [ypos ypos]);
set(data.hLine3dX, 'ZData', [zpos zpos]);
set(data.hLine3dY, 'XData', [xpos xpos]);
set(data.hLine3dY, 'ZData', [zpos zpos]);
set(data.hLine3dZ, 'XData', [xpos xpos]);
set(data.hLine3dZ, 'YData', [ypos ypos]);


% update position of 3D slices
coords = get(data.hSlice3dXY, 'ZData');
coords(:) = zpos;
set(data.hSlice3dXY, 'ZData', coords);

coords = get(data.hSlice3dYZ, 'XData');
coords(:) = xpos;
set(data.hSlice3dYZ, 'XData', coords);

coords = get(data.hSlice3dXZ, 'YData');
coords(:) = ypos;
set(data.hSlice3dXZ, 'YData', coords);

