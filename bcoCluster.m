function clusterNumbers = bcoCluster(X,k)
% Perform clustering using Bee Colony Optimization (BCO) algorithm

% Inputs:
%   X is an n-by-p matrix, where n is the number of examples and
%       p is the number of attributes
%   k is a scalar indicating the number of clusters

[numExamples, numAttributes] = size(X);

%% Algorithm parameters

% Number of scouting bees
Ns = 10;

% Number of best sites
Nb = 5;

% Number of elite bees
Ne = 2;

% Number of recruited bees following elite bees
Nre = 4;

% Number of recruited bees following non-elite bees
Nrn = 2;

% Number of iterations (we can use this or some other stopping criterion)
numIterations = 100;

% Number of examples to reassign for local search
numExamplesToReassign = round(0.05*numExamples);

%% Initialization

% Each "bee" is represented by a column in a matrix of cluster numbers
scoutingBees = randomIntInRange(1,k,numExamples,Ns);
scoutingBeeScores = evaluateBees(X,scoutingBees);

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
        scoutingBees(eliteBeeIdx) = updateClusterNumbers(...
            scoutingBees(:,eliteBeeIdx),scoutingBeeScores(eliteBeeIdx),...
            Nre,numExamplesToReassign,X,k);
    end
    % Update other bee cluster numbers
    for nonEliteBeeIdx = nonEliteBeeIdxs
        scoutingBees(eliteBeeIdx) = updateClusterNumbers(...
            scoutingBees(:,nonEliteBeeIdx),scoutingBeeScores(nonEliteBeeIdx),...
            Nrn,numExamplesToReassign,X,k);
    end
    % Set remaining bees randomly
    remainingBeeIdxs = otherIdxs(~ismember(otherIdxs,nonEliteBeeIdxs));
    scoutingBees(:,remainingBeeIdxs) = randomIntInRange(1,k,numExamples,length(remainingBeeIdxs));
    % Update scores
    scoutingBeeScores = evaluateBees(X,scoutingBees);
end

end