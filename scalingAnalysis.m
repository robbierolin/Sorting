function [ f, type,x,lo,hi ] = scalingAnalysis( x,y,maxValue,algorithm )
%--------------------------------------------------------------------------
% Inputs:           x is an array of input sizes (integers)
%                   y is an array of aggregate runtime metrics (in seconds) 
%                       for various sizes of instances for a given 
%                       algorithm
%                   maxValue is the largest number that can appear in a
%                       list to be sorted (integer)
%                   algorithm is the name of the algorithm for which the
%                       scaling analysis is being done (string)
%           
% Outputs:          f is a best-fit function to the input data.  If the
%                       function is a line then f is a single number such 
%                       that the line through f*x is the line of best fit.
%                       Otherwise f is an object returned by MATLABs fit
%                       function
%                   type is an integer where a value between 1-2 indicates
%                       the degree of the best-fit function and a value of
%                       5 indicates that the best-fit function is a
%                       nlogn function
%
% Description:      Performs a scaling analysis given a set of input sizes
%                   and an aggregate runtime metric for each input size. 
%                   Fits a line, quadratic, and nlogn curve to the data, 
%                   then performs an extrapolation challenge to determine 
%                   the best-fit.  The extrapolation challenge generates 
%                   instances up to twice as big as any instances seen so 
%                   far, determines the median runtime over multiple 
%                   instances for various input sizes greater than those 
%                   seen so far and selects the function with the lowest 
%                   RMSE on these new data points.  A figure is then 
%                   displayed with this function as well as a 90% 
%                   confidence interval for the function.  For a linear 
%                   function the confidence intervals are created using a 
%                   bootsrapping technique and for other functions the 
%                   confidence intervals can be read from the MATLAB 
%                   object.
%--------------------------------------------------------------------------

%% Fit monomials - TODO: clamp lower order terms - doesn't work so well, maybe try specifying starting point

figure; hold on;
p = plot((x),(y), '-*');
% color = get(p, 'color');
% plot(x,y,'*','color', color);
legend('Data', 'Location', 'NorthWest');
title(strcat('Median running times for',{' '}, algorithm, 'sort'));
xlabel('Input size');
ylabel('Running Time [seconds]');
% pause;

% Fit a line.
l = x\y;
line = l*x;
plot((x),(line), 'color', 'g');
legend('Data', 'Linear', 'Location', 'NorthWest');
% pause;

fits = cell(6);
% Fit a quadratic
[f1,gof1] = fit(x,y,'poly2', 'Normalize', 'off', 'Lower', [0,-inf,-inf], 'Upper', [inf,inf,inf]);
% [f1,gof1] = fit(x,y,'poly2', 'Normalize', 'on');
plot(f1, 'r-');
legend('Data','Linear','Quadratic', 'Location', 'NorthWest');
fits{1} = f1;
title(strcat('Median running times for',{' '}, algorithm, 'sort'));
xlabel('Input size');
ylabel('Running Time [seconds]');
% pause;

% Fit a cubic
% [f2,gof2] = fit(x,y,'poly3', 'Normalize', 'off', 'Lower', [0,-inf,-inf,-inf], 'Upper', [inf,inf,inf,inf]);
% % [f2,gof2] = fit(x,y,'poly3', 'Normalize', 'on');
% plot((f2), 'b-');
% legend('Data','Linear','Quadratic','Cubic', 'Location', 'NorthWest');
% fits{2} = f2;
% title(strcat('Median running times for',{' '}, algorithm, 'sort'));
% xlabel('Input size');
% ylabel('Running Time [seconds]');
% % pause;
% 
% % Fit a quartic
% [f3,gof3] = fit(x,y,'poly4', 'Normalize', 'off', 'Lower', [0,-inf,-inf,-inf,-inf], 'Upper', [inf,inf,inf,inf,inf]);
% % [f3,gof3] = fit(x,y,'poly4', 'Normalize', 'on');
% plot((f3), 'm-');
% legend('Data','Linear','Quadratic','Cubic','Quartic', 'Location', 'NorthWest');
% fits{3} = f3;
% title(strcat('Median running times for',{' '}, algorithm, 'sort'));
% xlabel('Input size');
% ylabel('Running Time [seconds]');
% pause;

%% Fit exponential
% fit 1-term 2-parameter exponential model.
% [f4,gof4] = fit(x,y,'exp1');
% plot((f4), 'c-');
% legend('Data','Linear','Quadratic','2-parameter exponential', 'Location', 'NorthWest');
% fits{4} = f4;
% title(strcat('Median running times for',{' '}, algorithm, 'sort'));
% xlabel('Input size');
% ylabel('Running Time [seconds]');
% pause;

%% Fit nlogn
nlogn = 'a*x*log2(b*x)';
[f5,gof5] = fit(x,y,nlogn, 'Lower', [0 1]);
plot((f5), 'm-');
legend('Data','Linear','Quadratic','nlog(n)','Location', 'NorthWest');
fits{5} = f5;
title(strcat('Median running times for',{' '}, algorithm, 'sort'));
xlabel('Input size');
ylabel('Running Time [seconds]');
%% Extrapolation Challenge.

% Generate a set of test inputs bigger than anything in input
% 11 inputs for 10 input sizes
maxSize = max(x);
minExtrapSize = floor(maxSize + maxSize/10);
% sizeGap = 1000;
% numSizes = 10;
% maxExtrapSize = minExtrapSize + (numSizes - 1)*sizeGap;
instancesPerSize = 11;
% sizes = minExtrapSize:sizeGap:maxExtrapSize;
sizes = maxSize * round(sqrt(10).^[1:4]);
numSizes = length(sizes);
maxExtrapSize = max(sizes);
I = generateInstances(instancesPerSize, maxValue, sizes, 0);
D = runSorts(I, {algorithm}, numSizes, instancesPerSize, 0);
D = reshape(D, [numSizes instancesPerSize]);

% Calculate the median for each input size
medians = median(D,2);

% Graph new points
xlim([0 maxExtrapSize + 100]);
scatter(sizes, medians);
plot([1 maxExtrapSize], l*[1 maxExtrapSize], 'color', 'g');
plot(f1, 'r-');
% plot(f2, 'b-');
% plot(f3, 'm-');
% plot(f4, 'c-');
plot(f5, 'm-');
legend('Data','Linear','Quadratic', 'nlog(n)','Extrapolated Data','Location', 'NorthWest');
title(strcat('Median running times for',{' '}, algorithm, 'sort'));
xlabel('Input size');
ylabel('Running Time [seconds]');


% Generate predictions for each input size for each function

% Predict from line
ypred = l*sizes;
rmse = sqrt(mean((ypred' - medians).^2))
rmseMin = rmse;
minFunc = 0;

% Predict from polynomials/exponential, calculate RMSEs
for i=2:6
   f = fits{i-1};
   if i== 3 || i ==4 || i == 5
       continue;
   end
   pred = f(sizes);
   rmse = sqrt(mean((pred - medians).^2))
   if rmse < rmseMin
       rmseMin = rmse;
       minFunc = i;
   end
end
minFunc
if minFunc == 0
    type = 1;
    f = l;
% elseif minFunc < 4
%     type = 'polynomial';
%     f = fits{minFunc-1};
else
%     type = 'exponential';
    type = minFunc;
    f = fits{minFunc-1};
end

%% Refit best function with extrapolation data
x = [x; sizes'];
y = [y; medians]; 
if type == 1
    f = x\y;
elseif type == 2
    f = fit(x,y,'poly2', 'Normalize', 'off', 'Lower', [0,-inf,-inf], 'Upper', [inf,inf,inf]);
elseif type == 3
    f = fit(x,y,'poly3', 'Normalize', 'off', 'Lower', [0,-inf,-inf,-inf], 'Upper', [inf,inf,inf,inf]);
elseif type == 4
    f = fit(x,y,'poly4', 'Normalize', 'off', 'Lower', [0,-inf,-inf,-inf,-inf], 'Upper', [inf,inf,inf,inf,inf]);
elseif type == 5
    f = fit(x,y,'exp1');
elseif type == 6
    f = fit(x,y,nlogn, 'Lower', [0 1]);

end

%% Compute CI for best fitting function
lo = 0;
hi = 0;
if type == 1
    nboot = 101;
    lines = zeros(nboot,1);
    numElements = size(x,1);
    l = f;
    for i = 1:nboot
       % Generate bootstrap sample
       samp = randi(numElements, 1, numElements);
       
       xboot = x(samp);
       yboot = y(samp);
       
       % compute line
       bootLine = xboot\yboot;
       
       % store line
       lines(i) = bootLine;
    end
    
    lines = sort(lines);
    lo = lines(6);
    hi = lines(96);
    figure; hold on;
    plot(x,y, '-*');
    plot([1 maxExtrapSize], l*[1 maxExtrapSize], 'color', 'r');
    plot([1 maxExtrapSize], lo*[1 maxExtrapSize], 'color', lightenColor([1 0 0], .5));
    plot([1 maxExtrapSize], hi*[1 maxExtrapSize], 'color', lightenColor([1 0 0], .5));
    
    title(strcat('Median running times for',{' '}, algorithm, 'sort'));
    xlabel('Input size');
    ylabel('Running Time [seconds]');
    legend('Data', 'Fit Function', '90% Confidence Bounds', 'Location', 'NorthWest');
        
else
    figure; hold on;
    
    ci = predint( f, 1:maxExtrapSize, 0.90, 'observation' );
    xlim([0 maxExtrapSize]);
    plot(x,y, '-*')
    plot(f,'r');
    plot(1:maxExtrapSize, ci(:,1), 'color', lightenColor([1 0 0], .5));
    plot(1:maxExtrapSize, ci(:,2), 'color', lightenColor([1 0 0], .5));
    
    title(strcat('Median running times for',{' '}, algorithm, 'sort'));
    xlabel('Input size');
    ylabel('Running Time [seconds]');
    legend('Data', 'Fit Function', '90% Confidence Bounds', 'Location', 'NorthWest');
end
x = x';
y = y';
end

