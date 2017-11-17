% main test

[s1, fs] = audioread('speech_and_noise_through_room_1.wav');
[s2, fs] = audioread('speech_and_noise_through_room_2.wav');
[v, fs] = audioread('noise_source.wav');
[c, fs] = audioread('clear_speech.wav');

%%

% [e, w, W] = NLMS(s2, v, 0.3, 200, 1);
[e, w, W] = NLMS(s1, v, 0.18, 200, 1);

figure(4)
cla,hold on
grid on
plot( W(60,:))
plot( W(180,:),'r')
legend('w(60)','w(180)','w_o(60)','w_o(180)','Location','SW')
ylabel('filter coefficient value')
xlabel('current input sample')
% title('speech\_and\_noise\_through\_room\_2.wav')
title('speech\_and\_noise\_through\_room\_1.wav')

Ns = numel(s1);

cc = c( Ns/2:Ns );

ce = cc - e( Ns/2:Ns );

ASE = (ce'*ce)/(cc'*cc)


% best mu for s2 at 0.05
% best mu for s1 at 0.03
%%

muvec = linspace(0.01,1.95,256);

ASE_mat = zeros( numel(muvec), 1 );

cc = c( Ns/2:Ns );

for nni = 1:length( muvec )
    
    [e, w, W] = NLMS(s2, v, muvec(nni), 200, 1);
    
    Ns = numel(s2);
    
    ce = cc - e( Ns/2:Ns );
    
    ASE = (ce'*ce)/(cc'*cc);

    ASE_mat(nni,1) = ASE;
    
    nni
    
end

figure(2),clf
plot( muvec, ASE_mat )

% legend('speech\_and\_noise\_through\_room\_1.wav','speech\_and\_noise\_through\_room\_2.wav')