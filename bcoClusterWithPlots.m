function [clusterNumbers, normalizedClusterCentroids] = ...
    bcoClusterWithPlots(X,k,evalType,printFlag)
% Perform clustering using Bee Colony Optimization (BCO) algorithm

% Inputs:
%   X is an n-by-p matrix, where n is the number of examples and p is the
%       number of attributes
%   k is a scalar indicating the number of clusters
%   evalType (optional) is a string indicating how each solution should be 
%       evaluated. Possible values are:
%           'centroid' (default) - Computes sum square euclidean distance 
%               from each point to corresponding cluster centroid
%           'silhouette' - Computes silhouette cluster quality metric,
%               which essentially quantifies how close each point is to
%               each other point in its cluster (as opposed to closeness to
%               the centroid only)
%           To use default ('centroid'), you can give an empty argument
%               using []
%   printFlag (optional) is a boolean indicating whether iteration numbers 
%       should be printed to command window during execution of algorithm 
%       (best with large data sets where clustering may take a long time).
%       False by default.

if nargin < 3 || isempty(evalType)
    evalType = 'centroid';
end
if nargin < 4
    printFlag = false;
end

numAttributes = size(X,2);
if numAttributes ~= 2
    error('Data must have 2 attributes');
end

% normalize attributes to [0,1] range
minVals = min(X,[],1);
maxVals = max(X,[],1);
Xnorm = (X-minVals)./(maxVals-minVals);

%% Algorithm parameters

% Number of scouting bees
Ns = 200;

% Number of best sites
Nb = 50;

% Number of elite bees
Ne = 30;

% Number of recruited bees following elite bees
Nre = 30;

% Number of recruited bees following non-elite bees
Nrn = 15;

% Number of iterations (we can use this or some other stopping criterion)
numIterations = 200;

% Range within which neighborhood search will be done
range = 0.05;

%% Initialization

% Each "bee" is represented by a "layer" of a 3-D matrix
% Each bee/layer is k-by-numAttributes and gives the cluster centroids

scoutingBees = rand(k,numAttributes,Ns);
scoutingBeeScores = evaluateBees(scoutingBees,Xnorm,evalType);

vid = VideoWriter('clustering2.avi');
set(vid,'FrameRate',5);
open(vid);

figure('Units','normalized','OuterPosition',[0 0 1 1]);

%% Main loop
for iterIdx = 1:numIterations
    % Select elite bees
    [~,sortedIdxs] = sort(scoutingBeeScores);
    eliteBeeIdxs = sortedIdxs(1:Ne);
    % Select other bees for local search
    otherIdxs = sortedIdxs(Ne+1:end);
    nonEliteBeeIdxs = otherIdxs(randperm(length(otherIdxs),Nb-Ne));
    % Update elite bee cluster numbers
    for eliteBeeIdx = eliteBeeIdxs
        [bestBee, bestScore] = doNeighborhoodSearch(...
            scoutingBees(:,:,eliteBeeIdx),scoutingBeeScores(eliteBeeIdx),...
            Nre,range,Xnorm,evalType);
        scoutingBees(:,:,eliteBeeIdx) = bestBee;
        scoutingBeeScores(eliteBeeIdx) = bestScore;
    end
    % Update other bee cluster numbers
    for nonEliteBeeIdx = nonEliteBeeIdxs
        [bestBee, bestScore] = doNeighborhoodSearch(...
            scoutingBees(:,:,nonEliteBeeIdx),scoutingBeeScores(nonEliteBeeIdx),...
            Nrn,range,Xnorm,evalType);
        scoutingBees(:,:,nonEliteBeeIdx) = bestBee;
        scoutingBeeScores(nonEliteBeeIdx) = bestScore;
    end
    % Set remaining bees randomly
    remainingBeeIdxs = otherIdxs(~ismember(otherIdxs,nonEliteBeeIdxs));
    scoutingBees(:,:,remainingBeeIdxs) = rand(k,numAttributes,length(remainingBeeIdxs));
    % Update scores of remaining bees
    scoutingBeeScores(remainingBeeIdxs) = evaluateBees(scoutingBees(:,:,remainingBeeIdxs),Xnorm,evalType);
    
    if printFlag
        fprintf('Iteration %d\n', iterIdx);
    end
    
    [~,bestIdx] = min(scoutingBeeScores);
    clusterNumbers = knnsearch(scoutingBees(:,:,bestIdx),Xnorm);
    normalizedClusterCentroids = scoutingBees(:,:,bestIdx);
    clusterCentroids = normalizedClusterCentroids.*(maxVals-minVals)+minVals;
    clf;
    gscatter(X(:,1),X(:,2),clusterNumbers);
    hold on;
    set(gcf,'defaultLegendAutoUpdate','off');
    plot(clusterCentroids(:,1),clusterCentroids(:,2),'x','Color','black','MarkerSize',15,'LineWidth',3);
    title(sprintf('Iteration %d',iterIdx)); 
    writeVideo(vid,getframe(gcf));
end

close(vid);

% return cluster numbers corresponding to best-scoring bee


end