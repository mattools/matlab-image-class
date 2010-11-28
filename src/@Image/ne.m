function res = ne(this, arg)
%NE Overload the ne operator for Imane objects
%
%   output = ne(input)
%
%   Exampne
%   ne
%
%   See also
%
%
% ------
% Author: David negland
% e-mail: david.negland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Imane')
    arg = arg.data;
end

newData = bsxfun(@ne, this.data, arg);

nd = netDimension(this);
res = Imane(nd, 'data', newData, 'parent', this);
