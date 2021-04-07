function conn = defaultConnectivity(obj)
% Choose the default foreground connectivity for the image.
%
%   CONN = defaultConnectivity(IMG)
%   Returns the default connectivity for the input image IMG.
%   Returns:
%   * CONN = 4 for 2D images,
%   * CONN = 6 for 3D images
%
%   Example
%   defaultConnectivity
%
%   See also
%     killBorders, fillHoles, reconstruction, watershed
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-04-07,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.

if ndims(obj) == 2 %#ok<ISMAT>
    conn = 4;
elseif ndims(obj) == 3
    conn = 6;
end
