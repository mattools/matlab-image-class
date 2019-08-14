function res = skeleton(obj, varargin)
% Skeleton of a binary planar image.
%
%   SKEL = skeleton(BIN)
%   Computes the skeleton of the binary image BIN. The result is a binary
%   image the same size as BIN.
%
%   SKEL = skeleton(BIN, 'method', METHOD)
%   Specifies the method used for skeletonization. METHOD can be one of:
%     'thin' (the default)
%     'skel' (produces more small branches)
%
%   Example
%       bin = Image.read('circles.png');
%       skel = skeleton(bin);
%       show(overlay(bin, skel));
%
%   See also
%     bwmorph
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Parse input arguments

% Error checks
if obj.Dimension ~= 2
    error('Image:skeleton:WrongDimension', 'Input image should have dimension 2');
end

if ~strcmp(obj.Type, 'binary')
    error('Image:skeleton:WrongType', 'Input image should be binary');
end

% default arguments
method = 'thin';

% if only one argument is given, it is assumed to be the method name
if length(varargin) == 1
    method = varargin{1};
    varargin(1) = [];
end

% extract input arguments
while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'method'
            method = varargin{2};
        otherwise
            error(['Unknown parameter name: ' paramName]);
    end

    varargin(1:2) = [];
end


%% Processing

% compute skeleton
binData = bwmorph(obj.Data, method, inf);

% create result image
res = Image('data', binData, 'parent', obj);
