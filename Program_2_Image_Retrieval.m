%% 
% The purpose of this program is to do image retrieval from the created
% database , image folder inside working path
clc; clear all; close all;

working_path = 'D:\Documents\MATLAB\MMTECH\Assignment';
cd(working_path);
addpath(pwd);


%% Step 0: Get query image
load('new_database_cbir.mat','database');% loading the database mat file
prompt = 'Enter image index in database , e.g 1, 101 >> ';
x = input(prompt) ;
prompt = 'Enter image label in database , e.g 1 for beach and 2 for building >> ';
label_true = input(prompt) ;
prompt = 'Enter number of images to be retrieved >> ';
num_images = input(prompt) ;
prompt = 'RGB results 1 for true and 0 for false >> ';
bool_RGB = input(prompt) ;
prompt = 'HSV results 1 for true and 0 for false >> ';
bool_HSV = input(prompt) ;
prompt = 'CNN results 1 for true and 0 for false >> ';
bool_CNN = input(prompt) ;

n=1;


%% get histograms

imfile = database(x).imageName ;
fprintf('\n\n The query image = %s :', imfile );

figure('Name','Query Image','NumberTitle','off'), imshow(imfile )

HistQHSV = getColourHistHSV(imfile);
HistQRGB = getColourHistRGB(imfile);
HistQCNN = getCNN(imfile);

%% how dissimalar each image in the database is to the query image
numIm = length(database)  ; % this give the number of images in database
distRGB = (0);
distHSV = (0);
distCNN = (0);

for i=1:numIm
    distRGB(i) = getEuclideanDistance(HistQRGB, database(i).featRGB);
    distHSV(i) = getEuclideanDistance(HistQHSV, database(i).featHSV);
    distCNN(i) = getEuclideanDistance(HistQCNN, database(i).featCNN);
end

%% Sort dist in ascending order

[sorted_distRGB, idxRGB] = sort(distRGB);
[sorted_distHSV, idxHSV] = sort(distHSV);
[sorted_distCNN, idxCNN] = sort(distCNN);


%% USER wants to show 30 images
id_listRGB = idxRGB(1:num_images) ;
id_listHSV = idxHSV(1:num_images) ;
id_listCNN = idxCNN(1:num_images) ;
count_trueRGB = 0;
count_falseRGB = 0;
count_trueHSV = 0;
count_falseHSV = 0;
count_trueCNN = 0;
count_falseCNN = 0;
l = sqrt(num_images);
l = round(l);
b = 0;
while (b*l)<num_images
    b = b+1;
end
if bool_RGB == 1
    figure('Name', 'RGB','NumberTitle','off');
    for j=1:num_images

        idRGB = id_listRGB(j) ;

        imfileRGB = database(id_listRGB(j)).imageName ;
        labelRGB = database(idRGB).label;

        if label_true == labelRGB
            count_trueRGB = count_trueRGB + 1;
        else
            count_falseRGB = count_falseRGB +1;
        end

        strRGB = sprintf('%d',labelRGB);  strRGB =[ '  Label = ' strRGB] ;
        subplot(l,b,j) , imshow(imfileRGB) , title(strRGB) ;

    end
    resultRGB = count_trueRGB/(count_trueRGB+count_falseRGB);
    fprintf('\nRGB probability is %f \n', resultRGB);
end

if bool_HSV == 1
    figure('Name', 'HSV','NumberTitle','off');
    for j=1:num_images
        idHSV = id_listHSV(j) ;

        imfileHSV = database(id_listHSV(j)).imageName ;
        labelHSV = database(idHSV).label;

        if label_true == labelHSV
            count_trueHSV = count_trueHSV + 1;
        else
            count_falseHSV = count_falseHSV +1;
        end


        strHSV = sprintf('%d',labelHSV);  strHSV =[ '  Label = ' strHSV] ;
        subplot(l,b,j) , imshow(imfileHSV) , title(strHSV) ;

    end
    resultHSV = count_trueHSV/(count_trueHSV+count_falseHSV);
    fprintf('HSV probability is %f \n', resultHSV);
end

if bool_CNN == 1
    figure('Name', 'CNN','NumberTitle','off');
    for j=1:num_images

        idCNN = id_listCNN(j) ;

        imfileCNN = database(id_listCNN(j)).imageName ;
        labelCNN = database(idCNN).label;
        
        if label_true == labelCNN
            count_trueCNN = count_trueCNN + 1;
        else
            count_falseCNN = count_falseCNN +1;
        end


        strCNN = sprintf('%d',labelCNN);  strCNN =[ '  Label = ' strCNN] ;
        subplot(l,b,j) , imshow(imfileCNN) , title(strCNN) ;

    end
    resultCNN = count_trueCNN/(count_trueCNN+count_falseCNN);
    fprintf('\nCNN probability is %f \n', resultRGB);
end



