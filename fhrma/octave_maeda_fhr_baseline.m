% This file uses the MATLAB code provided in the FHRMA toolbox to find
% baseline FHR with the methodology from Maeda et al. 2012. I have done this
% as I have been unable to exactly replicate their results in Python, but it is
% unclear why this is the case.

clear;

% -----------------------------------------------------------------------------
% Import the data
% -----------------------------------------------------------------------------

% Set filename
filename='train_test_data/traindata_fhr/train42';

% Open file
f=fopen([filename, '.fhr'], 'r');

% Load timestamp for beginning of recording
timestamp=fread(f,1,'uint32');

% Load FHR data - first corresponds to first sensor, and
% second corresponds to second sensor (which they don't use)
data=fread(f,[3,10000000],'uint16');
FHR=data(1,:)/4;

% Close the file
fclose(f);

% -----------------------------------------------------------------------------
% Process using the Maeda function in FHRMA
% -----------------------------------------------------------------------------
function y=avgsubsamp(x,factor)
    y=zeros(1,floor(length(x)/factor));
    for i=1:length(y)
        y(i)=mean(x((i-1)*factor+1:i*factor));
    end
end

sFHR=avgsubsamp(FHR,8);
baseline=zeros(1,length(FHR));

% For loop of values of 0, 150, 300, 450...
for win=[0:150:length(sFHR)-151 length(sFHR)-150]

    % disp(win)
    % Not used, just extracted to support comparison to Python results
    % current = sFHR(win+1:win+150)

    bins=zeros(1,25);

    for i=1:150
        bins(ceil(sFHR(win+i)/10))=bins(ceil(sFHR(win+i)/10))+1;
    end
    [~,bestbins]=max(bins(1:20));

    baseline(win*8+1:win*8+1200)=mean(sFHR( sFHR<=bestbins*10 & sFHR>(bestbins-1)*10 ));

end


baseline(win*8+1201:length(FHR))=baseline(win*8+1200);

% -----------------------------------------------------------------------------
% Show results
% -----------------------------------------------------------------------------

d = [true, diff(baseline) ~= 0, true]; % TRUE if values change
n = diff(find(d)); % Number of repetitions
d(end) = []; % Remove last element so matches dimensions
reshape([baseline(d) n], 4, 2) % Combine into 2D array to show result
