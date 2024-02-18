close all;
clear;
clc;

fprintf('----------------------------------------\n\n');
fprintf('Loading image data...\n\n');
data_file = './data/mnist.mat';

data = load(data_file);

% Read the train data
[train_C1_indices, train_C2_indices,train_C1_images,train_C2_images] = read_data(data.trainX,data.trainY.');

% Read the test data
[test_C1_indices, test_C2_indices,test_C1_images,test_C2_images] = read_data(data.testX,data.testY.');

%% Aspect ratio
C1trainLen = size(train_C1_images,1);
C2trainLen = size(train_C2_images,1);
C1testLen = size(test_C1_images,1);
C2testLen = size(test_C2_images,1);

total_im = C1trainLen + C2trainLen + C1testLen + C2testLen;
trainTestLimit= C1trainLen + C2trainLen;

fprintf('Program paused. Press enter to continue.\n');
fprintf('----------------------------------------\n\n');
pause;

% a = computeAspectRatio(train_C1_images(1,:,:),1);
aspectRatio = zeros(total_im,1);
%% Compute Aspect Ratio
% Compute the aspect ratios of all images and store the value of the i-th image in aRatios(i)
fprintf('Calculating aspect ratios...\n');
index = 0;
k = 0;
% C1train ratio
for i = 1:C1trainLen
    aspectRatio(i) = computeAspectRatio(train_C1_images(i,:,:),k);
end

% C2train ratio
index = index + C1trainLen;
k =1;
for i = 1:C2trainLen
    aspectRatio(index+i) = computeAspectRatio(train_C2_images(i,:,:),k);
    k = 0;
end

% C1test ratio
index = index + C2trainLen;
k =1;
for i = 1:C1testLen
    aspectRatio(index+i) = computeAspectRatio(test_C1_images(i,:,:),k);
    k = 0;
end

% C2test ratio
index = index + C1testLen;
k =1;
for i = 1:C2testLen
    aspectRatio(index+i) = computeAspectRatio(test_C2_images(i,:,:),k);
    k = 0;
end

minAspectRatio = min(aspectRatio);
maxAspectRatio = max(aspectRatio);

fprintf('Minimum aspect ratio: %.3f\n', minAspectRatio);
fprintf('Maximum aspect ratio: %.3f\n\n', maxAspectRatio);


fprintf('Program paused. Press enter to continue.\n');
fprintf('----------------------------------------\n\n');
pause;

%% Bayesian Classifier
fprintf('Calculate Classifiers.\n\n');
% Prior Probabilities
PC1 = C1trainLen / total_im;
PC2 = C2trainLen / total_im;

% Means of each class aspect ratio
muC1 = sum(aspectRatio(1:C1trainLen)) / C1trainLen

muC2 = sum(aspectRatio((C1trainLen+1):(C1trainLen + C2trainLen))) / C2trainLen;

% % Likelihoods
% PgivenC1 = ...
% PgivenC2 = ...
% 
% Calculate diviations of each class
sigmaC1 = 0;
for i = 1:C1trainLen
    sigmaC1 = sigmaC1 +  ((aspectRatio(i) - muC1)^2);
end
sigmaC1 = sqrt(sigmaC1 / C1trainLen );

sigmaC2 = 0;
for i = C1trainLen+1 : C1trainLen+C2trainLen
    sigmaC2 = sigmaC2 +  ((aspectRatio(i) - muC2)^2);
end
sigmaC2 = sqrt(sigmaC2 / C2trainLen ) ;

% Formula of each class
normalDistrC1 = @(xC1) 1/(sigmaC1^2 * sqrt(2*pi) ) * exp( (-1/2) * ( (xC1 - muC1) / sigmaC1^2)^2 );
normalDistrC2 = @(xC2) 1/(sigmaC2^2 * sqrt(2*pi) ) * exp( (-1/2) * ( (xC2 - muC2) / sigmaC2^2)^2 );

fprintf('Program paused. Press enter to continue.\n');
fprintf('----------------------------------------\n\n');
pause;
%% Classification result
% Init the results 
fprintf('Applying Classification.\n');

BayesClass = zeros(C1testLen + C2testLen, 1);
% Apply each test to the pdf and measure in which "pdf" is.
for i = 1:length(BayesClass)
    PgivenC1 = normalDistrC1(aspectRatio(trainTestLimit+i));
    PgivenC2 = normalDistrC2(aspectRatio(trainTestLimit+i));
%       PgivenC1 = 1/(sigmaC1^2 * sqrt(2*pi) ) * exp( (-1/2) * ( (aspectRatio(trainTestLimit+i) - muC1) / sigmaC1^2)^2 );
%       PgivenC2 = 1/(sigmaC2^2 * sqrt(2*pi) ) * exp( (-1/2) * ( (aspectRatio(trainTestLimit+i) - muC2) / sigmaC2^2)^2 );
%     PgivenC1 = arrayfun( normalDistrC1, aspectRatio(trainTestLimit+i) );
%     PgivenC2 = arrayfun( normalDistrC2, aspectRatio(trainTestLimit+i) );
    if (PgivenC1  <= PgivenC2 )
        BayesClass(i) = 2;
    else
        BayesClass(i) = 1;
    end
end

%% Count misclassified digits
count_errors_of_C1 = length(find( BayesClass(1:C1testLen) == 2 ));
count_errors_of_C2 = length(find( BayesClass(C1testLen+1:(C1testLen+C2testLen)) == 1 ));

count_errors = count_errors_of_C1 + count_errors_of_C2;

% Total Classification Error (percentage)
Error = count_errors / (C1testLen + C2testLen);

% show_im(test_C2_images(1,:,:))

fprintf('Total errors: %d (%f%%).\n',count_errors, Error)
fprintf('Class 1 errors: %d (%f%%).\n',count_errors_of_C1, (count_errors_of_C1/C1testLen))
fprintf('Class 2 errors: %d (%f%%).\n',count_errors_of_C2, (count_errors_of_C2/C2testLen))
