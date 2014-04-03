//
//  ViewController.m
//  Orientation
//
//  Created by Bo Wu on 14-1-8.
//  Copyright (c) 2014年 Bo Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


//Label for the first result vector for x-axis of phone
@synthesize X1;
@synthesize Y1;
@synthesize Z1;

//Label for the second result vector for y-axis of phone
@synthesize X2;
@synthesize Y2;
@synthesize Z2;

//slider for updating the frequency
@synthesize updateFrequencyLabel;

@synthesize measuredFrequencyLabel;

//Quaternion from the updating of the previous quaternion, named as new quaternion
double nQX;
double nQY;
double nQZ;
double nQW;

//Initial vector for x-axis
double iX1;
double iY1;
double iZ1;

//Initial vector for y-axis
double iX2;
double iY2;
double iZ2;

int i;

double sampleTime;
double diffTime;
double previousTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)startUpdatesWithSliderValue:(id)sender
{
    
    //Initialize the quaternion for (0, 0, 0, 1). Only the scaler part of quaterion is 1
    nQX = 0.0;
    nQY = 0.0;
    nQZ = 0.0;
    nQW = 1.0;
    
    //Initialize the x-axis is (1, 0, 0)
    iX1 = 1.0;
    iY1 = 0.0;
    iZ1 = 0.0;
    
    //Initialized the y-axis is （0, 1, 0)
    iX2 = 0.0;
    iY2 = 1.0;
    iZ2 = 0.0;
    
    i = 0;
    
    sampleTime = 0.0;
    diffTime = 0.0;
    previousTime = 0.0;
    
    //Set up the slider for the sampling interval
    UISlider *slider = (UISlider *) sender;
    float sliderVal = slider.value * 100;
    NSInteger updateFrequency = lround(sliderVal);
    float updateInterval = 1.0 / updateFrequency;
    
    //NSLog(@"%f, %d", updateInterval, updateFrequency);
    
    //Initialized the motion manager
    motionManager = [[CMMotionManager alloc] init];
    
    //Set up the device updating interval
    motionManager.deviceMotionUpdateInterval = updateInterval;
    
    //Start the device motion updating
    [motionManager startDeviceMotionUpdates];
    if ([motionManager isGyroAvailable]) {
        if (![motionManager isGyroActive]) {
            //Set up the gyro updating interval
            [motionManager setGyroUpdateInterval:updateInterval];
            //The push approach
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
                
                //Attitude contains the rotation matrix
                CMAttitude *attitude = motionManager.deviceMotion.attitude;
                //Rotaion matrix from the attitude
                CMRotationMatrix rm = attitude.rotationMatrix;
                //The quaternion form the device motion
                CMQuaternion quat = motionManager.deviceMotion.attitude.quaternion;
                
                
                //The rotation matrix from the attitude
                double m11 = rm.m11; double m12 = rm.m12; double m13 = rm.m13;
                double m21 = rm.m21; double m22 = rm.m22; double m23 = rm.m23;
                double m31 = rm.m31; double m32 = rm.m32; double m33 = rm.m33;
                
                //The quaterion form the attitude
                double qX = quat.x;
                double qY = quat.y;
                double qZ = quat.z;
                double qW = quat.w;
                
                //The rotation matrix from the caculation by the quaterion form the attitude by equation 2
                double qm11 = qW * qW + qX * qX - qY * qY - qZ * qZ;
                double qm12 = 2 * qX * qY - 2 * qZ * qW;
                double qm13 = 2 * qX * qZ + 2 * qY * qW;
                double qm21 = 2 * qX * qY + 2 * qZ * qW;
                double qm22 = qW * qW - qX * qX + qY * qY - qZ * qZ;
                double qm23 = 2 * qY * qZ - 2 * qX * qW;
                double qm31 = 2 * qX * qZ - 2 * qY * qW;
                double qm32 = 2 * qY * qZ + 2 * qX * qW;
                double qm33 = qW * qW - qX * qX - qY * qY + qZ * qZ;
                
                //double diffM11 = m11 - qm11; double diffM12 = m12 - qm12; double diffM13 = m13 - qm13;
                //double diffM21 = m21 - qm21; double diffM22 = m22 - qm22; double diffM23 = m23 - qm23;
                //double diffM31 = m31 - qm31; double diffM32 = m32 - qm32; double diffM33 = m33 - qm33;
                
                NSLog(@"m1: %f, %f, %f", m11, m12, m13);
                NSLog(@"m1: %f, %f, %f", m21, m22, m23);
                NSLog(@"m1: %f, %f, %f", m31, m32, m33);
                
                NSLog(@"m2: %f, %f, %f", qm11, qm12, qm13);
                NSLog(@"m2: %f, %f, %f", qm21, qm22, qm23);
                NSLog(@"m2: %f, %f, %f", qm31, qm32, qm33);
                
                
                //Timestamp of the gyro data
                sampleTime = gyroData.timestamp;
                diffTime = sampleTime - previousTime;
                previousTime = sampleTime;
                
                
                NSLog(@"different time: %f", diffTime);
                
                //Set the current quaternion to the previous quaternion
                double previousQX = nQX;
                double previousQY = nQY;
                double previousQZ = nQZ;
                double previousQW = nQW;
                
                //Get the rotation rate
                double rotationX = gyroData.rotationRate.x;
                double rotationY = gyroData.rotationRate.y;
                double rotationZ = gyroData.rotationRate.z;
                
                
                
                if (i >= 1) {
                    //Calculate the new quarternion from the previous quarternion and ratation rate by the the equation 7
                    nQX = previousQX + diffTime * rotationZ * previousQY / 2 - diffTime * rotationY * previousQZ / 2 + diffTime * rotationX * previousQW / 2;
                    nQY = - diffTime * rotationZ * previousQX / 2 + previousQY + diffTime * rotationX * previousQZ / 2 + diffTime * rotationY * previousQW / 2;
                    nQZ = diffTime * rotationY * previousQX / 2 + diffTime * rotationX * previousQY / 2 + previousQZ + diffTime * rotationZ * previousQW / 2;
                    nQW = - diffTime * rotationX * previousQX / 2 - diffTime * rotationY * previousQY / 2 - diffTime * rotationZ * previousQZ / 2 + previousQW;
                    
                    //Normalize the quaterion
                    double magnitude = sqrt(nQX * nQX + nQY * nQY + nQZ * nQZ + nQW * nQW);
                    nQX = nQX / magnitude;
                    nQY = nQY / magnitude;
                    nQZ = nQZ / magnitude;
                    nQW = nQW / magnitude;
                }
                
                
                //The rotation matrix from the calculated quaternion
                double nqm11 = nQW * nQW + nQX * nQX - nQY * nQY - nQZ * nQZ;
                double nqm12 = 2 * nQX * nQY - 2 * nQZ * nQW;
                double nqm13 = 2 * nQX * nQZ + 2 * nQY * nQW;
                double nqm21 = 2 * nQX * nQY + 2 * nQZ * nQW;
                double nqm22 = nQW * nQW - nQX * nQX + nQY * nQY - nQZ * nQZ;
                double nqm23 = 2 * nQY * nQZ - 2 * nQX * nQW;
                double nqm31 = 2 * nQX * nQZ - 2 * nQY * nQW;
                double nqm32 = 2 * nQY * nQZ + 2 * nQX * nQW;
                double nqm33 = nQW * nQW - nQX * nQX - nQY * nQY + nQZ * nQZ;
                
                //double dm11 = m11 - nqm11; double dm12 = m12 - nqm12; double dm13 = m13 - nqm13;
                //double dm21 = m21 - nqm21; double dm22 = m22 - nqm22; double dm23 = m23 - nqm23;
                //double dm31 = m31 - nqm31; double dm32 = m32 - nqm32; double dm33 = m33 - nqm33;
                
                NSLog(@"m3: %f, %f, %f", nqm11, nqm12, nqm13);
                NSLog(@"m3: %f, %f, %f", nqm21, nqm22, nqm23);
                NSLog(@"m3: %f, %f, %f", nqm31, nqm32, nqm33);
                
                
                //Initialze the result vector
                double rX1 = 0.0;
                double rY1 = 0.0;
                double rZ1 = 0.0;
                
                //The dot product from quanternion and initial vector
                double qpX1 = 0.0;
                double qpY1 = 0.0;
                double qpZ1 = 0.0;
                double qpW1 = 0.0;
                
                
                qpW1 = - nQX * iX1 - nQY * iY1 - nQZ * iZ1;
                qpX1 = nQW * iX1 + nQY * iZ1 - nQZ * iY1;
                qpY1 = nQW * iY1 - nQX * iZ1 + nQZ * iX1;
                qpZ1 = nQW * iZ1 + nQX * iY1 - nQY * iX1;
                
                //The result vector
                rX1 = - qpW1 * nQX + qpX1 * nQW - qpY1 * nQZ + qpZ1 * nQY;
                rY1 = - qpW1 * nQY + qpX1 * nQZ + qpY1 * nQW - qpZ1 * nQX;
                rZ1 = - qpW1 * nQZ - qpX1 * nQY + qpY1 * nQX + qpZ1 * nQW;
                
                //Output the result vector
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
                
                //Compute the second vector
                qpW2 = - nQX * iX2 - nQY * iY2 - nQZ * iZ2;
                qpX2 = nQW * iX2 + nQY * iZ2 - nQZ * iY2;
                qpY2 = nQW * iY2 - nQX * iZ2 + nQZ * iX2;
                qpZ2 = nQW * iZ2 + nQX * iY2 - nQY * iX2;
                
                
                rX2 = - qpW2 * nQX + qpX2 * nQW - qpY2 * nQZ + qpZ2 * nQY;
                rY2 = - qpW2 * nQY + qpX2 * nQZ + qpY2 * nQW - qpZ2 * nQX;
                rZ2 = - qpW2 * nQZ - qpX2 * nQY + qpY2 * nQX + qpZ2 * nQW;
                
                //double secondTime = gyroData.timestamp;
                //NSLog(@"Second Time: %f", secondTime);
                
                
                //Output the second vector
                NSString *resultX2 = [[NSString alloc]initWithFormat:@"x: %06f", rX2];
                X2.text = resultX2;
                
                NSString *resultY2 = [[NSString alloc]initWithFormat:@"y: %06f", rY2];
                Y2.text = resultY2;
                
                NSString *resultZ2 = [[NSString alloc]initWithFormat:@"z: %06f", rZ2];
                Z2.text = resultZ2;
                
                int measuredFrequency = 1 / diffTime;
                
                NSString *measureedFrquencyString = [[NSString alloc]initWithFormat:@"%d", measuredFrequency];
                measuredFrequencyLabel.text = measureedFrquencyString;
                
                i++;
                
            }];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NO GYRO" message:@"GET A GYRO" delegate:self cancelButtonTitle:@"DONE" otherButtonTitles: nil];
        [alert show];
    }
    
    
    if ([motionManager isAccelerometerAvailable]) {
        if (![motionManager isAccelerometerActive]) {
            [motionManager setAccelerometerUpdateInterval:updateInterval];
            [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accData, NSError *error){
                
                //Data from accelerometer
                //double aX = accData.acceleration.x;
                //double aY = accData.acceleration.y;
                //double aZ = accData.acceleration.z;
                
                //Sg from equation 4
                //double SgX = aX / sqrt(aX * aX + aY * aY + aZ * aZ);
                //double SgY = aY / sqrt(aX * aX + aY * aY + aZ * aZ);
                //double SgZ = aZ / sqrt(aX * aX + aY * aY + aZ * aZ);
            }];
        }
    }
    
    
    if ([motionManager isMagnetometerAvailable]) {
        if (![motionManager isMagnetometerActive]) {
            [motionManager setMagnetometerUpdateInterval:updateInterval];
            [motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *magData, NSError *error){
                
                //Data from magnetometer
                //double mX = magData.magneticField.x;
                //double mY = magData.magneticField.y;
                //double mZ = magData.magneticField.z;
                
                //Sm from equation 4
                //double SmX = mX / sqrt(mX * mX + mY * mY + mZ * mZ);
                //double SmY = mY / sqrt(mX * mX + mY * mY + mZ * mZ);
                //double SmZ = mZ / sqrt(mX * mX + mY * mY + mZ * mZ);
                
            }];
        }
    }
    
    self.updateFrequencyLabel.text = [NSString stringWithFormat:@"%ld HZ", (long)updateFrequency];
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
