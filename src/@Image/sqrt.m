function res = sqrt(this)
%SQRT Overload the sqrt operator for image object
%
%   output = sqrt(input)
%
%   Example
%   sqrt
%
%   See also
% 
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = sqrt(this.data);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
