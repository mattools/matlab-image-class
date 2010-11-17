function res = interpolate(this, x, y, varargin)
% Interpolates value of image for new positions
%   
%   IMG2 = img.interpolate(X, Y);
%   X and Y must be m*n array the same size
%   the result is a new instance of Image2D with size m*n
%

% create interpolator initialized with current image
% TODO: manage different interpolators
interpolator = LinearInterpolator2D(this);

% select pixels located inside interpolator buffer
box = this.getPhysicalExtent();
inside = x>box(1) & x<box(2) & y>box(3) & y<box(4);

% set up a rectangular buffer with appropriate mData
dat = zeros(size(x));
dat(inside) = interpolator.evaluate(x(inside), y(inside));

% set up the result image
res = Image2D(dat);
res.calib.origin = [x(1) y(1)];
res.calib.spacing = [x(1,2)-x(1,1) y(2,1)-y(1,1)];


