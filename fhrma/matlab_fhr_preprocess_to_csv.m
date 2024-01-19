% MATLAB - creation of csv directly using FHRMA package in MATLAB
% Code to import and pre-process the files is copeid from saveMAanalyse.m

clear;

% Change to the directory of the FHRMA add-on
cd '/home/amy/MATLAB Add-Ons/Collections/Fetal Heart Rate Morphological Analysis Toolbox (FHRMA)'

load FHRMAdataset/analyses/expertAnalyses.mat

for i=1:156
    if i<=90
        f='FHRMAdataset/testdata/';
    else
        f='FHRMAdataset/traindata/';
    end
    
    [FHR1,FHR2,~,TOCO,timestamp]=fhropen([f data(i).filename]);
    [FHRi,FHRraw,TOCOi]=preprocess(FHR1,FHR2,TOCO,data(i).unreliableSignal);
    
    % Get filename
    name = erase(data(i).filename, '.fhr')
    
    % Save results to a csv file
    writematrix(transpose(FHRi), ['/home/amy/Documents/ctg_exploratory/fhrma/train_test_data/clean_fhr_matlab/' name '.csv']);
    
end