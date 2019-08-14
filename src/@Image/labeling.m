function res = labeling(obj, varargin)
% Label connected components in a binary image.
%
%   LBL = labeling(IMB)
%   LBL = labeling(IMB, CONN)
%
%   Example
%   labeling
%
%   See also
%   label2rgb, watershed
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(obj.Type, 'binary')
    error('Requires a binary image');
end

nd = ndims(obj);
if nd == 2
    % Planar images
    data = bwlabel(obj.Data, varargin{:});
    
elseif nd == 3
    % 3D images
    data = bwlabeln(obj.Data, varargin{:});
    
else
    error('Function "labeling" is not implemented for image of dim %d', nd);
end

% create new image
res = Image('data', data, ...
    'parent', obj, ...
    'type', 'label');
