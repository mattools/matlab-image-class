function res = circshift(obj, varargin)
% Overload the circhshift function for Image class.
%
%   RES = circshift(IMG, SHIFT)
%
%   Example
%     img = Image.read('cameraman.tif');
%     res = circshift(img, [100 50]);
%     show(res)
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% process data buffer, using Matlab Image processing Toolbox
data = circshift(obj.Data, varargin{:});

% create new image object for storing result
res = Image.create('data', data, 'parent', obj);
