function res = crop(this, box)
%CROP Crop an image within a box
%
%   RES = crop(IMG, BOX);
%   BOX has syntax [xmin xmax ymin ymax] for 2D images, or 
%   [xmin xmax ymin ymax zmin zmax] for 3D images. 
%
%   BOX coordinates are given in physical units.
%
%   Example:
%     % crop the cameraman image
%     img = Image.read('cameraman.tif');
%     cropped = crop(img, [50 350 1 100]);
%     show(cropped)
%
%     % crop a color image
%     img = Image.read('peppers.png');
%     box = [71 240 181 330];
%     img2 = crop(img, box);
%     show(img2)
%

% size of image
siz = this.dataSize;

% image dimension
nd = ndims(this);

% allocate memory
indices = cell(ndims(this.data), 1);
newOrigin = zeros(1, nd);

% convert user corodinates to pixel coordinates
for i = 1:nd
    % compute all pixel positions in current direction
    pos = (0:siz(i) - 1) * this.spacing(i) + this.origin(i);
    
    % select cropped pixels
    inds = find(pos >= box(2*i-1) & pos <= box(2*i));
    
    % store results
    indices{i} = inds;
    newOrigin(i) = pos(inds(1));
end

% remaining dimensions keep all image indices
for i = (nd+1):ndims(this.data)
    indices{i}= ':';
end

% create new image with cropped buffer
res = Image('data', this.data(indices{:}), 'parent', this);

% change origin of new image
res.origin = newOrigin;
