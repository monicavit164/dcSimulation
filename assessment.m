
function [ assessedSample ] = assessment( load )
%ASSESSMENT Summary of this function goes here
%   Detailed explanation goes here

DCConfiguration;

T = 10;

for i = 1:T
    samples(i) = sample(load);
end

%compute indicators

%virtual machine average usage
UV = (mean(reshape([samples.UV], length(VList), size(samples,2) ),2))';
%server average usage
US = (mean(reshape([samples.US], length(SList), size(samples,2) ),2))';
%average response time
R = (mean(reshape([samples.R], length(VList), size(samples,2) ),2))';

%performance per energy
PV = reshape([samples.PV], length(VList), size(samples,2) );

PS = reshape([samples.PS], length(SList), size(samples,2) );

PE = zeros(1, length(VList));
for v = 1 : length(VList)
    if(UV(VList(v).id) == 0)
        PE(VList(v).id) = 0;
        EV(VList(v).id) = 0;
    else
        N_T = VList(v).activity.N/R(VList(v).id) * T;
        EV(VList(v).id) = trapz(PV(VList(v).id,:));
        PE(VList(v).id) = N_T/EV(VList(v).id)*1000;
    end;
end

for s = 1 : length(SList)
    ES(SList(s).id) = trapz(PS(SList(s).id,:));
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
    if US(i) < SList(i).cpuT.trL
        assessedSample(i+length(UV)) = 1;
    elseif US(i) < SList(i).cpuT.tyL
        assessedSample(i+length(UV)) = 2;
    elseif US(i) <SList(i).cpuT.tyH
        assessedSample(i+length(UV)) = 3;
     elseif US(i) <SList(i).cpuT.trH
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
    if ES(i) < SList(i).E.tyH
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 3;
    elseif ES(i) < SList(i).E.trH
        assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 4;
    else assessedSample(i+length(UV)+length(US)+length(R)+length(PE)+length(EV)) = 5;
    end
end


%assessedSample((length(UV)+length(US)+length(R)+length(PE)+1):length(indicatorsSample)) = 3;

dlmwrite('dataset.dat', assessedSample, '-append');


