function [xk,val,k]=trustm(x0)
%����: ţ���������򷽷������Լ���Ż����� min f(x)
%����: x0�ǳ�ʼ������
%���: xk�ǽ��Ƽ�С��, val�ǽ��Ƽ�Сֵ, k�ǵ�������
n=length(x0);  x=x0; dta=1;
eta1=0.15; eta2=0.75;  dtabar=2.0;
tau1=0.5; tau2=4.0; epsilon=1e-20;
k=0;  Bk=Hess(x);  %Bk=eye(n);  
while(k<150)
    gk=gfun(x);
%         fa=funRLSdan1(x);
    if(norm(gk)<epsilon)
        break;
    end
    d=trustq(gk,Bk,dta);   

    deltaq=-qk(x,d);  %ģ�ͺ������½���
    deltaf=fun(x)-fun(x+d);%Ŀ�꺯�����½���
    rk=deltaf/deltaq;  %��ֵ
    if(rk<=eta1)
        dta=tau1*dta;
    else if (rk>=eta2&&norm(d)==dta)
            dta=min(tau2*dta,dtabar);
        else
            dta=dta;
        end
    end
    if(rk>eta1)
        x0=x;     x=x+d;   
        Bk=Hess(x);
%         [D p]=chol(Bk);%p=0��������
%         if p~=0
%             disp(['����6��RLS��ʼ��1��',num2str(k),'�ε���Bk������']);
%         end     
    end
    k=k+1;
end
xk=x;
val=fun(xk);
% plot3(xx,xy,xz,'-ro');