主要改动:

使用复数16QAM星座
实现最小距离检测
添加Gray映射
使用并行计算提高性能clear; clc; close all;

% Setup
N = 1e6;
snr_db = 0:10;
trials = 20;

% 16-QAM constellation points
qam_points = [-3-3i, -3-1i, -3+3i, -3+1i, ...
              -1-3i, -1-1i, -1+3i, -1+1i, ...
               3-3i,  3-1i,  3+3i,  3+1i, ...
               1-3i,  1-1i,  1+3i,  1+1i]/sqrt(10);

% Simulation
ber = zeros(1, length(snr_db));
parfor i = 1:length(snr_db)
    errors = 0;
    noise_var = 1/(10^(snr_db(i)/10));
    
    for t = 1:trials
        % Transmit
        sym_idx = randi(16, 1, N);
        tx = qam_points(sym_idx);
        
        % Channel
        rx = tx + sqrt(noise_var/2)*(randn(1,N) + 1i*randn(1,N));
        
        % Detect
        [~, detected] = min(abs(rx.' - qam_points).', [], 1);
        
        % Gray mapping error count
        tx_bits = de2bi(sym_idx-1, 4, 'left-msb');
        rx_bits = de2bi(detected-1, 4, 'left-msb');
        errors = errors + sum(sum(tx_bits ~= rx_bits));
    end
    ber(i) = errors/(4*N*trials);
end

% Plot
theory = berawgn(10.^(snr_db/10), 'qam', 16);
figure('Color','w');
semilogy(snr_db, [theory; ber], 'LineWidth',2);
grid on;
title('16-QAM BER Performance');
xlabel('SNR (dB)');
ylabel('BER');
legend('Theory','Simulation','Location','southwest');
ylim([1e-5 1]);