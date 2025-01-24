clear; clc;
n=1e5; % 减少样本量
s=0:2:10; % 减少SNR点数
m={[0 1 3 2],[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]};
d={randi([0,3],1,n),randi([0,15],1,n)};
x={qammod(m{1}(d{1}+1),4),qammod(m{2}(d{2}+1),16)};
b{1}=sim(x{1},d{1},s+3,m{1},4);
b{2}=sim(x{2},d{2},s+6,m{2},16);
semilogy(s,[b{1};b{2}]','LineWidth',2);
grid;xlabel('SNR');ylabel('BER');
legend('QPSK','16QAM');ylim([1e-5 1]);

function b=sim(x,d,s,m,k)
    b=zeros(1,length(s));p=mean(abs(x).^2);
    for i=1:length(s)
        n=sqrt(p/(2*10^(s(i)/10)))*(randn(size(x))+1i*randn(size(x)));
        [~,b(i)]=biterr(d,m(qamdemod(x+n,k)+1),log2(k));
    end
end