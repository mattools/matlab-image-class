function res = labeling(this, varargin)
%LABELING Label connected components in a binary image
%
%   output = labeling(input)
%
%   Example
%   labeling
%
%   See also
%   label2rgb, watershed
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(this.type, 'binary')
    error('Requires a binary image');
end

nd = ndims(this);
if nd == 2
    % Planar images
    data = bwlabel(this.data, varargin{:});
    
elseif nd == 3
    % 3D images
    data = bwlabeln(this.data, varargin{:});
    
else
    error('Function "labeling" is not implemented for image of dim %d', nd);
end

% create new image
res = Image(nd, 'data', data, ...
    'parent', this, ...
    'type', 'label');
