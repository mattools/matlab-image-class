function band = getBand(this, index)
%GETBAND Return a specific band of a 2D Vector Image
%
%   BAND = img.getBand(INDEX)
%   INDEX is 1-referenced.
%
%   Example
%   getBand
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('oolip:deprecated', 'deprecated, use getChannel instead');

% create a new Image2D from data
band = Image2D('data', this.data(:,:,index), 'parent', this);
