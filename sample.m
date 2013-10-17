
function [ samples ] = sample( load )
%SAMPLE Samples CPU usage, power, and response time values for virtual machines and servers in
%the data center
% USAGE : [ samples ] = sample( load )
% INPUT: 
%   load - the load for each virtual machine in the configuration
% OUTPUT:
%   samples - the vector containing the values of the monitored part of the
%   data center

%configure the compoments of the data center
global VList;
global SList;
global VMAllocation;
global completeSList;

%sample vm cpu usage
for v = 1 : length(VList)
    l_i = round(load(VList(v).id) * VList(v).activity.prob);
    n_i = 0;

    for l = 1:l_i
        %n_i = n_i + poissrnd(VList(v).activity.lambda*100)/100;
        n_i = n_i + VList(v).activity.lambda + ((VList(v).activity.lambda - poissrnd(VList(v).activity.lambda*100)/100)/10);
    end
    n(VList(v).id) = n_i/VList(v).cpu;
    UV(VList(v).id) = min(n(v), 1);
    %compute weights for cpu usage
    s_id =  cell2mat(cellfun(@(x) [x.server * (find(x.vmList == VList(v).id) ~=0)], VMAllocation, 'UniformOutput',0));
    w(v) = VList(v).cpu /  SList([SList.id] == s_id).cpu;
end



%compute server cpu usage
for j = 1: length(completeSList)
    %check if the server is off
    if(isempty(SList([SList.id] == completeSList(j).id)))
        US(j) = 0;
    else
        %parameters for server cpu usage model
        s = 0.05;
        eta = 0.01*randn(1);
        temp = cell2mat(cellfun(@(x) [x.vmList * (x.server == completeSList(j).id)], VMAllocation, 'UniformOutput',0));
        vm_server = temp(temp~=0);
        u(j) = 0;
        umin(j) = 0;
        %u2(j) = 0;
        for k = 1:length(vm_server)
            u(j) = u(j)+ w(VList(vm_server(k)).id) * n(VList(vm_server(k)).id);
            umin(j) = umin(j) + w(VList(vm_server(k)).id) * UV(VList(vm_server(k)).id);
        end
        
        US(j) = min(1, u(j) + s + eta);
        umin(j) = min(1, umin(j) + s + eta);
        den = sum(w.*(n-UV));
        
        for k = 1:length(vm_server)
            UVExtra(VList(vm_server(k)).id) = min(n(VList(vm_server(k)).id)-UV(VList(vm_server(k)).id), (n(VList(vm_server(k)).id)-UV(VList(vm_server(k)).id))/den * (US(j)-umin(j)));
        end
    end
    
end

USExtra = US - umin;
UVReal = UV + UVExtra;

V = w.*UVReal;

%----------------------------------------------------------------------------------------------------------------------


%response time
gamma = 2;

for i = 1:length(VList)
    R(VList(i).id) = VList(i).activity.completionTime + VList(i).activity.completionTime/10 * UV(VList(i).id) / (1 - min(0.9,(n(VList(i).id) - UVReal(VList(i).id)))^gamma);
end;

%power sampling parameters
alpha = 0.66;
beta = 0.34;

%server power sampling
for j = 1:length(completeSList)
    if(isempty(SList([SList.id] == completeSList(j).id)))
        PS(completeSList(j).id) = 0;
    else
        PS(completeSList(j).id) = alpha * completeSList(j).peak + beta * completeSList(j).peak * US(completeSList(j).id);
    end
end

%virtual machine power assignment
for i = 1:length(VList)
    j = cell2mat(cellfun(@(x) [x.server * (find(x.vmList == VList(i).id) ~=0)], VMAllocation, 'UniformOutput',0));
    %j = find(VMAllocation(:,VList(i).id) == 1,1);
    ind = (find([SList.id] == j));
    PV(VList(i).id) = beta * SList(ind).peak * w(VList(i).id) * UVReal(i);
end

samples.UV = UV * 100;
samples.US = US * 100;
samples.R = R;
samples.PV = PV;
samples.PS = PS;
%samples. w = w;

dlmwrite('monitoring.txt', struct2array(samples), '-append');

