function res = mean(obj)
% Computes the mean values of image values
%
%   M = mean(IMG);
%
%   Example
%     img = Image.read('rice.png');
%     mean(img)
%     ans =
%       111.2468
%
%   See also
%     median, min, max, orthogonalProjection
%

res = mean(double(obj.Data(:)));
