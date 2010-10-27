function setOutputFunction(this, fun)
%SETOUTPUTFUNCTION Setup output function, called at the end of each iteration
%
%   REG.setOutputFunction(FUN)
%   FUN is a function handle, see documention of optimset for more details.
%
%   Example
%   setOutputFunction
%
%   See also
%   setFixedImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.outputFunction = fun;
