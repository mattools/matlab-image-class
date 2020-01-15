function info = fileInfo(fileName)
% Return information about an image file.
%
%   INFO = fileInfo(FNAME)
%
%   Currently supported file formats include:
%   * all the formats recognized by the imread function (see imfinfo)
%   * Analyze (see analyze75info)
%   * Dicom (see dicominfo)
%   * MetaImage (from Kitware)
%   * VGI
%
%   Example
%     info = Image.fileInfo('brainMRI.hdr');
%
%   See also
%     imfinfo, dicominfo, analyze75info
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

% extract extension
[path, name, ext] = fileparts(fileName); %#ok<ASGLU>

% remove dot
ext(1) = [];

switch lower(ext)
    case {'tif', 'png', 'jpg', 'bmp'}
        info = imfinfo(fileName);
        
    case 'hdr'
        info = analyze75info(fileName);
        
    case 'dicom'
        info = dicominfo(fileName);
        
    case {'mhd', 'mha'}
        % use function in 'private' directory
        info = readMetaImageInfo(fileName);

    case {'vgi'}
        % use function in 'private' directory
        info = readVgiStackInfo(fileName);

    otherwise
        error(['Can not manage file with extension: ' ext]);
end

