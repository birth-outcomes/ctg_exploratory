% This file uses the MATLAB code provided in the FHRMA toolbox to find
% baseline FHR with the methodology from Maeda et al. 2012.

clear;

octave_import_preprocess;

% Load expert analyses file
load expertAnalyses.mat

% Go through all 156, setting to correct filepath depending on train vs test
for i=1:156
    if i<=90
        f='train_test_data/testdata_fhr';
    else
        f='train_test_data/traindata_fhr';
    end

    % Get filename from the files in the expert analysis file
    file = data(i).filename;

    % Import file
    [FHR1, FHR2] = import_fhr([f '/' file]);

    % Identify any record of unreliable signal
    unreliable = data(i).unreliableSignal;

    % Process the signal
    FHR = process(FHR1, FHR2, unreliable);

    % Get the file name seperate to the file path, and create csv path
    name = erase(file, '.fhr')
    csvpath = ['train_test_data/traindata_octave_csv/' name '.csv'];

    % Save to csv
    dlmwrite(csvpath, transpose(FHR), 'precision', '%.14f');
end
