function res = imag(this)
%IMAG Get the imaginary part of a complex image
%
%   output = imag(input)
%
%   Example
%   imag
%
%   See also
%   image
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

newData = imag(this.data);

res = Image('data', newData, 'parent', this);
