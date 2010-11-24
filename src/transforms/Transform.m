classdef Transform < handle
%TRANSFORM  Abstract class for transform
%   
%   Transform are designed to transform points into other points. This
%   class defines some abstract methods that have to be implemented by
%   derived classes.
%
%   Abstract classes:
%   transformPoint  - Computes coordinates of transformed point
%   transformVector - Computes coordinates of transformed vector
%   getJacobian     - Computes jacobian matrix 
%
%   Example
%   trans = (...); % define a transform by using a derived class 
%   pt = (...);    % create a point corresponding to transform input
%   pt2 = trans.transformPoint(pt);
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the set of inner parameters of the transform
end

%% Static methods
methods (Static)
end

%% Abstract methods
methods (Abstract)
    
    transformPoint(this, point)
    % TRANSFORMPOINT Computes coordinates of transformed point
    % PT2 = this.transformPoint(PT);
    
    transformVector(this, vector, position)
    % TRANSFORMVECTOR Computes coordinates of transformed vector
    % VEC2 = this.transformPoint(VEC, PT);
    
    jacobian = getJacobian(this, position)
    % Computes jacobian matrix, i.e. derivatives wrt to each coordinate
    % jacob(i,j) = d x_i / d x_j
       
end % abstract methods

%% General methods
methods
    
    function res = compose(this, that)
        % Computes the composition of the two transforms
        %
        % The following:
        % T = T1.compose(T2)
        % P2 = T.tansformPoint(P);
        % % is the same as 
        % P2 = T1.transformPoint(T2.transformPoint(P));
        res = ComposedTransform(that, this);
    end
    
end % methods

end% classdef
