//
//  ViewController.h
//  Orientation
//
//  Created by Bo Wu on 14-1-8.
//  Copyright (c) 2014年 Bo Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController{
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
    
}

@property(weak, nonatomic) IBOutlet UILabel *X1;
@property(weak, nonatomic) IBOutlet UILabel *Y1;
@property(weak, nonatomic) IBOutlet UILabel *Z1;
@property(weak, nonatomic) IBOutlet UILabel *X2;
@property(weak, nonatomic) IBOutlet UILabel *Y2;
@property(weak, nonatomic) IBOutlet UILabel *Z2;


- (IBAction)begin;

@end
