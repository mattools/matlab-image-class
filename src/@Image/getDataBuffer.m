function data = getDataBuffer(this)
% Return the inner data buffer of the image, in XYZCT order.
%
%   DATA = getDataBuffer(IMG);
%   Equivalent to:
%   DATA = IMG.Data;
%
%   Example
%   getDataBuffer
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

data = this.Data;
