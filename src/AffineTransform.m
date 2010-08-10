classdef AffineTransform < Transform
%AFFINETRANSFORM  Abstract class for AffineTransform
%   
%   AffineTransform are designed to transform points into other points
%   using linear relations.
%
%   T : R^d -> R^d
%   
%   few methods are already implemented for convenience:
%   - transformPoint
%   - transformVector
%   - getJacobian
%   They all use the abstract getAffineMatrix method.
%   
%
%   See also
%   Transform
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
methods(Abstract)
    getAffineMatrix(this)
    % Returns the (d+1)*(d+1) affine matrix that represents this transform
    %
    % usage:
    % trans = Rotation2D([3 4], pi/3); % define an affine transform
    % mat = trans.getAffineMatrix();   % extract matrix
end

%% General methods specific to Affine transforms
methods
    function res = mtimes(this, that)
        % Multiplies two affine transforms
        % RES = THIS * THAT
        % RES = mtimes(THIS*THAT)
        % both THIS and THAT must be affine transforms.
        %
        % the result is an instance of MatrixAffineTransform.
        
        % extract matrices
        mat1 = this.getAffineMatrix;
        mat2 = that.getAffineMatrix;
        
        % check sizes are equal
        if sum(size(mat1)~=size(mat2))>0
            error('The two transforms must have matrices the same size');
        end
        
        % returns the multipled transform
        res = MatrixAffineTransform(mat1 * mat2);
    end
    
    function res = getInverse(this)
        % Computes the inverse transform of this affine transform
        % 
        % TINV = T.getInverse();
        % or 
        % TINV = getInverse(T);
        %
        mat = this.getAffineMatrix();
        res = MatrixAffineTransform(inv(mat));
    end
end

%% Methods implementing the transform interface
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
        % Transform the vector using affine coefficients
        % 
        % VEC2 = transfo.transformVector(VEC, POINT);

        mat = this.getAffineMatrix();
        res = zeros(size(point));
        for i=1:size(point, 2)
            res(:,i) = point*mat(i, 1:end-1)';
        end
    end

    function jacobian = getJacobian(this)
        % Compute jacobian matrix, i.e. derivatives for coordinate
        % jacob(i,j) = d x_i / d x_j
        mat = this.getAffineMatrix();
        jacobian = mat(1:end-1, 1:end-1);
    end

end % methods

end % classdef
