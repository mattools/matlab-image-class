function res = repmat(this, M, N)
%REPMAT  Overload repmat function for Image objects
%
%   RES = repmat(IMG, RX, RY)
%   RES = repmat(IMG, [RX RY])
%   Repeat the input image RX times along X axis, and RY times along Y
%   axis. The function handles color images properly.
%
%   RES = repmat(IMG, [1 1 3])
%
%   Example
%     % repeat grayscale image 
%     img = Image.read('cameraman.tif');
%     rep = repmat(img, [3 2]);
%     show(rep)
% 
%     % repeat a color image
%     img = Image.read('peppers.png');
%     rep = repmat(img, [2 3]);
%     show(rep)
%
%   See also
%   horzcat, vertcat, cat
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% 
if nargin < 2
    error('Image:repmat:NotEnoughInputs', 'Requires at least 2 inputs.')
end

% parse input
if nargin == 2
    if isscalar(M)
        siz = [M M];
    else
        siz = M;
    end
else
    siz = [M N];
end

% complete with ones
siz = [siz ones(1, 5-length(siz))];

newDim = this.dimension;
if siz(3) > 1
    newDim = 3;
end

% compute new data buffer
data = repmat(this.data, siz);

% create result image
res = Image('data', data);
