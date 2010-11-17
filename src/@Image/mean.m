function res = mean(this)
%Computes the average values of pixel values

res = mean(double(this.data(:)));
