function img = readMetaImage(info)
% Read an image in MetaImage format.
%
%   IMG = readMetaImage(FILENAME)
%   IMG = readMetaImage(MHD_INFO)
%
%   Example
%   info = readMetaImageInfo('example.hdr');
%   X = readMetaImage(info);
%
%   TODO: add support for multiple image files
%
%   See also
%     readMetaImageInfo, readMetaImageData, readstack, analyze75info
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)
% http://www.pfl-cepia.inra.fr/index.php?page=slicer
% Copyright 2010 INRA - Cepia Software Platform.

% info should be a structure. If not, assume this is name of info file
if ~isstruct(info)
    if ischar(info)
        % if file name is provided, read info file
        info = readMetaImageInfo(info);
    else
        error('First argument must be a MetaImage info structure');
    end
end

% read binary data and encapsulates into an image
data = readMetaImageData(info);
img = Image.create('data', data);

% setup spatial calibration
if isfield(info, 'Offset')
    img.Origin = info.Offset;
end
if isfield(info, 'ElementSize')
    img.Spacing = info.ElementSpacing;
end
if isfield(info, 'ElementSpacing')
    img.Spacing = info.ElementSpacing;
end