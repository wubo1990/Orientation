//
//  ViewController.h
//  Orientation
//
//  Created by Bo Wu on 14-1-8.
//  Copyright (c) 2014年 Bo Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

double iX;
double iY;
double iZ;
double iQX;
double iQY;
double iQZ;
double iQW;

@interface ViewController : UIViewController{
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
    
}

@property(weak, nonatomic) IBOutlet UILabel *X;
@property(weak, nonatomic) IBOutlet UILabel *Y;
@property(weak, nonatomic) IBOutlet UILabel *Z;
@property(weak, nonatomic) IBOutlet UILabel *W;
@property(weak, nonatomic) IBOutlet UITextField *initialX;
@property(weak, nonatomic) IBOutlet UITextField *initialY;
@property(weak, nonatomic) IBOutlet UITextField *initialZ;
@property(weak, nonatomic) IBOutlet UILabel *quaternionX;
@property(weak, nonatomic) IBOutlet UILabel *quaternionY;
@property(weak, nonatomic) IBOutlet UILabel *quaternionZ;
@property(weak, nonatomic) IBOutlet UILabel *quaternionW;


- (IBAction)begin;

@end
