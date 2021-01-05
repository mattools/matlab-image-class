function res = whiteTopHat(obj, varargin)
% White Top-Hat transform of an intensity or binary image.
%
%   WTH = whiteTopHat(IMG, SE)
%   Performs a White Top-Hat, that enhances bright structures smaller than
%   the structuring element.
%
%   The white top-hat (or top-hat by opening) is obtained by subtracting
%   the result of a morphological opening from the original image, i.e.:
%       whiteTopHat(I, SE) <=> I - opening(I, SE)
%
%   Example
%     % white top-hat filtering of rice image to remove bright background
%     img = Image.read('rice.png');
%     figure; show(original); title('original');
%     se = strel('disk', 12);
%     wth = whiteTopHat(img, se);
%     figure; show(wth); title('White Top-Hat');
%
%   See also
%     blackTopHat, opening, imtophat
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-06-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

datz = imtophat(obj.Data, varargin{1});

% create result image
name = createNewName(obj, '%s-WTH');
res = Image('Data', datz, 'Parent', obj, 'Name', name);
