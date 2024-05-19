% Test PCA
clc
clear all
rng(18007);
nvar = 28;
nsamples = randi([800,1000],1);
% True constraint matrix
%          1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
Atrue =   [1  1 -1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0; 
           0  0  0  0 -1 -1  1  1 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;
          -1  0  0  0  1  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;
           0  0  0  0  0  0  0  0  0  1  1 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;
           0  0  1  0  0  0  0  0  0  0 -1  0  1 -1 -1 -1 -1  0  0  0  0  0  0  0  0  0  0  0;
           0 -1  0  0  0  1  0  0  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;
           0  0  0  0  0  0 -1  0  0  0  0  0  0  1  0  0  0  1 -1 -1 -1  0  0  0  0  0  0  0;
           0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0 -1  0  0  0  1 -1 -1  0  0  0  0;
           0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  1  0  0  0  0  0 -1  0  0 -1  0  0  0;
           0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  1  0  0 -1  1  0;
           0  0  0  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  1  0  1 ];
        
%
A2 = [Atrue(:,1:3), Atrue(:,5), Atrue(:,7:9), Atrue(:,12), Atrue(:,15), Atrue(:,23), Atrue(:,25)];
A1 = [Atrue(:,4), Atrue(:,6), Atrue(:,10:11), Atrue(:,13:14), Atrue(:,16:22), Atrue(:,24), Atrue(:,26:28)];

indreorder = [18:20 1 21 2 22:24 3:4 25 5:6 26 7:13 27 14 28 15:17];
% True values of independent variables
x1 = zeros(17,1);
x1(1) = 109.95;
x1(2) = 112.27;
x1(3) = 52.41;
x1(4) = 14.86;
x1(5) = 111.27;
x1(6) = 91.86;
x1(7) = 23.64;
x1(8) = 32.73;
x1(9) = 16.23;
x1(10) = 7.95;
x1(11) = 10.5;
x1(12) = 87.27;
x1(13) =  5.45;
x1(14) = 46.64;
x1(15) = 81.32;
x1(16) = 70.77;
x1(17) = 72.23;

Bmat = -inv(A2'*A2)*A2'*A1;
x2 = Bmat*x1;


% Errors in measurements are from a normal distribution
stdx = 2*rand*ones(nvar,1);
% Standard deviation of measurement errors
Ltrue = diag(stdx);

Ftruefull(1,:) = [x1', x2']; 
for j = 2:nsamples
    for k = 1:17
        Ftruefull(j,k) = Ftruefull(1,k) + 15*rand(); 
    end
    Ftruefull(j,18:28) = Ftruefull(j,1:17)*Bmat';
end

for j = 1:nsamples
    error = randn(nvar,1);
    Fmeasfull(j,:) = Ftruefull(j,:) + error'*Ltrue;
end

% Rearrange measurements according to numbering in figure
Ftruer = Ftruefull(:,indreorder);
Fmeasr = Fmeasfull(:,indreorder);
stdr = stdx(indreorder);

%  Measure only a random subset of the full set of measurements

nsub = randi([20,nvar],1);
indx = randperm(nvar);
Fmindx = indx(1:nsub);
Ftrue = Ftruer(:,Fmindx);
Fmeas = Fmeasr(:,Fmindx);
save('steamdata.mat','Ftrue','Fmeas','Fmindx');

