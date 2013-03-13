//
//  ViewController.m
//  Bikerxun
//
//  Created by Bobie on 3/13/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "ViewController.h"
#import "Beintoo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.labelMiles.text = [NSString stringWithFormat:@"%.0f Miles", [self.sliderMiles value]];
    [self beintooLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_labelMiles release];
    [_sliderMiles release];
    [super dealloc];
}

- (void)beintooLogin
{
    [Beintoo setPlayerDelegate:self];
    [Beintoo login];
}

- (IBAction)addMiles:(id)sender {
    [Beintoo setPlayerDelegate:self];
    [Beintoo submitScore:10 forContest:@"default"];
    [Beintoo getScore];
}

- (IBAction)launchBeintoo:(id)sender {
    [Beintoo launchBeintoo];
}

- (IBAction)onSliderValueChanged:(id)sender {
    NSString* strMiles =  [NSString stringWithFormat:@"%.0f Miles", [(UISlider*)sender value] ];
    self.labelMiles.text = strMiles;
}
@end
