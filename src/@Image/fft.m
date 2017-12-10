function res = fft(this)
%FFT Fast-Fourier transform of an image
%
%   RES = fft(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     imgf = fft(img);
%     show(fftshift(log(abs(imgf))))
%
%   See also
%   ifft, fftshift, abs
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% process data buffer, using Matlab Image processing Toolbox
data = fftn(this.data);

% create new image object for storing result
res = Image('data', data, 'parent', this, 'type', 'complex');
