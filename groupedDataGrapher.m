function groupedDataGrapher(data, position, freq)
%Plots the grouped position grouped data into 3d plots
%then averages powergains across the trials to come up with a 2d signiature


frequencyscale= freq.*0.001; %converts MHz to GHz
[X,Y] = meshgrid(frequencyscale, 1:size(data,1));
j = floor(sqrt(size(position,2)));
k = ceil(size(position,2)/j);
averages = zeros(1,size(data,2),size(position,2));
standard_devs = zeros(1,size(data,2),size(position,2));

figure(1)
for i = 1:size(position,2)
    subplot(j,k,i); surface(X,Y,data(:,:,i)); title(sprintf('Power at Position = %d cm', position(i))); xlabel('Frequency (GHz)'); ylabel('Trial Number'); h=colorbar; ylabel(h,'Power (dBm)');
end

for w = 1: size(position,2)
    for i = 1:size(data,2)
        averages(1,i,w) = mean(data(:,i,w));
        standard_devs(1,i,w) = std(data(:,i,w));
    end
end

figure(2)
for i = 1:size(position,2)
    subplot(j,k,i);
    hold on
    plot(frequencyscale,averages(1,:,i));
    plot(frequencyscale,averages(1,:,i)+2*standard_devs(1,:,i), '--','Color', [0.8500,0.3250,0.0980]); %plots +2 std deviations
    plot(frequencyscale,averages(1,:,i)-2*standard_devs(1,:,i), '--','Color', [0.8500,0.3250,0.0980]); %plots -2 std deviations
    title(sprintf('Averaged Power at %d cm (%d Trials)', position(i), size(data,1)));
    xlabel('Frequency (GHz)'); ylabel('Power (dBm)'); 
    %legend('Average', '+/- 2 std devs','FontSize', 5,'Location','SouthEast');
    hold off
end

figure(3)
Legend = cell(size(position,2),1);
for i = 1:size(position,2)
    hold on
    plot(frequencyscale,averages(1,:,i));
    title(sprintf('Averaged Power - All Positions Overlayed (%d Trials)', size(data,1)));
    xlabel('Frequency (GHz)'); ylabel('Power (dBm)'); 
    Legend{i}=sprintf('x = %d cm',position(i));
    hold off
end
legend(Legend,'FontSize', 8,'Location','SouthEast');
end

