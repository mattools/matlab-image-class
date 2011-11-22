function b = isComplexImage(this)
%ISCOMPLEXIMAGE Checks if an image contains complex values
%
%   B = isComplexImage(IMG)
%   Returns trus if the image is complex, i.e. contains two channels, one
%   for real and the other one for imaginary data.
%
%   Example
%     img = Image.read('cameraman.tif');
%     isComplexImage(img)
%     ans =
%         0
%
%   See also
%     isVectorImage, isGrayscaleImage, isBinaryImage, isIntensityImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'complex');