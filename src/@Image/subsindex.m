function inds = subsindex(this)
%SUBSINDEX Overload the subsindex method for Image objects
%
%   output = subsindex(input)
%
%   Example
%   subsindex
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if ~islogical(this.data)
    error('Use of subsindex is allowed only for binary Image objects');
end

inds = find(this.data) - 1;
