%% Initialization
NrOfTrials = 10; % Number of realizations.
M = 6; % Adaptive filter length. Do not change.

ff = 1.0; % forgetting factor, use values in the range [0.998,1]

hRLS = dsp.RLSFilter('Length', M, 'Method', 'Conventional RLS', 'ForgettingFactor', ff);

% Desired signal
[d, fs] = audioread('S7_Quake_III_Arena_Gameplay.wav');

yl = 1e-6;
yl2 = 1;

e_RLS = [];
e_RLS_alg = [];

figure(1),
clf

% iterate over trials
for k = 1:NrOfTrials
    
    % Input signal
    [u, fs] = audioread(['S7_Quake_III_Arena_Gameplay_IIR_', num2str(k), '.wav']);
    u = u * 2^(24-16);
    
    % -- Recursive Least Squares algorithms.
    % RLS
    [y, e] = step(hRLS, u, d);
    e_RLS = [e_RLS, e]; 
    release(hRLS)
    
    % select a proper delta value, 
    % see http://www.cs.tut.fi/~tabus/course/AdvSP/21006Lect7.pdf, p.23
    % What is delta used for?
    % Adjust param w
    delta = round(100 * std(u)^2 + 1);
    % finish the implementation of RLS_alg()
    [e, w] = RLS_alg(d, u, M, ff, delta);
    e_RLS_alg = [e_RLS_alg, e];
    
    subplot 211
    cla
    semilogy(mean(e_RLS.^2, 2))
    title(['RLS, \lambda = ' num2str(ff)])
    ylim([-yl yl2])
    
    subplot 212
    cla
    semilogy(mean(e_RLS_alg.^2, 2))
    title(['RLS\_alg, \lambda = ' num2str(ff)])
    ylim([-yl yl2])
    
    drawnow
    
end

% What are these? 
% mean of errors of RLS and RLS_alg
% If our implementation of RLS_alg() was succesful, how should these look like?
% 3rd value should be 1

[ mean(mean(e_RLS(end/2:end, :).^2, 2))...
	mean(mean(e_RLS_alg(end/2:end, :).^2, 2))...
    mean(mean(e_RLS_alg(end/2:end, :).^2, 2)) / mean(mean(e_RLS(end/2:end, :).^2, 2))]

















