%% Exercise 1: 
% How do generate data according to different distributions in Matlab?

clear;
clc;
close all;

%% Uniform distribution.

% u1 is a vector containing 100000 pseudorandom variables from an uniform
% distribution.
u1 = rand(100000, 1); % 0-1的均匀分布

% The function hist can be used to count the number of values that fit in
% M = 50 bins.
M = 50; % 50个bins中值的数量，按1/50来分的

figure(1); 
hist(u1, M); % size(u1) = 100000 1
ylabel('Value count'); 
xlabel('Values');


%------------------------------------------------------------------------
% U is an 100x1000 matrix containing 100000 pseudorandom variables from an
% uniform distribution.
U = rand(100, 1000);

% We use the same hist function to count the values of the first row from U.
figure(2); 
hist(U(1, :), M); % size(U(1,:)) = 1 1000
ylabel('Value count'); 
xlabel('Values');

% Question: Why does the histogram look differently now? Why aren not the
% values distributed more or less uniformly in the bins?

% Only 1000 elements are counted in hist(U), but 100000 elements are
% counted in hist(u1). The scale of the y axis(value count) changed from
% 0-500 to 0-5.

%------------------------------------------------------------------------
% u2 is a vector containing 100000 pseudorandom variables from an uniform
% distribution.
u2 = -5 + 8 * rand(100000, 1);

% The function hist is used to count the number of values.
figure(3); 
hist(u2, M);
ylabel('Value count'); 
xlabel('Values');

% Question: What interval corresponds to the distribution?
% 8/50 = 0.16
