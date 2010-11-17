function res = open(this, varargin)
%OPEN Computes morphological opening of image

% process data buffer, using Matlab Image processing Toolbox
data = imopen(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
