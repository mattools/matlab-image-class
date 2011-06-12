function varargout = find(this, varargin)
%FIND Find non zero elements in image
%
%   INDS = find(IMG)
%   Returns indices of non-zeros elements in image.
%
%   [XI YI] = find(IMG)
%   [XI YI ZI] = find(IMG)
%   Returns X and Y positions as indices (between 1 and max dim). If image
%   is 3D, returns also the Z indices if non zeros voxels.
%
%   [XI YI VI] = find(IMG)
%   [XI YI ZI VI] = find(IMG)
%   Also returns the value of the non-zero pixels or voxels.
%
%   [...] = find(IMG, k, 'first');
%   [...] = find(IMG, k, 'last');
%   Returns only the k first or last values.
%
%
%   Example
%     find(Image.create([0 1 0;1 1 0]))
%     ans = 
%         2
%         4
%         5
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nd = this.dimension;

if nd <= 2
    varargout = cell(1, max(nargout, 1));
    [varargout{:}] = find(this.data, varargin{:});

elseif nd == 3
    inds = find(this.data, varargin{:});
    
    if nargout <= 1
        varargout = {inds};
        
    elseif nargout == nd
        varargout = cell(1, nd);
        [varargout{:}] = ind2sub(this.dataSize(1:nd), inds);
        
    else
        vals = this.data(inds);
        vars1 = cell(1, nd);
        [vars1{:}] = ind2sub(this.dataSize(1:nd), inds);
        varargout = [vars1, {vals}];
    end
end
