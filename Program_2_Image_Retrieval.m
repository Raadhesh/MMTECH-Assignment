%% 
% The purpose of this program is to do image retrieval from the created
% database , image folder inside working path
% clc; clear all; close all;
global dbFile;
global imfiler;
working_path = 'D:\Documents\MATLAB\MMTECH\Assignment';
cd(working_path);
addpath(pwd);


%% Step 0: Get query image
% load('new_database_cbir.mat','database');% loading the database mat file
load(dbFile,'database');% loading the database mat file
% prompt = 'Enter image index in database , e.g 1, 101 >> ';
% x = input(prompt) ;
% prompt = 'Enter image label in database , e.g 1 for beach and 2 for building >> ';
% label_true = input(prompt) ;
% prompt = 'Enter number of images to be retrieved >> ';
% num_images = input(prompt) ;
% prompt = 'RGB results 1 for true and 0 for false >> ';
% bool_RGB = input(prompt) ;
% prompt = 'HSV results 1 for true and 0 for false >> ';
% bool_HSV = input(prompt) ;
% prompt = 'CNN results 1 for true and 0 for false >> ';
% bool_CNN = input(prompt) ;
% prompt = 'MSE results 1 for true and 0 for false >> ';
% bool_MSE = input(prompt) ;
% prompt = 'SSIM results 1 for true and 0 for false >> ';
% bool_SSIM = input(prompt) ;
bool_MSE = 0;
bool_SSIM = 0;
n=1;
num_images = findobj(0, 'tag', 'edit1');
num_images = str2double(get(num_images, 'string'));
num_images = num_images + 1; 

rgbhisto = findobj(0, 'tag', 'radiobutton1');
hsvhisto = findobj(0, 'tag', 'radiobutton2');
cnnfeat = findobj(0, 'tag', 'radiobutton3');
msefeat = findobj(0, 'tag', 'radiobutton4');
ssimfeat = findobj(0, 'tag', 'radiobutton5');

bool_RGB = get(rgbhisto, 'Value');
bool_HSV = get(hsvhisto, 'Value');
bool_CNN = get(cnnfeat, 'Value');
bool_MSE = get(msefeat, 'Value');
bool_SSIM = get(ssimfeat, 'Value');


%% get histograms

% imfile = database(x).imageName ;
imfile = imfiler;
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
distMSE = (0);
distSSIM = (0);
tic
for i=1:numIm
    distRGB(i) = getEuclideanDistance(HistQRGB, database(i).featRGB);
    distHSV(i) = getEuclideanDistance(HistQHSV, database(i).featHSV);
    distCNN(i) = getEuclideanDistance(HistQCNN, database(i).featCNN);
    I = database(i).imageName ;
    if (bool_MSE == 1) || (bool_SSIM == 1)
        distMSE(i) = getMSE(imfile, I);
        distSSIM(i) = getSSIM(imfile, I);
    end
    fprintf('Difference between query image and database image %d\n', i);
end
toc
%% Sort dist in ascending order

[sorted_distRGB, idxRGB] = sort(distRGB);
[sorted_distHSV, idxHSV] = sort(distHSV);
[sorted_distCNN, idxCNN] = sort(distCNN);
[sorted_distMSE, idxMSE] = sort(distMSE);
[sorted_distSSIM, idxSSIM] = sort(distSSIM, 'descend');


%% USER wants to show 30 images
label_true = database(idxRGB(1)).label;
id_listRGB = idxRGB(2:(num_images+1)) ;
id_listHSV = idxHSV(2:(num_images+1)) ;
id_listCNN = idxCNN(2:(num_images+1)) ;
if (bool_MSE == 1) || (bool_SSIM == 1)
    id_listMSE = idxMSE(2:(num_images+1)) ;
    id_listSSIM = idxSSIM(2:(num_images+1)) ;
end
count_trueRGB = 0;
count_falseRGB = 0;
count_trueHSV = 0;
count_falseHSV = 0;
count_trueCNN = 0;
count_falseCNN = 0;
count_trueMSE = 0;
count_falseMSE = 0;
count_trueSSIM = 0;
count_falseSSIM = 0;

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
        strRGB2 = sprintf('%.2f', sorted_distRGB(j)); strRGB2=['  Disimmilarity = ' strRGB2];
        strRGB = strRGB + "\n" + strRGB2;
        subplot(l,b,j) , imshow(imfileRGB) , title(compose(strRGB)) ;

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
        strHSV2 = sprintf('%.2f', sorted_distHSV(j)); strHSV2=['  Disimmilarity = ' strHSV2];
        strHSV = strHSV + "\n" + strHSV2;
        subplot(l,b,j) , imshow(imfileHSV) , title(compose(strHSV)) ;

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
        strCNN2 = sprintf('%.2f', sorted_distCNN(j)); strCNN2=['  Disimmilarity = ' strCNN2];
        strCNN = strCNN + "\n" + strCNN2;
        subplot(l,b,j) , imshow(imfileCNN) , title(compose(strCNN)) ;

    end
    resultCNN = count_trueCNN/(count_trueCNN+count_falseCNN);
<<<<<<< Updated upstream
    fprintf('\nCNN probability is %f \n', resultCNN);
=======
    fprintf('CNN probability is %f \n', resultCNN);
>>>>>>> Stashed changes
end

if bool_MSE == 1
    figure('Name', 'MSE','NumberTitle','off');
    for j=1:num_images

        idMSE = id_listMSE(j) ;

        imfileMSE = database(id_listMSE(j)).imageName ;
        labelMSE = database(idMSE).label;
        
        if label_true == labelMSE
            count_trueMSE = count_trueMSE + 1;
        else
            count_falseMSE = count_falseMSE +1;
        end


        strMSE = sprintf('%d',labelMSE);  strMSE =[ '  Label = ' strMSE] ;
        strMSE2 = sprintf('%.2f', sorted_distMSE(j)); strMSE2=['  Disimmilarity = ' strMSE2];
        strMSE = strMSE + "\n" + strMSE2;
        subplot(l,b,j) , imshow(imfileMSE) , title(compose(strMSE)) ;
    end
    resultMSE = count_trueMSE/(count_trueMSE+count_falseMSE);
<<<<<<< Updated upstream
    fprintf('\nMSE probability is %f \n', resultMSE);
=======
    fprintf('MSE probability is %f \n', resultMSE);
>>>>>>> Stashed changes
end


if bool_SSIM == 1
    figure('Name', 'SSIM','NumberTitle','off');
    for j=1:num_images

        idSSIM = id_listSSIM(j) ;

        imfileSSIM = database(id_listSSIM(j)).imageName ;
        labelSSIM = database(idSSIM).label;
        
        if label_true == labelSSIM
            count_trueSSIM = count_trueSSIM + 1;
        else
            count_falseSSIM = count_falseSSIM +1;
        end


        strSSIM = sprintf('%d',labelSSIM);  strSSIM =[ '  Label = ' strSSIM] ;
        strSSIM2 = sprintf('%.2f', sorted_distSSIM(j)); strSSIM2=['  Simmilarity = ' strSSIM2];
        strSSIM = strSSIM + "\n" + strSSIM2;
        subplot(l,b,j) , imshow(imfileSSIM) , title(compose(strSSIM)) ;

    end
    resultSSIM = count_trueSSIM/(count_trueSSIM+count_falseSSIM);
<<<<<<< Updated upstream
    fprintf('\nSSIM probability is %f \n', resultSSIM);
=======
    fprintf('SSIM probability is %f \n', resultSSIM);
>>>>>>> Stashed changes
end



