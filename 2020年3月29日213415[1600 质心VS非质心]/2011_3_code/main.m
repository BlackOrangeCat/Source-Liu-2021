clc;close all;format long e
nodes_n=9;%���нڵ���
anchors_n=8;%ê����
save anchors_nm.mat anchors_n;
square_L=2400;%�����μ������ı߳�
cspeed=3e8;
alfa=1e-22;
yita=0.1;
badnode=0;
runnum=700;%���д���
badnode_inf=[];
%dB=[0:10:50]' ;
dB=[0:5:25]' ;
compare_data=zeros(10,length(dB));
dB2xigma;
%xigma_vector=xigma_vector/3e8;%��������ת��Ϊʱ������
coefficient=[0.618,0.618^2,0.618^3,0.618^4,0.618^5]/sum([0.618,0.618^2,0.618^3,0.618^4,0.618^5]);

%% Ԥ�������ʱ��͵�����������
T_Monte_carlo_nonzhixin=zeros(runnum,length(dB));T_Monte_carlo_zhixin=zeros(runnum,length(dB));
T_TR_nonzhixin=zeros(runnum,length(dB));T_TR_zhixin=zeros(runnum,length(dB));
T_2LS=zeros(runnum,length(dB));T_MMA=zeros(runnum,length(dB));
T_2016=zeros(runnum,length(dB));T_2013=zeros(runnum,length(dB));
T_TDOA=zeros(runnum,length(dB));T_PAMP=zeros(runnum,length(dB));
K_TR_nonzhixin=zeros(runnum,length(dB));K_TR_zhixin=zeros(runnum,length(dB));
area=zeros(runnum,length(dB));
R_CRLB_TDOA=zeros(8,length(dB));
%% ��̬figure�ߴ�����
scrsz = get(groot,'ScreenSize');
figure('Position',[0 0 scrsz(3) scrsz(4)])

%% �Ƚϸ��㷨�ڲ�ͬ�����µ�RMSE
for kkk=1:length(dB)
    kkk
    xigma=xigma_vector(kkk);
    diserr=xigma*cspeed;%��toa��������ת��Ϊ��������
    %cita=0.1*xigma;
    cita=1e7*xigma;
    save citam.mat cita;
    
    %% ��λ�������Ԥ����
    Loc_Monte_carlo_nonzhixin=zeros(2,runnum);Loc_Monte_carlo_zhixin=zeros(2,runnum);
    LocTRdisn_nonzhixin=zeros(2,runnum);LocTRdisn_zhixin=zeros(2,runnum);
    Loc2LS=zeros(2,runnum); LocMMA=zeros(2,runnum);
    LocSDP_NEW_2016=zeros(2,runnum);
    LocSDP_NEW_2013=zeros(2,runnum);
    LocTDOA=zeros(2,runnum);LocPAMP=zeros(2,runnum);
    Err=[];Err1=[];
    
    %% ÿ������������runnum�θ��㷨
    for kk=1:runnum
        kk
        square_random(square_L,nodes_n,anchors_n);
        load coordinates.mat;
        %t0=normrnd(0,2,1,1);
        t0=unifrnd(10e-9, 40e-9, 1, 1);
        %t0=      %8*10^(-3) %good for MMA
        d0=t0*cspeed;
        Distreal=zeros(anchors_n,1);%ÿ��δ֪�ڵ���ÿ��ê������ʵ����
        ti=zeros(anchors_n,1);
        Di=zeros(anchors_n,1);
        Kn2=zeros(anchors_n,1);
        
        
        for i=1:all_nodes.anchors_n
            Distreal(i,1)=norm(all_nodes.all(:,i)-all_nodes.all(:,nodes_n));
            nti=normrnd(0,xigma,1,1);%toa��������
            ti(i,1)=Distreal(i,1)/cspeed+t0+nti;
            
            % TOP(i,1)=Distreal(i,1)/cspeed;%Timr of  Propagation
            Di(i,1)=ti(i,1)*cspeed;
            Ri=Di;
            Kn2(i)=all_nodes.all(:,i)'*all_nodes.all(:,i);
        end
        save tim.mat ti;
        save Dim.mat Di;
        save Distreal.mat Distreal;
        %enta=alfa*mean(TOP,1);
        % enta=5.245953009174224e-02
        %enta=10^(-3); %good;   200 8.570297895054225e-01
        enta=alfa*mean(ti,1);
        % enta=6.18e-5;
        
        %% ���и��㷨
                [Loc_Monte_carlo_nonzhixin(:,kk),T_Monte_carlo_nonzhixin(kk,kkk)]=initial_point_Monte_carlo_nonzhixin(kk,kkk);
                 [LocTRdisn_nonzhixin(:,kk),T_TR_nonzhixin(kk,kkk),K_TR_nonzhixin(kk,kkk)]=method_trdisn(Loc_Monte_carlo_nonzhixin(:,kk));
       
        [Loc_Monte_carlo_zhixin(:,kk),T_Monte_carlo_zhixin(kk,kkk),area(kk,kkk)]=initial_point_Monte_carlo_zhixin(kk,kkk,coefficient);
        [LocTRdisn_zhixin(:,kk),T_TR_zhixin(kk,kkk),K_TR_zhixin(kk,kkk)]=method_trdisn(Loc_Monte_carlo_zhixin(:,kk));
        
%         SDP_2LS_LE;
%         
       %  SDP_MMA;
 %[~,LocPAMP(:,kk),T_PAMP(kk,kkk)] = method_PAMP(all_nodes,anchors_n,cspeed,ti);
%         SDP_NEW_2016;
     %   SDP_NEW_2013;
%         [LocTDOA(:,kk),T_TDOA(kk,kkk)]=TDOA2005(Kn2);
        
        
        
        
        %% ��ȡ���㷨��λ�����������
        Err(kk,:)=[norm(all_nodes.all(:,nodes_n)-Loc_Monte_carlo_nonzhixin(:,kk)),norm(all_nodes.all(:,nodes_n)-Loc_Monte_carlo_zhixin(:,kk)),...
            norm(all_nodes.all(:,nodes_n)-LocTRdisn_nonzhixin(:,kk)),norm(all_nodes.all(:,nodes_n)-LocTRdisn_zhixin(:,kk)),norm(all_nodes.all(:,nodes_n)-...
            Loc2LS(:,kk)),norm(all_nodes.all(:,nodes_n)-LocMMA(:,kk)),norm(all_nodes.all(:,nodes_n)-LocSDP_NEW_2016(:,kk)),norm(all_nodes.all(:,nodes_n)-LocSDP_NEW_2013(:,kk))...
            ,norm(all_nodes.all(:,nodes_n)-LocTDOA(:,kk)) ,norm(all_nodes.all(:,nodes_n)-LocPAMP(:,kk))];
        
        %% ����SDP_NEW_2016��Badnode����
        %{
        while(Err(kk,5)>5)
            badnode=badnode+1;
            badnode_inf=[badnode_inf;dB(kkk),kk,t0,nti,T_2016(kk,kkk),Err(kk,5),LocSDP_NEW_2016(:,kk)']
            
            t0=unifrnd(10e-9, 40e-9, 1, 1);
            %t0=      %8*10^(-3) %good for MMA
            d0=t0*cspeed;
            Distreal=zeros(anchors_n,1);%ÿ��δ֪�ڵ���ÿ��ê������ʵ����
            diserr=zeros(anchors_n,1);
            ti=zeros(anchors_n,1);
            Di=zeros(anchors_n,1);
            Ri=zeros(anchors_n,1);
            diserr=zeros(anchors_n,1);
            for i=1:all_nodes.anchors_n
                Distreal(i,1)=norm(all_nodes.all(:,i)-all_nodes.all(:,nodes_n));
                %Disttest(i,1)=Distreal(i,1)+diserr(i);%��ʵֵ���ϲ������
                %  ti(i,1)=Disttest(i,1)/cspeed+t0;
                nti=normrnd(0,xigma,1,1);
                ti(i,1)=Distreal(i,1)/cspeed+t0+nti;
                diserr(i)=nti*cspeed;
                TOP(i,1)=Distreal(i,1)/cspeed;%TIME OF  Propagation
                %ti(i,1)= Ri(i,1)/cspeed;
                Di(i,1)=ti(i,1)*cspeed;
            end
            
            SDP_NEW_2016;
            Err(kk,5)=norm(all_nodes.all(:,nodes_n)-u);
        end
        %}
    end
    
    %T=[T1,T2,T3,T4,T5,T6,T7,T8,T9];
    % K=[K1,K2,K3,K4,K5,K6,K7,K8,K9,K10];
    RMSE=[sqrt(mean(Err.^2,1))]';
    %mean(T,1)
    % mean(K,1)
    %badnode;
    
   % R_CRLB_TDOA(:,kkk)=solve_R_CRLB_TDOA(xigma);
    compare_data(:,kkk)=RMSE;
end
Area1=mean(area,1)
Area2=mean(Area1)
%% ��CRLB�͸��㷨�Ķ�λ����
solve_R_CRLB;
compare_data=[compare_data;R_CRLB';R_CRLB_TDOA(1,:)];

%% ���㷨��ʱ�临�Ӷ�
mean_T=[mean(T_Monte_carlo_nonzhixin);mean(T_Monte_carlo_zhixin);mean(T_TR_nonzhixin);mean(T_TR_zhixin);mean(T_2LS);mean(T_MMA);mean(T_2016);mean(T_2013);mean(T_TDOA);mean(T_PAMP)];
mean_T_1=mean(mean_T,2)
T=[mean_T(1,:)+mean_T(3,:);mean_T(2,:)+mean_T(4,:);mean_T(5:end,:)];
T_1=mean(T,2)
%% ����һ�β����ף������б�������������
current_time=string(datetime);
filename=char(strcat('All_',replace(current_time,{'-',':',' '},'_'),'.mat'));
save(filename);

%% ��ͼ
figure(2)
set(gcf,'Position',[100 100 475 475]);
set(gca,'Position',[.13 .12 .85 .86]);  %���� XLABLE��YLABLE���ᱻ�е�
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);


%curve=semilogy(dB,compare_data(2,:),'--dr',dB,compare_data(4,:),'-.>r',dB,compare_data(5,:),'--sb',dB,compare_data(6,:),'-.+m',dB,compare_data(7,:),'-.*k',dB,compare_data(8,:),':<k',dB,compare_data(9,:),':sg',dB,compare_data(10,:),':*b',dB,compare_data(11,:),'--ok',dB,compare_data(12,:),':oc');

curve=semilogy(dB,compare_data(1,:),'--sg',dB,compare_data(2,:),'--dr',dB,compare_data(3,:),'-.+g',dB,compare_data(4,:),'-.>r',dB,compare_data(11,:),'--ok');

ylabel('RMSE(m)');
xlabel('1/\sigma^{2}(dB)');
grid on;
%legend('show')
legend('MC (Non-B)','MC (B)','Proposed MC-TR (Non-B)','Proposed MC-TR (B)','CRLB-TOA','Location','southwest')
%legend('MC(Non-Barycenter)','Proposed MC-TR','2LS in [15]','MMA in [15]','SDP 2016 in [14]','SDP 2013 in [19]','Classic TDOA in [2]','PAMP\_Chen','CRLB-TOA','CRLB-TDOA','Location','southwest')
ylim([.01 10]);
%% ������pdf
%
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
filename = 'fig5-1124'; % �趨�����ļ���
print(gcf,filename,'-dpdf','-r0')
close(gcf)
%}
%% �������������ʾ
for i = 1:3
    sound(sin(2*pi*8*(1:1000)/100));
    pause(.33)
end
