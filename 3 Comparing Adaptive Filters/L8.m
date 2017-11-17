% Calculate and plot the average error of the realizations i.e. learning curve
clear
close all
clc

%% Initialization
NrOfTrials = 10; % Number of realizations. 
M = 6; % Adaptive filter length.

mu_LMS = 0.0125; % The step size parameter for LMS.

% Create the filters using DSP System Toolbox
hLMS = dsp.LMSFilter(M, 'StepSize', mu_LMS);
hNLMS = dsp.LMSFilter(M, 'StepSize', mu_LMS, 'Method', 'Normalized LMS');
hSSLMS = dsp.LMSFilter(M, 'StepSize', mu_LMS, 'Method', 'Sign-Sign LMS');

hRLS = dsp.RLSFilter(M);
hHRLS = dsp.RLSFilter(M, 'Method', 'Householder RLS');
hHSWRLS = dsp.RLSFilter(M, 'Method', 'Householder sliding-window RLS');
% lambda = 0.99; % RLS forgetting factor
% p0 = 2 * eye(M); % Initial sqrt correlation matrix inverse
% hRLS = dsp.RLSFilter(M, 'ForgettingFactor', lambda, 'InitialInverseCovariance', p0);

% Desired signal
[d, fs] = audioread('S7_Quake_III_Arena_Gameplay.wav');

e = zeros(16000, 6); % e = [];
% nJ0_LMS = zeros(16000, 1); % keep here the average of the parameter error J = e^2

% iterate over trials
for k = 1:NrOfTrials
    % Input signal
    [u, fs] = audioread(['S7_Quake_III_Arena_Gameplay_IIR_', num2str(k), '.wav']);
    u = u * 2^(24-16);
    
    % -- Use the filters -------------------------------------------------
    % -- Least Mean Squares algorithms
    % LMS 
    [y_LMS, e_LMS, w_LMS] = step(hLMS, u, d);  e(:, 1) = e(:, 1) + e_LMS .^ 2;
    % NLMS
    [y_NLMS, e_NLMS, w_NLMS] = step(hNLMS, u, d);  e(:, 2) = e(:, 2) + e_NLMS .^ 2;
    % Sign-Sign LMS
    [y_SSLMS, e_SSLMS, w_SSLMS] = step(hSSLMS, u, d);  e(:, 3) = e(:, 3) + e_SSLMS .^ 2;
    
%     figure;
%     plot(e_LMS(1:100)); hold on; plot(e_NLMS(1:100)); hold on; plot(e_SSLMS(1:100));
%     title(['Least Mean Squares algorithms ', num2str(k)]);
%     legend('LMS', 'NLMS', 'Sign-Sign LMS', 'Location',  'NorthEast');
    
    % -- Recursive Least Squares algorithms.
    % RLS
    [y_RLS, e_RLS] = step(hRLS, u, d); e(:, 4) = e(:, 4) + e_RLS .^ 2;
    % Householder RLS
    [y_HRLS, e_HRLS] = step(hHRLS, u, d); e(:, 5) = e(:, 5) + e_HRLS .^ 2;
    % Householder sliding window RLS
    [y_HSWRLS, e_HSWRLS] = step(hHSWRLS, u, d); e(:, 6) = e(:, 6) + e_HSWRLS .^ 2;
    
%     figure;
%     plot(e_RLS(1:100)); hold on; plot(e_HRLS(1:100)); hold on; plot(e_HSWRLS(1:100));
%     title(['Recursive Least Squares algorithms ', num2str(k)]);
%     legend('RLS', 'Householder RLS', 'Householder sliding window RLS', 'Location',  'NorthEast');

%     nJ0_LMS = nJ0_LMS + J_LMS;
%     nJ0_NLMS = nJ0_NLMS + J_NLMS;
%     nJ0_SSLMS = nJ0_SSLMS + J_SSLMS;
%     nJ0_RLS = nJ0_RLS + J_RLS;
%     nJ0_HRLS = nJ0_HRLS + J_HRLS;
%     nJ0_HSWRLS = nJ0_HSWRLS + J_HSWRLS;
end

% -- Plot results here:
% Use legend, title, xlabel and ylabel to illustrate what is plotted.
% You can use the function semilogy to plot on logarithmic y-axis.
figure;
semilogy(e(:, 1) / NrOfTrials); hold on;
semilogy(e(:, 2) / NrOfTrials); hold on;
semilogy(e(:, 3) / NrOfTrials);
xlabel('Iteration number'); ylabel('Squarred filter error');
title('Learning curve J = e^2');
legend('LMS', 'NLMS', 'Sign-Sign LMS', 'Location',  'NorthEast');

% Why is it useful to take many realizations? 
% Can you observe the convergence time and steady state error from your plot?
% What is the theoretical difference of the algorithms? 
% How and why are the learning curves different? 


figure;
semilogy(e(:, 4) / NrOfTrials); hold on;
semilogy(e(:, 5) / NrOfTrials); hold on;
semilogy(e(:, 6) / NrOfTrials);
xlabel('Iteration number'); ylabel('Squarred filter error');
title('Learning curve J = e^2');
legend('RLS', 'Householder RLS', 'Householder sliding window RLS', 'Location',  'NorthEast');

% Do you see a different result for all the methods? Why?
% What is the effect of the forgetting factor?
% Is it in any way related to the filter length?


% Best algorithms
figure;
semilogy(e(:, 2) / NrOfTrials); hold on;
semilogy(e(:, 5) / NrOfTrials);
xlabel('Iteration number'); ylabel('Squarred filter error');
title('Best Algorithms Learning curve J = e^2');
legend('NLMS', 'Householder RLS', 'Location',  'NorthEast');

% What are the best performing algorithms? Householder RLS
% Does it make sense theoretically?
% What criteria do you use to define ¡±best¡±? Lowest error value


