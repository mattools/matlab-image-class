%DEMOGEOMETRYOPERATORS  One-line description here, please.
%
%   output = demoGeometryOperators(input)
%
%   Example
%   demoGeometryOperators
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-07,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


img = Image.read('cameraman.tif');

% flip in the x-direction
imgFlip = flip(img, 1);
write(imgFlip, 'cameraman-flip.png');

% rotation by 90 degrees
imgRot = rotate90(img, 1);
write(imgRot, 'cameraman-rot90.png');

% sub-sampling by 2
imgSub = subsample(img, 2);
write(imgSub, 'cameraman-sub2.png');

% rotation
imgRot = rotate(img, 30);
write(imgRot, 'cameraman-rot30.png');

% circshift
imgShift = circshift(img, [150 100]);
write(imgShift, 'cameraman-circshift.png');

% Concatenation
imgCat = [img img img ; img img img];
write(imgCat, 'cameraman-concat.png');
