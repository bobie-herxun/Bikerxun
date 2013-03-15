//
//  ViewController.h
//  Bikerxun
//
//  Created by Bobie on 3/13/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *labelMiles;
@property (retain, nonatomic) IBOutlet UISlider *sliderMiles;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)addMiles:(id)sender;
- (IBAction)launchBeintoo:(id)sender;
- (IBAction)onSliderValueChanged:(id)sender;

@end
