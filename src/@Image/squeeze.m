function res = squeeze(this)
%SQUEEZE Remove singleton spatial dimensions of an image
%
%   output = squeeze(input)
%
%   Example
%   squeeze
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

keepDims = find(this.dataSize(1:3)~=1);

nd = length(keepDims);

res = Image(nd, 'data', squeeze(this.data));
