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

#import "BPopupAnimated.h"
#import "Beintoo.h"
#import <QuartzCore/QuartzCore.h>

@implementation BPopupAnimated

// ----------------- NEW -------------------------->

-(id)init
{
	if (self = [super init])
	{
		current_element                 = [[NSDictionary alloc] init];
	}
    return self;
}

// ---- This is the last method called, when the notification for the achievement is ready and well oriented
- (void)showNotification
{	
	notificationCurrentlyOnScreen = YES;
	
	self.alpha = 0;
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.7f];
	[applicationLoadViewIn setValue:@"load" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionMoveIn];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	self.alpha = 1;
}

- (void)closeNotification
{	
	self.alpha = 0;
	CATransition *popupExitAnimation = [CATransition animation];
	[popupExitAnimation setDuration:0.5f];
	[popupExitAnimation setValue:@"unload" forKey:@"name"];
	popupExitAnimation.removedOnCompletion = YES;
	[popupExitAnimation setType:kCATransitionFade];
	popupExitAnimation.delegate = self;
	[popupExitAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self layer] addAnimation:popupExitAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{    
    float notificationTimeOnScreen;
    switch (notificationType) {
		case NOTIFICATION_TYPE_ACHIEV:
            notificationTimeOnScreen = NOTIFICATION_ACHIEVEM_SECONDS;
			break;
		default:
			break;
	}	
    
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
		[NSTimer scheduledTimerWithTimeInterval:notificationTimeOnScreen target:self  selector:@selector(closeNotification)
									   userInfo:nil repeats:NO];	
	}
	
	if ([[animation valueForKey:@"name"] isEqualToString:@"unload"]) {
		
		for (UIView* child in self.subviews) {
			[child removeFromSuperview];
		}
		
		[self removeFromSuperview];
		notificationCurrentlyOnScreen = NO;
	}
}

- (void)prepareNotificationOrientation:(CGRect)startingFrame
{
	self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	CGRect windowFrame	 = [[Beintoo getAppWindow] bounds];
    
    int notificationHeight;
    
    switch (notificationType) {
        case NOTIFICATION_TYPE_ACHIEV:
            notificationHeight = NOTIFICATION_HEIGHT_ACHIEV;
            break;

        default:
            break;
    }
    		
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
		self.center = CGPointMake(windowFrame.size.width-(notificationHeight/2.f), windowFrame.size.height/2.f) ;
		
		transitionEnterSubtype = kCATransitionFromRight;
		transitionExitSubtype  = kCATransitionFromLeft;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
		self.center = CGPointMake((notificationHeight/2), windowFrame.size.height/2) ;
		transitionEnterSubtype = kCATransitionFromLeft;
		transitionExitSubtype  = kCATransitionFromRight;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;	
		self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(notificationHeight/2.f));
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	
	if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;	
		self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(notificationHeight/2.f));
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	
	switch (notificationType) {
		case NOTIFICATION_TYPE_ACHIEV:
			[self drawAchievement];
			break;

		default:
			break;
	}	
}

- (void)removeViews
{
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)closeAchievement
{
	self.alpha = 0;
	[self removeFromSuperview];
}

#pragma mark -
#pragma mark Achievement

- (void)setNotificationContentForAchievement:(NSDictionary *)_theAchievement WithWindowSize:(CGSize)windowSize
{	
	current_element = _theAchievement;
	notificationType = NOTIFICATION_TYPE_ACHIEV;

	CGSize callerFrameSize = windowSize;
	
	self.frame = CGRectZero;
	CGRect notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_ACHIEV, callerFrameSize.width, NOTIFICATION_HEIGHT_ACHIEV);
	[self setFrame:notification_frame];
	
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8];
	//self.layer.cornerRadius = 2;
	//self.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
	//self.layer.borderWidth = 1;
	
	[self prepareNotificationOrientation:notification_frame];
}


- (void)drawAchievement
{
	[self removeViews];
	
	NSString *msg = NSLocalizedStringFromTable(@"unlockAchievMsg",@"BeintooLocalizable",@"");
	NSString *achievementName = [current_element objectForKey:@"name"];
	
	captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 5, [self bounds].size.width-50, 25)];
	captionLabel.backgroundColor = [UIColor clearColor];
	captionLabel.textColor = [UIColor whiteColor];
	captionLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:17];
    captionLabel.text = achievementName;
	[self addSubview:captionLabel];
	
	achievNameLabel	= [[UILabel alloc] initWithFrame:CGRectMake(11, 28, [self bounds].size.width-50, 20)];
	achievNameLabel.backgroundColor = [UIColor clearColor];
	achievNameLabel.textColor = [UIColor whiteColor];
	achievNameLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    achievNameLabel.text = msg;	
	[self addSubview:achievNameLabel];
    
    percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake([self bounds].size.width-55, 5, 50, 25)];
	percentageLabel.backgroundColor = [UIColor clearColor];
	percentageLabel.textColor = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
	percentageLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:17];
    percentageLabel.text = @"100%";
	[self addSubview:percentageLabel];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    captionLabel.textAlignment = NSTextAlignmentLeft;
    achievNameLabel.textAlignment = NSTextAlignmentLeft;
    percentageLabel.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        captionLabel.textAlignment = NSTextAlignmentLeft;
        achievNameLabel.textAlignment = NSTextAlignmentLeft;
        percentageLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        captionLabel.textAlignment = UITextAlignmentLeft;
        achievNameLabel.textAlignment = UITextAlignmentLeft;
        percentageLabel.textAlignment = UITextAlignmentLeft;
    }
#else
    captionLabel.textAlignment = UITextAlignmentLeft;
    achievNameLabel.textAlignment = UITextAlignmentLeft;
    percentageLabel.textAlignment = UITextAlignmentLeft;
#endif
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [captionLabel release];
	[beintooLogo release];
	[achievNameLabel release];
    [percentageLabel release];
#endif
	
}	

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [current_element release];
    [super dealloc];

#endif

}

@end
