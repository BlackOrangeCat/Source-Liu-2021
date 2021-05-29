function [loc,t]=initial_point_Monte_carlo_nonzhixin(kk,kkk)
load coordinates.mat
load tim.mat
load Dim.mat
anchors_n=8;
cspeed=3e8;
%A=zeros(anchors_n,5);
b=zeros(anchors_n,1);
Ai=all_nodes.all(:,1:anchors_n);
A=[-2*Ai',2*cspeed^2*ti,-cspeed^2*ones(anchors_n,1),ones(anchors_n,1)];
A1=zeros(5,1);
for bh=1:anchors_n
    b(bh,:)=Di(bh,1)^2-all_nodes.all(1,bh)^2-all_nodes.all(2,bh)^2;%norm(Ai(:,bh))^2;
end

%% ��ʼһ������
%test_number=60*ceil(1600*1600/(200^2));%ƽ��ÿ��С����60�����Ե�
%test_number=60*ceil(2400*2400/(200^2));%ƽ��ÿ��С����60�����Ե�
%test_number=30*(2000*1600/(200^2));%ƽ��ÿ��С����60�����Ե�
%test_number_1=ceil(5*(1600*1600/(pi*40^2)));
test_number_1=ceil(8*(2000*1600/(pi*70^2)));
test_m=zeros(3,test_number_1);
test_theta_m=zeros(5,test_number_1);
err_Monte_carlo=zeros(1,test_number_1);
v_1=zeros(anchors_n,1);
tic
for i=1:test_number_1
    
    test_loc=[unifrnd(1200, 3200, 1, 1);unifrnd(-800, 800, 1, 1)];
    m_1=all_nodes.all(:,1:8)-test_loc;
    
    for ii=1:anchors_n
        v_1(ii)=norm(m_1(:,ii));
    end
    center=min(ti)-min(v_1)/cspeed;
    test_m(:,i)=[test_loc;center];
    
    test_theta_m(:,i)=[test_m(:,i); test_m(3,i)^2;test_m(1,i)^2+test_m(2,i)^2];
    
    err_Monte_carlo(i)=norm(A*test_theta_m(:,i)-b);
end
err_Monte_carlo_NEW=err_Monte_carlo;
%% ѡ�������С��selected_num���㣬�õ�min_m(2,selected_num)
selected_num=8;
min_c=zeros(1,selected_num);
min_m=zeros(2,selected_num);
%coefficient=exp(0:-1:-(selected_num-1))/sum(exp(0:-1:-(selected_num-1)));

for i=1:selected_num
    
    index=find(err_Monte_carlo_NEW==min(err_Monte_carlo_NEW));
    min_c(i)=index(1);
    err_Monte_carlo_NEW(min_c(i))= NaN;
    min_m(:,i)=test_m(1:2,min_c(i));
end
% [K,A] = convhull(min_m(1,:)',min_m(1,:)');
% in(kk,kkk) = inpolygon(all_nodes.all(:,nodes_n),min_m(1,K),min_m(2,K));

%{

min_m_1=min_m;

%axis([-800,800,-800,800])
%axis([-1200,1200,-1200,1200])
axis([800,3200,-800,800])
%axis([-800,3200,-800,800])
scatter(all_nodes.all(1,1:8),all_nodes.all(2,1:8),35,'k','s','filled')
grid on
hold on

scatter(all_nodes.all(1,9),all_nodes.all(2,9),30,'r')
scatter(test_m(1,:),test_m(2,:),2,'b','filled')
scatter(min_m(1,1),min_m(2,1),25,'r','filled')
scatter(min_m(1,2),min_m(2,2),25,'m','filled')
scatter(min_m(1,3),min_m(2,3),25,'y','filled')
scatter(min_m(1,4),min_m(2,4),25,'g','filled')
scatter(min_m(1,5),min_m(2,5),25,'k','filled')
for i=6:selected_num
    scatter(min_m(1,i),min_m(2,i),25,'b','filled')
%scatter(Loc_Monte_carlo_zhixin(1,kk),Loc_Monte_carlo_zhixin(2,kk),28,'r','*')
end
legend('Anchor node','Source node','Monte carlo node','1','2','3','4','5','6������')
title(['Monte carlo������ȡ�������ʼ������','(kkk=',num2str(kkk),',kk=',num2str(kk),')���׶�һ'])
ylabel('��λ��m');
xlabel('��λ��m');
hold off
saveas(gcf,['kkk=',num2str(kkk),',kk=',num2str(kk),'�׶�һ.fig']); %���浱ǰ���ڵ�ͼ��
pause(1)
%}



%% ���������selected_num������������ƽ�е�͹�������Σ�
min_x=min( min_m(1,:));max_x=max( min_m(1,:));
min_y=min( min_m(2,:));max_y=max( min_m(2,:));
area(kk,kkk)=(max_x-min_x)*(max_y-min_y);

%% ��͹���ڶ�������
%test_number_2=ceil(20*area(kk,kkk)/(pi*5^2));%ƽ��ÿ��С����120�����Ե�
test_number_2=ceil(5*area(kk,kkk)/(pi*3.1^2));
test_m=zeros(3,test_number_2);
test_theta_m=zeros(5,test_number_2);
err_Monte_carlo=zeros(1,test_number_2);

for i=1:test_number_2
    
    %test_loc=[unifrnd(1200, 3200, 1, 1);unifrnd(-800, 800, 1, 1)];
    test_loc=[unifrnd(min_x, max_x, 1, 1);unifrnd(min_y, max_y, 1, 1)];
    m_1=all_nodes.all(:,1:8)-test_loc;
    v_1=zeros(anchors_n,1);
    for ii=1:anchors_n
        v_1(ii)=norm(m_1(:,ii));
    end
    center=min(ti)-min(v_1)/cspeed;
    %test_m(:,i)=[test_loc;unifrnd(min(ti)-center-3*xigma_vector(kkk),min(ti)-center+3*xigma_vector(kkk))];
    test_m(:,i)=[test_loc;center];
    
    test_theta_m(:,i)=[test_m(:,i); test_m(3,i)^2;test_m(1,i)^2+test_m(2,i)^2];
    err_Monte_carlo(i)=norm(A*test_theta_m(:,i)-b);
end
index=find(err_Monte_carlo==min(err_Monte_carlo));
loc=test_m(1:2,index(1));
t=toc;





%Loc_Monte_carlo(:,kk)= 0.4*test_m(1:2,c_index1)+0.25*test_m(1:2,c_index2)+0.15*test_m(1:2,c_index3)+0.12*test_m(1:2,c_index4)+0.08*test_m(1:2,c_index5);
%disp('===���Ƿָ���===')

%{
scatter(all_nodes.all(1,1:8),all_nodes.all(2,1:8),35,'k','s','filled')
%axis([-800,800,-800,800])
%axis([-1200,1200,-1200,1200])
axis([min_x-10,max_x+10,min_y-10,max_y+10])
%axis([-800,3200,-800,800])

grid on
hold on

scatter(all_nodes.all(1,9),all_nodes.all(2,9),30,'r')
scatter(test_m(1,:),test_m(2,:),2,'b','filled')
scatter(min_m(1,1),min_m(2,1),25,'r','filled')
scatter(min_m(1,2),min_m(2,2),25,'m','filled')
scatter(min_m(1,3),min_m(2,3),25,'y','filled')
scatter(min_m(1,4),min_m(2,4),25,'g','filled')
scatter(min_m(1,5),min_m(2,5),25,'k','filled')
scatter(Loc_Monte_carlo_zhixin(1,kk),Loc_Monte_carlo_zhixin(2,kk),50,'r','*')



for i=1:length(min_m_1)
    scatter(min_m_1(1,i),min_m_1(2,i),25,'b','filled')
%scatter(Loc_Monte_carlo_zhixin(1,kk),Loc_Monte_carlo_zhixin(2,kk),28,'r','*')
end

legend('Anchor node','Source node','Monte carlo node','1','2','3','4','5','��00000��','�׶�һ')
title(['Monte carlo������ȡ�������ʼ������','(kkk=',num2str(kkk),',kk=',num2str(kk),')�׶ζ�'])
ylabel('��λ��m');
xlabel('��λ��m');
hold off
saveas(gcf,['Bkkk=',num2str(kkk),',kk=',num2str(kk),'�׶ζ�.fig']); %���浱ǰ���ڵ�ͼ��
pause(3)
%}