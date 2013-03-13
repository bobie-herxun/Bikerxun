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

//  Adapted from the MTPopupWindow code by Marin Todorov on 7/1/11.

#import "BPopup.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BGradientView.h"
#import "BScrollView.h"
#import "BButton.h"
#import "BeintooGraphic.h"

#define kShadeViewTag 1000

@interface BPopup(Private)
- (id)initWithSuperview:(UIView*)sview andFile:(NSString*)fName;
@end

@implementation BPopup

#pragma mark -
#pragma mark Achievement popup

/**
 * ---------------------- POPUP FOR AN ACHIEVEMENT DETAIL --------------------
 * @param NSDictionary* _achievementInfo provide a dictionary with the info about the achievement to load, or a URL to load a web page
 * @param UIView* view provide a UIViewController's view here
 */

/*+ (void)showPopupForAchievement:(NSDictionary *)_achievementInfo insideView:(UIView *)view
{
    [[BPopup alloc] initWithSuperview:view andAchievement:_achievementInfo];
}*/

// ---- ACHIEVEMENT INIT
- (id)initWithSuperview:(UIView *)sview andAchievement:(NSDictionary *)_achievement
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
#ifdef BEINTOO_ARC_AVAILABLE
        bgView = [[UIView alloc] initWithFrame: sview.bounds];
#else
        bgView = [[[UIView alloc] initWithFrame: sview.bounds] autorelease];
#endif
        
        [sview addSubview: bgView];
		
		achievementOpenAppURL = [[NSString alloc] init];
        
        // proceed with animation after the bgView was added
        
        [self performSelector:@selector(doTransitionForAchievementWithContentFile:) withObject:_achievement afterDelay:0.1];
    }
    
    return self;
}

/**
 * Afrer the window background is added to the UI the window can animate in
 * and load the UIWebView
 */

- (void)doTransitionForAchievementWithContentFile:(NSDictionary *)_achievement
{
	NSArray *blockedByList	= [_achievement objectForKey:@"blockedBy"];
	BOOL isBlockedByOthers = FALSE;
	if (blockedByList != nil) {
		isBlockedByOthers = TRUE;
	}

    float viewHeight = [bgView bounds].size.height;
    float viewWidth = [bgView bounds].size.width;

#ifdef BEINTOO_ARC_AVAILABLE
    bigPanelView = [[BScrollView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width-(viewWidth*0.1), bgView.frame.size.height-(viewHeight*0.4))];
#else
    bigPanelView = [[[BScrollView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width-(viewWidth*0.1), bgView.frame.size.height-(viewHeight*0.4))] autorelease];
#endif
	
	[bigPanelView setGradientType:GRADIENT_BODY];
	bigPanelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	bigPanelView.alpha  = 1;
    bigPanelView.center = CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height/2);
	bigPanelView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
	
	// Scroll view content size , based on the list of blockedby achievements
	if (isBlockedByOthers) {
		int moreSpaceForBlockedAchievements = 50*[blockedByList count];
		bigPanelView.contentSize = CGSizeMake(bigPanelView.bounds.size.width, 200+moreSpaceForBlockedAchievements);
	}else {
	}
	
	[[bigPanelView layer] setBorderColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1].CGColor];
	[[bigPanelView layer] setBorderWidth:1.0f];
	[[bigPanelView layer] setCornerRadius:3.0f];
	
	// -------------------- ACHIEVEMENT DETAILS SUBVIEW --------------------------------------
    
	UIImage *cellImage  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_achievement objectForKey:@"imageURL"]]]];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 55, 55)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.backgroundColor = [UIColor clearColor];
	[imageView setImage:cellImage];
	
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, [bigPanelView bounds].size.width-80, 40)];
	textLabel.text = [_achievement objectForKey:@"name"];
	textLabel.font = [UIFont systemFontOfSize:15];
	textLabel.backgroundColor  = [UIColor clearColor];
	textLabel.numberOfLines	   = 3;
	textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 70, [bigPanelView bounds].size.width-60, 40)];
	detailTextLabel.text = [_achievement objectForKey:@"description"];
	detailTextLabel.font = [UIFont systemFontOfSize:14];
	detailTextLabel.numberOfLines	 = 2;
	detailTextLabel.textColor		 = [UIColor colorWithWhite:0 alpha:0.7];
	detailTextLabel.backgroundColor  = [UIColor clearColor];
	detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UILabel *blockedByText = [[UILabel alloc] initWithFrame:CGRectMake(18, 110, [bigPanelView bounds].size.width-60, 40)];
	blockedByText.text = NSLocalizedStringFromTable(@"blockedby",@"BeintooLocalizable",@"");
	blockedByText.font = [UIFont systemFontOfSize:12];
	blockedByText.numberOfLines	   = 1;
	blockedByText.backgroundColor  = [UIColor clearColor];
	blockedByText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
	[bigPanelView addSubview:textLabel];
	[bigPanelView addSubview:detailTextLabel];
	[bigPanelView addSubview:imageView];

	if (isBlockedByOthers) {
		[bigPanelView addSubview:blockedByText];
	}

	for (int i = 0; i < [blockedByList count]; i++) {
		NSDictionary *blockingAchievement = [blockedByList objectAtIndex:i];

		NSDictionary *otherAppAchievement = [blockingAchievement objectForKey:@"app"];
		BOOL isOnOtherApp = FALSE;
		if (otherAppAchievement != nil) {
			isOnOtherApp = TRUE;
		}
		
		int offset = i+1;
		
		UIImage *cellImage  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[blockingAchievement objectForKey:@"imageURL"]]]];
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 100+(offset*53), 45, 45)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.backgroundColor = [UIColor clearColor];
		[imageView setImage:cellImage];
		
		UILabel *achievemName = [[UILabel alloc] initWithFrame:CGRectMake(68, 97+(offset*53), [bigPanelView bounds].size.width-100, 40)];
		achievemName.text = [blockingAchievement objectForKey:@"name"];
		achievemName.font = [UIFont systemFontOfSize:12];
		achievemName.numberOfLines	   = 1;
		achievemName.backgroundColor  = [UIColor clearColor];
		achievemName.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		UILabel *onApp = [[UILabel alloc] initWithFrame:CGRectMake(68, 97+(offset*53)+30, 60, 20)];
		onApp.text = [NSString stringWithFormat:@"On app:"];
		onApp.font = [UIFont systemFontOfSize:12];
		onApp.numberOfLines	   = 1;
		onApp.backgroundColor  = [UIColor clearColor];
		onApp.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		float pixelsForAppName = [BeintooGraphic getPixelsForString:[otherAppAchievement objectForKey:@"name"] andFontSize:13];
		
		// NO URL - NO BUTTON
		UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(115, 97+(offset*53)+31, pixelsForAppName+4, 16)];
		appName.text = [otherAppAchievement objectForKey:@"name"];
		appName.font = [UIFont systemFontOfSize:12];
		appName.numberOfLines	 = 1;
		appName.backgroundColor  = [UIColor clearColor];
		appName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		// We have IOS URL -> so we have a Button to open the link
		BButton *openAppButton = [[BButton alloc] initWithFrame:CGRectMake(115, 97+(offset*53)+31, pixelsForAppName+20, 19)];
		[openAppButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
		[openAppButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
		[openAppButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
		[openAppButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
		[openAppButton setTitle:[otherAppAchievement objectForKey:@"name"] forState:UIControlStateNormal];
		[openAppButton addTarget:self action:@selector(openAppURL) forControlEvents:UIControlEventTouchUpInside];
		[openAppButton setButtonTextSize:13];

		// We set the URL to be opened
        
#ifdef BEINTOO_ARC_AVAILABLE
        achievementOpenAppURL = [[otherAppAchievement objectForKey:@"download_url"] objectForKey:@"IOS"];
#else
        achievementOpenAppURL = [[[otherAppAchievement objectForKey:@"download_url"] objectForKey:@"IOS"] retain];
#endif
        
		if (achievementOpenAppURL == nil) {
            
#ifdef BEINTOO_ARC_AVAILABLE
            achievementOpenAppURL = [[otherAppAchievement objectForKey:@"download_url"] objectForKey:@"WEB"];
#else
            achievementOpenAppURL = [[[otherAppAchievement objectForKey:@"download_url"] objectForKey:@"WEB"] retain];
#endif
			
		}
		
		[bigPanelView addSubview:imageView];
		[bigPanelView addSubview:achievemName];
		if (isOnOtherApp) {
			if (achievementOpenAppURL!=nil) {
				[bigPanelView addSubview:openAppButton];
			}else {
				[bigPanelView addSubview:appName];
			}
			[bigPanelView addSubview:onApp];
		}
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [imageView release];
		[achievemName release];
		[onApp release];
		[openAppButton release];
#endif
		
	}
	
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [textLabel release];
	[detailTextLabel release];
	[imageView release];
	[blockedByText release];
#endif
    
	// -----------------------------------------------------------------------------

	// Close Button
    int closeBtnOffset = 30;
    UIImage* closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setImage:closeBtnImg forState:UIControlStateHighlighted];
    [closeBtn setImage:closeBtnImg forState:UIControlStateSelected];
    [closeBtn setFrame:CGRectMake(bigPanelView.frame.size.width - closeBtnOffset - 5, 10, closeBtnImg.size.width, closeBtnImg.size.height)];
	
    [closeBtn addTarget:self action:@selector(closePopupWindow) forControlEvents:UIControlEventTouchUpInside];
    [bigPanelView addSubview: closeBtn];
	
	[bgView addSubview:bigPanelView];
	
	CATransition *popupEnterAnimation = [CATransition animation];
	[popupEnterAnimation setDuration:0.3f];
	[popupEnterAnimation setValue:@"enterAnimation" forKey:@"name"];
	popupEnterAnimation.removedOnCompletion = YES;
	[popupEnterAnimation setType:kCATransitionFade];
	popupEnterAnimation.delegate = self;
	[popupEnterAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[bgView layer] addAnimation:popupEnterAnimation forKey:nil];
}

- (void)openAppURL
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:achievementOpenAppURL]];
}

/**
 * Removes the window background and calls the animation of the window
 */

- (void)closePopupWindow
{
    bgView.alpha = 0;
	CATransition *popupExitAnimation = [CATransition animation];
	[popupExitAnimation setDuration:0.05f];
	[popupExitAnimation setValue:@"exitAnimation" forKey:@"name"];
	popupExitAnimation.removedOnCompletion = YES;
	[popupExitAnimation setType:kCATransitionFade];
	popupExitAnimation.delegate = self;
	[popupExitAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[bgView layer] addAnimation:popupExitAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
	if ([[animation valueForKey:@"name"] isEqualToString:@"exitAnimation"]) {
		
		for (UIView* child in bigPanelView.subviews) {
			[child removeFromSuperview];
		}
		for (UIView* child in bgView.subviews) {
			[child removeFromSuperview];
		}
		[bgView removeFromSuperview];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [self release];
#endif
		
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[achievementOpenAppURL release];
	[super dealloc];
}
#endif

@end