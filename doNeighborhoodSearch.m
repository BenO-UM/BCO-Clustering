function [bestBee, bestScore] = doNeighborhoodSearch(originalBee,score,Nr,range,X,evalType)

% Generate Nr recruited bees by randomly reassigning cluster numbers from
% current bee
deviation = 2*range*rand(size(originalBee,1),size(originalBee,2),Nr)-range;
recruitedBees = repmat(originalBee,1,1,Nr)+deviation;
recruitedBees(recruitedBees>1) = 1;
recruitedBees(recruitedBees<0) = 0;

% Get scores of recruited bees
recruitedBeeScores = evaluateBees(recruitedBees,X,evalType);

% Find recruited bee with best score
[bestRecruitedBeeScore, bestRecruitedBeeIdx] = min(recruitedBeeScores);

% If best recruited bee score is better than original bee, update
if bestRecruitedBeeScore < score
    bestBee = recruitedBees(:,:,bestRecruitedBeeIdx);
    bestScore = bestRecruitedBeeScore;
else
    bestBee = originalBee;
    bestScore = score;
end