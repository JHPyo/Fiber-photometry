function processAvoidanceData(path)
    % Define output file name based on the path
    [parentDir, name, ~] = fileparts(path);
    outputFile = fullfile(parentDir, [name, '_Avoidance.csv']);
    
    % Initialize variables to store results
    Subject = {};
    TotalNumberofAvoidance1 = [];
    AvoidanceLatency = [];

    % List all CSV files in the specified directory
    files = dir(fullfile(path, '*.csv'));

    % Loop through each file
    for k = 1:length(files)
        full_name = fullfile(files(k).folder, files(k).name);
        disp(['In Processing :', full_name]);
        
        % Read data
        data = readtable(full_name);

        % Initialize variable for latency list
        AvoidanceLatencylist = [];
        
        % Compute number of 'Avoidance+' occurrences
        NumberofAvoidance2 = sum(strcmp(data.Event, 'Avoidance+'));
        
        % Calculate latency for each row
        latency = data.offset - data.onset; % Adjust Var2 and Var3 according to your data structure
        
        AvoidanceLatencylist = [AvoidanceLatencylist; latency];
        
        % Calculate mean latency and add to array
        AvoidanceLatency1 = mean(AvoidanceLatencylist);
        AvoidanceLatency = [AvoidanceLatency; AvoidanceLatency1];
        Subject = [Subject; {files(k).name(1:end-7)}];
        TotalNumberofAvoidance1 = [TotalNumberofAvoidance1; NumberofAvoidance2];
    end
    
    % Create a table with results
    df = table(Subject, TotalNumberofAvoidance1, AvoidanceLatency, 'VariableNames', {'Subject', 'Avoidance', 'Avoidance_Latency'});
    
    % Write to new CSV file
    writetable(df, outputFile);
end