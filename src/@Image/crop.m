function res = crop(this, box)
%CROP Crop an image within a box
%
%   RES = crop(IMG, BOX);
%   BOX has syntax [xmin xmax ymin ymax] for 2D images, or 
%   [xmin xmax ymin ymax zmin zmax] for 3D images. 
%
%   Example:
%     % crop the cameraman image
%     img = Image.read('cameraman.tif');
%     cropped = crop(img, [50 350 1 100]);
%     show(cropped)
%

% size of image
siz = this.dataSize;

% image dimension
nd = ndims(this);

% allocate memory
indices = cell(nd, 1);
newOrigin = zeros(1, nd);

% pixel coord for original image
for i = 1:nd
    % compute all pixel positions in current direction
    pos = (0:siz(i) - 1) * this.spacing(i) + this.origin(i);
    
    % select cropped pixels
    inds = find(pos >= box(2*i-1) & pos <= box(2*i));
    
    % store results
    indices{i} = inds;
    newOrigin(i) = pos(inds(1));
end

% create new image with cropped buffer
res = Image('data', this.data(indices{:}), 'parent', this);

% change origin of new image
res.origin = newOrigin;
