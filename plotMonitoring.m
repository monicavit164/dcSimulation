
%this script plots the monitored values grouped by server and category (cpu, response time, power)

monitoring = load('monitoring.txt');

global SList;
global VList;
global VMAllocation;

nv = length(VList);
n = length(SList) + nv;


for i = 1:length(SList)
   figure;
   vm_server = find(cell2mat(cellfun(@(x) [x.vmList * (x.server == i)], VMAllocation, 'UniformOutput',0)));
   u = zeros(size(monitoring,1), length(vm_server)+1);
   for j = 1:length(vm_server)
       u(:, j) = monitoring(:,vm_server(j));
       leg{j} = ['U(VM', num2str(vm_server(j)),  ')'];
   end
   u(:, j+1) = monitoring(:,length(VList)+i);
   leg{j+1} = ['U(S', num2str(i), ')'];
   X = repmat([1:size(monitoring,1)]', 1, length(vm_server)+1) ;
   plot(X, u);
   xlabel('time(minutes)');
   ylabel('% CPU');
   legend(leg);
   axis([0 300 0 110]);
end


for i = 1:length(SList)
   figure;
   vm_server = find(cell2mat(cellfun(@(x) [x.vmList * (x.server == i)], VMAllocation, 'UniformOutput',0)));
   rt = zeros(size(monitoring,1), length(vm_server));
   for j = 1:length(vm_server)
       rt(:, j) = monitoring(:,n + vm_server(j));
       leg{j} = ['RT(VM', num2str(vm_server(j)), ')'];
   end
   X = repmat([1:size(monitoring,1)]', 1, length(vm_server)) ;
   plot(X, rt);
   xlabel('time(minutes)');
   ylabel('Response Time (ms)');
   legend(leg);
end

for i = 1:length(SList)
   figure;
   vm_server = find(cell2mat(cellfun(@(x) [x.vmList * (x.server == i)], VMAllocation, 'UniformOutput',0)));
   e = zeros(size(monitoring,1), length(vm_server)+1);
   for j = 1:length(vm_server)
       e(:, j) = monitoring(:,n+nv+vm_server(j));
       leg{j} = ['P(VM', num2str(vm_server(j)), ')'];
   end
   e(:, j+1) = monitoring(:,n+nv+nv+i);
   leg{j+1} = ['P(S', num2str(i), ')'];
   X = repmat([1:size(monitoring,1)]', 1, length(vm_server)+1) ;
   plot(X, e);
   xlabel('time(minutes)');
   ylabel('Power (W)');
   legend(leg);
   axis([0 300 0 360]);
end



