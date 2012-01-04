function res = ifftshift(this)
%IFFTSHIFT Shift the zero frequency of spectrum image to the center
%
%   RES = ifftshift(IMG)
%
%   Example
%   ifftshift
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
data = ifftshift(this.data);

% create new image object for storing result
res = Image('data', data, 'parent', this);
