function setParameterScaling(this, scale)
%SETPARAMETERSCALING Setup scaling factor associated to each parameter
%
%   REG.setParameterScaling(SCALE)
%
%   Convention:
%   see the scale as a normalisation towards unit.
%
%   Some empirical choices:
%   - translation parameters are not rescaled
%   - rotation parameters are rescaled by 180/pi.
%
%   Example
%   setParameterScaling
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.paramScales = scale;
