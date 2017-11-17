%%
close all
clear
clc

[speech, fs]= audioread('clear_speech.wav');
% sound(speech, fs);
[noise, fs]= audioread('noise_source.wav');
% sound(noise, fs);
[speech_and_noise1, fs]= audioread('speech_and_noise_through_room_1.wav');
% sound(speech_and_noise1, fs);
[speech_and_noise2, fs]= audioread('speech_and_noise_through_room_2.wav');
% sound(speech_and_noise2, fs);

d = speech_and_noise1; % vector of desired signal samples = clear source(ct) + noise(vt)
u = noise; % vector of input signal samples = noise(vt)
mu = 0.1; % the constant parameter of controlling step size 0-2
M = 200; % length of FIR filter, number of taps
a = 1; % constant to mitigate norm(u) ~ 0

nlms = NLMS(d, u, mu, M, a); % output error vector = clear signal(et)
sound(nlms, fs);

figure(1);
subplot 411; plot(speech); title('original signal');
subplot 412; plot(speech_and_noise1); title('speech and noise signal - room 1');
subplot 413; plot(nlms); title('reconstructed signal');
subplot 414; plot(nlms, 'b-'); hold on; plot(speech, 'r-'); title('comparison');
legend('reconstructed signal', 'original signal');


%% Average square error, computes how big is the error
Ns = length(noise);
c = speech; % clear source(ct)
e = nlms; % clear signal(et)

ASE = norm(c(Ns/2:Ns)-e(Ns/2:Ns), 2)^2 / norm(c(Ns/2:Ns),2)^2;

mu_list = 0:0.05:1.95;
c = speech;
u = noise;
d = speech_and_noise1; % clear source(ct) + noise(vt)
d2 = speech_and_noise2;
M = 200;
a = 1;
ASE_list = zeros(1, length(mu_list));
for i = 1:length(mu_list)
    e = NLMS(d, u, mu_list(i), M, a);
    % ASEList(m) = ((c(Ns/2:Ns)-e(Ns/2:Ns))'*(c(Ns/2:Ns)-e(Ns/2:Ns)))/(c(Ns/2:end)'*c(Ns/2:end));
    ASE_list(i) = norm(c(Ns/2:Ns)-e(Ns/2:Ns),2)^2 / norm(c(Ns/2:Ns),2)^2;
end

ASE_list2 = zeros(1, length(mu_list));
for i = 1:length(mu_list)
    e = NLMS(d2, u, mu_list(i), M, a);
    ASE_list2(i) = norm(c(Ns/2:Ns)-e(Ns/2:Ns),2)^2 / norm(c(Ns/2:Ns),2)^2;
end

figure(2);
subplot 211; plot(mu_list, ASE_list); 
xlabel('\mu'); ylabel('ASE'); title('room 1');
subplot 212; plot(mu_list, ASE_list2); 
xlabel('\mu'); ylabel('ASE'); title('room 2');



%%
d = speech_and_noise1;
u = noise;
M = 200;
mu = 0.2;
a = 1;
[e, W] = NLMS(d, u, mu, M, a);

coff1_60 = W(60, :);
coff1_180 = W(180, :);

figure(3);
subplot 211; plot(coff1_60); hold on; plot(coff1_180);
legend('element 60', 'element 180');
title('room 1'); xlabel('Iterations'); ylabel('True cofficient value');



d = speech_and_noise2;
u = noise;
M = 200;
mu = 0.4;
a = 1;
[e, W] = NLMS(d, u, mu, M, a);

coff2_60 = W(60, :);
coff2_180 = W(180, :);

subplot 212; plot(coff2_60); hold on; plot(coff2_180);
legend('element 60', 'element 180');
title('room 2'); xlabel('Iterations'); ylabel('True cofficient value');


