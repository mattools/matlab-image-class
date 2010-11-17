function norm = getNorm(this)
%GETNORM  Compute the norm of each vector in image
%
%   output = getNorm(input)
%
%   Example
%   getNorm
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% use vector norm
siz = this.dataSize;
siz2 = [siz(1:3) 1 siz(5)];
norm = zeros(siz2);
nc = this.getChannelNumber();
for i=1:nc
    norm = norm + this.data(:,:,:,i,:).^2;
end
norm = sqrt(norm);

norm = Image('data', norm, 'parent', this);
