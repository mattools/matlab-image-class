classdef BSplines < handle
%BSPLINES Contains several static functions for manipulation of cubic splines
%
%   output = BSplines(input)
%
%   Example
%   BSplines
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods (Static)
    
    %% Basis functions 
    
    function res = beta3_0(u)
        res = (1 - u).^3 / 6;
    end
    
    function res = beta3_1(u)
        res = (3*u.^3 - 6*u.^2 + 4) / 6;
    end
    
    function res = beta3_2(u)
        res = (-3*u.^3 + 3*u.^2 +3*u + 1) / 6;
    end
    
    function res = beta3_3(u)
        res = u.^3 / 6;
    end

    
    %% Derivatives
    
    function res = beta3_0d(u)
        res = -(1 - u).^2 / 2;
    end
    
    function res = beta3_1d(u)
        res = 3*u.^2 / 2 - 2*u;
    end
    
    function res = beta3_2d(u)
        res = (-3*u.^2 + 2*u + 1) / 2;
    end
    
    function res = beta3_3d(u)
        res = u.^2 / 2;
    end
    
    
end % static methods

end % classdef
