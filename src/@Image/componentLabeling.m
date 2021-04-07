function res = componentLabeling(obj, varargin)
% Label connected components in a binary image.
%
%   LBL = componentLabeling(BIN)
%   LBL = componentLabeling(BIN, CONN)
%
%   Example
%     img = Image.read('coins.png');
%     bin = opening(img > 80, ones(3, 3));
%     lbl = componentLabeling(bin);
%     rgb = label2rgb(lbl, 'jet', 'w');
%     figure; show(rgb);
%
%   See also
%     label2rgb, watershed, reconstruction
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(obj.Type, 'binary')
    error('Requires a binary image');
end

% choose default connectivity depending on dimension
conn = defaultConnectivity(obj);

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end

nd = ndims(obj);
if nd == 2
    % Planar images
    data = bwlabel(obj.Data, conn);
    
elseif nd == 3
    % 3D images
    data = bwlabeln(obj.Data, conn);
    
else
    error('Function "componentLabeling" is not implemented for image of dim %d', nd);
end

% create new image
name = createNewName(obj, '%s-labels');
res = Image('Data', data, ...
    'Parent', obj, ...
    'Type', 'label', ...
    'Name', name);
