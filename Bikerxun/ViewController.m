//
//  ViewController.m
//  Bikerxun
//
//  Created by Bobie on 3/13/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_labelMiles release];
    [super dealloc];
}
- (IBAction)addMiles:(id)sender {
}

- (IBAction)launchBeintoo:(id)sender {
}

- (IBAction)onSliderValueChanged:(id)sender {
    NSString* strMiles =  [NSString stringWithFormat:@"%.0f Miles", [(UISlider*)sender value] ];
    self.labelMiles.text = strMiles;
}
@end
