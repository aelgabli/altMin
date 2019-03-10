function [x0, ipHat,Z_rec]=qpsk_mmse(H,z,EbNo)
          i=sqrt(-1);
          sgm2=10^(-EbNo/10);
          
          N=size(H,1);
         % Z_rec=H'*inv(H*H'+sgm2*eye(N))*z; 
          Z_rec=inv(H'*H+sgm2*eye(size(H,2)))*H'*z; 
          
        
          y_re = real(Z_rec); % real
          y_im = imag(Z_rec); % imaginary
          

                  
          ipHat(find(y_re < 0 & y_im < 0)) = -1 + -1*i;
          ipHat(find(y_re >= 0 & y_im > 0)) = 1 + 1*i;
          ipHat(find(y_re < 0 & y_im >= 0)) = -1 + 1*i;
          ipHat(find(y_re >= 0 & y_im < 0)) = 1 - 1*i;

          
          x01=[real(ipHat.'); imag(ipHat.')]; x0=x01>0;
          
         