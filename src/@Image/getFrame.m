function frame = getFrame(this, index)
%GETFRAME  Return a specific frame of a movie Image
%
%   FRAME = IMG.getFrame(INDEX)
%   FRAME = getFrame(IMG, INDEX)
%
%   Example
%   getFrame
%
%   See also
%   getChannel
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% create a new Image from data
frame = Image('data', this.data(:,:,:,:,index), 'parent', this);
