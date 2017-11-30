% RLS_alg - Conventional recursive least squares
%
% Usage: [e, w] = RLS(d, u, M, ff, delta)
%
% Inputs:
% d  - the vector of desired signal samples of size Ns,
% u  - the vector of input signal samples of size Ns,
% M  - the number of taps.
% ff - forgetting factor
% delta - initialization parameter for P
%
% Outputs:
% e - the output error vector of size Ns
% w - the last tap weights

function [e, w] = RLS_alg(d, u, M, ff, delta)

% inital values
w = zeros(M ,1);
P = eye(M) * delta;

% input signal length
Ns = length(d);
u = [zeros(M-1, 1); u]; % zero padding

% error vector
e = zeros(Ns, 1);

for i = 1:Ns
    
    uu = u(i+M-1:-1:i); % M*1
    y = d(i); % 1*1
    
    % from http://www.cs.tut.fi/~tabus/course/AdvSP/21006Lect7.pdf, p. 24
    % implement all the steps 2.1-2.5 (label 2.5 is used three times, nevermind that)
  
    % 2.1
    pi_ = uu' * P; % 1*M
    % 2.2
    gamma = ff + pi_ * uu; % 1*1
    % 2.3
    k = pi_' / gamma; % M*1
    % 2.4
    e(i) = y - w(:, i)' * uu; % w1u1 + w2u2 + ..
    % 2.5
    w(:, i+1) = w(:, i) + k * e(i); % w(i+1) adjusted by current w+ke
    % 2.5
    P_ = k * pi_;
    % 2.5
    P = (P - P_) / ff;
    
end
end
