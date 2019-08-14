function res = var(obj)
% Computes the variance of image values
%
%   See also
%     mean, std
%

res = var(double(obj.Data(:)));
