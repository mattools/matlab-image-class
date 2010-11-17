function data = getDisplayData(this)
%GETDISPLAYDATA Returns a data array that can be used for display
%
%   DAT = img.getDisplayData()
%
%   For scalar image, the inner data array is simply returned.
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

% number of channels
nc = this.dataSize(4);

if nc == 1
    % for grayscale images, simply extract appropriate slice, and transpose
    data = this.data(:, :, 1, 1, 1)';
    
elseif nc == 3
    % If number of channels is 3, assumes this is a color image
    % extract appropriate slice, and transpose.
    data = permute(squeeze(this.data(:, :, 1, :, 1)), [2 1 3]);
    
else
    % For vector images, create a new intensity image from norm
    
    % allocate memory for result
    nx = this.dataSize(1);
    ny = this.dataSize(2);
    data = zeros([nx ny]);
    
    % iterate over channels
    for i=1:nc
        channel = double(squeeze(this.data(:,:,1,i,1)));
        data = data + channel.^2;
    end
    
    % square root, and transpose to comply with matlab orientation
    data = sqrt(data)';
end
