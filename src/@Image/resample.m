function res = resample(this, k, varargin)
% Resamples image with a given rate
%
%   Example:
%   img = Image2D('cameraman.tif');
%   img2 = img.resample(4);
%   img2.show([])
%

% TODO: split in two functions: copy this one to 'rescale', and use lx+ly
% instead of 'k'

% size of image
siz = this.dataSize;

% compute position of interpolated pixels
lx = linspace(0, siz(1)+1, k*(siz(1)+1)+1);
ly = linspace(0, siz(2)+1, k*(siz(2)+1)+1);

% keep pixels located in image extent
lx = lx(lx>=+.5 & lx<siz(1)+.5);
ly = ly(ly>=+.5 & ly<siz(2)+.5);

% generate pixel grid
[x y] = meshgrid(lx, ly);

% interpolate image at given positions
% TODO: manage different interpolators
interpolator = LinearInterpolator2D(this); 
dat = interpolator.evaluateAtIndex(x, y);

% Create new image with interpolated data
res = Image.create(dat);

% compute basis of new image
lx = (lx-1)*this.spacing(1) + this.origin(1);
ly = (ly-1)*this.spacing(2) + this.origin(2);

% set up new image
res.origin = [lx(1) ly(1)];
res.spacing = [lx(2)-lx(1) ly(2)-ly(1)];
