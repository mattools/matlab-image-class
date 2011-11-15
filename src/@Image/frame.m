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
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% create a new Image from data
nd = ndims(this);
frame = Image(nd, 'data', this.data(:,:,:,:,index), 'parent', this);
