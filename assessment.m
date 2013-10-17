
function [indicatorsSample, assessedSample ] = assessment( load )
%ASSESSMENT This function simulate a given load and performs the assessment of the monitored data
%applying thresholds to the indicators according to what is specified in
%the configuration file "DCConfiguration.m"
% USAGE : [indicatorsSample, assessedSample ] = assessment( load )
% INPUT: 
%   load - the load for each virtual machine in the configuration
% OUTPUT:
%   indicatorsSample - the vector containing the actual values of all the
%   indicators
%   assessedSample - the vector containing the state of all the indicators

%DCConfiguration;
global VList;
global SList;
global completeSList;


T = 1;

for i = 1:T
    samples(i) = sample(load);
end

%compute indicators

%virtual machine average usage
UV = (mean(reshape([samples.UV], length(VList), size(samples,2) ),2))';
%server average usage
US = (mean(reshape([samples.US], length(completeSList), size(samples,2) ),2))';
%average response time
R = (mean(reshape([samples.R], length(VList), size(samples,2) ),2))';

%performance per energy
PV = reshape([samples.PV], length(VList), size(samples,2) );

PS = reshape([samples.PS], length(completeSList), size(samples,2) );

PE = zeros(1, length(VList));

%power is expressed in watt, energy in kilowattHour

for v = 1 : length(VList)
    if(UV(VList(v).id) == 0)
        PE(VList(v).id) = 0;
        EV(VList(v).id) = 0;
    else
        N_T = VList(v).activity.N/R(VList(v).id);
        if(length(PV(VList(v).id,:)) >1)
            EV(VList(v).id) = trapz(PV(VList(v).id,:))/T;
        else
            EV(VList(v).id) = PV(VList(v).id,:);
        end
        PE(VList(v).id) = N_T/EV(VList(v).id);
    end;
end

for s = 1 : length(completeSList)
    if(length(PS(completeSList(s).id,:)) >1)
        ES(completeSList(s).id) = trapz(PS(SList(s).id,:))/T;
    else
        ES(completeSList(s).id) = PS(completeSList(s).id,:);
    end
end

indicatorsSample = [UV, US, R, PE, EV, ES];
dlmwrite('indicators.dat', indicatorsSample, '-append');

%indicators threshold evaluation
assessedSample = zeros(size(indicatorsSample));

for i = 1 : length(UV)
    if UV(i) < VList(i).cpuT.trL
        assessedSample(i) = 1;
    elseif UV(i) < VList(i).cpuT.tyL
        assessedSample(i) = 2;
    elseif UV(i) <VList(i).cpuT.tyH
        assessedSample(i) = 3;
     elseif UV(i) <VList(i).cpuT.trH
        assessedSample(i) = 4;
    else assessedSample(i) = 5;
    end
end

for i = 1 : length(US)
    %if the server is off usage is considered satisfied
    if(isempty(SList([SList.id] == completeSList(i).id)))
        assessedSample(i+length(UV)) = 3;       
    elseif US(i) < completeSList(i).cpuT.trL
        assessedSample(i+length(UV)) = 1;
    elseif US(i) < completeSList(i).cpuT.tyL
        assessedSample(i+length(UV)) = 2;
    elseif US(i) <completeSList(i).cpuT.tyH
        assessedSample(i+length(UV)) = 3;
     elseif US(i) <completeSList(i).cpuT.trH
        assessedSample(i+length(UV)) = 4;
    else assessedSample(i+length(UV)) = 5;
    end
end

for i = 1 : length(R)
    if R(i) < VList(i).activity.R.tyH
        assessedSample(i+length(UV)+length(US)) = 3;
    elseif R(i) < VList(i).activity.R.trH
        assessedSample(i+length(UV)+length(US)) = 4;
    else assessedSample(i+length(UV)+length(US)) = 5;
    end
end

for i = 1 : length(PE)
    if PE(i) < VList(i).activity.PE.trL
        assessedSample(i+length(UV)+length(US)+length(R)) = 1;
    elseif PE(i) < VList(i).activity.PE.tyL
        assessedSample(i+length(UV)+length(US)+length(R)) = 2;
    else assessedSample(i+length(UV)+length(US)+length(R)) = 3;
    end
end

for i = 1 : length(EV)
    if EV(i) < VList(i).E.tyH
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)) = 3;
    elseif EV(i) < VList(i).E.trH
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)) = 4;
    else assessedSample(i+length(UV)+length(US)+length(R)+length(PE)) = 5;
    end
end

for i = 1 : length(ES)
    %if the server is off usage is considered satisfied
    if(isempty(SList([SList.id] == completeSList(i).id)))
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 3; 
    elseif ES(i) < completeSList(i).E.tyH
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 3;
    elseif ES(i) < completeSList(i).E.trH
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 4;
    else assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 5;
    end
end


%assessedSample((length(UV)+length(US)+length(R)+length(PE)+1):length(indicatorsSample)) = 3;

dlmwrite('dataset.dat', assessedSample, '-append');


