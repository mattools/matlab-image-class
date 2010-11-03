classdef MidRegistrationEvaluator
%MIDREGISTRATIONEVALUATOR temporary class for some test cases
%
%   output = MidRegistrationEvaluator(input)
%
%   Example
%   MidRegistrationEvaluator
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    transfo1;
    transfo2;
    metric;
end

methods
    function this = MidRegistrationEvaluator(varargin)
        
        if nargin<3
            error('Need at least 3 arguments');
        end
        
        this.transfo1   = varargin{1};
        this.transfo2   = varargin{2};
        this.metric     = varargin{3};
        
    end % constructor
end

methods
    function value = evaluate(this, params)
        
        % create parameter array for each transform
        np = length(params);
        params1 = params(1:np/2);
        params2 = params(np/2+1:end);
        
        % update each transform
        this.transfo1.setParameters(params1);
        this.transfo2.setParameters(params2);
        
        % compute resulting value
        value = this.metric.computeValue();
    end
end

end
