clear all;
close all;
clc

fg=[0;0;-1];
fm=[0;1;0];
qPrev=[0;0;0;1];

r3=cross(fg,fm);

load GyroData.mat
GD = GyroData;
load AccelerometerData.mat
AD = AccelerometerData;
load MagnetData.mat
MD = MagnetData;

lenGD = length(GD);
I4=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];

v1=[0;1;0];
for i = 2:lenGD-1
    Wx = GD(i,1);
    Wy = GD(i,2);
    Wz = GD(i,3);
    dt = GD(i,4) - GD(i-1,4);
    omiga=[0, -Wz, Wy, Wx; Wz, 0, -Wx, Wy; -Wy, Wx, 0, Wz; Wx, Wy, Wz, 0];
    q=(I4+1/2*dt*omiga)*qPrev;
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

lenAD=length(AD);
lenMD=length(MD);

for i=1:lenMD
    
    mX=MD(i, 1);
    mY=MD(i, 2);
    mZ=MD(i, 3);
    
    aX=AD(i, 1);
    aY=AD(i, 2);
    aZ=AD(i, 3);
    
    m=[mX;mY;mZ];
    a=[aZ;aY;aZ];
    
    Sm=m/norm(m);
    Sg=a/norm(a);
    
    b3=cross(Sm,Sg)/norm(cross(Sm,Sg));
    
    B=0.2*dot(Sg, fg)+0.2*dot(Sm, fm);
    
    qCoe=1/(sqrt(2*(1+dot(b3, r3))));
    crossb3r3=cross(b3,r3);
    
    qmin=[qCoe*crossb3r3(1);qCoe*crossb3r3(2);qCoe*crossb3r3(3); 1+dot(b3,r3)];
    
    q180=[qCoe*(b3(1)+r3(1));qCoe*(b3(2)+r3(2));qCoe*(b3(2)+r3(2));0];
    
    alpha=(1+dot(b3,r3))*(0.1*dot(Sg,fg)+0.1*dot(Sm,fm))+dot(cross(b3,r3),(0.1*cross(Sg,fg)+0.1*cross(Sm,fm)));
    
    beta=dot((b3+r3),0.1*cross(Sg,fg)+0.1*cross(Sm,fm));
    c=b3+r3;
    
    lameda=sqrt(alpha^2+beta^2);
    cos=alpha/lameda;
    sin=beta/lameda;
    
    if cos>=0
       cosH=sqrt(1/2*(1+cos)); 
       sinH=sin/sqrt(1/2*(1+cos));
    
    elseif cos<0
        cosH=sqrt(1/2*(1-cos));
        sinH=sin/sqrt(1/2*(1-cos));
    end
       
    if alpha>=0
        qoptCoe=1/(2*sqrt(lameda*(lameda+alpha)*(1+dot(b3,r3))));
        qopt1=[qoptCoe*((lameda+alpha)*crossb3r3(1)+beta*(b3(1)+r3(1)));
              qoptCoe*((lameda+alpha)*crossb3r3(2)+beta*(b3(2)+r3(2)));
              qoptCoe*((lameda+alpha)*crossb3r3(3)+beta*(b3(3)+r3(3)));
              qoptCoe*(lameda+alpha)*(1+dot(b3,r3))];
        display(qopt1);
    elseif alpha<0
        qoptCoe=1/(2*sqrt(lameda*(lameda-alpha)*(1+dot(b3,r3))));
        qopt2=[qoptCoe*(beta*crossb3r3(1)+(lameda-alpha)*(b3(1)+r3(1)));
              qoptCoe*(beta*crossb3r3(2)+(lameda-alpha)*(b3(2)+r3(2)));
              qoptCoe*(beta*crossb3r3(3)+(lameda-alpha)*(b3(3)+r3(3)));
              beta*(1+dot(b3,r3))];
        display(qopt2);
    end
    
    
end
display(result);
