classdef MatrixAffineTransform < AffineTransform
%MATRIXAFFINETRANSFORM  An affine transform defined by its matrix
%   output = MatrixAffineTransform(input)
%
%   Example
%   MatrixAffineTransform
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % center of the transform
    matrix = eye(3);
end

%% Constructors
methods
    function this = MatrixAffineTransform(varargin)
        % Create a new model for translation transform model
        
        if isempty(varargin)
            % parameters already set to default values
            return;
        end
        
        % extract first argument, and try to interpret
        var = varargin{1};
        if isa(var, 'MatrixAffineTransform')
            this.matrix = var.matrix;
        elseif isnumeric(var)
            dim = size(var);
            if dim(1)==dim(2)
                this.matrix = var;
            elseif dim(1) == dim(2)-1
                % make the matrix square
                var(end+1, end) = 1;
                this.matrix = var;
            else
                error('Input matrix should be square');
            end
        else
            error('Unable to understand input arguments');
        end
    end % constructor declaration
end % methods

%% General methods
methods
    function mat = getAffineMatrix(this)
        % Simply returns the inner matrix stored by this transform.
        %
        mat = this.matrix;
    end
    
end % methods
    
    
end % classdef