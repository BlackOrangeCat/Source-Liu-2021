function  d=trustq(gk,Bk,dta)
% ����: ���������������:  min qk(d)=gk'*d+0.5*d'*Bk*d, s.t. ||d||<=delta
%����:  gk��xk�����ݶ�, Bk�ǵ�k�ν���Hesse��, dta�ǵ�ǰ������뾶
%���:  d, val�ֱ�������������ŵ������ֵ, lam�ǳ���ֵ, k�ǵ�������.

  alfk=gk'*gk/(gk'*Bk*gk);
  skc=-alfk*gk;
  
  nskc=norm(skc);
  skn=-inv(Bk)*gk;
  nskn=norm(skn);
  if nskc>=dta
      d=-dta*gk/(norm(gk));
  else if nskn>dta
          save skcm.mat skc;
          save sknm.mat skn;
          save dtam.mat dta;
          dta
          lam=fsolve(@funlam,0);
          d=skc+lam*(skn-skc);          
      else
          d=-inv(Bk)*gk;
      end
  end
