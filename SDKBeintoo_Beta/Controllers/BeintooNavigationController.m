/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import "BeintooNavigationController.h"
#import "Beintoo.h"

@implementation BeintooNavigationController
@synthesize type, isSignupDirectLaunch;

- (void)show
{
	self.view.alpha = 1;
	
	// Ipad functions here not used (this class is not used on ipad)
    ipadView = [[UIView alloc] initWithFrame:[self.view bounds]];
	ipadView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
	
	if ([BeintooDevice isiPad]) {
		self.view = ipadView;
	}
		
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.5f];
    if (type != NAV_TYPE_SIGNUP_PRIVATE && type != NAV_TYPE_NOTIFICATIONS_PRIVATE)
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionMoveIn];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
}

- (void)hide
{
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.5f];
    
    if (type != NAV_TYPE_SIGNUP_PRIVATE && type != NAV_TYPE_NOTIFICATIONS_PRIVATE)
        [applicationUnloadViewIn setValue:@"unload" forKey:@"name"];
	
    applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionExitSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	self.view.alpha = 0;
}

- (void)hideNotAnimated
{
    self.view.alpha = 0;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
	if ([[animation valueForKey:@"name"] isEqualToString:@"unload"]) {
		[self.view removeFromSuperview];
		[Beintoo beintooDidDisappear];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
		[Beintoo beintooDidAppear];
	}
}

- (void)prepareBeintooPanelOrientation
{
    if ([BeintooDevice isiPad]){
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
            self.view.frame  = CGRectMake(0, 0, 320, 550);
            self.view.bounds = CGRectMake(0, 0, 550, 320);
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90));
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
            self.view.frame  = CGRectMake(0, 0, 320, 550);
            self.view.bounds = CGRectMake(0, 0, 550, 320);
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
        if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
            self.view.frame = CGRectMake(0, 0, 320, 550);
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
        if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
            self.view.frame = CGRectMake(0, 0, 320, 550);
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
    }
    else {
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
            self.view.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width); 
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90));
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
            self.view.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width); 
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
        if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
        if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
            self.view.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
    }
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (void)dealloc {
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[ipadView release];
    [super dealloc];
#endif
    
}

@end
