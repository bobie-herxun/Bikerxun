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
    [self.activityIndicator stopAnimating];
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
    [_activityIndicator release];
    [super dealloc];
}

- (void)beintooLogin
{
    [Beintoo setPlayerDelegate:self];
    [Beintoo login];
}

- (IBAction)addMiles:(id)sender {
    [Beintoo setPlayerDelegate:self];
    [Beintoo setAchievementsDelegate:self];
    [Beintoo submitScore:[self.sliderMiles value] forContest:@"default"];
    [Beintoo incrementAchievement:@"0e2ed8007bd0f3acbbe53f1abfe0acfe" withScore:80];    //a9d0686c3aeea261efdfaa1f6ee71959
    [Beintoo getScore];
    
    [self.activityIndicator startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(stopActivityIndicator) userInfo:nil repeats:NO];
}

- (void)stopActivityIndicator
{
    [self.activityIndicator stopAnimating];
}

- (IBAction)launchBeintoo:(id)sender {
    [Beintoo launchBeintoo];
}

- (IBAction)onSliderValueChanged:(id)sender {
    NSString* strMiles =  [NSString stringWithFormat:@"%.0f Miles", [(UISlider*)sender value] ];
    self.labelMiles.text = strMiles;
}
@end
