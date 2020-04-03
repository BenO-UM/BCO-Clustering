function clusterNumbers = bcoCluster(X,k)
% Perform clustering using Bee Colony Optimization (BCO) algorithm

% Inputs:
%   X is an n-by-p matrix, where n is the number of examples and p is the
%       number of attributes
%   k is a scalar indicating the number of clusters

numExamples = size(X,1);

%% Algorithm parameters

% Number of scouting bees
Ns = 200;

% Number of best sites
Nb = 20;

% Number of elite bees
Ne = 10;

% Number of recruited bees following elite bees
Nre = 30;

% Number of recruited bees following non-elite bees
Nrn = 15;

% Number of iterations (we can use this or some other stopping criterion)
numIterations = 500;

% Number of examples to reassign for local search
numExamplesToReassign = round(0.05*numExamples);

%% Initialization

% Each "bee" is represented by a column in a matrix of cluster numbers
scoutingBees = randomIntInRange(1,k,numExamples,Ns);
scoutingBeeScores = evaluateBees(scoutingBees,X,k);

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
        [updatedClusterNumbers, updatedScore] = updateClusterNumbers(...
            scoutingBees(:,eliteBeeIdx),scoutingBeeScores(eliteBeeIdx),...
            Nre,numExamplesToReassign,X,k);
        scoutingBees(:,eliteBeeIdx) = updatedClusterNumbers;
        scoutingBeeScores(eliteBeeIdx) = updatedScore;
    end
    % Update other bee cluster numbers
    for nonEliteBeeIdx = nonEliteBeeIdxs
        [updatedClusterNumbers, updatedScore] = updateClusterNumbers(...
            scoutingBees(:,nonEliteBeeIdx),scoutingBeeScores(nonEliteBeeIdx),...
            Nrn,numExamplesToReassign,X,k);
        scoutingBees(:,nonEliteBeeIdx) = updatedClusterNumbers;
        scoutingBeeScores(nonEliteBeeIdx) = updatedScore;
    end
    % Set remaining bees randomly
    remainingBeeIdxs = otherIdxs(~ismember(otherIdxs,nonEliteBeeIdxs));
    scoutingBees(:,remainingBeeIdxs) = randomIntInRange(1,k,numExamples,length(remainingBeeIdxs));
    % Update scores of remaining bees
    scoutingBeeScores(remainingBeeIdxs) = evaluateBees(scoutingBees(:,remainingBeeIdxs),X,k);
end

% return cluster numbers corresponding to best-scoring bee
[~,bestIdx] = min(scoutingBeeScores);
clusterNumbers = scoutingBees(:,bestIdx);

% Idea for improvement - calculate cluster centroids from clusterNumbers 
% above, and assign each point to nearest cluster centroid

end