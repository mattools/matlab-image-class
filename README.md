# matlab-image-class
Generic class for representation of 2D/3D...5D images with Matlab. 

## Description
This package consists in the `Image` class, that encapsulates a (possibly multidimensional) 
data array together with various meta-data used to interpret the data (spatial calibration,
look-up table, grayscale extent...). 

The Image class can manage up to five dimensions, corresponding to the X, Y, Z, Channels, and Time.
Images are asociated to a type that indicates how the content should be interpreted: "color", "intensity", "binary", "label"...

Nearly 200 methods are provided for quickly applying image processing operators on image instances, 
by keeping relevant meta-data such as spatial calibration, and automatically inferring the type of the
result images. A [User Manual](https://github.com/mattools/matlab-image-class/releases/download/v1.0/ImageClass-Manual.pdf) is available in pdf format.

The `Image` class is at the basis of the development of the `ImageM` application (http://github.com/mattools/ImageM). The MatStats package (https://github.com/mattools/matStats) may be necessary for some functions.

## Example 1

The following example performs a segmentation on a grayscale image. It uses computation of gradient, filtering, morphological processing, and management of label images.

    % read a grayscale image
    img = Image.read('coins.png');
    % compute gradient as a vector image. 
    grad = gradient(img);
    % Compute the norm of the gradient, and smooth
    gradf = boxFilter(norm(grad), [5 5]);
    figure; show(gradf, []);
    % compute watershed after imposition of extended minima
    emin = extendedMinima(gradf, 20, 4);
    grad2 = imposeMinima(gradf, emin, 4);
    lbl = watershed(grad2, 4);
    % display binary overlay over grayscale image
    show(overlay(img, lbl==0, 'g'));
    % cleanup segmentation and convert to RGB image
    lbl2 = killBorders(lbl);
    show(label2rgb(lbl2, 'jet', 'w'));

![segmentation pipeline of a grayscale image using watershed](https://github.com/mattools/matlab-image-class/blob/master/doc/images/coins-segWat.png)

## Example 2

The following example presents various ways to explore and display the content of a 3D image.

    % read data, adjust contrast, and specify spatial calibration
    img = adjustDynamic(Image.read('brainMRI.hdr'));
    img.Spacing = [1 1 2.5];
    % show as three orthogonal planes
    figure; showOrthoPlanes(img, [60 80 13]); axis equal;
    % show as three orthogonal slices in 3D
    figure; showOrthoSlices(img, [60 80 13]); axis equal; view(3); 
    axis(physicalExtent(img));
    % display as isosurface
    figure; isosurface(gaussianFilter(img, [5 5 5], 2), 50);
    axis equal; axis(physicalExtent(img)); view([145 25]); light;

![Various representations of 3D image using Image class](https://github.com/mattools/matlab-image-class/blob/master/doc/images/visu3d.png)
