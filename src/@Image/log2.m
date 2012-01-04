function res = log2(this)
%LOG2 Overload the log2 operator for image object
%
%   output = log2(input)
%
%   Example
%   log2
%
%   See also
% 
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = log2(double(this.data));

res = Image('data', newData, 'parent', this);
