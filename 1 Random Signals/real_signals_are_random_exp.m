function real_signals_are_random_exp(Y, dlt, cntr_pw, no)

nY = length(Y);

for i=1:no
    figure(1); clf;
    
    % Take intervals with length 2^(i+dlt):
    if cntr_pw(1) == 0
        Xcenters = 0:2^(i+dlt):2^cntr_pw(2);
    else
        Xcenters = -2^cntr_pw(1):2^(i+dlt):2^cntr_pw(2);
    end
    
    % How many intervals fit inside min(Y) max(Y):
    number_of_intervals_containing_data = ceil((max(Y)-min(Y))/2^(i+dlt))
    
    % Take the intervals having as centers the points
    % -2^cntr_pw(1):2^(i+dlt):2^cntr_pw(2),
    % and compute how many times Y has value in each interval;
    % the hist function gives quickly the answer, followed by a plot:
    hist(Y, Xcenters);
    hold on
    
    % Now compute the mean and variance of the values:
    [muhat] = expfit(Y);
    
    muhat_o = sum(Y)/length(Y);
    %sigmahat_o = sqrt(sum( (Y-muhat_o).^2)/length(Y));
    
    matlab_estimates = [muhat]
    own_estimates = [muhat_o]
    
    % Assume a normal distribution and plot the frequency of occurance for
    % each interval, according to the normal distribution hypothesis:
    if cntr_pw(1) == 0
        Xbounderies = [0 (Xcenters(1:(end-1)) + Xcenters(2:end))/2 2^cntr_pw(2)];
    else
        Xbounderies = [-2^cntr_pw(1) (Xcenters(1:(end-1)) + Xcenters(2:end))/2 2^cntr_pw(2)];
    end
    
    % Cumulative normal distribution at each boundary point P(x<Xb(j)):
    P = expcdf(Xbounderies, muhat);
    
    % Probability of each interval:
    Pint = P(2:end) - P(1:(end-1));
    plot(Xcenters, nY*Pint, '-ro');
    ylabel('Value count');
    xlabel('Centers values');
    
    pause;
    clc;
end

end