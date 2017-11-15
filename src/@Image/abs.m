function res = abs(this)
%ABS Overload the abs operator for image object
%
%   output = abs(input)
%
%   Example
%   abs
%
%   See also
% 

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = abs(this.data);

res = Image('data', newData, 'parent', this);
