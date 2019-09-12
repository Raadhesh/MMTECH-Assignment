function result = getMSE(filename1, filename2)

im1 = imread(filename1);
im1 = imresize(im1, [277 277]);

im2 = imread(filename2);
im2 = imresize(im2, [277 277]);


result = immse(im1, im2);
