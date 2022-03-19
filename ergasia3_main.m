clc;
clear;
close all;
more off;

%% ------------------------------------------------------
% PART A MAIN 
% ------------------------------------------------------

% --- INIT
if exist('OCTAVE_VERSION', 'builtin')>0
    % If in OCTAVE load the image package
    warning off;
    pkg load image;
    warning on;
end

%% ------------------------------------------------------
% LOAD AND SHOW THE IMAGE + CONVERT TO BLACK-AND-WHITE
% ------------------------------------------------------

% --- Step A1
% read the original RGB image 
Filename='Troizina 1827.jpg';
I=imread(Filename);
% show it (Eikona 1)
% figure;
% image(I);
% axis image off;
% colormap(gray(256));

%% --- Step A2
% convert the image to grayscale
A=any_image_to_grayscale_func('Troizina 1827.jpg');

% apply gamma correction (a value of 1.0 doesn't change the image)
GammaValue=0.6; 
A=imadjust(A,[],[],GammaValue); 

% show the grayscale image (Eikona 2)
figure;
image(A);
colormap(gray(256));
axis image off;
title('Grayscale image');

%% --- Step A3
% convert the grayscale image to black-and-white using Otsu's method
Threshold= graythresh(A); 
BW = ~im2bw(A,Threshold);

% show the black-and-white image (Eikona 3)
figure;
image(~BW);
colormap(gray(2));
axis image;
set(gca,'xtick',[],'ytick',[]);
title('Binary image');

%% ------------------------------------------------------
% CLEAN THE IMAGE
% ------------------------------------------------------
% --- Step A4
% make morphological operations to clean the image
A=strel('rectangle', [6 9]);
B=strel('diamond', 1);

% clear stamp
C=imdilate(BW, A);
C=imclearborder(C,8); 
stamp=and(BW, C);

% show the cleared from stamp, image
figure;
image(~stamp);
colormap(gray(2));
axis image off;
title('Image without Stamp');

% perform opening/closing to image and clear noise 
stamp=imopen(stamp, B);
stamp=imclose(stamp, B);
stamp = bwareaopen(stamp, 31);

% show cleaned image (Eikona 4)
figure;
image(~stamp);
colormap(gray(2));
axis image off;
title('Cleaned Image');

%% ------------------------------------------------------
% WORD SEGMENTATION
% ------------------------------------------------------
% --- Step A5
% make morphological operations for word segmentation ...
% find the right length
D = strel('line', 18, 0);  
C=imdilate(stamp, D); 

% find the connected components (using bwlabel) ...
% [C, count]=bwlabel(C, 4); % 4-connectivity
[C, count]=bwlabel(C, 8); % 8-connectivity

% word segmentation (Eikona 5) ...
% Show the image with the boxes
RGB = label2rgb(C, 'lines');

figure;
image(RGB);
colormap(gray(2));
axis image off;
title(sprintf('%g components in %d-connectivity',count,4));

% % function to increase bounding boxes
for i = 1:count
    [row, col]=find(C == i);
    for j = [row col]
     C(row, col)=i; 
    end
end

%% ------------------------------------------------------
% FINAL IMAGE WITH BOUNDING BOXES
% ------------------------------------------------------
% --- Step A6
% show the original image with the final bounding boxes (Eikona 6) ...

% extract bounding boxes properties 
% regionprops measure properties of image regions
CC = bwconncomp(C);
s = regionprops(CC,'BoundingBox', 'Area');

% create a matrix nX4.
% bounding box total number and 4 properties of bounding box (x,y,width,height)
L  = vertcat(s(:).BoundingBox);
L

% show the original image 
figure;
image(I);
axis image off;
title('Final results 1');

% show the final bounding boxes 
for n = 1:length(s)
    rectangle('Position',s(n).BoundingBox,'EdgeColor',[rand rand rand],LineWidth=1)
end

% Enlarge the figure
drawnow;
set(gcf,'units','normalized','position',[0.1 0.1 0.8 0.8]);

% --- Step A7
% let suppose matrix R contains all the N bounding boxes in the form
% x11 y11 x12 y12
% x21 y21 x22 y22
% ...
% xN1 yN1 xN2 yN2


% --- Store all the bounding boxes in R
x1 = L (:,1)+0.5;
y1 = L (:,2)+0.5;
x2 = x1 + L (:,3);
y2 = y1 + L (:,4);
R=[x1 y1 x2 y2]; % append to R the bounding box as [x1 y1 x2 y2]


% then save the bounding boxes in a text file results.txt ...
if exist('R','var')
    dlmwrite('results_modified.txt',R,'\t');
    fprintf('File saved as "results.txt".\n');
end