clear

N = 16;              %number of transmitters
M = 128;              %number of receivers
SymPerXmission = N*100;       %number of symbols of transmission
BitsPerSymbol = 2;          %bits/symbol of 4-QAM
NumSym = [10 50 100 100  100 100 100 200 200 200 300]*SymPerXmission;               %total number of symbols to be sent per energy Eb/No
EbNoVec = [0:2:20];
ModType = 2; %QPSK

Algorithm = 'alterMin';%'admm_pj';

use_fixed_seed = 1;

 if(use_fixed_seed) % Fixed seed for repetablity
%          RandStream.setDefaultStream(RandStream('mt19937ar','seed',12344321));   
 RandStream.setGlobalStream(RandStream('mt19937ar','seed',12344321)); 
 end 


QMod = modem.qammod('M',4,'PhaseOffset',0,'SymbolOrder','binary','InputType','integer');
QDemod = modem.qamdemod(QMod);



%calculate the snr of each and initialization
snr = EbNoVec -10*log10(M);    
SER_ml = zeros(1, length(EbNoVec));
for id = 1:length(EbNoVec)
    Xmitted = 0;  Acc_SER = 0;    Acc_SER_mmse = 0;       %transmitted symbols & accumulated SER
    
    counter=0;
    j=sqrt(-1);
    while (Xmitted < NumSym(id))
        
        counter=counter+1;
        aa=0;bb=3;msg=round(aa+(bb-aa)*rand(1,SymPerXmission));%msg = randint(1, SymPerXmission, 16);
        msg=msg(1,[1:SymPerXmission]);
        True_msg = modulate(QMod, msg);
        Tx = (1/sqrt(2))*reshape(True_msg,N, SymPerXmission/N);    %demultiplex to transmitting attenas
        
        H = (randn(M, N) + 1j*randn(M, N))./(sqrt(2));       %create rayleigh fading channel matrix
       
        
        w = ((1/sqrt(2))*(randn(1,M *SymPerXmission/N)+ 1j*randn(1,M*SymPerXmission/N)));
        ww = reshape(w,M, SymPerXmission/N); 
        r = H*Tx +(10^(-snr(id)/20))*ww;
        bhat = zeros(N, SymPerXmission/N);bmmse = zeros(N, SymPerXmission/N);Xhat_sic = bhat;
        
   
   
     if strcmp(Algorithm, 'alterMin')== 1
         for ii = 1:size(r,2) 
         iterCount=10;

         [x0, xmmse]=qpsk_mmse(H,r(:,ii),snr(id));       
                   
         x0=zeros(2*M,1);
                
         X_altmin = AlterMin_Algo(H,r(:,ii),x0, iterCount);
           
         bmmse(:,ii) = xmmse;
     
         bhat(:,ii)= X_altmin;   
          
         end     
         
      
         
     elseif strcmp(Algorithm, 'admm_pj')== 1
         for ii = 1:size(r,2)     

          [x0, xmmse]=qpsk_mmse(H,r(:,ii),snr(id));
          
          [X_pjadmm]=ADMM_PJ(H,r(:,ii),[],12);
    
          bmmse(:,ii) = xmmse;
     
          bhat(:,ii)= X_pjadmm;   
         end        
         
   
     end 
        
        
     
        Out_bb = reshape(bhat, 1, SymPerXmission);      %relocate detected signal to output string
        Out_mmse = reshape(bmmse, 1, SymPerXmission);      %relocate detected signal to output string
        Acc_SER = Acc_SER + symerr(True_msg, Out_bb) ;       %calculate SER from each transmission and accumulate it
        Acc_SER_mmse = Acc_SER_mmse + symerr(True_msg, Out_mmse);        %calculate SER from each transmission and accumulate it
        Xmitted = Xmitted + SymPerXmission;             %sum transmitted symbols
    end %while 
    
        BER_bb(id) = Acc_SER/(2*Xmitted); % bit error rate for Altmin or PJADMM algorithms     
        BER_mmse(id) = Acc_SER_mmse/(2*Xmitted);
   
end 


figure (1)
semilogy(EbNoVec,BER_bb,'ks-', 'Linewidth',2) 
axis([5 15 10^-6 1])
grid on
xlabel('Eb/No, dB')
ylabel('Bit Error Rate')
title('QPSK MIMO  ')
hold on
figure (1)
semilogy(EbNoVec,BER_mmse,'rs--', 'Linewidth',2)
axis([5 15 10^-6 1])
grid on
xlabel('Eb/No, dB')
ylabel('Bit Error Rate')
title('QPSK MIMO  ')
hold on

