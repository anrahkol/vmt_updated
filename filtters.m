function [ dataOut ] = filtters( y, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


       [b,a] = butter(2,[59.9,60.1]/(Fs/2),'stop');
       filtered55 = filter(b,a,y);
    
       [d,c] = butter(10,100/(Fs/2),'low');
       filtered105 = filter(d,c,filtered55);
       
       [f,e] = butter(3,0.5/(Fs/2),'high');
       dataOut = filter(f,e,filtered105);

end

