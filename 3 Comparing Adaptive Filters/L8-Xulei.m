% Calculate and plot the average error of the realizations i.e. learning curve
clear
close all
clc

%% Initialization
NrOfTrials = 10; % Number of realizations. 
M = 6; % Adaptive filter length.

mu_LMS = 0.05; % The step size parameter for LMS.
% mu_NLMS = 1;
mu_SSLMS = 0.01;
lambda = 0.99; % RLS forgetting factor
p0 = 10 * eye(M); % Initial sqrt correlation matrix inverse
g0 = sqrt(10) * eye(M);
N  = 64; % block length

% Create the filters using DSP System Toolbox
hLMS = dsp.LMSFilter(M, 'StepSize', mu_LMS);
hNLMS = dsp.LMSFilter(M, 'StepSize', mu_LMS, 'Method', 'Normalized LMS');
hSSLMS = dsp.LMSFilter(M, 'StepSize', mu_SSLMS, 'Method', 'Sign-Sign LMS');

hRLS = dsp.RLSFilter(M, 'ForgettingFactor', lambda, 'InitialInverseCovariance', p0);
hHRLS = dsp.RLSFilter(M, 'ForgettingFactor', lambda, 'InitialInverseCovariance', g0, 'Method', 'Householder RLS');
hHSWRLS = dsp.RLSFilter(M, 'ForgettingFactor', lambda, 'InitialInverseCovariance', g0, 'Method', 'Householder sliding-window RLS');

% Desired signal
[d, fs] = audioread('S7_Quake_III_Arena_Gameplay.wav');

% Initialize the error containers
eLMS = zeros(NrOfTrials, length(d));
eNLMS = eLMS; eSSLMS = eLMS;
eRLS = eLMS; eHRLS = eLMS; eHSWRLS = eLMS;

% iterate over trials
for k = 1:NrOfTrials
    % Input signal
    [u, fs] = audioread(['S7_Quake_III_Arena_Gameplay_IIR_', num2str(k), '.wav']);
    u = u * 2^(24-16);
    
    % -- Least Mean Squares algorithms
    % LMS 
    [yLMS, eLMS(k, :)] = step(hLMS, u, d);
    % NLMS
    [yNLMS, eNLMS(k, :)] = step(hNLMS, u, d);
    % Sign-Sign LMS
    [ySSLMS, eSSLMS(k, :)] = step(hSSLMS, u, d);
    
    % -- Recursive Least Squares algorithms.
    % RLS
    [yRLS, eRLS(k, :)] = step(hRLS, u, d);
    % Householder RLS
    [yHRLS, eHRLS(k, :)] = step(hHRLS, u, d);
    % Householder sliding window RLS
    [yHSWRLS, eHSWRLS(k, :)] = step(hHSWRLS, u, d);
end


% -- Plot results here:
% Use legend, title, xlabel and ylabel to illustrate what is plotted.
% You can use the function semilogy to plot on logarithmic y-axis.

% LMS
eLMS_MAE = mean(abs(eLMS));
eNLMS_MAE = mean(abs(eNLMS));
eSSLMS_MAE = mean(abs(eSSLMS));
semilogy(eLMS_MAE); hold on;
semilogy(eNLMS_MAE); hold on;
semilogy(eSSLMS_MAE);
title('LMS'); legend('LMS Error', 'NLMS Error', 'SSLMS Error');
xlabel('Time index'); ylabel('Signal Value');

% RLS
figure;
eRLS_MAE = mean(abs(eRLS));
eHRLS_MAE = mean(abs(eHRLS));
eHSWRLS_MAE = mean(abs(eHSWRLS));
semilogy(eRLS_MAE); hold on;
semilogy(eHRLS_MAE); hold on;
semilogy(eHSWRLS_MAE);
title('RLS'); legend('RLS Error', 'HRLS Error', 'HSWRLS Error');
xlabel('Time index'); ylabel('Signal Value');

