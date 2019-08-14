function type = getDataType(this)
% Return datatype of internal buffer.
%
%   TYPE = getDataType(IMG);
%
%   Example
%   img = Image2D('cameraman.tif');
%   getDataType(img)
%   ans = 
%       uint8
%
%   See also
%     class
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% Returns class name of data stored in internal buffer
type = class(this.Data);
