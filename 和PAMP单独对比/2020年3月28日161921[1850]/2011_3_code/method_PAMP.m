%% ���룺 
% all_nodes: ����ֵ��ê�������ܵ���
% anchors_n: ê����
% c: �����ٶ�
% runt: ѭ������
% ti: TOA
% y: ��ʼ��
% �����
% KKK: �㷨��������
% y_star: λ�ý�
% TTT: �㷨����ʱ��

function [KKK,y_star,TTT] = method_PAMP(all_nodes,anchors_n,c,ti)

%%  ������ʼ��
Iternum = 1000;     %��ѭ������
Itermax_a = 1;
Itermax_bb = 500;   %�ڵ�������
eta = 1e-7;
r = 1.618;
sigma = 1e-3;
t0_k = 0;
flag = 0;
   y=[unifrnd(-800,800, 1, 1);unifrnd(-800, 800, 1, 1)];
%% �㷨��ʼ
tic
for k = 1:Iternum  
    t0_pro = 0;
    for i = 1:anchors_n
        t0_pro = t0_pro + (c * ti(i,1) - norm(all_nodes.all(:,i) - y));
    end    
    if (k ~= 1)
        t0_k = t0_kk;                                                       %��һ�����Ƶ�ʱ��ƫ�����ǰ��
    end
    t0_kk = (1/(r + anchors_n * c^2)) * (c * t0_pro + r * t0_k);            %ʱ��ƫ��������ʽ
    
    y_k = y;
%     eps_p = 0.01 / k^2;                                                        %�ڵ�����ֹ����
    eps_p = 1 / 1e3;
%     fprintf("%d armijo\n", k);
    for p = 1:Itermax_a
        val = 0;
        %% Recording
        for i = 1:anchors_n
            val = val + 1/2 *((c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_k))^2);
        end
        %% ��ѭ����������
        grad = zeros(2,1);
        for i = 1:anchors_n
            grad = grad + (c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_k)) * (all_nodes.all(:,i) - y_k)/(norm(all_nodes.all(:,i) - y_k));
        end
        if (norm(grad) < eps_p)
             break;
        end
        %% ��������
        d = -grad;
        %% ������ʲ���
        yn = 0;
        alpha_a = 1;                                                        %��ʼ����
        yn = y_k + alpha_a * d;
        fn = 0;
        for i = 1:anchors_n
            fn = fn + 1/2 * ((c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - yn))^2);
        end
        while (fn > val + alpha_a * sigma * grad' * d)                   %Armijo��������
            alpha_a = alpha_a * 0.618;                                    %��0.618����
            yn = y_k + alpha_a * d;                                       %���²�������ֵ�ж��Ƿ������������
            fn = 0;
            for i = 1:anchors_n
                fn =  fn + 1/2 *((c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - yn))^2);
            end
        end
        %% ����yֵ         
         y_kk =  y_k + alpha_a * d;                                          %ʹ�õõ����²�������ֵ
         break
    end
    %     y_k = y_kk;
    y_bb = y_kk;
    %% ��ѭ����������
    eps_k = [abs(t0_kk - t0_k),norm(y_kk - y_k,'inf')];
    if(max(eps_k) < eta)
        break;
    end
    %     fprintf('bb\n');
    %% bb��ʼ
    alpha_bb = 0;
    grad_old = zeros(2,1);
    grad_new = zeros(2,1);
    T = 1;
    gamma = 0.85;
    for p = 1:Itermax_bb
        if(p == 1) %Armijo������һ��BB
            grad_new = zeros(2,1);
            for i = 1:anchors_n
                grad_new = grad_new + (c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_bb)) * (all_nodes.all(:,i) - y_bb)/(norm(all_nodes.all(:,i) - y_bb));
            end
            d = -grad_new;                                                                    %���ݶ���������
            alpha_bb = ((y_bb - y_k)' * (y_bb - y_k))/((y_bb - y_k)' * (grad_new - grad));    %BB��������
            y_ini = y_bb;
            grad_ini = grad_new;
        end
        val = 0;
        for i = 1:anchors_n
            val = val + 1/2 *((c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_ini))^2);
        end
%         fprintf("%d bb\n", k);
        y_new = y_ini + alpha_bb * d;                                          %ʹ�õõ����²�������ֵ        
        fn = 0;
        for i = 1:anchors_n
            fn = fn + 1/2 *((c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_new))^2);
        end
        phi = fn - (val - 1/2 * alpha_bb * norm(grad_new)^2);
%         val = fn;
        rho = exp(1)^(-phi/T);
        rho_rand = unifrnd(exp(1)^(-10),exp(1)^(-1/10));
        while(rho < rho_rand)
            y_k = y_new;
            flag = 1;
            Armijo;
            break
        end     
        if(flag == 1)
            grad_old = zeros(2,1);
            for i = 1:anchors_n
                grad_old = grad_old + (c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_ini)) * (all_nodes.all(:,i) - y_ini)/(norm(all_nodes.all(:,i) - y_ini));    %�������ݶ�
            end
        end
        grad_new = zeros(2,1);                                              %���ݶȳ�ʼ��
        for i = 1:anchors_n
            grad_new = grad_new + (c * (ti(i,1) - t0_kk) - norm(all_nodes.all(:,i) - y_new)) * (all_nodes.all(:,i) - y_new)/(norm(all_nodes.all(:,i) - y_new));    %�������ݶ�
        end
        if(flag == 1)
            alpha_bb = ((y_new - y_ini)' * (y_new - y_ini))/((y_new - y_ini)' * (grad_new - grad_old));
        else
            alpha_bb = ((y_new - y_ini)' * (y_new - y_ini))/((y_new - y_ini)' * (grad_new - grad_ini));    %BB�������±��ʽ
        end
        d = -grad_new;                                                      %���ݶ���������
        grad_ini = grad_new;
        T = gamma * T;
        y_k = y_ini;
        y_ini = y_new;       
        %% ��ѭ����������
        if (norm(grad_new) < eps_p)
             break;
        end
    end
    y_kk = y_new;
    y = y_new;                                                               % y_p+1 = y_p
    %% ��ѭ����������
    eps_k = [abs(t0_kk - t0_k),norm(y_kk - y_k,'inf')];
    if(max(eps_k) < eta)
        break;
    end
end

KKK = k;
y_star = y;
t = toc;
TTT = t;
%disp(['PAMP is Solved'])

%%	����main������method_PAMP��
%     K1(runt,1) = KKK;
%     Loc_PAMP(:,runt) = y_star;
%     T1(runt,1) = TTT;


end