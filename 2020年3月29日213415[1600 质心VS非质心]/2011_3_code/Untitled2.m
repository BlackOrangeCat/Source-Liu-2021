clc
clear all
close all
 
x = 0;  % ��ʼ����
y = 0;  % ��ʼ����
figure(1)

plot(x,y,'^r');
%axis([0,10,0,10])
grid on
%hold on    % ��֮ǰ��ͼ���뱣�������hold onע�͵�
xlabel('x');
ylabel('y');
for i=1:10
    x = x + 1;   % ���º�����
    y = y + 1;   % ���º�����
    plot(x, y, '^r');
    axis([0,10,0,10])
    grid on
    %hold on    % ��֮ǰ��ͼ���뱣�������hold onע�͵�
    pause(0.5);
end