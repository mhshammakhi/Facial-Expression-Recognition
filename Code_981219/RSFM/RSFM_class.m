clc
clear
close all
dataFolder='D:\UNIstuff\BachelorProject\Result_990506';
dataFolder(dataFolder=='\')='/';
path_save='D:\UNIstuff\BachelorProject\RSFM\results-sig0.001';
path_save(path_save=='\')='/';
max_acc=0;
err=[];
kj=1;
for seg=3:10
    for bin=10:5:50
        for OverP=0:1:8
            try
            load([dataFolder,'/',sprintf('Dataset_sig2_seg%d_bins%d_overlap0.%d.mat',seg,bin,OverP)]) ;
            [trainInd,valInd,testInd]=dividerand(size(Data,1),0.75,0,0.25);
            X_TRAIN=Data(trainInd,:);ytrain=Label(trainInd);
            xtest=Data(testInd,:);ytest=Label(testInd);
            u=unique(ytrain);
            numClasses=length(u);
            j = 1;
            
            for i=1:numClasses
                G1=X_TRAIN(ytrain==u(i),:);G2=X_TRAIN(ytrain~=u(i),:);
                G1_l=ones(sum(ytrain==u(i)),1);G2_l=zeros(sum(ytrain~=u(i)),1);
                xtrain = [G1; G2];    
                t = [G1_l ;G2_l]; %target values
                N = size(xtrain,1);
                N_W = N+1; % number of sample wieghts
                N_L = size(xtrain,2)+1;% number of feature wieghts

                % Kernel matrix on training data
                sig = 0.001; %kernel width
              
                A = Kernel_Mtx(xtrain,xtrain,sig);


                M_W = N_W;
                M_L = N_L;

                alpha_W		= ones(M_W,1);
                gamma_W		= ones(M_W,1);
                alpha_L		= ones(M_L,1);
                gamma_L		= ones(M_L,1);
                beta = 0.5;

                W = ones(M_W,1)*0.01;
                L = ones(M_L,1)*0.05;

                maxIts = 30;
                ALPHA_MAX_W = 1e12;
                ALPHA_MAX_L = 1e12;

                PRUNE_POINT = 15; %
                Y  = zeros(N,1);
                for i = 1:N
                    Y(i)=W'*A(:,:,i)*L;
                end
                y	= sigmoid(Y);
                yvar	= y.*(1-y);
                B = diag(yvar);
                for i_loop = 1:maxIts
                    M_W
                    M_L
                    %updating W
                    if M_W >= 50

                        %pruning large value of alpha_W
                        nonZero_W	= find(alpha_W<ALPHA_MAX_W);
                        alpha_W_nz	= alpha_W(nonZero_W);
                        W(~ismember(1:N_W,nonZero_W))	= 0;
                        M_W		= length(nonZero_W);



                        PHI_L = zeros(N,N_W);
                        for i = 1:N
                            PHI_L(i,:) = (A(:,:,i)*L)';
                        end
                        PHI_L_nz	= PHI_L(:,nonZero_W);
                         Hessian_W	= (PHI_L_nz'*PHI_L_nz)*beta/2 + diag(alpha_W_nz);
%                         Hessian_W	= (PHI_L_nz'*B*PHI_L_nz) + diag(alpha_W_nz);

                        [U_W,flag]		= chol(Hessian_W);
                        U_Wi		= U_W ^-1; % inv(U_W)
                         W(nonZero_W)	= U_Wi * U_Wi' * PHI_L_nz' * t * beta/2;
%                         W(nonZero_W)	= U_Wi * U_Wi' * PHI_L_nz' * B*t;

                        %     Sigma_W = (Hessian_W)^-1;
                        %     W(nonZero_W)	= Sigma_W * PHI_L_nz' * t * beta/2;

                        ED_W		= sum((t-PHI_L_nz*W(nonZero_W)).^2);
                        diagSig_W	= sum(U_Wi.^2,2);
                        gamma_W		= 1 - alpha_W_nz.*diagSig_W;

                        %     gamma_W		= 1 - alpha_W_nz.*diag(Sigma_W);

                        if i_loop<PRUNE_POINT
                            % MacKay-style update given in original NIPS paper
                            alpha_W(nonZero_W)	= gamma_W ./ W(nonZero_W).^2;
                        else
                            % Hybrid update based on NIPS theory paper and AISTATS submission

                            alpha_W(nonZero_W)	= gamma_W ./ (W(nonZero_W).^2./gamma_W - diagSig_W);
                            %         alpha_W(nonZero_W)	= gamma_W ./ (W(nonZero_W).^2./gamma_W - diag(Sigma_W));
                            alpha_W(alpha_W<=0)	= inf; % This will be pruned later
                        end

                    end

                    %updating L
                    %pruning large value of alpha_W
                    if M_L>=50
                        nonZero_L	= find(alpha_L<ALPHA_MAX_L);
                        alpha_L_nz	= alpha_L(nonZero_L);
                        L(~ismember([1:N_L],nonZero_L))	= 0;
                        M_L		= length(nonZero_L);



                        PHI_W = zeros(N,N_L);
                        for i = 1:N
                            PHI_W(i,:) = W'*A(:,:,i);
                        end
                        PHI_W_nz	= PHI_W(:,nonZero_L);
%                         Hessian_L	= (PHI_W_nz'*B*PHI_W_nz) + diag(alpha_L_nz);
                         Hessian_L	= (PHI_W_nz'*PHI_W_nz)*beta/2 + diag(alpha_L_nz);
                         
                        [U_L,flag]		= chol(Hessian_L);
                        U_Li		= U_L ^-1; % inv(U_L)
%                         L(nonZero_L)	= U_Li * U_Li' * PHI_W_nz' *B*t;
                         L(nonZero_L)	= U_Li * U_Li' * PHI_W_nz' * t * beta/2;
                        %     Sigma_L = (Hessian_L)^-1;
                        %     L(nonZero_L)	= Sigma_L * PHI_W_nz' * t * beta/2;

                        ED_L		= sum((t-PHI_W_nz*L(nonZero_L)).^2);
                        diagSig_L	= sum(U_Li.^2,2);
                        gamma_L		= 1 - alpha_L_nz.*diagSig_L;
                        %     gamma_L		= 1 - alpha_L_nz.*diag(Sigma_L);

                        if i_loop<PRUNE_POINT
                            % MacKay-style update given in original NIPS paper
                            alpha_L(nonZero_L)	= gamma_L ./ L(nonZero_L).^2;
                        else
                            % Hybrid update based on NIPS theory paper and AISTATS submission

                            alpha_L(nonZero_L)	= gamma_L ./ (L(nonZero_L).^2./gamma_L - diagSig_L);
                            %         alpha_L(nonZero_L)	= gamma_L ./ (L(nonZero_L).^2./gamma_L - diag(Sigma_L));

                            alpha_L(alpha_L<=0)	= inf; % This Lill be pruned later
                        end
                    end


                    %updating beta
                    beta = (N_W/2-sum(gamma_L)-sum(gamma_W))/(1/4*ED_W+1/4*ED_L);
                end

                beta
                tp  = zeros(N,1);
                for i = 1:N
                    tp(i)=W'*A(:,:,i)*L;
                end

                A_test = Kernel_Mtx(xtest,xtrain,sig);
                A_test = A_test(nonZero_W,nonZero_L,:);


                W_new = W(nonZero_W);
                L_new = L(nonZero_L);

                Sigma_L = (Hessian_L)^-1;
                Sigma_W = (Hessian_W)^-1;

                decomp = chol(Sigma_L+L_new*L_new');


                for i = 1:size(xtest,1)
                    t_reg(i)= W_new'*A_test(:,:,i)*L_new;
                    T = A_test(:,:,i)*decomp;
                    t_reg_var(i) = trace(T'*Sigma_W*T)+W_new'*A_test(:,:,i)*Sigma_L*A_test(:,:,i)'*W_new;
                end

                res(j,:)= t_reg(1,:) ;
                j=j+1;
            end
            
            [~,per] = max(res);
            accuracy = mean(ytest==per');
            if(accuracy>max_acc)
                max_acc=accuracy;
                seg_max=seg;
                bin_max=bin;
                disp(max_acc)
            end
            
            confmat = confusionmat(ytest,per);
            data_name=sprintf('FinalOutputRSFM_%dseg_%dbins_%doverlap.mat',seg,bin,OverP);
            add_save=sprintf([path_save,'/',data_name]);
            save(add_save,'seg','bin','OverP','accuracy','confmat');
            disp(['seg:',num2str(seg),' bin:',num2str(bin),' Overlap:',num2str(OverP),'acc:',num2str(accuracy)])
          
            catch
             err(kj,:)=[seg bin OverP];
             kj=kj+1;
             disp('Error Occured')
            end
            
         data_name=sprintf('errors');
         add_save=sprintf([path_save,'/',data_name]);
         save(add_save,'err')  
         
        end 
    end
end
function y = sigmoid(x)
y = 1./(1+exp(-x));
end