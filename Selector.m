%--------------------------------------------------------------------------
% Description:      Creates a per-input algorithm selector using random
%                       forests crossvalidated on number of trees and
%                       leaf size. Compares the performance of the selector
%                       on a held out test set versus the performance of a
%                       per-set selector and a perfect selector.
%--------------------------------------------------------------------------

%% Per-input algorithm selector

% Generate training data & testing data.
% algorithms = algorithms(dominatingSubset);
algorithms = {'shell' 'bucket' 'merge'};
numAlgorithms = numel(algorithms);

maxesIntervals = 10.^[0:6]; 
numMaxes = numel(maxesIntervals) - 1;
lengthIntervals = 10.^[0:6];  
numLengths = numel(lengthIntervals) - 1;
instancesPerLengthMax = 5;
numInstances = numMaxes * numLengths * instancesPerLengthMax;
lengths = zeros(numLengths, 1);
maxes = zeros(numMaxes, 1);
%%
% for i = 1:numMaxes
%    maxes(i) = randi(maxesIntervals(i) - maxesIntervals(i-1)) + maxesIntervals(i-1); 
% end
% 
% for i = 1:numLengths
%     lengths(i) = randi(lengthIntervals(i) - lengthIntervals(i-1)) + lengthIntervals(i-1);
% end

% I = {};
% D = zeros(numInstances, numAlgorithms);
% for k=1:numMaxes
%     m = maxes(k);
%     M = {};
%     for length=lengths
%         L = {};
%         for j=1:instancesPerLengthMax
%            i = randi(m,1,length);
%            
%            L = {L{1:end} i};
%         end
%         M = {M{1:end} L};
%     end
%     Dm = runSorts(M, algorithms, numLengths, instancesPerLengthMax, 0);
%     Dm1 = zeros(numLengths * instancesPerLengthMax, numAlgorithms);
%     for i=1:numAlgorithms
% %        size(Dm(i,:,:))
% %        size(squeeze(Dm(i,:,:)))
%        Dm1(:, i) = reshape(squeeze(Dm(i, :, :))', [numLengths*instancesPerLengthMax 1]); 
%     end
%     startIdx = (k-1) * numLengths*instancesPerLengthMax + 1;
%     endIdx = k * numLengths*instancesPerLengthMax;
%     D(startIdx:endIdx, :) = Dm1(:,:);
% end
Data = [];
X = [];
for j=1:numLengths
    for i=1:numMaxes
        for k=1:instancesPerLengthMax
            m = randi(maxesIntervals(i+1) - maxesIntervals(i)) + maxesIntervals(i);
            l = randi(lengthIntervals(j+1) - lengthIntervals(j)) + lengthIntervals(j);
            I = randi(m,1,l);
            M = {{I}};
            Dml = squeeze(runSorts(M, algorithms, 1, 1, 0));
            Data = [Data; Dml'];
            X = [X; [m l]];
        end
    end
    j
end


%% Per-set performance
[minPerf, perSetAlgorithm] = min(sum(Data)) 

%% Extract features to create clean data.
% X = zeros(numInstances, 2);
% lengthFeatures = [];
% for i=1:numLengths
%     lengthFeatures = [lengthFeatures; repmat(lengths(i), instancesPerLengthMax, 1)];
% end
% 
% for i=1:numMaxes
%     m = maxes(i);
%     numCopies = numLengths * instancesPerLengthMax;
%     startIdx = (i-1)*numCopies + 1;
%     endIdx = i*numCopies;
%     X(startIdx:endIdx, 1) = repmat(m, numCopies, 1);
%     X(startIdx:endIdx, 2) = lengthFeatures;
% end
[minVal,minIndex] = min(Data,[],2);
Y = minIndex;
% Split data for test and train.
N = round(2*numInstances/3);
T = numInstances - N;
perm = randperm(numInstances);
X(1:end,:) = X(perm,:); 
Y(:) = Y(perm);
Xtrain = X(1:N,:);
Ytrain = Y(1:N);
Xtest = X(N+1:end,:);
Ytest = Y(N+1:end);

% TODO (possibly) analyze time of extracting features.

%% Cross-validation on minLeafSize.
leafs = logspace(0,2,10);

% Build random forest with cross validation.
minError = inf;
minTree = inf;
minLeafSize = inf;
for numTrees=1:30
   for l = 1:10
       errors = zeros(10,1);
       for k=1:10
            % Split data
            xtrain_cv = Xtrain;
            ytrain_cv = Ytrain;
            xtrain_cv((k-1)*floor(N/10) + 1: k*floor(N/10), :) = [];
            ytrain_cv((k-1)*floor(N/10) + 1: k*floor(N/10)) = [];
            xval_cv = Xtrain((k-1)*floor(N/10) + 1: k*floor(N/10), :);
            yval_cv = Ytrain((k-1)*floor(N/10) + 1: k*floor(N/10));
            
            
            % Train on training set
            RF = TreeBagger(numTrees, xtrain_cv, ytrain_cv, 'SampleWithReplacement', 'on', 'Method', 'classification', 'MinLeafSize', l); 
            % Predict on validation set
            yval_hatcell = predict(RF, xval_cv);
            % Get fold error
            numVal = size(yval_cv, 1);
            yval_hat = zeros(numVal, 1);
            for t=1:numVal
                yval_hat(t) = yval_hatcell{t} - 48;
            end
            e = sum(yval_hat ~= yval_cv)/numVal;
            errors(k) = e;
       end
       % Average error over folds. 
       error = mean(errors);
       if error < minError
          minError = error; 
          minTree = numTrees;
          minLeafSize = l;
       end
   end
   numTrees
end

minTree
minLeafSize
RF = TreeBagger(minTree, Xtrain, Ytrain, 'SampleWithReplacement', 'on', 'Method', 'classification', 'MinLeafSize', minLeafSize);

% Predict on test data.
yhatCell = predict(RF, Xtest);
yhat = zeros(T,1);
for t=1:T
   yhat(t) = yhatCell{t} - 48; 
end
yhat
e = sum(yhat ~= Ytest)/T

%% Compare performance of per-set selector vs per-input on test data.
testData = Data(perm, :);
testData = testData(N+1:end, :);
perSetPerformance = sum(testData(:,perSetAlgorithm))
perInputPerformance = 0;
oraclePerformance = 0;
for t=1:T
   perInputPerformance = perInputPerformance + testData(t, yhat(t)); 
   oraclePerformance = oraclePerformance + min(testData(t, :));
end
perInputPerformance
oraclePerformance

%% Oracle performance
algorithms = {'bubble' 'bucket' 'cocktail' 'comb' 'heap' 'insertion' 'merge' 'quick' 'radix' 'selection' 'shell'};
oraclePerformance = 0;
for i=1:T
   testex = Xtest(i, :);
   m = testex(1)
   l = testex(2)
   I = randi(m,1,l);
   M = {{I}};
   Dml = squeeze(runSorts(M, algorithms, 1, 1, 0));
   oraclePerformance = oraclePerformance + min(Dml);
   i 
end