function rgb = label2rgb(obj, varargin)
% Convert label image to RGB image.
%
%   RGB = label2rgb(LBL)
%   Converts the label image LBL to a RGB image. The result image is
%   encoded into uint8.
%
%   Example
%     img = Image.read('coins.png');
%     bin = closing(img > 80, ones(3,3));
%     lbl = componentLabeling(bin);
%     rgb = label2rgb(lbl, 'jet', 'w', 'shuffle');
%     rgb.Name = 'regions(coins)';
%     figure; show(rgb);
%
%   See also
%     watershed, binarize
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(obj.Type, 'label')
    error('Requires a label image');
end

% default behaviour is shuffled 'JET' LUT with white BackGround
if isempty(varargin)
    varargin = {jet(double(max(obj.Data(:)))), 'w', 'shuffle'};
end

nd = obj.Dimension;
if nd == 2
    data = label2rgb(obj.Data, varargin{:});
    data = reshape(data, [obj.DataSize(1:3) 3 obj.DataSize(5)]);
         
elseif nd == 3
    N = double(max(obj.Data(:)));
    dim = size(obj.Data);
    dim = dim(1:3);
    
    map = varargin{1};
    
    % extract each channel
    r = zeros(dim, 'uint8');
    g = zeros(dim, 'uint8');
    b = zeros(dim, 'uint8');
    
    for label = 1:N
        inds = find(obj.Data==label);
        r(inds) = 255 * map(label, 1);
        g(inds) = 255 * map(label, 2);
        b(inds) = 255 * map(label, 3);
    end
    
    % build the result 3D color image
    data = cat(4, r, g, b);

end

% create new image
name = createNewName(obj, '%s-rgb');
rgb = Image('Data', data, 'Parent', obj, 'Type', 'Color', 'Name', name);
