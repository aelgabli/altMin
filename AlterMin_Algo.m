function [X ]=AlterMin_Algo(Hc,yc,x0, iterCount)

H = [ real(Hc)  -imag(Hc); imag(Hc)  real(Hc)];
y = [real(yc); imag(yc)];

N=length(y);

M=size(H,2);
lambda=zeros(N,1);
maxItr=iterCount;
z=zeros(N,M);
x=zeros(M,1);%x0;%zeros(M,1);
c=M;
delta=1E-3;
iter=1;
obj=1E6;

while iter < maxItr
   
    
    for k=1:length(lambda)
         sum=0;
        for ii=1:M
        sum=sum+H(k,ii)*x(ii);
        end        
        lambda(k)=c*1/M*(y(k)-sum);
    end
    
     for k=1:N
        for ii=1:M
            z(k,ii)=H(k,ii)*x(ii)+lambda(k)/2;
        end        

     end
      
      for i=1:M
        
        x(i)= H(:,i)' * z(:,i)/norm(H(:,i))^2;
        if(x(i) > 1)
            x(i)=1;
        elseif(x(i) < -1)
            x(i)=-1;
        end
        
      end
             
    prevObj=obj;
    obj=norm(y-H*x);
    %abs(obj-prevObj)
    
    if(iter > 1 && abs(obj-prevObj) < delta)
        %iter
        %abs(obj-prevObj)
        break;
       % count=count+1;
    end
    
    iter=iter +1;
    
end

   zsol=2*([x]>0)-1; 
            
    for t=1:M/2
            X(t,1)=zsol(t)+1j*zsol(t+M/2);
    end
              
              
          