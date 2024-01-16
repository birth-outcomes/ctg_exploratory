% This file uses the MATLAB code provided in the FHRMA toolbox to find
% baseline FHR with the methodology from Maeda et al. 2012.

clear;

octave_import_preprocess;

% Get list of all files in training data and loop through them
train_path = 'train_test_data/traindata_fhr';
train_files = dir([train_path '/*.fhr']);
for i = 1:length(train_files)
    file = train_files(i).name;
    % Import file and pre-process
    [FHR1, FHR2] = import_fhr([train_path '/' file]);
    FHR = process(FHR1, FHR2);
    % Get the file name seperate to the file path, and create csv path
    name = erase(file, '.fhr')
    csvpath = ['train_test_data/traindata_octave_csv/' name '.csv'];
    % Save to csv
    dlmwrite(csvpath, transpose(FHR), 'precision', '%.14f');
end

% Repeat for the test files
test_path = 'train_test_data/testdata_fhr';
test_files = dir([test_path '/*.fhr']);
for i = 1:length(test_files)
    file = test_files(i).name;
    [FHR1, FHR2] = import_fhr([test_path '/' file]);
    FHR = process(FHR1, FHR2);
    name = erase(file, '.fhr')
    csvpath = ['train_test_data/testdata_octave_csv/' name '.csv'];
    dlmwrite(csvpath, transpose(FHR), 'precision', '%.14f');
end
