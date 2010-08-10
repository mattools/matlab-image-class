classdef AffineTransformAbstract < AffineTransform
%AFFINETRANSFORM  Proposes a skeleton for building other affine transforms
%   
%   AffineTransform are designed to transform points into other points
%   using linear relations.
%
%   This classes implements some classes of AffineTransform, mostly those
%   that can be based on 'getAffineMatrix' method.
%   
%
%   See also
%   AffineTransform
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the set of inner parameters of the AffineTransform
end

%% Static methods
methods(Static)
end

%% Abstract methods
methods
    function varargout = transformPoint(this, point, varargin)
        % Transform the point using affine coefficient
        % 
        % transfo.transformPoint(POINT);
        % transfo.transformPoint(X, Y);
        % transfo.transformPoint(X, Y, Z);
        
        % extract affine coefficients
        mat = this.getAffineMatrix();
        
        % format to process a single array
        baseSize = size(point);
        if ~isempty(varargin)
            point = point(:);
            point(1, nargin-1)=0;
            for i=3:nargin
                var = varargin{i-2};
                point(:,i) = var(:);
            end
        end
        
        % compute coordinate of result point
        res = zeros(size(point));
        for i=1:size(point, 2)
            res(:,i) = point*mat(i, 1:end-1)' + mat(i, end);
        end
        
        % format output arguments
        if nargout<=1
            varargout{1} = res;
        else
            for i=1:nargout
                varargout{i} = reshape(res(:,i), baseSize);
            end
        end
    end
    
    function vector = transformVector(this, vector, position) %#ok<INUSD>
        % Transform the vector using affine coefficient
        % 
        % transfo.transformVector(VECTOR, POINT);

        mat = this.getAffineMatrix();
        res = zeros(size(point));
        for i=1:size(point, 2)
            res(:,i) = point*mat(i, 1:end-1)';
        end
    end

    function jacobian = getJacobian(varargin)
        % Compute jacobian matrix, i.e. derivatives for coordinate
        % jacob(i,j) = d x_i / d x_j
        mat = this.getAffineMatrix();
        jacobian = mat(1:end-1, 1:end-1);
    end
end % methods

end % classdef
