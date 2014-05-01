clear all;
close all;
clc

fg=[0,0,-1];
fm=[0,1,0];
qPrev=[0;0;0;1];

load GyroData.mat
GD = GyroData;
load AccelerometerData.mat
AD = AccelerometerData;
load MagnetData.mat
MD = MagnetData;

len = length(GD);
I4=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];

v1=[0;1;0];
for i = 2:len-1
    Wx = GD(i,1);
    Wy = GD(i,2);
    Wz = GD(i,3);
    dt = GD(i,4) - GD(i-1,4);
    omiga=[0, -Wz, Wy, Wx; Wz, 0, -Wx, Wy; -Wy, Wx, 0, Wz; Wx, Wy, Wz, 0];
    q=(I4+dt*omiga)*qPrev;
    nq=q/norm(q);
    qinvers=[-nq(1);-nq(2);-nq(3);-nq(4)];
    
    qw=-nq(1)*v1(1)-nq(2)*v1(2)-nq(3)*v1(3);
    qx=nq(4)*v1(1)+nq(2)*v1(3)-nq(3)*v1(2);
    qy=nq(4)*v1(2)-nq(1)*v1(3)+nq(3)*v1(1);
    qz=nq(4)*v1(3)+nq(1)*v1(2)+nq(2)*v1(1);
    
    rx=-qw*nq(1)+qx*nq(4)-qy*nq(3)+qz*nq(2);
    ry=-qw*nq(2)+qx*nq(3)-qy*nq(4)+qz*nq(1);
    rz=-qw*nq(3)-qx*nq(2)+qy*nq(1)+qz*nq(4);
    
    result=[rx;ry;rz];
    qPrev = nq;
  
end



display(result);
