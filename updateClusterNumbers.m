function [newClusterNumbers, newScore] = updateClusterNumbers(bee,score,Nr,numExamplesToReassign,X,k)

% Generate Nr recruited bees by randomly reassigning cluster numbers from
% current bee
recruitedBees = repmat(bee,1,Nr);
numExamples = size(X,1);
for recruitedBeeIdx = 1:Nr
    % select random examples to reassign
    examplesToReassign = randperm(numExamples,numExamplesToReassign);
    % reassign example cluster numbers
    recruitedBees(examplesToReassign,recruitedBeeIdx) = ...
        randomIntInRangeExcept(1,k,bee(examplesToReassign),numExamplesToReassign,1);
end

% Get scores of recruited bees
recruitedBeeScores = evaluateBees(recruitedBees,X,k);

% Find recruited bee with best score
[bestRecruitedBeeScore, bestRecruitedBeeIdx] = min(recruitedBeeScores);

% If best recruited bee score is better than original bee, update
if bestRecruitedBeeScore < score
    newClusterNumbers = recruitedBees(:,bestRecruitedBeeIdx);
    newScore = bestRecruitedBeeScore;
else
    newClusterNumbers = bee;
    newScore = score;
end