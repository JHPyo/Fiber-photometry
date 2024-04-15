function createFolder(directory)
    if ~exist(directory, 'dir')
        try
            mkdir(directory);
        catch
            fprintf('Error: Creating directory %s\n', directory);
        end
    end