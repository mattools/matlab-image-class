function type = getDataType(this)
%GETDATATYPE  Return datatype of internal buffer
%
%   TYPE = IMG.getDataType();
%
%   Example
%   img = Image2D('cameraman.tif');
%   img.getDataType()
%   ans = 
%       uint8
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% Returns class name of data stored in internal buffer
type = class(this.data);
