clc;
clear;
close all;

% --- Init 
I=any_image_to_grayscale_func('Troizina 1827.jpg');

% --- Load and show the image
figure('units','normalized','position',[0.1 0.1 0.8 0.8]);
image(I);
colormap(gray(256));
axis image off;
hold on;

% --- Define the Ground Truth (yellow bounding boxes)
GT= dlmread('Troizina 1827_ground_truth.txt');

% --- Get the number of ground truth bounding boxes
Ng=size(GT,1);

% --- Define the method's results (blue bounding boxes)
D=dlmread('results_modified.txt');
% D=dlmread('results_modified.txt');

% --- Get the number of resulting bounding boxes
Nd=size(GT,1);

% % --- Show the resulting bounding boxes
x1=D(:,1);
y1=D(:,2);
x2=D(:,3);
y2=D(:,4);
patch([x1 x1 x2 x2 x1]',[y1 y2 y2 y1 y1]',ones(5,size(D,1)),'edgecolor','r','facealpha',0,'linewidth',1);

% --- Show the ground truth bounding boxes
x1=GT(:,1);
y1=GT(:,2);
x2=GT(:,3);
y2=GT(:,4);
patch([x1 x1 x2 x2 x1]',[y1 y2 y2 y1 y1]',ones(5,size(GT,1)),'edgecolor','b','facealpha',0,'linewidth',1);
title('Ground truth vs resulting bounding boxes')

% --- Calculate the Intersection Over Union
IOU=calcIOU(D,GT);
fprintf('IOU is:\n');
disp(IOU);

% --- Write the IOU results to a text file
dlmwrite('IOU.txt',IOU,'delimiter','\t','precision',2);

% --- Define a threshold for the IOU results
T=0.7;

% --- Filter out the IOU results
IOUFinal=(IOU>=T);
fprintf('Final IOU is:\n');
disp(IOUFinal);

% --- Write the final IOU results to a text file
dlmwrite('IOUFinal.txt',IOUFinal,'precision',2);

% calculate TP, FP, FN, Recall, Precision and F-Measure
% TIP: check the last part of iou_demo.m
%import the filtered iou results
result= dlmread('IOUFinal.txt');

%calculate TP, FP, FN
%calculate sum of rows
t = sum(result,2);

%calculate sum of columns
b = sum(result,1);

%Calculate TP
%sum of 1s in every column
TP = sum(b(:,:)==1);
fprintf('Number of TP is: %d\n',TP);

% Calculate FP
%number of 0s in the sum of every row
FP = sum(t(:,:)==0);
fprintf('Number of FP is: %d\n',FP);

%Calculate FN
%sum of 0s in every column
FN = sum(b(:,:)==0);
fprintf('Number of FN is: %d\n',FN);


%calculate Recall Precision F-score
Recall = TP/(TP+FN);
Precision = TP/(TP+FP);
F1 = 2*((Precision*Recall)/(Precision + Recall));

% and show the results
fprintf('Recall %0.2f\n',Recall);
fprintf('Precision %0.2f\n',Precision);
fprintf('F-Measure %0.2f\n',F1);

