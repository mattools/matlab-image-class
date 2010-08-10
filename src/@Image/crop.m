function res = crop(this, box)
%CROP Crop an image within a box
%
%   RES = this.crop(BOX);
%   BOX has syntax [xmin xmax ymin ymax] for 2D images, or 
%   [xmin xmax ymin ymax zmin zmax] for 3D images. 
%
%   Example:
%   % note 0-indexing
%   img = Image2D('cameraman.tif');
%   img2 = img.crop([50 350 0 100]);
%   img2.show([])
%

% size of image
siz = this.dataSize;

% imaeg dimension
nd = length(siz);

% allocate memory
indices = cell(nd, 1);
newOrigin = zeros(1, nd);

% pixel coord for original image
cal = this.getSpatialCalibration();
for i=1:nd
    % compute all pixel positions in current direction
    pos = (0:siz(i)-1)*cal.spacing(i) + cal.origin(i);
    
    % select cropped pixels
    inds = find(pos>=box(2*i-1) & pos<=box(2*i));
    
    % store results
    indices{i} = inds;
    newOrigin(i) = pos(inds(1));
end

% create new image with cropped buffer
res = Image(nd, 'data', this.data(indices{:}), 'parent', this);

% change origin of new image
cal.origin = newOrigin;
res.setSpatialCalibration(cal);
