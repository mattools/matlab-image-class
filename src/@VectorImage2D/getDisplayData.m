function norm = getDisplayData(this)
%GETDISPLAYDATA Returns a data array that can be used for display
%
%   DAT = img.getDisplayData()
%
%   For vector image, the norm of each pixel vector is used.
%
%   Example
%   getDisplayData
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% compute data to display
% use vector norm
norm = zeros(this.dataSize);
nc = this.getComponentNumber();
for i=1:nc
    norm = norm + this.data(:,:,i).^2;
end
norm = sqrt(norm)';
