function [ locs, peak_diffs, pks ] = peak_detect_and_diffs( dataOut,x, Fs )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
       max=0;
       for i = 1:size(dataOut)-(3*Fs)
 
           for k = 1:(3*Fs)
                temp = dataOut(i+k);
                
               if(temp > max)
                max = temp;
               end                
           end
         tresholds(i) = max;   
         max=0;
         
       end

       peak_treshold = 0.4*mean(tresholds)

       %{
       figure;
       plot(x(1:end-(3*Fs)),tresholds);
       xlabel('Time (s)');
       ylabel('Amplitude (V)');
       title('R-PEAK ENVELOPE')
       %}
       
      % figure;
       MAXW = 0.01;
       MPD = 0.3;
       [pks,locs] = findpeaks(dataOut,x,'MinPeakHeight', peak_treshold,'MinPeakWidth', MAXW,'MinPeakDistance',MPD);

       
%Peak distances

       for i=2:size(locs)
          peak_diffs(i-1) = locs(i)-locs(i-1);
       end
       
        locs = locs(2:end);
        pks = pks(2:end);

end

