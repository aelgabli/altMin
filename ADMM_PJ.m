function [X, avg_time_per_Iter ]=ADMM_PJ(Hc,yc, x0, maxItr)

H = [ real(Hc)  -imag(Hc); imag(Hc)  real(Hc)];
y = [real(yc); imag(yc)];
C0=zeros(size(y,1),size(y,2));
N=length(y);

M=size(H,2);


if (M/2)==16
rho=0.01; % the best for 16x128, 32X128
alpha=1;
tau=0.08;

elseif (M/2)==32
rho=0.01; % The best for 32x128 64X128
alpha=1;
tau=0.1;
elseif (M/2)==64
rho=0.01; % The best for 32x128 64X128
alpha=1;
tau=0.1;
else
 
rho=0.001;
alpha=1;
tau=0.01; % The best for 128x128
end



%maxItr=8;
z=zeros(N,M);
prev_z=zeros(N,M);
x=zeros(M,1);
prev_x=zeros(M,1);

lambda=zeros(N,1);
delta=1E-3;
iter=1;
obj=1E6;


    while iter < maxItr
    
    for i=1:M
      t=tic;
        for k=1:N
            %z(k,i)=0;
            C0(k)=y(k);
            for ii=1:M
                if(ii ~= i)
                   C0(k)=C0(k)-prev_z(k,ii);
                end
            end
        end
            nem=1/(2+rho+tau)*H(:,i)'*lambda+rho/(2+rho+tau)*H(:,i)'*C0...
                +tau/(2+rho+tau)*H(:,i)'*prev_z(:,i)-tau*prev_x(i);
            dem=(1-2/(2+rho+tau))*norm(H(:,i))^2-tau;
            x(i)=nem/dem;
            if(x(i) > 1)
                x(i)=1;
            elseif(x(i) < -1)
                x(i)=-1;
            end
            for k=1:N
               z(k,i)=1/(2+rho+tau)*(2*H(k,i)*x(i)+lambda(k)+rho*C0(k)+tau*prev_z(k,i));
            end
            
       t=toc(t);
       elapsed_Time(i)=t;
  
    end
    
    avg_time_per_Iter(iter)=mean(elapsed_Time);
    prev_z=z;
    prev_x=x;
        
    for k=1:length(lambda)       
        lambda(k)=lambda(k)+alpha*rho*(y(k)-sum(z(k,:)));
    end
    
    prevObj=obj;
    obj=norm(y-H*x);
 
    iter=iter +1;
    
    end

   zsol=2*([x]>0)-1; 
            
   for t=1:M/2
            X(t,1)=zsol(t)+1j*zsol(t+M/2);
   end