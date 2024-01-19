% This file uses the MATLAB code provided in the FHRMA toolbox to find
% baseline FHR with the methodology from Maeda et al. 2012. I have done this
% as I have been unable to exactly replicate their results in Python, but it is
% unclear why this is the case.

clear;

% -----------------------------------------------------------------------------
% Import and pre-process an example
% -----------------------------------------------------------------------------

filename='train_test_data/traindata_fhr/train46.fhr';

octave_import_preprocess
[FHR1, FHR2] = import_fhr(filename);
FHR = process(FHR1, FHR2);

% To simplify the workspace, remove all variables except FHR
clearvars -except FHR;

% -----------------------------------------------------------------------------
% Process using the Maeda function in FHRMA
% -----------------------------------------------------------------------------

function y=avgsubsamp(x,factor)
    y=zeros(1,floor(length(x)/factor));
    for i=1:length(y)
        y(i)=mean(x((i-1)*factor+1:i*factor));
    end
end


function baseline=maedabaseline(FHR)

sFHR=avgsubsamp(FHR,8);
baseline=zeros(1,length(FHR));

% For loop of values of 0, 150, 300, 450...
% Except the penultimate value, which is for a section as short as needed to
% ensure that the final section is 150 long
for win=[0:150:length(sFHR)-151 length(sFHR)-150]

    bins=zeros(1,25);

    for i=1:150
        bins(ceil(sFHR(win+i)/10))=bins(ceil(sFHR(win+i)/10))+1;
    end
    [~,bestbins]=max(bins(1:20));

    baseline(win*8+1:win*8+1200)=mean(sFHR( sFHR<=bestbins*10 & sFHR>(bestbins-1)*10 ));

end


baseline(win*8+1201:length(FHR))=baseline(win*8+1200);

end

% -----------------------------------------------------------------------------
% Show results
% -----------------------------------------------------------------------------

baseline = maedabaseline(FHR);

d = [true, diff(baseline) ~= 0, true]; % TRUE if values change
n = diff(find(d)); % Number of repetitions
d(end) = []; % Remove last element so matches dimensions
format short g % set display format
reshape([baseline(d) n], length(n), 2) % Combine into 2D array to show result

% -----------------------------------------------------------------------------
% Import the FHRMA baseline
% (if want to use that rather than calculated above)
% -----------------------------------------------------------------------------

% Load the baseline data (and accelerations and decelerations)
struct = load('MD_std.mat');

% Extract the test01 baseline
%{
md_base = struct.data(91).baseline;
md_acc = struct.data(91).accelerations;
md_dec = struct.data(91).decelerations;
md_file = struct.data(91).filename;
%}

% -----------------------------------------------------------------------------
% Define function for acceleration and deceleration detection
% -----------------------------------------------------------------------------

function [acc,dec,falseacc,falsedec]=simpleaddetection(fhr,baseline)

acc=detectaccident(fhr-baseline,15);
dec=detectaccident(baseline-fhr,15);
falseacc=minusint(acc,detectaccident(fhr-baseline,5));
falsedec=minusint(dec,detectaccident(baseline-fhr,5));
end

function accidentsample=detectaccident(sig,thre)

% Find points where the difference between signal and baseline is past threshold
peaks=find(sig>thre);
% Create empty (3x0) array of zeros
accidentsample=zeros(3,0);
% Whilst there are points in peaks
while ~isempty(peaks)

    % Get points from sig up to the first peak, and set to 1 if less than 0

    % Being more than zero means it is over the baseline (in the direction we
    % are looking at) - e.g. acceleration, FHR-baseline, so FHR 140 baseline 135
    % would be result of 5, whilst FHR 130 baseline 135 would be -5.
    % Find the last indice of a non-zero point

    % So, in the signal before the peak, find the last point where it is < 0
    % (or, for accelerations eg., FHR is below the baseline)
    dacc=find(sig(1:peaks(1))<0,1,'last');
    % If there is no point below 0, set to 1
    if isempty(dacc)
        dacc=1;
    end

    % Then, from the point after dacc to the end, find the first index below 0
    facc=find(sig(dacc+1:end)<0,1,'first')+dacc;
    if isempty(facc)
        facc=length(sig);
    end

    % Between those two points, find index of the maximum (i.e. furthest from
    % baseline) (e.g. highest above baseline, for accelerations)
    [~,macc]=max(sig(dacc:facc));
    % Convert that to index in the actual signal
    macc=macc+dacc-1;
    % If length of the interval between the two points is greater than 15 secs
    if facc-dacc>15*4
        % Save the max, start and end to accident sample
        % Divide by 4 to get time in seconds
        % Divide by 60 to get time in minutes (not in their function but is in
        % their results)
        accidentsample=[accidentsample [dacc;facc;macc]/4/60];
    end
    % Filter peaks to those that fall after the interval explored above
    peaks=peaks(peaks>facc);
end
end

function f=minusint(a,f)

for i=1:size(a,2)
    n=find(f(1,:)>=a(1,i) &f(2,:)<=a(2,i));
    if ~isempty(n)
        f=f(:,[1:n-1 n+1:end]);
    end
end

end

% -----------------------------------------------------------------------------
% Apply function
% -----------------------------------------------------------------------------

[acc,dec,falseacc,falsedec]=simpleaddetection(FHR, baseline);
test_facc = detectaccident(FHR-baseline,5);

% -----------------------------------------------------------------------------
% Import all the FHRMA data and try to run baseline on all, recording if err
% -----------------------------------------------------------------------------

% Get current working directory
currentdir = pwd;

% Find all files that end with .fhr
fhr_files = dir(fullfile('train_test_data', '**/*.fhr'));

% Loop through files
for i = 1:length(fhr_files)

  % Get file
  fullpath = fullfile(fhr_files(i).folder, fhr_files(i).name);
  relativepath = strrep(fullpath, currentdir, '')(2:end);

  % Import and pre-process file
  [FHR1, FHR2] = import_fhr(relativepath);
  FHR = process(FHR1, FHR2);

  % Calculate baseline
  baseline = maedabaseline(FHR);

  % Make save path and save to csv
  [path, name, ext] = fileparts(relativepath);
  csvpath = ['train_test_data/maeda_octave/' name '.csv'];
  dlmwrite(csvpath, transpose(baseline), 'precision', '%.14f');

end
