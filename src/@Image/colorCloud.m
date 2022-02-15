function varargout = colorCloud(obj, varargin)
% Display image colors into the 3D space of specified gamut.
%
%   colorCloud(IMG)
%   colorCloud(IMG, GAMUT)
%   See the "colorcloud" function help for options.
%
%   Works also for 3D images.
%
%   Example
%     % Read and display a color image
%     img = Image.read('peppers.png');
%     figure; show(img);
%     %  Display color cloud in a new figure
%     colorCloud(img)
%
%   See also
%     show, isColorImage, colorcloud
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-02-18,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

% check input
if ~isColorImage(obj)
    error('requires a color image as input');
end

% format data
if obj.DataSize(3) == 1
    rgb = permute(obj.Data(:,:,1,:,1), [2 1 4 3 5]);
else
    nSlices = obj.DataSize(3);
    rgb = zeros([0 3]);
    for iz = 1:nSlices
        rgb = [rgb ; permute(obj.Data(:,:,iz,:,1), [2 1 4 3 5])]; %#ok<AGROW>
    end
end

% call the IPT function
varargout = cell(1, nargout);
[varargout{:}] = colorcloud(rgb, varargin{:});
