function inds = subsindex(obj)
% Overload the subsindex method for Image objects.
%
%   INDS = subsindex(IMG)
%
%   Example
%   subsindex
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if ~islogical(obj.Data)
    error('Use of subsindex is allowed only for binary Image objects');
end

inds = find(obj.Data) - 1;
