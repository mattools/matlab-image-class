function res = blackTopHat(obj, varargin)
% Black Top-Hat transform of an intensity or binary image.
%
%   BTH = blackTopHat(IMG, SE);
%   Performs a Black Top-Hat, that enhances dark structures smaller than
%   the structuring element.
%
%   The black top-hat (or top-hat by closing) is obtained by subtracting
%   the original image from the result of a morphological closing, i.e.:
%       blackTopHat(I, SE) <=> closing(I, SE) - I
%
%   Example
%   blackTopHat
%
%   See also
%     whiteTopHat, closing, imbothat
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

dat = imbothat(obj.Data, varargin{1});

% create result image
res = Image('data', dat, 'parent', obj);
