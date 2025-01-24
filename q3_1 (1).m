主要变化：

使用复数QPSK星座
使用最小距离检测
向量化符号映射
添加并行计算

clear; clc; close all;

% Setup
N = 1e6; 
SNRdB = 0:10;
trials = 20;
ber = zeros(1, length(SNRdB));

% Run simulation
parfor snr_idx = 1:length(SNRdB)
    error_sum = 0;
    noise_power = 1/(10^(SNRdB(snr_idx)/10));
    
    for t = 1:trials
        % Generate QPSK constellation
        symbols = (1+1i)/sqrt(2) * [1 -1 1i -1i];
        bits = randi([0 1], 2, N);
        symbol_idx = bits(1,:)*2 + bits(2,:) + 1;
        tx_signal = symbols(symbol_idx);
        
        % Channel
        noise = sqrt(noise_power/2)*(randn(1,N) + 1i*randn(1,N));
        rx_signal = tx_signal + noise;
        
        % Detect symbols
        [~, detected] = min(abs(rx_signal.' - symbols).', [], 1);
        detected_bits = [floor((detected-1)/2); mod(detected-1,2)];
        
        % Count errors
        error_sum = error_sum + sum(sum(bits ~= detected_bits));
    end
    
    ber(snr_idx) = error_sum/(2*N*trials);
end

% Plot results
figure('Color','w');
theory = berawgn(10.^(SNRdB/10), 'psk', 4, 'nondiff');
semilogy(SNRdB, [theory; ber], 'LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('QPSK Performance');
legend('Theoretical','Simulated','Location','southwest');
ylim([1e-5 1]);