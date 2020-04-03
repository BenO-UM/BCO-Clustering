function plotTwoClusters(X,clusterNumbers)

clusterColor1 = 'red';
clusterColor2 = 'blue';

figure;
hold on;
for i = 1:size(X,1)
    if clusterNumbers(i)==1
        colorStr = clusterColor1;
    else
        colorStr = clusterColor2;
    end
    plot(X(i,1),X(i,2),'x','Color',colorStr);
end

end