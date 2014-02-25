//
//  ViewController.m
//  Orientation
//
//  Created by Bo Wu on 14-1-8.
//  Copyright (c) 2014年 Bo Wu. All rights reserved.
//

#import "ViewController.h"
#import <math.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize X;
@synthesize Y;
@synthesize Z;
@synthesize W;
@synthesize quaternionX;
@synthesize quaternionY;
@synthesize quaternionZ;
@synthesize quaternionW;

double nQX;
double nQY;
double nQZ;
double nQW;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)begin{
    nQX = 0.0;
    nQY = 0.0;
    nQZ = 0.0;
    nQW = 1.0;
    
    motionManager = [[CMMotionManager alloc]init];
    motionManager.deviceMotionUpdateInterval = 0.01;
    [motionManager startDeviceMotionUpdates];
    if ([motionManager isGyroAvailable]) {
        if (![motionManager isGyroActive]) {
            [motionManager setGyroUpdateInterval:0.01];
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
                //CMQuaternion quat = motionManager.deviceMotion.attitude.quaternion;
                
                
                //double qX = quat.x;
                //double qY = quat.y;
                //double qZ = quat.z;
                //double qW = quat.w;
                
                //double qX = 0.0;
                //double qY = 0.7;
                //double qZ = 0.0;
                //double qW = 0.7;
                
                double previousQX = nQX;
                double previousQY = nQY;
                double previousQZ = nQZ;
                double previousQW = nQW;
                
                double rotationX = gyroData.rotationRate.x;
                double rotationY = gyroData.rotationRate.y;
                double rotationZ = gyroData.rotationRate.z;
                
                NSLog(@"rX: %04f", rotationX);
                NSLog(@"rY: %04f", rotationY);
                NSLog(@"rZ: %04f", rotationZ);
                
                //nQX = nQX - rotationZ * nQX / 2 + rotationY * nQZ / 2 + rotationX * nQW / 2;
                //nQY = rotationZ * nQX / 2 + nQY - rotationX * nQZ / 2 + rotationY * nQW /2;
                //nQZ = - rotationY * nQX / 2 + rotationX * nQY / 2 + nQZ + rotationZ * nQW / 2;
                //nQW = rotationX * nQX / 2 + rotationY * nQY / 2 + rotationZ * nQZ / 2 + nQW;
                
                nQX = previousQX + rotationZ * previousQY / 20 - rotationY * previousQZ / 20 + rotationX * previousQW / 20;
                nQY = - rotationZ * previousQX / 20 + previousQY + rotationX * previousQZ / 20 + rotationY * previousQW / 20;
                nQZ = rotationY * previousQX / 20 + rotationX * previousQY / 20+ previousQZ + rotationZ * previousQW / 20;
                nQW = - rotationX * previousQX / 20 - rotationY * previousQY / 20 - rotationZ * previousQZ / 20 + previousQW;
                
                //nQX = previousQX - rotationX * previousQY / 20 - rotationY * previousQZ / 20 - rotationZ * previousQW / 20;
                //nQY = rotationX * previousQX / 20 + previousQY + rotationZ * previousQZ / 20 - rotationY * previousQW / 20;
                //nQZ = rotationY * previousQX / 20 - rotationZ * previousQY / 20 + previousQZ + rotationX * previousQW / 20;
                //nQW = rotationZ * previousQX / 20 + rotationY * previousQY / 20 - rotationX * previousQZ / 20 + previousQW;
                
                
                double magnitude = sqrt(nQX*nQX + nQY * nQY + nQZ * nQZ + nQW * nQW);
                nQX = nQX / magnitude;
                nQY = nQY / magnitude;
                nQZ = nQZ / magnitude;
                nQW = nQW / magnitude;
                
                //NSLog(@"X: %04f", nQX);
                //NSLog(@"Y: %04f", nQY);
                //NSLog(@"Z: %04f", nQZ);
                //NSLog(@"W: %04f", nQW);
                
                iX = 0.0;
                iY = 0.0;
                iZ = 0.0;
                
                iY = [self.initialX.text doubleValue];
                iX = [self.initialY.text doubleValue];
                iZ = [self.initialZ.text doubleValue];
                
                double rX = 0.0;
                double rY = 0.0;
                double rZ = 0.0;
                double rW = 0.0;
                
                double qpX = 0.0;
                double qpY = 0.0;
                double qpZ = 0.0;
                double qpW = 0.0;
                
                qpW = - nQX * iX - nQY * iY - nQZ * iZ;
                qpX = nQW * iX + nQY * iZ - nQZ * iY;
                qpY = nQW * iY - nQX * iZ + nQZ * iX;
                qpZ = nQW * iZ + nQX * iY - nQY * iX;

                
                rX = - qpW * nQX + qpX * nQW - qpY * nQZ + qpZ * nQY;
                rY = - qpW * nQY + qpX * nQZ + qpY * nQW - qpZ * nQX;
                rZ = - qpW * nQZ - qpX * nQY + qpY * nQX + qpZ * nQW;
                
                //rX = (nQX * nQX + nQY * nQY -nQZ * nQZ - nQW * nQW) * iX
                //+ 2 * (nQY * nQZ - nQX * nQW) * iY
                //+ 2 * (nQY * nQW + nQX * nQW) * iZ;
                
                //rY = 2 * (nQY * nQZ + nQX * nQW) * iX
                //+ (nQZ * nQZ - nQW * nQW + nQX * nQX - nQY * nQY) * iY
                //+ 2 * (nQZ * nQW - nQX * nQY) * iY;
                
                //rZ = 2 * (nQY * nQW - nQX * nQZ) * iY
                //+ 2 * (nQZ * nQW + nQX * nQY) * iY
                //+ (nQW * nQW - nQZ * nQZ - nQY * nQY + nQX * nQX) * iZ;
                
                
                NSString *x = [[NSString alloc]initWithFormat:@"y: %06f", rX];
                
                
                NSString *y = [[NSString alloc]initWithFormat:@"x: %06f", rY];
                Y.text = x;
                X.text = y;
                
                NSString *z = [[NSString alloc]initWithFormat:@"z: %06f", rZ];
                Z.text = z;
                
                NSString *w = [[NSString alloc]initWithFormat:@"w: %06f", rW];
                W.text = w;
                
                NSString *quatX = [[NSString alloc]initWithFormat:@"qX: %06f", nQX];
                quaternionX.text = quatX;
                
                NSString *quatY = [[NSString alloc]initWithFormat:@"qY: %06f", nQY];
                quaternionY.text = quatY;
                
                NSString *quatZ = [[NSString alloc]initWithFormat:@"qZ: %06f", nQZ];
                quaternionZ.text = quatZ;
                
                NSString *quatW = [[NSString alloc]initWithFormat:@"qW: %06f", nQW];
                quaternionW.text = quatW;
                
            }];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NO GYRO" message:@"GET A GYRO" delegate:self cancelButtonTitle:@"DONE" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
