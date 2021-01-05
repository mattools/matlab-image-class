function res = reconstruction(marker, mask, varargin)
% Morphological reconstruction of marker image under mask image.
%
%   REC = reconstruction(MARKER, MASK)
%   Performs a morphological reconstruction of image defined by MARKER
%   under the mask given by MASK. Both MARKER and MASK should be images the
%   same size and the same type.
%
%   Morphological reconstruction is used as base algorithm for several
%   filters such as border removal, holes filling or extended minima and
%   maxima.
%
%   Example
%     % performs morphological reconstruction to extract the 'w' letter
%     % from a binary image representing text
%     mask = Image.read('text.png');
%     marker = Image.create(size(mask), 'logical');
%     marker(94, 13) = true; % set the marker
%     rec = reconstruction(marker, mask);
%     show(rec);
%
%   See also
%     killBorders, fillHoles, extendedMinima, floodFill, imreconstruct,
%     geodesicDistanceMap

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%   HISTORY

[marker, mask, parent] = parseInputCouple(marker, mask);
data = imreconstruct(marker, mask, varargin{:});

% create result image
name = createNewName(parent, '%s-minima');
res = Image('Data', data, 'Parent', parent, 'Type', parent.Type, 'Name', name);
