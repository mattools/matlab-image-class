function res = imag(obj)
% Get the imaginary part of a complex image.
%
%   RES = imag(IMG)
%
%   Example
%   imag
%
%   See also
%     real
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

res = Image('data', imag(obj.Data), 'parent', obj);
