%%% ������Ŀ�꺯�� %%%%%%%%%%%%%
function qd=qkdis(x,d)
gk=gfundis(x);  Bk=Hessdis(x);
qd=gk'*d+0.5*d'*Bk*d;