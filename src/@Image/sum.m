function res = sum(obj)
% Computes the sum of pixel values in an image
%
%   See Also
%     mean, std
%

res = sum(obj.Data(:));
