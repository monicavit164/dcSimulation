
%Data center components definition

%Servers: id, number of cpus, peak power consumption
S1.id = 1;
S1.cpu = 4;
S1.cpuT.trH = 90;
S1.cpuT.tyH = 80;
S1.cpuT.trL = 60;
S1.cpuT.tyL = 65;
S1.peak = 350;
S1.E.trH = 3100;
S1.E.tyH = 3000;

S2.id = 2;
S2.cpu = 4;
S2.cpuT.trH = 85;
S2.cpuT.tyH = 80;
S2.cpuT.trL = 70;
S2.cpuT.tyL = 75;
S2.peak = 280;
S2.E.trH = 3100;
S2.E.tyH = 3000;

SList = [S1, S2];

%SList = S1;

%Activities parameters definition
A1.id = 1;
A1.N = 1000;
A1.R.trH = 26;
A1.R.tyH = 24;
A1.PE.tyL = 1.5;
A1.PE.trL = 1.2;
A1.lambda = 0.2;
A1.prob = 1;
A1.completionTime = 20;

A2.id = 2;
A2.N = 10000;
A2.R.trH = 27;
A2.R.tyH = 26;
A2.PE.tyL = 9;
A2.PE.trL = 8;
A2.lambda = 0.3;
A2.prob = 1;
A2.completionTime = 20;

A3.id = 3;
A3.N = 5000;
A3.R.trH = 28;
A3.R.tyH = 26;
A3.PE.tyL = 1.5;
A3.PE.trL = 1.2;
A3.lambda = 0.25;
A3.prob = 1;
A3.completionTime = 20;

AList = [A1, A2, A3];
%AList = [A1, A2];

%Virtual Machines: id, number of cpus, number of transactions executed
%during a run of the activity, thresholds
V1.id = 1;
V1.cpu = 2;
V1.cpuT.trH = 95;
V1.cpuT.tyH = 90;
V1.cpuT.trL = 70;
V1.cpuT.tyL = 75;
V1.activity = A1;
V1.E.trH = 950;
V1.E.tyH = 700;



V2.id = 2;
V2.cpu = 2;
V2.cpuT.trH = 95;
V2.cpuT.tyH = 90;
V2.cpuT.trL = 70;
V2.cpuT.tyL = 75;
V2.activity = A2;
V2.E.trH = 950;
V2.E.tyH = 700;


V3.id = 3;
V3.cpu = 2;
V3.cpuT.trH = 95;
V3.cpuT.tyH = 90;
V3.cpuT.trL = 70;
V3.cpuT.tyL = 75;
V3.activity = A3;
V3.E.trH = 950;
V3.E.tyH = 700;

VList = [V1, V2, V3];
%VList = [V1, V2];

% rows are servers, columns are virtual machines, 1 if virtual machine j on
% server i
VMAllocation = [1 0 1; 0 1 0];
%VMAllocation = [1 1];



