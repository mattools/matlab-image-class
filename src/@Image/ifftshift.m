function res = ifftshift(obj)
% Shift the zero frequency of spectrum image from center to corner.
%
%   RES = ifftshift(IMG)
%
%   Example
%   ifftshift
%
%   See also
%     fftshift, fft
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% process data buffer, using Matlab Image processing Toolbox
data = ifftshift(obj.Data);

% create new image object for storing result
res = Image('data', data, 'parent', obj);
