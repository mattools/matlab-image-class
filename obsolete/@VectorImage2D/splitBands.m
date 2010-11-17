function res = splitBands(this)
%SPLITBANDS Return the different bands of the vector image in a cell array
%
%   output = img.splitBands();
%
%   Example
%   splitBands
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('oolip:deprecated', 'deprecated, use splitChannels instead');

nc = this.getComponentNumber();

res = cell(1, nc);
for i=1:nc
    res{i} = Image2D.create('data', this.data(:, :, i), 'parent', this);
end
