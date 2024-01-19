% This file uses the MATLAB code provided in the FHRMA toolbox to import .fhr
% files and pre-process them. Note: You cannot start a script with a function
% keyword, it will raise an error.

a = 1

% -----------------------------------------------------------------------------
% Import the data
% -----------------------------------------------------------------------------

function [FHR1,FHR2]=import_fhr(filename)
    % Open file
    f=fopen(filename, 'r');

    % Load timestamp for beginning of recording
    timestamp=fread(f,1,'uint32');

    % Load FHR data - first corresponds to first sensor, and
    % second corresponds to second sensor (which they don't use)
    data=fread(f,[3,10000000],'uint16');
    FHR1=data(1,:)/4;
    FHR2=data(2,:)/4;

    % Close the file
    fclose(f);
end

% -----------------------------------------------------------------------------
% Pre-process
% This was performed with a series of functions, so I have sectioned to show
% which code is from which function
% -----------------------------------------------------------------------------

function FHR=process(FHR1, FHR2, unreliable)
  % From preprocess()...

  % Set to max of the two
  FHR=max([FHR1;FHR2]);

  for j=1:size(unreliable,1)
      disp(round(unreliable(j,1)*240+1))
      disp(round(unreliable(j,2)*240))
      disp(FHR(round(unreliable(j,1)*240+1):round(unreliable(j,2)*240)));
      FHR(round(unreliable(j,1)*240+1):round(unreliable(j,2)*240))=0;
      disp(FHR(round(unreliable(j,1)*240+1):round(unreliable(j,2)*240)));
  end

  % From removesmallpart()...

  % Remove extreme values
  FHR(FHR>220|FHR<50)=0;

  % Find indices where FHR transitions from zero to non-zero value
  % (e.g. if n has index 397, then 396 was 0 and 397 was not zero)
  n=find(FHR(1:end-1)==0 & FHR(2:end)>0)+1;

  for i=1:length(n)
      % Find the first occurence of 0 after a non-zero section
      % e.g. if n=397 and f=28, FHR(397+27) takes you to the first zero
      % so the length of the non-zero section was f-1
      f=find(FHR(n(i):end)==0,1,'first');
      % If f is less than 5 seconds (5*4), set that whole section to zero
      if f<5*4
        FHR(n(i):n(i)+f)=0;
      end
  end

  % Explained with example, where 0 is zero and 1 is non-zero:
  % 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1
  % Location of n:
  % - - - - - - - - - - ! - - - - - - - - - - - - - - - - - - - - -
  % Contributors to length of f:
  % - - - - - - - - - - ! ! ! ! ! ! ! ! ! ! ! - - - - - - - - - - -
  % Location of lastvalid:
  % - - - - ! - - - - - - - - - - - - - - - - - - - - - - - - - - -
  % Location of firstvalid:
  % - - - - - - - - - - - - - - - - - - - - - - - - - - ! - - - - -

  n=find(FHR(1:end-1)==0 & FHR(2:end)>0)+1;
  for i=1:length(n)
     % As above, find first occurence of 0 after a non-zero section (f)
     f=find(FHR(n(i):end)==0,1,'first');
     % If f is less than 30 seconds (30*4)
     if f<30*4

       % Find index of last non-zero before start of zero section before n
       lastvalid=find(FHR(1:n(i)-1)>0,1,'last');
       % Find index of first non-zero after the zero section after f
       nextvalid=find(FHR(n(i)+f:end)>0,1,'first')+n(i)+f-1;

       % Find difference between FHR at last valid and at n
       lastvalid_diff = FHR(n(i))-FHR(lastvalid);
       % Find difference between the last non-zero in the non-zero
       % section that started with n, and the first valid point after the
       % zeros that followed that
       nextvalid_diff = FHR(n(i)+f-2)-FHR(nextvalid);

       % If difference in the heart rate is more than absolute value of 25 for
       % both of those (with last valid and with first valid), then set that
       % non-zero portion that began with n and was f-1 long, to 0
       try
          if(  (lastvalid_diff<-25 && nextvalid_diff<-25 ))
              FHR(n(i):n(i)+f)=0;
          end
          if(  (lastvalid_diff>25 && nextvalid_diff>25 ))
              FHR(n(i):n(i)+f)=0;
          end
       catch
       end
    end
  end

  % From interpolfhr()...

  % Redundant
  % d=find(FHR>0,1);

  % Get the first index where FHR is non-zero and non-NaN
  n=find(FHR>0 & ~isnan(FHR),1);

  % Set any values preceding that index to the value of that index
  FHR(1:n)=FHR(n);

  % Redundant
  % d=n;

  % While you have a value of n and it is not the final index of FHR
  while ~isempty(n) && n<length(FHR)
    % Get index of first occurence after n that is zero or NaN
    n=find(FHR(n:end)==0|isnan(FHR(n:end)),1)+n-1;
    % Get index of first occurence after that new n, that is non-zero and non-NaN
    nf=find(FHR(n:end)>0&~isnan(FHR(n:end)),1)+n-1;
    % If you have found a subsequent value that is non-zero or non-NaN...
    if(~isempty(nf))
      % Linear interpolation between nf and the non-zero point before n
      % Populating that section of zeros
      FHR(n-1:nf)=linspace(FHR(n-1),FHR(nf),nf-n+2);
    end
    % Set n to nf
    n=nf;
  end

  % Get the last index where FHR is non-zero and non-NaN
  f=find(FHR>0&~isnan(FHR),1,'last');

  % Set any values following that index to the value of that index
  FHR(f:end)=FHR(f);

  % From preprocess()...

  % If any zero remain, set to NaN
  FHR(FHR==0)=NaN;
end
