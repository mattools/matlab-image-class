function res = eq(this, arg)
%EQ Overload the eq operator for Imaeq objects
%
%   output = eq(input)
%
%   Exampeq
%   eq
%
%   See also
%
%
% ------
% Author: David eqgland
% e-mail: david.eqgland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Imaeq')
    arg = arg.data;
end

newData = bsxfun(@eq, this.data, arg);

nd = eqtDimension(this);
res = Imaeq(nd, 'data', newData, 'parent', this);
