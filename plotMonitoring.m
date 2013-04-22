
%plot monitoring results

monitoring = load('monitoring.txt');

DCConfiguration;

nv = length(VList);
n = length(SList) + nv;


for i = 1:length(SList)
   figure;
   vm_server = find(VMAllocation(i,:) == 1);
   u = zeros(size(monitoring,1), length(vm_server)+1);
   for j = 1:length(vm_server)
       u(:, j) = monitoring(:,vm_server(j));
       l{j} = ['UV', num2str(vm_server(j))];
   end
   u(:, j+1) = monitoring(:,length(VList)+i);
   l{j+1} = ['US', num2str(i)];
   X = repmat([1:size(monitoring,1)]', 1, length(vm_server)+1) ;
   plot(X, u);
   xlabel('time(minutes)');
   ylabel(['Usage on server ', num2str(i)]);
   legend(l);
end


for i = 1:length(SList)
   figure;
   vm_server = find(VMAllocation(i,:) == 1);
   rt = zeros(size(monitoring,1), length(vm_server));
   for j = 1:length(vm_server)
       rt(:, j) = monitoring(:,n + vm_server(j));
       l{j} = ['RT', num2str(vm_server(j))];
   end
   X = repmat([1:size(monitoring,1)]', 1, length(vm_server)) ;
   plot(X, rt);
   xlabel('time(minutes)');
   ylabel(['Response Time on server ', num2str(i)]);
   legend(l);
end

for i = 1:length(SList)
   figure;
   vm_server = find(VMAllocation(i,:) == 1);
   e = zeros(size(monitoring,1), length(vm_server)+1);
   for j = 1:length(vm_server)
       e(:, j) = monitoring(:,n+nv+vm_server(j));
       l{j} = ['EV', num2str(vm_server(j))];
   end
   e(:, j+1) = monitoring(:,n+nv+nv+i);
   l{j+1} = ['ES', num2str(i)];
   X = repmat([1:size(monitoring,1)]', 1, length(vm_server)+1) ;
   plot(X, e);
   xlabel('time(minutes)');
   ylabel(['Energy on server ', num2str(i)]);
   legend(l);
end



