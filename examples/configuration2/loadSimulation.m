function [  ] = loadSimulation(  )
%LOADSIMULATION This function simulates several loads saving simulated data
%about the monitored values, the assessed values and the row values of the
%indicators.
% USAGE : [] = loadSimulation( )

delete('monitoring.txt');
delete('dataset.dat');
delete('indicators.dat');

DCConfiguration();

for l = 1:20
    for i = 1:5        
        assessment([l,5,5]);
    end
end

for l = 1:20
    for i = 1:5        
        assessment([5,l,5]);
    end
end

for l = 1:20
    for i = 1:5
        assessment([5,5,l]);
    end
end

for l = 1:20
    for i = 1:5
        assessment([l,l,l]);
    end
end

plotMonitoring;






