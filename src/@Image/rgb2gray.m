function res = rgb2gray(this)
%RGB2GRAY Convert RGB image to grayscale image
%
%   IMG = rgb2gray(RGB)
%   Convert color image RGB into grayscale image with same size.
%
%   Example
%     img = Image.read('peppers.png');
%     gray = rgb2gray(img);
%     show(gray);
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(this.type, 'color')
    error('Requires a color image');
end

% compute coefs
mat = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
coefs = mat(1, :);

% compute grayscale value from weighted mean of RGB bands
gray = imlincomb(coefs(1), this.data(:,:,:,1,:), ...
    coefs(2), this.data(:,:,:,2,:), coefs(3), this.data(:,:,:,3,:));

% create new image
nd = ndims(this);
res = Image(nd, 'data', gray, ...
    'parent', this, ...
    'type', 'grayscale');
