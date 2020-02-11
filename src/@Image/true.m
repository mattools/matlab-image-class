function res = true(dim, varargin)
% Create a binary image containing only true values.
%
%   res = Image.true(DIM)
%   Creates a new binary image with dimensions pecified by DIMS and
%   containing only TRUE values.
%
%   Example
%     marker = Image.true([256 256]);
%     figure; show(marker);
%
%   See also
%     false, create
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-02-11,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

data = true(dim);
res = Image('Data', data, varargin{:});
