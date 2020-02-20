function varargout = dataTypeExtent(obj)
% Extent of input image data type.
%
%   EXTENT = dataTypeExtent(IMG)
%   [IMIN, IMAX] = dataTypeExtent(IMG)
%   Returns minimal and maximal values of image data type. If image is of
%   type double, returns the minimal and maximal values of image data.
%   Useful for computing appropriate display scaling.
%
%   Example
%     img = Image.read('cameraman.tif');
%     dataTypeExtent(img)
%     ans = 
%         0   255
%
%   See also
%     intmin, intmax, min, max, dataExtent
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRAE - Cepia Software Platform.

% extract type
type = class(obj.Data);

% compute type extent
if isinteger(obj.Data)
    minVal = double(intmin(type));
    maxVal = double(intmax(type));
else
    maxVal = realmax(realmax(type));
    minVal = -maxVal;
end

% format output
if nargout <= 1
    varargout = {[minVal maxVal]};
else
    varargout = {minVal, maxVal};
end
