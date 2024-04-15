function processFluorescenceData(path, drop, Pre, Post, Pre2, Post2, TTL1, TTL2, Timebin, Sampling_rate)
    FP_directoryname = fullfile(path, 'FP');
    TTL_directoryname = fullfile(path, 'TTL');
    Sampling_rate_inverse = 1 / Sampling_rate;

    FP_files = dir(fullfile(FP_directoryname, '*Signal.csv'));

    for i = 1:length(FP_files)
        FP_fullname = fullfile(FP_files(i).folder, FP_files(i).name);
        disp(['Processing FP file: ', FP_fullname]);

        FP_data = readtable(FP_fullname);
        FP_data = FP_data(drop+1:end, :); % Drop initial rows

        % Perform linear fitting and calculate ΔF/F0
        reg = polyfit(FP_data.Control, FP_data.Signal, 1);
        ControlFit = polyval(reg, FP_data.Control);
        normDat = (FP_data.Signal - ControlFit) ./ ControlFit;
        normDatper = normDat * 100;
        FP_data.dff = normDatper;

        % Process TTL data
        TTL_filename = fullfile(TTL_directoryname, replace(FP_files(i).name, 'Signal.csv', 'TTL.csv'));
        TTL_data = readtable(TTL_filename);
        TTL_data1 = TTL_data(strcmp(TTL_data.Event, TTL1), :);;
        TTL_data1_onset = TTL_data1.onset;
        TTL_data1_offset = TTL_data1.offset;
        TTL_data2 = TTL_data(strcmp(TTL_data.Event, TTL2), :);
        TTL_data2_onset = TTL_data2.onset;
        % Process and plot data for TTL1 and TTL2
        processAndPlotTTLData(FP_data, TTL_data1_onset, Pre, Post, Sampling_rate, FP_fullname, TTL1, 'onset');
        processAndPlotTTLData(FP_data, TTL_data1_offset, Pre2, Post2, Sampling_rate, FP_fullname, TTL1, 'offset');
        processAndPlotTTLData(FP_data, TTL_data2_onset, Pre, Post, Sampling_rate, FP_fullname, TTL2, 'onset');
    end
end

function createFolder(directory)
    if ~exist(directory, 'dir')
        mkdir(directory);
    end
end