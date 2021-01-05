function res = permute(obj, order)
% Permute image dimensions.
%
%   IMG2 = permute(IMG, ORDER)
%   rearranges the dimensions of the image IMG so that they are in the
%   order specified by the vector ORDER. 
%
%   Example
%     permute
%
%   See also
%     transpose
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-06-17,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.

% permute data
data2 = permute(obj.Data, order);

% create result image
name = createNewName(obj, '%s-permute');
res = Image('Data', data2, 'Parent', obj, 'Name', name);
