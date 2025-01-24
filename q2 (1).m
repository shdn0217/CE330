clear; clc; close all;

% Setup
N = 1e6;
SNRdB = 0:10;
grayQPSK = [0 1 3 2];
gray16QAM = [0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];

% Generate and modulate signals
dataPSK = randi([0,3], 1, N);
data16QAM = randi([0,15], 1, N);
sigPSK = qammod(grayQPSK(dataPSK + 1), 4);
sig16QAM = qammod(gray16QAM(data16QAM + 1), 16);

% Calculate BER
berPSK = simulate_ber(sigPSK, dataPSK, SNRdB + 10*log10(2), grayQPSK, 4);
ber16QAM = simulate_ber(sig16QAM, data16QAM, SNRdB + 10*log10(4), gray16QAM, 16);

% Plot
figure('Color', 'w');
semilogy(SNRdB, berPSK, 'bo-', SNRdB, ber16QAM, 'r*-', 'LineWidth', 2);
grid on;
xlabel('Eb/No [dB]');
ylabel('BER');
title('QPSK vs 16QAM BER Performance');
legend('QPSK', '16QAM');
xlim([0 10]); ylim([1e-5 1]);

function ber = simulate_ber(sig, data, EsNo, grayMap, M)
    ber = zeros(1, length(EsNo));
    sigPower = mean(abs(sig).^2);
    
    for i = 1:length(EsNo)
        noise = sqrt(sigPower/(2*10^(EsNo(i)/10))) * (randn(size(sig)) + 1i*randn(size(sig)));
        rxSig = sig + noise;
        demod = grayMap(qamdemod(rxSig, M) + 1);
        [~, ber(i)] = biterr(data, demod, log2(M));
    end
end