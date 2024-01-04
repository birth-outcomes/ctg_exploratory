clear;

% Set filename
filename='train_test_data/testdata_fhr/test01';

% Open file
f=fopen([filename, '.fhr'], 'r');

% Load timestamp for beginning of recording
timestamp=fread(f,1,'uint32');

% Load FHR data - first corresponds to first sensor, and
% second corresponds to second sensor (which they don't use)
data=fread(f,[3,10000000],'uint16');
FHR1=data(1,:)/4;
FHR2=data(2,:)/4;

fseek(f,4,'bof');

% TOCO signal
data=fread(f,[6,10000000],'uint8');
TOCO=data(5,:)/2;

MHR=zeros(size(FHR1));
infos=[];
fclose(f);

% Save FHR1 to a file for use in python
csvwrite([filename, '.csv'], transpose(FHR1));
