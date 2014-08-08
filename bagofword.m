function [testIndex] = bagofword(train,test,trainIndex,clusterSize)
% Author: Huan N. Do - dohuan@msu.edu
% Input:
%       - train: each member contain: 
%           + features: nxp vector with n = number of valid
%                   points in one image, p = 64: feature dim
%           + point: SURFclass variables
%       - test: testing features from ONE test image
%       - trainIndex: label of all possible positions
%       - clusterSize: number of clusters, default: 500
% Output:
%       -testIndex: label of the position from which image was taken
%%    
    if (nargin<4)
        clusterSize = 500;
    end
    trainSize =  size(train,2);
    featurePool = [];
    % ----------- collect all features into the codebook ------------------
    for i=1:trainSize
       featurePool = [featurePool;train(i).feature]; 
    end
    % - idx: index of all feature in feature pool
    % - ctr: a kxp centroids; k: number of clusters, p = 64: feature dim
    [~,ctr] = kmeans(featurePool,clusterSize,'distance','cosine'); % create the codebook
    % ---------------- create histogram for train set ---------------------
    train_hist = zeros(trainSize,clusterSize);
    progressbar('create train hist from codebook ...');
    for i=1:trainSize
       size_temp = size(train(i).feature,1);
       feature_index_train = zeros(size_temp,1);
       for j=1:size_temp
          for k=1:clusterSize
            %dist(k) = sqrt(sum(train(i).feature(j,:)-ctr(k,:).^2));
            dist_train(k) = 1-(dot(train(i).feature(j,:),ctr(k,:))/...
                (norm(train(i).feature(j,:),2)*norm(ctr(k,:),2)));
          end
          minIndex = find(dist_train==min(dist_train));
          feature_index_train(j,1) = minIndex;
       end
       hist_temp = hist(feature_index_train,clusterSize);
       % -- normalize histogram
       train_hist(i,:) = hist_temp/sum(hist_temp);
       progressbar(i/trainSize);
    end
    
    % ---------------- create histogram for test set ----------------------
    testSize = size(test,2);
    test_hist = zeros(testSize,clusterSize);
    progressbar('create test hist from codebook ...');
    for i=1:testSize
        size_temp = size(test(i).feature,1);
        feature_index_test = zeros(size_temp,1);
        for j=1:size_temp
          for k=1:clusterSize
            %dist(k) = sqrt(sum(test(i).feature(j,:)-ctr(k,:).^2));
            dist_test(k) = 1-(dot(test(i).feature(j,:),ctr(k,:))/...
                (norm(test(i).feature(j,:),2)*norm(ctr(k,:),2)));
          end
          minIndex = find(dist_test==min(dist_test));
          feature_index_test(j,1) = minIndex;
        end
        hist_temp = hist(feature_index_test,clusterSize);
        % -- normalize histogram
        test_hist(i,:) = hist_temp/sum(hist_temp);
        progressbar(i/testSize);
    end
    % ---------------- use knn classifier to label the test ---------------
    testIndex = knnclassify(test_hist,train_hist,trainIndex,1,...
                                                   'correlation');
end