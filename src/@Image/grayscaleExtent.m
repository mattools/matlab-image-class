function varargout = grayscaleExtent(this)
%GRAYSCALEEXTENT Grayscale extent of input image data type
%
%   EXTENT = grayscaleExtent(IMG)
%   [GMIN GMAX] = grayscaleExtent(IMG)
%   Returns minimal and maximal values of image data type. If image is of
%   type double, returns the minimal and maximal values of image data.
%   Useful for computing appropriate display scaling.
%
%   Example
%     img = Image.read('cameraman.tif');
%     grayscaleExtent(img)
%     ans = 
%         0   255
%
%   See also
%   intmin, intmax, min, max, dataExtent
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% compute minimal 
if isinteger(this.data)
    type = class(this.data);
    minVal = double(intmin(type));
    maxVal = double(intmax(type));
else
    minVal = double(min(this.data(:)));
    maxVal = double(max(this.data(:)));
end

% format output
if nargout <= 1
    varargout = {[minVal maxVal]};
else
    varargout = {minVal, maxVal};
end
