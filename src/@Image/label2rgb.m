function rgb = label2rgb(this, varargin)
%LABEL2RGB Convert label image to RGB image
%
%   RGB = label2rgb(LBL)
%   Covnerts the label image LBL to a RGB image. The result image is
%   encoded into uint8.
%
%   Example
%     label2rgb
%
%   See also
%   watershed
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(this.type, 'label')
    error('Requires a label image');
end

% default behaviour is shuffled HSV LUT with white BackGround
if isempty(varargin)
    varargin = {jet(double(max(this.data(:)))+1), 'w', 'shuffle'};
end

nd = this.dimension;
if nd == 2
    data = label2rgb(this.data, varargin{:});
    data = reshape(data, [this.dataSize(1:3) 3 this.dataSize(5)]);
         
elseif nd == 3
    N = double(max(this.data(:)));
    dim = size(this.data);
    dim = dim(1:3);
    
    map = varargin{1};
    
    % extract each channel
    r = zeros(dim, 'uint8');
    g = zeros(dim, 'uint8');
    b = zeros(dim, 'uint8');
    
    for label = 1:N
        inds = find(this.data==label);
        r(inds) = 255 * map(label, 1);
        g(inds) = 255 * map(label, 2);
        b(inds) = 255 * map(label, 3);
    end
    
    % build the result 3D color image
    data = cat(4, r, g, b);

end

% create new image
rgb = Image('data', data, 'parent', this, 'type', 'color');
