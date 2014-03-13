//
//  SliderViewController.m
//  Orientation
//
//  Created by Bo Wu on 14-3-10.
//  Copyright (c) 2014年 Bo Wu. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@property (weak, nonatomic) IBOutlet UISlider *updateFrequencySlider;

@end

@implementation SliderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.updateFrquencySlider.value = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startUpdatesWithSliderValue:(int)(self.updateFrquencySlider.value * 100)];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopUpdates];
    
}

- (IBAction)takeSliderValueFrom:(UISlider *)sender
{
    [self startUpdatesWithSliderValue:(int)(sender.value *100)];
}

- (void)startUpdatesWithSliderValue:(int)sliderValue
{
    return;
}

- (void)stopUpdates
{
    return;
}

@end
