
%this script plots the monitored values singularly

monitoring = load('monitoring.txt');

global SList;
global VList;

nv = length(VList);
n = length(SList);


for i = 1:length(VList)
   figure;
   plot(monitoring(:,i));
   xlabel('time (minutes)');
   ylabel('% of CPU');
   axis([0 300 0 110]);
end

for i = 1:length(SList)
   figure;
   plot(monitoring(:,nv+i));
   xlabel('time (minutes)');
   ylabel('% of CPU');
   axis([0 300 0 110]);
end


for i = 1:length(VList)
   figure;
   plot(monitoring(:,nv+n+i));
   xlabel('time(minutes)');
   ylabel('Response Time (ms)');
end

for i = 1:length(VList)
   figure;
   plot(monitoring(:,n+nv+nv+i));
   xlabel('time(minutes)');
   ylabel('Power (W) ');
   axis([0 300 0 100]);
end

for i = 1:length(SList)
   figure;
   plot(monitoring(:,n+nv+nv+nv+i));
   xlabel('time(minutes)');
   ylabel('Power (W) ');
   axis([0 300 0 360]);
end

