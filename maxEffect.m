function [ X, Y, Z ] = maxEffect(algorithm )
%--------------------------------------------------------------------------
% Inputs:           algorithm is a cell array with a single string 
%                       containing the name of the algorithm to run
%
% Outputs:          X is an array of the lengths of lists for which data
%                       was collected
%                   Y is an array of the maxElements for which data was
%                       collected
%                   Z is a 2D matrix where each Z(i,j) is the runtime for a
%                       list with length X(j) and maxElement Y(i)
%
% Description:      Explore the effect of different values as the upper
%                   bound on each element in an instance. For various 
%                   length lists, a logarithmically-scaled set of upper 
%                   bounds are tried.  Multiple instances are created for 
%                   each upper bound and their medians are plotted with 90% 
%                   bootstrap confidence intervals. A final surface of
%                   runtime vs list length vs maxElement is produced.
%--------------------------------------------------------------------------
lengths = round((10).^[1:6]);
numLengths = numel(lengths);
maxes = round(10.^[1:10])
numMaxes = numel(maxes);
Z = zeros(numMaxes, numLengths);
instancesPerMax = 11;

for k=1:numLengths
    length = lengths(k);
    I = {};
    for m = maxes
        X = {};
        for j = 1:instancesPerMax;
            i = randi(m,1,length);

            X = {X{1:end} i};
        end
        I = {I{1:end} X};
    end
    M = runSorts(I, algorithm, numMaxes, instancesPerMax, 0);

    % Get medians for each max
    medians = getQuantiles(M,0.5,1,numMaxes,instancesPerMax);

    % Create bootstrap confidence intervals for the medians
    nBoot = 1001;
    bootMedians = zeros(numMaxes,nBoot);
    for i = 1:nBoot
        MBoot = zeros(numMaxes, instancesPerMax);
        for j=1:numMaxes
            samp = randi(instancesPerMax, 1, instancesPerMax);
            MBoot(j,:) = M(1,j,samp);
        end
        bootMedian = median(MBoot, 2);
        bootMedians(:,i) = bootMedian;
    end
    
    % Sort medians for each max.
    for i=1:numMaxes
       sortedMedians = sort(bootMedians(i,:));
       bootMedians(i,:) = sortedMedians;
    end

    % Plot
    figure; hold on;
    p = semilogx(maxes,medians(1,:), '-*');
    color = get(p, 'color');
    boundColor = lightenColor(color, .5);
    semilogx(maxes, bootMedians(:,26), 'color', boundColor);
    semilogx(maxes, bootMedians(:,976), 'color', boundColor);
    legend('Medians', '95% UCB', '95% LCB');
    xlabel('Maximum element');
    ylabel('Running Time [Seconds]');
    title(strcat('Effect of Duplicates on Runtime of ', {' '}, algorithm{1}, {'sort '}, 'on Lists of Size', {' '}, int2str(length)));
    set(gca, 'XScale', 'log');
%     pause;
    csvwrite(strcat(algorithm{1}, 'size', num2str(k), 'PRC.csv'), [medians(1,:)' bootMedians(:,26) bootMedians(:,976)]);
    Z(:,k) = medians(1,:);
end
save(strcat(algorithm{1}, 'PRS.mat'), 'Z');
csvwrite(strcat(algorithm{1}, 'PRS.csv'), Z);
figure; 
Y = maxes;
X = lengths;
surf(X,Y,Z);
ylabel('Maximum Element');
xlabel('Input Size');
zlabel('Running Time [Seconds]');
title(strcat('Parameter Response Curve for ', {' '}, algorithm{1}, 'sort'));
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');

end

