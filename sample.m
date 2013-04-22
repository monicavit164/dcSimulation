
function [ samples ] = sample( load )
%SAMPLEUSAGE Samples CPU usage values vor virtual machines and servers in
%the data center

%configure the compoments of the data center
DCConfiguration;

%sample vm cpu usage
for v = 1 : length(VList)
    l_i = round(load(VList(v).id) * VList(v).activity.prob);
    n_i = 0;

    for l = 1:l_i
        n_i = n_i + poissrnd(VList(v).activity.lambda*100)/100;
    end
    n(VList(v).id) = n_i/VList(v).cpu;
    UV(VList(v).id) = min(n(v), 1);
    %compute weights for cpu usage
    s_id = find(VMAllocation(:,VList(v).id) == 1);
    w(v) = VList(v).cpu / SList(s_id).cpu;
end



%compute server cpu usage
for j = 1: length(SList)
    %parameters for server cpu usage model
    s = 0.05;
    eta = 0.01*randn(1);
    vm_server = find(VMAllocation(j,:) == 1);
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
for j = 1:length(SList)
    PS(SList(j).id) = alpha * SList(j).peak + beta * SList(j).peak * US(SList(j).id);
end

%virtual machine power assignment
for i = 1:length(VList)
    j = find(VMAllocation(:,VList(i).id) == 1,1);
    PV(VList(i).id) = beta * SList(j).peak * w(VList(i).id) * UVReal(i);
end

samples.UV = UV * 100;
samples.US = US * 100;
samples.R = R;
samples.PV = PV;
samples.PS = PS;
%samples. w = w;

dlmwrite('monitoring.txt', struct2array(samples), '-append');

