function varargout = montage(obj, varargin)
% Display multiple image frames as rectangular montage.
%
%   montage(IMG)
%   Creates a montage from the 3D image IMG. This function is just a
%   wrapper for the matlab function "montage".
%
%   montage(..., NAME, VALUE)
%
%   Example
%   % montage of a 3D grayscale image
%     img = Image.read('brainMRI.hdr');
%     montage(img);
%
%   % Montage of a 3D RGB image
%     img = Image.read('brainMRI.hdr');
%     se = ones([3 3 3]);
%     bin = close(img > 0, se);         % binarize, remove small holes
%     bnd = dilate(boundary(bin), se);  % compute boundary
%     ovr = overlay(img*3, bnd, 'm');   % compute overlay
%     montage(ovr);
%
%   See also
%     montage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% check image dimension
if obj.Dimension < 3
    error('montage: works only for 3D images');
end

% call native montage fonction
if nargout == 0
    montage(permute(obj.Data, [2 1 4 3]), varargin{:});
else
    varargout{1} = montage(permute(obj.Data, [2 1 4 3]), varargin{:});
end

% decorate figure
if ~isempty(obj.Name)
    set(gcf, 'name', ['Montage of ' obj.Name]);
else
    set(gcf, 'name', ['Montage' obj.Name]);
end
