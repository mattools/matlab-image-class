function res = extendedMaxima(obj, dyn, varargin)
% Extended maxima of the image.
%
%   IMGMAX = extendedMaxima(IMG, DYN)
%   Computes extended maxima of input image IMG, using the dynamic value
%   DYN. 
%
%   IMGMAX = extendedMaxima(IMG, DYN, CONN)
%   Also specifies the connectivity for computing the maxima.
%
%   Example
%     % Compute extended maxima to identify grains
%     img = Image.read('rice.png');
%     emax30 = extendedMaxima(img, 30);
%     figure; show(emax30)
%
%   See also
%     extendedMinima, regionalMaxima
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check image type
if ~strcmp(obj.Type, 'grayscale') && ~strcmp(obj.Type, 'intensity')
    error('Requires a Grayscale or intensity image to work');
end

% choose default connectivity depending on dimension
conn = defaultConnectivity(obj);

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end

data = imextendedmax(obj.Data, dyn, conn);

% create result image
name = createNewName(obj, '%s-extMax');
res = Image('Data', data, 'Parent', obj, 'Type', 'binary', 'Name', name);
