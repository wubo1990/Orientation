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

@synthesize X1;
@synthesize Y1;
@synthesize Z1;
@synthesize X2;
@synthesize Y2;
@synthesize Z2;


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
    
    iX1 = 1.0;
    iY1 = 0.0;
    iZ1 = 0.0;
    
    iX2 = 0.0;
    iY2 = 1.0;
    iZ2 = 0.0;
    
    motionManager = [[CMMotionManager alloc]init];
    motionManager.deviceMotionUpdateInterval = 0.1;
    [motionManager startDeviceMotionUpdates];
    if ([motionManager isGyroAvailable]) {
        if (![motionManager isGyroActive]) {
            [motionManager setGyroUpdateInterval:0.1];
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
    
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
                
                
                nQX = previousQX + rotationZ * previousQY / 20 - rotationY * previousQZ / 20 + rotationX * previousQW / 20;
                nQY = - rotationZ * previousQX / 20 + previousQY + rotationX * previousQZ / 20 + rotationY * previousQW / 20;
                nQZ = rotationY * previousQX / 20 + rotationX * previousQY / 20+ previousQZ + rotationZ * previousQW / 20;
                nQW = - rotationX * previousQX / 20 - rotationY * previousQY / 20 - rotationZ * previousQZ / 20 + previousQW;
                
                
                double magnitude = sqrt(nQX*nQX + nQY * nQY + nQZ * nQZ + nQW * nQW);
                nQX = nQX / magnitude;
                nQY = nQY / magnitude;
                nQZ = nQZ / magnitude;
                nQW = nQW / magnitude;
                
                
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
