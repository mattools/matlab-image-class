%OVERVIEW_SEGMENTRICEGRAINS  One-line description here, please.
%
%   output = overview_segmentRiceGrains(input)
%
%   Example
%   overview_segmentRiceGrains
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

img = Image.read('rice.png');

grad = norm(gradient(img));
figure; show(grad, []);

emin = extendedMinima(grad, 10, 4);
grad2 = imposeMinima(grad, emin, 4);
wat = watershed(grad2, 4);

ovr = overlay(img, wat==0, 'g');
figure; show(ovr);

rgb = label2rgb(wat, 'jet', 'w');
figure(show(rgb));

