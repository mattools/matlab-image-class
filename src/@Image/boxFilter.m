function res = boxFilter(obj, filterSize, varargin)
% Box filtering of an image, computing mean value in pixel neighborhood.
%
%   RES = boxFilter(IMG, SE);
%   Compute the box filter of image IMG, by performing linear filter using
%   rectangular neighborhod.
%
%   Example
%     % Box filtering of planar image
%     img = Image.read('cameraman.tif');
%     imgf = boxFilter(img, [5 5]);
%     figure; show(imgf);
%
%     % Box filtering of a 3D image
%     mriData = load('mri');
%     img = Image(squeeze(mriData.D));
%     imgf = boxFilter(img, [5 5 3]);
% 
%   See also:
%   medianFilter, gaussianFilter, meanFilter, imboxfilt, imboxfilt3
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-11-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nd = ndims(obj);

if nargin < 2
    filterSize = 3 * ones(1, nd);
end

% perform filtering
if nd == 2
    data = imboxfilt(obj.Data, filterSize, varargin{:});
elseif nd == 3
    data = imboxfilt3(obj.Data, filterSize, varargin{:});
end

% create result image
name = createNewName(obj, '%s-boxFilt');
res = Image('Data', data, 'Parent', obj, 'Name', name);
