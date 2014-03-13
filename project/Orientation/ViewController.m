//
//  ViewController.m
//  Orientation
//
//  Created by Bo Wu on 14-1-8.
//  Copyright (c) 2014年 Bo Wu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

static const NSTimeInterval timeMin = 0.01;

@interface ViewController ()

@end

@implementation ViewController

@synthesize X1;
@synthesize Y1;
@synthesize Z1;
@synthesize X2;
@synthesize Y2;
@synthesize Z2;
@synthesize updateFrequencyLabel;

double nQX;
double nQY;
double nQZ;
double nQW;
double iX1;
double iY1;
double iZ1;
double iX2;
double iY2;
double iZ2;

double sampleTime;
double diffTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)startUpdatesWithSliderValue:(int)sliderValue
{
    nQX = 0.0;
    nQY = 0.0;
    nQZ = 0.0;
    nQW = 1.0;
    
    iX1 = 1.0;
    iY1 = 0.0;
    iZ1 = 0.0;
    
    iX2 = 0.0;
    iY2 = 1.0;
    iZ2 = 0.0;
    
    sampleTime = 0.0;
    diffTime = 0.0;
    
    NSTimeInterval delta = 0.005;
    NSTimeInterval updateInterval = timeMin + delta * sliderValue;
    
    int updateFrequency = 1 / updateInterval;
    
    NSLog(@"%d", updateFrequency);
    motionManager = [[CMMotionManager alloc]init];
    motionManager.deviceMotionUpdateInterval = 0.01;
    [motionManager startDeviceMotionUpdates];
    if ([motionManager isGyroAvailable]) {
        if (![motionManager isGyroActive]) {
            [motionManager setGyroUpdateInterval:0.01];
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
                //CMDeviceMotion *motion = motionManager.deviceMotion;
                CMAttitude *attitude = motionManager.deviceMotion.attitude;
                CMRotationMatrix rm = attitude.rotationMatrix;
                CMQuaternion quat = motionManager.deviceMotion.attitude.quaternion;
                
                double m11 = rm.m11; double m12 = rm.m12; double m13 = rm.m13;
                double m21 = rm.m21; double m22 = rm.m22; double m23 = rm.m23;
                double m31 = rm.m31; double m32 = rm.m32; double m33 = rm.m33;
                
                double qX = quat.x;
                double qY = quat.y;
                double qZ = quat.z;
                double qW = quat.w;
                
                double qm11 = qW * qW + qX * qX - qY * qY - qZ * qZ;
                double qm12 = 2 * qX * qY - 2 * qZ * qW;
                double qm13 = 2 * qX * qZ + 2 * qY * qW;
                double qm21 = 2 * qX * qY + 2 * qZ * qW;
                double qm22 = qW * qW - qX * qX + qY * qY - qZ * qZ;
                double qm23 = 2 * qY * qZ - 2 * qX * qW;
                double qm31 = 2 * qX * qZ - 2 * qY * qW;
                double qm32 = 2 * qY * qZ + 2 * qX * qW;
                double qm33 = qW * qW - qX * qX - qY * qY + qZ * qZ;
                
                
                NSLog(@"diff of m11: %f", m11 - qm11);
                NSLog(@"diff of m12: %f", m12 - qm12);
                NSLog(@"diff of m13: %f", m13 - qm13);
                
                double time = gyroData.timestamp;
                
                
                
                diffTime = time - sampleTime;
                //NSLog(@"time: %f, %f", sampleTime, time);
                sampleTime = time;
                
                
                double previousQX = nQX;
                double previousQY = nQY;
                double previousQZ = nQZ;
                double previousQW = nQW;
                
                double rotationX = gyroData.rotationRate.x;
                double rotationY = gyroData.rotationRate.y;
                double rotationZ = gyroData.rotationRate.z;
                
                nQX = previousQX + diffTime * rotationZ * previousQY / 2 - diffTime * rotationY * previousQZ / 2 + diffTime * rotationX * previousQW / 2;
                nQY = - diffTime * rotationZ * previousQX / 2 + previousQY + diffTime * rotationX * previousQZ / 2 + diffTime * rotationY * previousQW / 2;
                nQZ = diffTime * rotationY * previousQX / 2 + diffTime * rotationX * previousQY / 2 + previousQZ + diffTime * rotationZ * previousQW / 2;
                nQW = - diffTime * rotationX * previousQX / 2 - diffTime * rotationY * previousQY / 2 - diffTime * rotationZ * previousQZ / 2 + previousQW;
                
                
                double magnitude = sqrt(nQX*nQX + nQY * nQY + nQZ * nQZ + nQW * nQW);
                nQX = nQX / magnitude;
                nQY = nQY / magnitude;
                nQZ = nQZ / magnitude;
                nQW = nQW / magnitude;
                
                
                double nqm11 = nQW * nQW + nQX * nQX - nQY * nQY - nQZ * nQZ;
                double nqm12 = 2 * nQX * nQY - 2 * nQZ * nQW;
                double nqm13 = 2 * nQX * nQZ + 2 * nQY * nQW;
                double nqm21 = 2 * nQX * nQY + 2 * nQZ * nQW;
                double nqm22 = nQW * nQW - nQX * nQX + nQY * nQY - nQZ * nQZ;
                double nqm23 = 2 * nQY * nQZ - 2 * nQX * nQW;
                double nqm31 = 2 * nQX * nQZ - 2 * nQY * nQW;
                double nqm32 = 2 * nQY * nQZ + 2 * nQX * nQW;
                double nqm33 = nQW * nQW - nQX * nQX - nQY * nQY + nQZ * nQZ;
                
                
                double rX1 = 0.0;
                double rY1 = 0.0;
                double rZ1 = 0.0;
                
                double qpX1 = 0.0;
                double qpY1 = 0.0;
                double qpZ1 = 0.0;
                double qpW1 = 0.0;
                
                
                qpW1 = - nQX * iX1 - nQY * iY1 - nQZ * iZ1;
                qpX1 = nQW * iX1 + nQY * iZ1 - nQZ * iY1;
                qpY1 = nQW * iY1 - nQX * iZ1 + nQZ * iX1;
                qpZ1 = nQW * iZ1 + nQX * iY1 - nQY * iX1;

                
                rX1 = - qpW1 * nQX + qpX1 * nQW - qpY1 * nQZ + qpZ1 * nQY;
                rY1 = - qpW1 * nQY + qpX1 * nQZ + qpY1 * nQW - qpZ1 * nQX;
                rZ1 = - qpW1 * nQZ - qpX1 * nQY + qpY1 * nQX + qpZ1 * nQW;
                
                
                
                NSString *resultX1 = [[NSString alloc]initWithFormat:@"x: %06f", rX1];
                X1.text = resultX1;
                
                NSString *resultY1 = [[NSString alloc]initWithFormat:@"y: %06f", rY1];
                Y1.text = resultY1;
                
                
                NSString *resultZ1 = [[NSString alloc]initWithFormat:@"z: %06f", rZ1];
                Z1.text = resultZ1;

                double rX2 = 0.0;
                double rY2 = 0.0;
                double rZ2 = 0.0;
                
                double qpX2 = 0.0;
                double qpY2 = 0.0;
                double qpZ2 = 0.0;
                double qpW2 = 0.0;
                
                
                qpW2 = - nQX * iX2 - nQY * iY2 - nQZ * iZ2;
                qpX2 = nQW * iX2 + nQY * iZ2 - nQZ * iY2;
                qpY2 = nQW * iY2 - nQX * iZ2 + nQZ * iX2;
                qpZ2 = nQW * iZ2 + nQX * iY2 - nQY * iX2;
                
                
                rX2 = - qpW2 * nQX + qpX2 * nQW - qpY2 * nQZ + qpZ2 * nQY;
                rY2 = - qpW2 * nQY + qpX2 * nQZ + qpY2 * nQW - qpZ2 * nQX;
                rZ2 = - qpW2 * nQZ - qpX2 * nQY + qpY2 * nQX + qpZ2 * nQW;
                
                NSString *resultX2 = [[NSString alloc]initWithFormat:@"x: %06f", rX2];
                X2.text = resultX2;
                
                NSString *resultY2 = [[NSString alloc]initWithFormat:@"y: %06f", rY2];
                Y2.text = resultY2;
                
                NSString *resultZ2 = [[NSString alloc]initWithFormat:@"z: %06f", rZ2];
                Z2.text = resultZ2;
            }];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NO GYRO" message:@"GET A GYRO" delegate:self cancelButtonTitle:@"DONE" otherButtonTitles: nil];
        [alert show];
    }
    if ([motionManager isAccelerometerAvailable]) {
        if (![motionManager isAccelerometerActive]) {
            [motionManager setAccelerometerUpdateInterval:0.01];
            [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accDate, NSError *error){
             
             
             
             
            }];
        }
    }
    
    if ([motionManager isMagnetometerAvailable]) {
        if (![motionManager isMagnetometerActive]) {
            [motionManager setMagnetometerUpdateInterval:0.01];
            [motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *magDate, NSError *error){
              
                
                
                
            }];
        }
    }
    
    self.updateFrequencyLabel.text = [NSString stringWithFormat:@"%d HZ", updateFrequency];
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
