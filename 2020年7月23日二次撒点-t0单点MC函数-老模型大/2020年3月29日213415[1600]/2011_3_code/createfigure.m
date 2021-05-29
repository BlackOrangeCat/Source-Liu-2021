function createfigure(ymatrix1)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  bar ��������

%  �� MATLAB �� 15-Mar-2020 14:20:09 �Զ�����

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% ʹ�� bar �ľ������봴������
bar1 = bar(ymatrix1);
set(bar1(6),'DisplayName','0dB');
set(bar1(5),'DisplayName','5dB');
set(bar1(4),'DisplayName','10dB');
set(bar1(3),'DisplayName','15dB');
set(bar1(2),'DisplayName','20dB');
set(bar1(1),'DisplayName','25dB');

% ���� ylabel
ylabel('��λ��s');

box(axes1,'on');
% ������������������
set(axes1,'XTick',[1 2 3 4 5],'XTickLabel',...
    {'Monte carlo-������','Monte carlo-����','The proposed MC-TR-������','The proposed MC-TR-����','2LS'});
% ���� legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.172523182672718 0.642226591136203 0.0512445088841381 0.268324599840254]);

