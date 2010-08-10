function res = std(this)
%Computes the standard deviation of pixel values

res = std(double(this.data(:)));
