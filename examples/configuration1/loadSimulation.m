function [  ] = loadSimulation(  )
%LOADSIMULATION Summary of this function goes here
%   Detailed explanation goes here

delete('monitoring.txt');
delete('dataset.dat');
delete('indicators.dat');

DCConfiguration2vm();

for l = 1:20
    for i = 1:5
        assessment([l,5]);
    end
end

for l = 1:20
    for i = 1:5
        assessment([5,l]);
    end
end

for l = 1:20
    for i = 1:5
        assessment([l,l]);
    end
end

plotMonitoringSingle;
