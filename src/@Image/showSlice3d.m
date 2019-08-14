function hs = showSlice3d(obj, dim, varargin)
% Show a moving 3D slice of an image.
%
%   showSlice3d(IMG, DIR)
%   showSlice3d(IMG, DIR, INDEX)
%   IMG is a 3D image. It can be grayscale, color, or vector.
%   DIM is the direction of slicing, that can be:
%   1, corresponding to the 'x' direction
%   2, corresponding to the 'y' direction
%   3, corresponding to the 'z' direction
%   INDEX is the index of the slice in the corresponding direction. Default
%   is the middle of the image in the given direction.
%
%   showSlice3d(..., 'ColorMap', MAP)
%   Specifies a color map for diplaying grayscale images.
%
%   showSlice3d(..., 'displayRange', RANGE)
%   Specifies the range in which image data should be displayed. RANGE is a
%   1-by-2 row vector containing values of min and max values corresponding
%   to displayed black and white respectively.
%
%   See also
%     showOrthoSlices, showXSlice, showYSlice, showZSlice, showOrthoPlanes
%
%   References
%   Largely inspired by file 'slice3i' from Anders Brun, see FEx:
%   http://www.mathworks.fr/matlabcentral/fileexchange/25923
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Initialisations

% get image size (in x, y, z order)
siz = size(obj);

% use a default position if not specified
if nargin < 3 || ischar(varargin{1})
    index = ceil(siz / 2);
else
    index = varargin{1};
    varargin(1) = [];
end

% check axis direction
dim = parseAxisIndex(dim);

% initialize transform matrix from index coords to physical coords
dcm = diag([obj.Spacing 1]);
dcm(1:3, 4) = obj.Origin;

% default display calibration
displayRange = [];
lut = [];

% extract display calibration
while length(varargin) > 1
    param = varargin{1};
    switch lower(param)
        case 'displayrange'
            displayRange = varargin{2};
        case {'lut', 'colormap'}
            lut = varargin{2};
            if ischar(lut)
                lut = feval(lut, 256);
            end
        otherwise
            error(['Unknown parameter: ' param]);
    end
    varargin(1:2) = [];
end


%% Extract and normalise slice

% extract the slice
planarSlice = slice(obj, dim, index);

displayData = computeSliceRGB(planarSlice, displayRange, lut);


%% Extract slice coordinates

% 
switch dim
    case 1
        % X Slice
        
        % compute coords of u and v
        vy = ((0:siz(2)) + .5);
        vz = ((0:siz(3)) + .5);
        [ydata, zdata] = meshgrid(vy, vz);
        
        % coord of slice supporting plane
        lx = 1:siz(1);
        xdata = ones(size(ydata)) * lx(index);
        
   case 2
        % Y Slice
       
        % compute coords of u and v
        vx = ((0:siz(1)) + .5);
        vz = ((0:siz(3)) + .5);
        [xdata, zdata] = meshgrid(vx, vz);

        % coord of slice supporting plane
        ly = 1:siz(2);
        ydata = ones(size(xdata)) * ly(index);

    case 3
        % Z Slice

        % compute coords of u and v
        vx = ((0:siz(1)) + .5);
        vy = ((0:siz(2)) + .5);
        [xdata, ydata] = meshgrid(vx, vy);
        
        % coord of slice supporting plane
        lz = 1:siz(3);
        zdata = ones(size(xdata)) * lz(index);
        
    otherwise
        error('Unknown stack direction');
end

% transform coordinates from image reference to spatial reference
hdata = ones(1, numel(xdata));
trans = dcm(1:3, :) * [xdata(:)'; ydata(:)'; zdata(:)'; hdata];
xdata(:) = trans(1,:); 
ydata(:) = trans(2,:); 
zdata(:) = trans(3,:); 


%% Display slice in 3D

% global parameters for surface display
params = [{'facecolor', 'texturemap', 'edgecolor', 'none'}, varargin];

% display voxel values in appropriate reference space
hs = surface(xdata, ydata, zdata, displayData, params{:});


% set up slice data
data.handle         = hs;
data.image          = obj;
data.dim            = dim;
data.index          = index;
data.dcm            = dcm;
data.displayRange   = displayRange;
data.lut            = lut;
set(hs, 'UserData', data);

% set up mouse listener
set(hs, 'ButtonDownFcn', @startDragging);



function startDragging(src, event) %#ok<INUSD>
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

% store data for creating ray
data.startRay   = get(gca, 'CurrentPoint');
data.startIndex = data.index;

% update data of slice object
set(src, 'UserData', data);

% store reference to slice object in figure object
hFig = gcbf();
set(hFig, 'UserData', src);

% set up listeners for figure object
set(hFig, 'WindowButtonMotionFcn', @dragSlice);
set(hFig, 'WindowButtonUpFcn', @stopDragging);


function stopDragging(src, event) %#ok<INUSD>
%STOPDRAGGING  One-line description here, please.
%
%   output = stopDragging(input)
%
%   Example
%   stopDragging
%
%   See also
%


% remove figure listeners
hFig = src;
set(hFig, 'WindowButtonUpFcn', '');
set(hFig, 'WindowButtonMotionFcn', '');

% get slice reference
hs   = get(src, 'UserData');
data = get(hs, 'UserData');

% reset slice data
data.startray = [];
set(hs, 'UserData', data);

% reset figure data
set(hFig, 'UserData', []);

% update display
drawnow;


function dragSlice(src, event) %#ok<INUSD>
%DRAGSLICE  One-line description here, please.
%
%   output = dragSlice(input)
%
%   Example
%   dragSlice
%
%   See also
%


%% Extract data

% Extract slice data
hs      = get(src, 'UserData');
data    = get(hs, 'UserData');

% basic checkup
if ~isfield(data, 'startRay')
    return;
end
if isempty(data.startRay)
    return;
end

if ~isfield(data, 'dcm')
    data.dcm = eye(4);
end


%% Compute new slice index

% dimension in xyz
dim = data.dim;

s = data.dcm(1:3, dim);

% Project start ray on slice-axis
a = data.startRay(1, :)';
b = data.startRay(2, :)';

alphabeta = computeAlphaBeta(a, b, s);
alphastart = alphabeta(1);

% Project current ray on slice-axis
currentRay = get(gca, 'CurrentPoint');
a = currentRay(1, :)';
b = currentRay(2, :)';
alphabeta = computeAlphaBeta(a, b, s);
alphanow = alphabeta(1);

% compute difference in positions
slicediff = alphanow - alphastart;

index = data.startIndex + round(slicediff);
index = min(max(1, index), size(data.image, data.dim));
data.index = index;

% Store gui object
set(hs, 'UserData', data);


%% Update content of the surface object with current slice

% extract slice corresponding to current index
planarSlice = slice(data.image, data.dim, data.index);
displayData = computeSliceRGB(planarSlice, data.displayRange, data.lut);
set(hs, 'CData', displayData);


%% Update position of the slice along its direction


imgSize = size(data.image);

meshSize = [size(displayData, 1) size(displayData, 2)] + 1;

isOrtho = sum(abs(data.dcm([2 3 5 7 9 10]))) < 1e-12;

if isOrtho
    % in the case of scaling + translation, use simpler processing
    switch data.dim
        case 1
            xpos = data.index * data.dcm(1,1) + data.dcm(1,4);
            xdata = ones(meshSize) * xpos;
            set(hs, 'xdata', xdata);
            
        case 2
            ypos = data.index * data.dcm(2,2) + data.dcm(2,4);
            ydata = ones(meshSize) * ypos;
            set(hs, 'ydata', ydata);
            
        case 3
            zpos = data.index * data.dcm(3,3) + data.dcm(3,4);
            zdata = ones(meshSize) * zpos;
            set(hs, 'zdata', zdata);
            
        otherwise
            error('Unknown stack direction');
    end
    
else
    % for general matrices, computes transformed coordinates (seems to be
    % slower)
    switch data.dim
        case 1
            % compute coords of u and v
            vy = ((0:imgSize(1)) + .5);
            vz = ((0:imgSize(3)) + .5);
            [ydata, zdata] = meshgrid(vy, vz);

            lx = 1:imgSize(2);
            xdata = ones(size(ydata)) * lx(index);

        case 2
            % compute coords of u and v
            vx = ((0:imgSize(2)) + .5);
            vz = ((0:imgSize(3)) + .5);
            [zdata, xdata] = meshgrid(vz, vx);

            ly = 1:imgSize(1);
            ydata = ones(size(xdata)) * ly(index);

        case 3
            % compute coords of u and v
            vx = ((0:imgSize(2)) + .5);
            vy = ((0:imgSize(1)) + .5);
            [xdata, ydata] = meshgrid(vx, vy);

            lz = 1:imgSize(3);
            zdata = ones(size(xdata)) * lz(index);

        otherwise
            error('Unknown stack direction');
    end

    % transform coordinates from image reference to spatial reference
    hdata = ones(1, numel(xdata));
    trans = data.dcm(1:3,:) * [xdata(:)'; ydata(:)'; zdata(:)'; hdata];
    xdata(:) = trans(1,:); 
    ydata(:) = trans(2,:); 
    zdata(:) = trans(3,:); 
    set(hs, 'xdata', xdata, 'ydata', ydata, 'zdata', zdata);
end

% update display
drawnow;


function alphabeta = computeAlphaBeta(a, b, s)
dab = b - a;
alphabeta = pinv([s'*s -s'*dab ; dab'*s -dab'*dab]) * [s'*a dab'*a]';


function rgb = computeSliceRGB(slice, displayRange, lut)
% Convert image slice to renderable data

% convert to a 2D (or 2D+color) array
data = permute(squeeze(slice.Data), [2 1 3]);

% eventually converts to uint8, rescaling data between 0 and max value
if ~isa(data, 'uint8')
    if isempty(displayRange)
        displayRange = [0 max(data(isfinite(data)))];
    end
    extent = displayRange(2) - displayRange(1);
    data = uint8((double(data) - displayRange(1)) * 255 / extent);
end

if isScalarImage(slice)
    % convert gray-scale slice to RGB slice
    % eventually apply a LUT
    if ~isempty(lut)
        lutMax = max(lut(:));
        dim = size(data);
        rgb = zeros([dim 3], 'uint8');
        
        % compute each channel
        for c = 1:size(lut, 2)
            res = zeros(size(data));
            for i = 0:size(lut)-1
                res(data==i) = lut(i+1, c);
            end
            rgb(:,:,c) = uint8(res * 255 / lutMax);
        end
        
    else
        % if no LUT, simply use gray equivalent
        rgb = repmat(data, [1 1 3]);
    end
    
else
    % if slice is 3D, it is assumed to be RGB image.
    rgb = data;
end

