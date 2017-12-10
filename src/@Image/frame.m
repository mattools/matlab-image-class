function frame = frame(this, index)
%FRAME  Return a specific frame of a movie Image
%
%   FRAME = frame(IMG, INDEX)
%   FRAME = IMG.frame(INDEX)
%   Returns the frame with index INDEX from the movie image IMG.
%
%   Example
%   frame
%
%   See also
%   channel
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nf = size(this, 5);
if index > nf
    pattern = 'Can not get frame %d of an movie with %d frames';
    error('Image:frame:IndexOutsideBounds', ...
        pattern, index, nf);
end


% create a new Image from data
frame = Image('data', this.data(:,:,:,:,index), 'parent', this);
