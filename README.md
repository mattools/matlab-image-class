# matlab-image-class
Generic class for representation of 2D/3D...5D images with Matlab

This package consists in the `Image` class, that contains a (possibly multidimensional) 
data array together with various meta-data used to interpret the data (spatial calibration,
look-up table, grayscale extent...).

Many methods are provided for quickly apply image processing operators on image instances.

The `Image` class is at the basis of the development of the `ImageM` application (http://github.com/dlegland/ImageM)
