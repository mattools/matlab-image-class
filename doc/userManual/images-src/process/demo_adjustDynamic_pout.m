%DEMO_ADJUSTDYNAMIC_POUT  One-line description here, please.
%
%   output = demo_adjustDynamic_pout(input)
%
%   Example
%   demo_adjustDynamic_pout
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-10-11,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2018 INRA - Cepia Software Platform.

% read image
img = Image.read('pout.tif');

% computes enhanced image
img2 = adjustDynamic(img, .01);
img2.name = 'pout-adjusted';

% write image
write(img2, 'pout_adjusted.tif');

% display histograms
figure; 
subplot(211); histogram(img);
subplot(212); histogram(img2);

% save figure
print(gcf, 'pout_histograms.png', '-dpng');
