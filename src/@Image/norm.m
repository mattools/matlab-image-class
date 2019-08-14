function norm = norm(obj)
% Compute the norm of each vector in image.
%
%   NOR = norm(IMG)
%   Computes the norm image of the vector image IMG. The result NOR is a
%   grayscale image with the same spatial dimension of IMG, but contains
%   only one channel.
%
%   Example
%     img = Image.read('peppers.png');
%     nor = norm(img);
%     show(nor);
%
%   See also
%     channel, channelNumber, size
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% allocate memory
siz = obj.DataSize;
siz2 = [siz(1:3) 1 siz(5)];
norm = zeros(siz2);

% iterate on channels
nc = siz(4);
for i = 1:nc
    norm = norm + double(obj.Data(:,:,:,i,:)).^2;
end
norm = sqrt(norm);

% create result image
norm = Image('data', norm, 'parent', obj, 'type', 'intensity');
