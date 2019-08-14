function res = median(obj)
% Compute the median values of image values
%
%   M = median(IMG);
%
%   Example
%     img = Image.read('rice.png');
%     median(img)
%     ans =
%        104
%
%   See also
%     median, min, max
%

res = median(double(obj.Data(:)));
