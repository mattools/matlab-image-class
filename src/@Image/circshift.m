function res = circshift(this, varargin)
%CIRCSHIFT Overlaod the circhshift function for Image class
%
%   RES = circshift(IMG)
%
%   Example
%   circshift
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% process data buffer, using Matlab Image processing Toolbox
data = circshift(this.data, varrargin);

% create new image object for storing result
res = Image.create(data, 'parent', this);
