function s = size(this)
%SIZE Return image size
%
%   B = img.size();
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   img.size()
%   ans =
%       256 256
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

s = this.dataSize;