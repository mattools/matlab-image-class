function varargout = size(obj, dim)
% Return image size.
%
%   S = size(IMG);
%   Return the size of the image in the space and time dimensions. S is a
%   row vector with at most 5 values, corresponding to the X, Y, Z, C and T
%   dimensions. 
%   In the case of images with no time dimensions (single frame images),
%   only the space dimensions are returned.
%
%   S = size(IMG, DIM);
%   Return the size of the image in a given dimension:
%   size(IMG, 1) returns the number of columns  ("X" direction)
%   size(IMG, 2) returns the number of rows     ("Y" direction)
%   size(IMG, 3) returns the number of slices   ("Z" direction)
%   size(IMG, 4) returns the number of channels ("C" direction)
%   size(IMG, 5) returns the number of frames   ("T" direction)
%
%   Examples
%   img = Image.read('cameraman.tif');
%   size(img)
%   ans =
%        256   256
%
%   img = Image.read('peppers.png');
%   size(img)
%   ans =
%      512   384   
%
%   size(img, 4)
%   ans =
%        3
%
%
%   See also
%     ndims, elementCount, elementSize, channelCount, frameCount
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRAE - Cepia Software Platform.

if nargout <= 1
    % compute dim
    if nargin == 1
        if size(obj.Data, 5) == 1
            s = obj.DataSize(1:obj.Dimension);
        else
            s = obj.DataSize;
        end
    else
        s = obj.DataSize(dim);
    end
    varargout = {s};

else
    
    s = obj.DataSize(1:nargout);
    varargout = num2cell(s);
end

