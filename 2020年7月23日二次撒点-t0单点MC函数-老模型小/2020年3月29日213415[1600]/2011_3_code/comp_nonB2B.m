%% ��ͼ
figure(2)

% figure resize

set(gcf,'Position',[100 100 430 375]);
set(gca,'Position',[.13 .13 .85 .85]);  %���� XLABLE��YLABLE���ᱻ�е�
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);



curve=semilogy(dB,compare_data(1,:),'--sg',dB,compare_data(2,:),'--dr',dB,compare_data(3,:),'-.+g',dB,compare_data(4,:),':>r',dB,compare_data(9,:),'--ok');
ylabel('RMSE(m)');
xlabel('1/\sigma^{2}(dB)');
grid on;
%legend('show')
legend('MC non-B','MC B','Proposed MC non-B TR','Proposed MC B TR','Root of CRLB','Location','southwest')

% ������pdf
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
filename = 'fig4-0907'; % �趨�����ļ���
print(gcf,filename,'-dpdf','-r0')
close(gcf)
