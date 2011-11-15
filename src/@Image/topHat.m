function res = topHat(this, varargin)
%TOPHAT Top-Hat transform of an intensity or binary image
%
%   Deprecated, use "whiteTopHat" instead.
%
%
%   See also
%     whiteTopHat
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

warning('Image:deprecated', ...
    'method "topHat" is deprecated, use "whiteTopHat" instead');

dat = imtophat(this.data, varargin{1});

% create result image
res = Image(this.dimension, 'data', dat, 'parent', this);
