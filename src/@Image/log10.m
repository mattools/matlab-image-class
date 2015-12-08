function res = log10(this)
%LOG10 Overload the log10 operator for image object
%
%   output = log10(input)
%
%   Example
%   log10
%
%   See also
% 
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = log10(double(this.data));

res = Image('data', newData, 'parent', this, 'type', 'intensity');
