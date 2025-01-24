clear; clc; close all;

% Basic setup
n = 1e6; 
s = 0:20;
t = 20;
p = pi/16;
c = exp(1i*([1:4]*pi/2 + p - pi/4));
b = zeros(1,length(s));

parfor i = 1:length(s)
    e = 0;
    v = 1/(10^(s(i)/10));
    
    for k = 1:t
        d = randi([0 1], 2, n/2);
        x = c(d(1,:)*2 + d(2,:) + 1);
        r = x + sqrt(v/2)*(randn(1,n/2) + 1i*randn(1,n/2));
        [~, m] = min(abs(r.' - c).', [], 1);
        e = e + sum(sum([floor((m-1)/2); mod(m-1,2)] ~= d));
    end
    b(i) = e/(n*t);
end

% Plot
figure('Color','w');
semilogy(s, [berawgn(10.^(s/10), 'psk', 4, 'nondiff'); b], 'LineWidth',2);
grid on;
xlabel('SNR (dB)'); ylabel('BER');
title('QPSK with Phase Offset');
legend('Theory','Simulation','Location','southwest');
ylim([1e-5 1]);

主要简化:

缩短变量名
合并相似操作
移除多余注释
精简绘图代码