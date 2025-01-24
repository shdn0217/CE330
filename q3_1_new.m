clear;
n=6e5; % 减小样本数
s=0:2:10; % 减少SNR点
t=10; % 减少迭代次数
c=[-3-3i,-3-1i,-3+3i,-3+1i,-1-3i,-1-1i,-1+3i,-1+1i,3-3i,3-1i,3+3i,3+1i,1-3i,1-1i,1+3i,1+1i]/sqrt(10);
b=zeros(1,length(s));

for i=1:length(s)
   e=0;v=1/(10^(s(i)/10));
   for k=1:t
       x=randi(16,1,n);
       y=c(x);
       r=y+sqrt(v/2)*(randn(1,n)+1i*randn(1,n));
       [~,d]=min(abs(r.'-c).',[],1);
       e=e+sum(sum(de2bi(x-1,4,'left-msb')~=de2bi(d-1,4,'left-msb')));
   end
   b(i)=e/(4*n*t);
end

figure('Color','w');
semilogy(s,[berawgn(10.^(s/10),'qam',16);b],'LineWidth',2);
grid on;xlabel('SNR');ylabel('BER');
legend('Theory','Sim');ylim([1e-5 1]);