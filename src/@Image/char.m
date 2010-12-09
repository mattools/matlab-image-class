function string = char(this)
%CHAR Return a character representation of this image object
%
%   output = char(input)
%
%   Example
%   char
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = this.getDimension;

pattern = repmat('%d x ', 1, nd);
pattern(end-2:end) = [];
pattern = [ pattern ' %s'];

string = sprintf(pattern, this.getSize(), this.class());
