% Khrisna Kamarga
% AMATH 482 - Homework 5
clear all; close all; clc;

v = VideoReader('andre.mp4');

frames = 400;
dt = 1/v.frameRate;

m = 640;
n = 360;

%for car: 0.1 m = 108, n = 192
%my phone: 0.5 m = 240, n = 320
X = zeros(m*n, frames);
for i = 1:frames
    vidFrame = imresize(rgb2gray(readFrame(v)), 0.5);
    X(:,i) = reshape(double(vidFrame), m*n, 1);
%     pcolor(flipud(vidFrame)); colormap gray, shading interp;
%     drawnow;
end

%%
for i = 1:frames
    pcolor(flipud(reshape(X(:,i), m, n))); colormap gray, shading interp;
    drawnow;
end

%%
clc;
X1 = X;
X2 = X;
X1(:,end)=[];
X2(:,1) = [];
t = dt*(1:frames);

[Phi, w, lambda, b, Xdmd] = DMD(X1, X2, 20, dt);
display("done");

phip = Phi(:,1);
phij = Phi(:,2);
wp = w(1);
wj = w(2);

background = b.'.*Phi*exp(w.*t);

% background = b(3).'.*Phi(:,3)*exp(w(3)*t);

R = background;
R(R>0) = 0;

background = background - R;

Xsparse = X - abs(background);
Xsparse = Xsparse; % - R;


%%
clc; close all;
for i = 1:frames
    pcolor(flipud(reshape(abs(background(:,i)), m, n))); colormap gray, shading interp;
    drawnow;
end
display("done");

















%%
clc;
Xall = zeros(m*n, 1000);
for i = 1:1000
    vidFrame = imresize(rgb2gray(readFrame(v)), 0.1);
    X(:,i) = reshape(double(vidFrame), m*n, 1);
%     pcolor(flipud(vidFrame)); colormap gray, shading interp;
%     drawnow;
end
%%
XsparseAll = zeros(m*n, 1000);
for i = 1:size(Xall, 2)
    XsparseAll(:,i) = Xall(:,i) - abs(background(:,1)) - R;
end

%%
clc;
for i = 1:frames
    pcolor(flipud(reshape(abs(XsparseAll(:,i)), m, n))); colormap gray, shading interp;
    drawnow;
end
display("done");

