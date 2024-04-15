function processCSVFiles(path)
    % Display the path
    disp(['Processing path: ', path]);

    % Function to create a folder
    function createFolder(directory)
        if ~exist(directory, 'dir')
            try
                mkdir(directory);
            catch
                fprintf('Error: Creating directory %s\n', directory);
            end
        end
    end

    % Determine the parent directory of the path
    [parentDir, ~, ~] = fileparts(path);

    % Create the folder in the parent directory
    newFolder = fullfile(parentDir, 'FP');
    createFolder(newFolder);

    % Get all CSV files in the specified directory
    files = dir(fullfile(path, '*.csv')); % Non-recursive search

    % Loop through each file
    for k = 1:length(files)
        full_name = fullfile(files(k).folder, files(k).name);
        disp(['Processing for signal:', full_name]);
        
        % Read data
        data = readtable(full_name, 'HeaderLines', 1);
        
        % Rename columns
        data.Properties.VariableNames{'Time_s_'} = 'Timestamp';
        data.Properties.VariableNames{'AIn_1_Dem_AOut_1_'} = 'Control';
        data.Properties.VariableNames{'AIn_1_Dem_AOut_2_'} = 'Signal';
        
        % Select specific columns
        data = data(:, {'Timestamp', 'Signal', 'Control'});
        
        % Write to new CSV file
        newFileName = fullfile(newFolder, strrep(files(k).name, '.csv', '_Signal.csv'));
        writetable(data, newFileName, 'WriteVariableNames', true);
    end
end