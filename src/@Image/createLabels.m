function [res, num] = createLabels(obj, conn)
% Connected components labeling of a binary image.
%
%   Deprecated, use "componentLabeling" instead.

%   LBL = createLabels(BIN);
%   where BIN is either a 2D or 3D binary image, returns a label image of
%   the connected components of image BIN.
%
%   LBL = createLabels(BIN, CONN);
%   Specifies the connectivity to use, can be 4 or 8 for 2D images, 6, 18
%   or 26 for 3D images.
%
%   Example
%     createLabels
%
%   See also
%     componentLabeling
%

warning('Function "createLabels" is deprecated, use "componentLabeling" instead');

% check image data type
if ~strcmp(obj.Type, 'binary')
    error('Image:createLabels:WrongArgument', ...
        'Function "createLabels" requires a binary image as input');
end

% extract image dimension
nd = ndims(obj);

% setup default connectivity
if nargin < 2
    if nd == 2
        conn = 8;
    else
        conn = 26;
    end
end

% call the label function
if nd == 2
    [labels, num] = bwlabel(obj.Data, conn);
else
    [labels, num] = bwlabeln(obj.Data, conn);
end

% create new image with result of filtering
res = Image(...
    'data', labels, ...
    'parent', obj, 'type', 'label');
    
    