function res = real(obj)
% Get the real part of a complex image.
%
%   output = real(input)
%
%   Example
%   real
%
%   See also
%     imag
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

newData = real(obj.Data);

res = Image('data', newData, 'parent', obj);
