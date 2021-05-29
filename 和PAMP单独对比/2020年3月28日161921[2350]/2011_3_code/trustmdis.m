function [xk,val,k]=trustmdis(x0)
%����: ţ���������򷽷������Լ���Ż����� min f(x)
%����: x0�ǳ�ʼ������
%���: xk�ǽ��Ƽ�С��, val�ǽ��Ƽ�Сֵ, k�ǵ�������
%n=length(x0);
x=x0; dta=1;
eta1=0.15; eta2=0.75;  dtabar=2.0;
tau1=0.5; tau2=4.0; epsilon=1e-3;
k=0;  Bk=Hessdis(x);  %Bk=eye(n);
%while(k<1500000000000)
while(k<150)%2020��3��12��12:20:16��ʤ
    gk=gfundis(x);
    
    if(norm(gk)<epsilon)
        break;
    end
    d=trustqdis(gk,Bk,dta);
    
    deltaq=-qkdis(x,d);  %ģ�ͺ������½���
    deltaf=fundis(x)-fundis(x+d);%Ŀ�꺯�����½���
    rk=deltaf/deltaq;  %��ֵ
    if(rk<=eta1)
        dta=tau1*dta;
    else
        if (rk>=eta2&&norm(d)==dta)
            dta=min(tau2*dta,dtabar);
%         else
%             dta=dta;
        end
    end
    if(rk>eta1)
        %x0=x;     
        x=x+d;
        Bk=Hessdis(x);
        %         [D p]=chol(Bk);%p=0��������
        %         if p~=0
        %             disp(['����6��RLS��ʼ��1��',num2str(k),'�ε���Bk������']);
        %         end
    end
    k=k+1;
end
xk=x;
val=fundis(xk);
% plot3(xx,xy,xz,'-ro');