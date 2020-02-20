function varargout = dataExtent(obj, varargin)
% Intensity extent of image data.
%
%   EXTENT = dataExtent(IMG)
%   [VMIN, VMAX] = dataExtent(IMG)
%   Returns minimal and maximal intensity values in image. 
%
%   Example
%     img = Image.read('cameraman.tif');
%     dataExtent(img)
%     ans = 
%         7   253
%
%   See also
%     min, max, dataTypeExtent
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if isempty(varargin)
    % compute minimal and maximal values
    minVal = double(min(obj.Data(:)));
    maxVal = double(max(obj.Data(:)));
else
    % compute minimal and maximal values within a mask
    roi = varargin{1};
    minVal = double(min(obj.Data(roi)));
    maxVal = double(max(obj.Data(roi)));
end


% format output
if nargout <= 1
    varargout = {[minVal maxVal]};
else
    varargout = {minVal, maxVal};
end
