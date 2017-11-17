%% Initialization
clear all;
NrOfTrials = 10; % Number of realizations. 
M = 6; % Adaptive filter length. Do not change.

mu_LMS = 0.01; % The step size parameter for LMS. Change.

% Create the filters using DSP System Toolbox
%hLMS = dsp.LMSFilter;
%hRLS = dsp.RLSFilter;


% Desired signal
[d, fs] = audioread('S7_Quake_III_Arena_Gameplay.wav');
for steplength=mu_LMS:0.01:0.15
e = [];
% iterate over trials
for k=1:NrOfTrials
    % Input signal
    [u, fs] = audioread(['S7_Quake_III_Arena_Gameplay_IIR_', num2str(k), '.wav']);
    u = u * 2^(24-16);
    
    % -- Use the filters -------------------------------------------------
     
    % -- Least Mean Squares algorithms
    % LMS 
    lms_filt=dsp.LMSFilter('Length',M,'Method','LMS','StepSize',steplength);
    [yLMS(k,:),eLMS(k,:),wLMS(k,:)]=lms_filt(u,d);
    % NLMS
    nlms_filt=dsp.LMSFilter('Length',M,'Method','Normalized LMS','StepSize',steplength);
    [yNLMS(k,:),eNLMS(k,:),wNLMS(k,:)]=nlms_filt(u,d);   
    % Sign-Sign LMS
    sslms_filt=dsp.LMSFilter('Length',M,'Method','Sign-Sign LMS','StepSize',steplength);
    [ySSLMS(k,:),eSSLMS(k,:),wSSLMS(k,:)]=sslms_filt(u,d);   
end
    
    
    eLMS1=sum(eLMS.^2)/NrOfTrials;
    eNLMS1=sum(eNLMS.^2)/NrOfTrials;
    eSSLMS1=sum(eSSLMS.^2)/NrOfTrials;



    n=length(d);
    figure;
    semilogy(1:n,eLMS1,'r',1:n,eNLMS1,'b',1:n,eSSLMS1,'g');
    legend('LMS','NLMS','Sign-Sign LMS');
    title(['Learning curve Ee(n)^2 of IIR for different algorithm for mu=',num2str(steplength)]);
    ylabel('Ee^2');
    xlabel('time step n');
end

for i=0.1:0.1:1
e = [];
% iterate over trials
for k=1:NrOfTrials
    % Input signal
    [u, fs] = audioread(['S7_Quake_III_Arena_Gameplay_IIR_', num2str(k), '.wav']);
    u = u * 2^(24-16);
% Different reaizations makes the input of different properties, because the
% LMS are linear, the average of different realizations are more accurate.
% Normalized LMS algorithm generally converges faster than LMS 
% but the the error is also larger than LMS algorithm. THis is because the 
% denominator of the NLMS limit the coefficients of the filter which makes
% it easy to converge but not so accurate.
    
    % -- Use the filters -------------------------------------------------
    % -- Recursive Least Squares algorithms.
    % RLS
    rls_filt=dsp.RLSFilter('Length',M,'Method','Conventional RLS','ForgettingFactor',i);
    [yRLS(k,:),eRLS(k,:)]=rls_filt(u,d); 
    wRLS(k,:)=rls_filt.Coefficients;
    % Householder RLS
    hhrls_filt=dsp.RLSFilter('Length',M,'Method','Householder RLS','ForgettingFactor',i);
    [yHHRLS(k,:),eHHRLS(k,:)]=hhrls_filt(u,d);  
    wHHRLS(k,:)=hhrls_filt.Coefficients;
    % Householder sliding window RLS
    hhswrls_filt=dsp.RLSFilter('Length',M,'Method','Householder sliding-window RLS','ForgettingFactor',i);
    [yHHSWRLS(k,:),eHHSWRLS(k,:)]=hhswrls_filt(u,d);      
    wHHSWRLS(k,:)=hhswrls_filt.Coefficients;
end

% -- Plot results here:
% Use legend, title, xlabel and ylabel to illustrate what is plotted.
% You can use the function semilogy to plot on logarithmic y-axis.


eRLS1=sum(eRLS.^2)/NrOfTrials;
eHHRLS1=sum(eHHRLS.^2)/NrOfTrials;
eHHSWRLS1=sum(eHHSWRLS.^2)/NrOfTrials;

figure;
semilogy(1:n,eRLS1,'b',1:n,eHHRLS1,'m',1:n,eHHSWRLS1,'y');
legend('RLS','Householder RLS','Householder sliding windows RLS');
title(['Learning curve Ee(n)^2 of IIR for different algorithm for fogetting factor=',num2str(i)]);
ylabel('Ee^2');
xlabel('time step n');
% results are different. The forgetting factor reduces the influence of old
% data.It is larger then the length is smaller.
% forgetting factor should keep the sample data enough for the long filter
% length.
end
figure;
semilogy(1:n,eNLMS1,'b',1:n,eHHSWRLS1,'k');
legend('NLMS','Householder sliding windows RLS');
title(['Two best learning curves mu for LMS is 0.15 forgetting factor for RLS is ']);
ylabel('Ee^2');
xlabel('time step n');

% converge time*E(e)^2 the smaller the better.

















