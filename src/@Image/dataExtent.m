function varargout = dataExtent(this, varargin)
%DATAEXTENT Intensity extent of image data 
%
%   EXTENT = dataExtent(IMG)
%   [VMIN VMAX] = dataExtent(IMG)
%   Returns minimal and maximal intensity values in image. 
%
%   Example
%     img = Image.read('cameraman.tif');
%     dataExtent(img)
%     ans = 
%         7   253
%
%   See also
%   min, max, grayscaleExtent
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if isempty(varargin)
    % compute minimal and maximal values
    minVal = double(min(this.data(:)));
    maxVal = double(max(this.data(:)));
else
    % compute minimal and maximal values within a mask
    roi = varargin{1};
    minVal = double(min(this.data(roi)));
    maxVal = double(max(this.data(roi)));
end


% format output
if nargout <= 1
    varargout = {[minVal maxVal]};
else
    varargout = {minVal, maxVal};
end
