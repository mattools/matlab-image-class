function res = permute(this, order)
%PERMUTE permute image dimensions
%
%   IMG2 = permute(IMG, ORDER)
%   rearranges the dimensions of this image IMG so that they are in the
%   order specified by the vector ORDER. 
%
%   Example
%     permute
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-06-17,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.

data2 = permute(this.data, order);
res = Image('data', data2, 'parent', this);
