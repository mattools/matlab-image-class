function dat = getBuffer(this)
%GETBUFFER Return data buffer using matlab index convention
%
%   DATA = getBuffer(IMG)
%
%   Example
%   getBuffer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = this.getDimension();
if nd==2
    dat = squeeze(permute(this.data, [2 1 4 5 3]));
else
    dat = squeeze(permute(this.data, [2 1 3:5]));
end