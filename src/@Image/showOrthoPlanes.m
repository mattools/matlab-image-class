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
    siz = this.dataSize;
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

% prepare display
clf;


%% Display XY Slice

subplot(2, 2, 1); hold on;

show(sliceXY, 'xdata', xdata, 'ydata', ydata);

line([xdata(1) xdata(end)], [yPos yPos], 'color', 'r');
line([xPos xPos], [ydata(1) ydata(end)], 'color', 'r');

if ~isempty(this.axisNames)
    xlabel(this.getAxisName(1));
    ylabel(this.getAxisName(2));
end


%% Display ZY Slice

subplot(2, 2, 2); hold on;

show(sliceZY, 'xdata', zdata, 'ydata', ydata);

line([zdata(1) zdata(end)], [yPos yPos], 'color', 'r');
line([zPos zPos], [ydata(1) ydata(end)], 'color', 'r');

if ~isempty(this.axisNames)
    xlabel(this.getAxisName(2));
    ylabel(this.getAxisName(3));
end


%% Display XZ Slice

subplot(2, 2, 3); hold on;

show(sliceXZ, 'xdata', xdata, 'ydata', zdata);

line([xdata(1) xdata(end)], [zPos zPos], 'color', 'r');
line([xPos xPos], [zdata(1) zdata(end)], 'color', 'r');

if ~isempty(this.axisNames)
    xlabel(this.getAxisName(1));
    ylabel(this.getAxisName(3));
end


%% Display Orthoslices

subplot(2, 2, 4);

this.showOrthoSlices(pos);

line([xdata(1) xdata(end)], [yPos yPos], [zPos zPos], 'color', 'r');
line([xPos xPos], [ydata(1) ydata(end)], [zPos zPos], 'color', 'r');
line([xPos xPos], [yPos yPos], [zdata(1) zdata(end)], 'color', 'r');

view([-20 30]);

axis equal;

