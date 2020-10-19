%DEMOJOINTHISTOGRAM  One-line description here, please.
%
%   output = demoJointHistogram(input)
%
%   Example
%   demoJointHistogram
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-07-29,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


%% Input data

% read a color image
img = Image.read('peppers.png');

% show it
figure; show(img);


%% joint histogram

% compute joint histogram, as an image!
histoRG = jointHistogram(channel(img, 1), channel(img, 2));

% use logarithmic representation for better display
histoRG2 = log(histoRG+1);

% display
figure; show(histoRG2);
colormap(jet);
set(gca, 'ydir', 'normal');
