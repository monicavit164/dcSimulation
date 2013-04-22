function [  ] = loadSimulation(  )
%LOADSIMULATION Summary of this function goes here
%   Detailed explanation goes here

delete('monitoring.txt');
delete('dataset.dat');
delete('indicators.dat');

% for load_profile = 0:0.005:1
%     for i = 1:25
%         assessment('poisson',load_profile);
%     end
% end

%lambdaVector = [1.6, 1.3, 1.2; 0.5, 1.7, 1.6; 1.4, 0.6, 0.3; 1.6, 1.7 0.8; 0.3, 0.5, 0.9];

for l = 1:20
    for i = 1:5        
        assessment([l,5,5]);
    end
end

% for j = 1:100
%     l1 = round(rand*19)+1;
%     l2 = round(rand*19)+1;
%     l3 = round(rand*19)+1;
%     assessment([l1,l2, l3]);
% end

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

% for j = 1:100
%     l1 = round(rand*19)+1;
%     l2 = round(rand*19)+1;
%     l3 = round(rand*19)+1;
%     assessment([l1,l2, l3]);
% end

for l = 1:20
    for i = 1:5
        assessment([l,l,l]);
    end
end

% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l,l,l1]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l,l1,l]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l1,l,l]);
%     end
% end
% 
% for j = 1:100
%     l1 = round(rand*19)+1;
%     l2 = round(rand*19)+1;
%     l3 = round(rand*19)+1;
%     assessment([l1,l2, l3]);
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l,20-l, l1]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l1,20-l, l]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l,20-l,l]);
%     end
% end
% 
% 
% for j = 1:100
%     l1 = round(rand*19)+1;
%     l2 = round(rand*19)+1;
%     l3 = round(rand*19)+1;
%     assessment([l1,l2, l3]);
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([20-l,l,l1]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([20-l,l1,l]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([20-l,l,l]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l1,l,20-l]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l,l1,20-l]);
%     end
% end
% 
% for l = 1:20
%     l1 = round(rand*19)+1;
%     for i = 1:5
%         assessment([l,l,20-l]);
%     end
% end
% 
% for j = 1:100
%     l1 = round(rand*19)+1;
%     l2 = round(rand*19)+1;
%     l3 = round(rand*19)+1;
%     assessment([l1,l2, l3]);
% end





