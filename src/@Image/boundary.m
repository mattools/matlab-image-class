function bnd = boundary(this, varargin)
%BOUNDARY Boundary of a binary image
%
%   BND = boundary(IMG)
%   IMG is a boundary image with one or several structures of interest
%   coded as 1 (white) over a 0 (black) background.
%   BND is the set of boundary pixel of the structure, that is the pixels
%   that belongs to the structure and that touch the background.
%
%   BND = boundary(IMG, CONN)
%   Specifies the connectivity to use. CONN can be 4 or 8 for planar
%   images, 6 or 26 for 3D images.
%
%   BND = boundary(IMG, SE)
%   Specifies the structuring element that will be used for detecting
%   neighborhood.
%
%   BND = boundary(IMG, TYPE)
%   Specifies whether the function should compute the outer or inner
%   boundary. TYPE can be either 'outer' or 'inner'.
%
%   The function works for binary 2D or 3D images. If input image is not
%   binary, the result is undefined.
%
%   Example
%     BW = Image.read('circles.png');
%     figure;
%     subplot(121);show(boundary(BW)); title('inner boundary');
%     subplot(122);show(boundary(BW, 'outer')); title('outer boundary');
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% default parameters

% number of dimensions
nd = this.dimension;

% default structuring element
if nd == 2
    se = [0 1 0;1 1 1;0 1 0];
elseif nd == 3
    se = cross3d;
else
    se = ones(3*ones(1, nd));
end

% operation to perform
op = @imerode;


%% Process input arguments

while ~isempty(varargin)
    var = varargin{1};
    if isnumeric(var)
        if isscalar(var)
            % Determines structuring element based on connectivity info
            switch var
                case 4
                    se = [0 1 0;1 1 1;0 1 0];
                case 8
                    se = ones(3,3);
                case 6
                    se = cross3d;
                case 26
                    se = ones([3 3 3]);
                otherwise
                    error('Unknown value for connectivity');
            end
        else
            % Structuring element is given as argument
            se = var;
        end
        
    elseif ischar(var)
        switch var
            case 'outer'
                op = @imdilate;
            case 'inner'
                op = @imerode;
            otherwise
                error('Unknown string option');
        end
    end
    
    varargin(1) = [];
end

%% Process

% erode the structure and compare with original
bnd = Image(op(this.data, se) ~= this.data, 'parent', this);
