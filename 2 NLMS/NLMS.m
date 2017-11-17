% INPUT
% d - vector of desired signal samples = clear source(ct) + noise(vt)
% u - vector of input signal samples = noise(vt)
% mu - the constant parameter of controlling step size
% M - length of FIR filter, number of taps
% a  - constant to mitigate norm(u) ~ 0

% OUTPUT
% e - output error vector = clear signal(et)

function [e, W] = NLMS(d, u, mu, M, a) % Normalized Least Mean Squares
    n_max = length(d);
    if (n_max ~= length(u)) return; end
    u = [zeros(M-1, 1); u]; % noise(vt) % 开头续了199个0，为了使u从第一个数开始读入
    w = zeros(M, 1); % the tap weights
    W = zeros(M, n_max); % a matrix M * n_max containing the coefficients
    y = zeros(n_max, 1);
    e = zeros(n_max, 1); % clear signal
    
    for n = 1:n_max
        uu = u(n+M-1:-1:n); % M+n-1~n, 200~1, 201~2, 32199~32000.. % 分段截取，每段200个(200*1)
        y(n) = w' * uu; % filtered noise, w'(1*200)
        e(n) = d(n) - y(n); % ct + vt - sum(wi(t) * v(t-i))
        % w = w + mu * e(n) * uu;
        
        % To overcome the possible numerical difficulties when ||u(n)|| is
        % very close to zero, a constant a > 0 is used:
        % wj(n+1) = wj(n) + e(n)*u(n-j)*mu/(a+||u(n)||^2)
        w = w + uu * e(n) * mu / (a + norm(uu)); 
        W(:, n) = w;
    end
end

