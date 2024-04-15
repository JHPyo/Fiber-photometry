function processAndPlotTTLData(FP_data, TTL_data, Pre, Post, Sampling_rate, FP_fullname, TTLType, suffix)
    myFolders = split(FP_fullname,"\");
    Filename = myFolders(end);
    Filename = char(Filename);
    Filename = strcat(extractBefore(Filename, length(Filename) - 15));
    Folder = char(join(myFolders(1:end-1),"\"));
    % Define time range for analysis
    TimeRange = Pre:1/Sampling_rate:Post;
    nTimePoints = length(TimeRange);

    % Initialize matrices for storing aligned data
    alignedData = [];
    TotalData = [];

    % Process each TTL event
    for i = 1:height(TTL_data)
        % Extract event time
        eventTime = TTL_data(i);

        % Align data to event time and extract relevant window
        startIndex = find(FP_data.Timestamp >= eventTime + Pre, 1, 'first');
        endIndex = find(FP_data.Timestamp <= eventTime + Post, 1, 'last');
        alignedSegment = FP_data.dff(startIndex:endIndex);

        % Interpolate or truncate data to match the time range
        if length(alignedSegment) > nTimePoints
            alignedSegment = interp1(linspace(Pre, Post, length(alignedSegment)), alignedSegment, TimeRange);
        elseif length(alignedSegment) < nTimePoints
            alignedSegment = [alignedSegment; nan(nTimePoints - length(alignedSegment), 1)];
        end

        % Append to aligned data matrix
        alignedData = [alignedData, alignedSegment];
    end
    writematrix(alignedData, ([Folder,'\', Filename,' ', TTLType, ' ', suffix '.csv'])) 
    % Calculate mean and SEM for plotting
    meanData = mean(alignedData, 2);
    semData = std(alignedData, 0, 2) / sqrt(size(alignedData, 2));
    TotalData = [TotalData, alignedData];
    % Generate plots
    plotTTLAlignedData(TimeRange, alignedData, meanData, semData, FP_fullname, TTLType, suffix);
end

function plotTTLAlignedData(TimeRange, alignedData, meanData, semData, FP_fullname, TTLType, suffix)
    myFolders = split(FP_fullname,"\");
    Filename = myFolders(end);
    Filename = char(Filename);
    Filename = strcat(extractBefore(Filename, length(Filename) - 15));
    % Create a figure for heatmap and line graph
    figure;

    % Heatmap
    subplot(2, 1, 1);
    imagesc(TimeRange, 1:size(alignedData, 2), alignedData');
    colormap redblue(1024);
    colorbar('northoutside');
    xlabel('Time (s)');
    ylabel('Trial');
    title([Filename,' ',TTLType,' ', suffix ' Heatmap']);

    % Line graph with SEM
    subplot(2, 1, 2);
    plot(TimeRange, meanData, 'LineWidth', 2);
    hold on;
    fill([TimeRange, fliplr(TimeRange)], [meanData-semData; flipud(meanData+semData)], 'b', 'LineStyle', 'none', 'FaceAlpha', 0.3);
    xlabel('Time (s)');
    ylabel('ΔF/F0 (%)');
    title([Filename,' ', TTLType, ' ', suffix ' Line Graph']);
    hold off;

    % Save figure
    saveas(gcf, fullfile(fileparts(FP_fullname), [Filename,' ',TTLType, suffix '.png']));
end