function res = ismember(this, values)
%ISMEMBER  Override the ismember function
%
%   RES = ismember(IMG, VALUES);
%   Returns a binary image the same size as the input image. The value of
%   the element in RES is TRUE when the correponding element in input image
%   has a value contained in the array of values given by VALUES.
%
%   Example
%     ismember
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

dat = ismember(this.data, values);
res = Image('data', dat, 'parent', this, 'type', 'binary');

