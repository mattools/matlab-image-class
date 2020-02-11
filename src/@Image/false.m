function res = false(dim, varargin)
% Create a binary image containing only false values.
%
%   res = Image.false(DIM)
%   Creates a new binary image with dimensions pecified by DIMS and
%   containing only FALSE values.
%
%   Example
%     marker = Image.false([256 256]);
%     figure; show(marker);
%
%   See also
%     true, create
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-02-11,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

data = false(dim);
res = Image('Data', data, varargin{:});
