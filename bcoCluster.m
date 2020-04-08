function [clusterNumbers, normalizedClusterCentroids] = bcoCluster(X,k,evalType,printFlag)
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

% normalize attributes to [0,1] range
X = (X-min(X,[],1))./(max(X,[],1)-min(X,[],1));

%% Algorithm parameters

% Number of scouting bees
Ns = 1000;

% Number of best sites
Nb = 100;

% Number of elite bees
Ne = 50;

% Number of recruited bees following elite bees
Nre = 20;

% Number of recruited bees following non-elite bees
Nrn = 10;

% Number of iterations (we can use this or some other stopping criterion)
numIterations = 50;

% Range within which neighborhood search will be done
range = 0.1;

%% Initialization

% Each "bee" is represented by a "layer" of a 3-D matrix
% Each bee/layer is k-by-numAttributes and gives the cluster centroids

scoutingBees = rand(k,numAttributes,Ns);
scoutingBeeScores = evaluateBees(scoutingBees,X,evalType);

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
            Nre,range,X,evalType);
        scoutingBees(:,:,eliteBeeIdx) = bestBee;
        scoutingBeeScores(eliteBeeIdx) = bestScore;
    end
    % Update other bee cluster numbers
    for nonEliteBeeIdx = nonEliteBeeIdxs
        [bestBee, bestScore] = doNeighborhoodSearch(...
            scoutingBees(:,:,nonEliteBeeIdx),scoutingBeeScores(nonEliteBeeIdx),...
            Nrn,range,X,evalType);
        scoutingBees(:,:,nonEliteBeeIdx) = bestBee;
        scoutingBeeScores(nonEliteBeeIdx) = bestScore;
    end
    % Set remaining bees randomly
    remainingBeeIdxs = otherIdxs(~ismember(otherIdxs,nonEliteBeeIdxs));
    scoutingBees(:,:,remainingBeeIdxs) = rand(k,numAttributes,length(remainingBeeIdxs));
    % Update scores of remaining bees
    scoutingBeeScores(remainingBeeIdxs) = evaluateBees(scoutingBees(:,:,remainingBeeIdxs),X,evalType);
    
    if printFlag
        fprintf('Iteration %d\n', iterIdx);
    end
end

% return cluster numbers corresponding to best-scoring bee
[~,bestIdx] = min(scoutingBeeScores);
clusterNumbers = knnsearch(scoutingBees(:,:,bestIdx),X);
normalizedClusterCentroids = scoutingBees(:,:,bestIdx);

end