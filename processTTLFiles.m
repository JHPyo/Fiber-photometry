function processTTLFiles(path)
    % Define output folder and create it if necessary
    [parentDir, ~, ~] = fileparts(path);

    % Define the output folder in the parent directory and create it if necessary
    outputFolder = fullfile(parentDir, 'TTL');
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    % List all files in the directory
    files = dir(fullfile(path, '*.csv'));

    % Process each file
    for k = 1:length(files)
        file = files(k);
        fullPath = fullfile(file.folder, file.name);
        disp(['Processing for TTL: ', fullPath]);

        % Read the CSV file, skipping the first row (header)
        data = readtable(fullPath, 'HeaderLines', 1);

        % Filter rows where the 6th column is not zero
        data2 = data(data{:, 6} ~= 0, :);

        % Initialize variables
        Start = [];
        End = [];
        Event = [];

        % Process the data
        Start(end + 1) = data2{1, 1};
        for i = 2:height(data2)
            if (data2{i, 1} - data2{i - 1, 1}) > 0.5
                Start(end + 1) = data2{i, 1};
                End(end + 1) = data2{i - 1, 1};
            end
        end
        End(end + 1) = data2{end, 1};

        % Analyze events
        for i = 1:length(Start)
            if End(i) - Start(i) > 24.99
                Event{end + 1} = 'Escape+';
            elseif End(i) - Start(i) < 24.99
                Event{end + 1} = 'Avoidance+';
            end
        end

        % Create and save the result table
        df = table(Event', Start', End', 'VariableNames', {'Event', 'onset', 'offset'});
        writetable(df, fullfile(outputFolder, strcat(extractBefore(file.name, length(file.name) - 3), '_TTL.csv')));
    end
end