%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NLMS.m - Normalized least mean squares algorithm
%
% Usage: [e, w, W] = NLMS(d, u, mu, M, a)
%
% Inputs:
% d  - the vector of desired signal samples of size Ns,
% u  - the vector of input signal samples of size Ns,
% mu - the µ parameter,
% M  - the number of taps.
% a  - constant to mitigate norm(u) ~ 0
%
% Outputs:
% e - the output error vector of size Ns
% w - the last tap weights
% W - a matrix M x Ns containing the coefficients (thir evolution)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [e, w, W] = NLMS(d, u, mu, M, a)

%% Initialization
Ns = length(d);
if (Ns ~= length(u)) help NLMS; return; end
u = [zeros(M-1, 1); u];
w = zeros(M,1);
W = zeros(M, Ns);
y = zeros(Ns,1);
e = zeros(Ns,1);

%% The LMS loop
for n = 1:Ns
    % write code here


    uu = u(n+M-1:-1:n);
    y(n) = w'*uu;
    e(n) = d(n) - y(n);
    w = w + (mu/(a+uu'*uu))*e(n)*uu;
    
    W(:,n) = w;


end

end

