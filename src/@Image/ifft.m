function res = ifft(this)
%IFFT  Inverse Fourier Transform of an image
%
%   output = ifft(input)
%
%   Example
%     img = Image.read('cameraman.tif');
%     imgf = fft(img);
%     imgf(51:206,:) = 0;
%     imgf(:,51:206) = 0;
%     show(fftshift(log(abs(imgf))))
%     img2 = ifft(imgf);
%     show(abs(img2));
%
%   See also
%    fft, ifftshift
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% process data buffer, using Matlab Image processing Toolbox
data = ifftn(this.data);

% create new image object for storing result
res = Image('data', data, 'parent', this, 'type', 'complex');
