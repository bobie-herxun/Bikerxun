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

#import "BMessageAnimated.h"
#import "Beintoo.h"
#import <QuartzCore/QuartzCore.h>

@implementation BMessageAnimated
@synthesize delegate;

- (id)init
{
	if (self = [super init])
	{
       
    }
    return self;
}

- (void)showNotification
{    
    if ([[self delegate] respondsToSelector:@selector(messageDidAppear)])
        [[self delegate] messageDidAppear];
	
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationOrientationChanged object:nil];
    
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
        case NOTIFICATION_TYPE_PLOGIN:
            notificationTimeOnScreen = NOTIFICATION_PLOGIN_SECONDS;
			break;
		case NOTIFICATION_TYPE_SSCORE:
            notificationTimeOnScreen = NOTIFICATION_SSCORE_SECONDS;
			break;
        case NOTIFICATION_TYPE_GIVE_BEDOLLARS:
            notificationTimeOnScreen = NOTIFICATION_GIVE_BEDOLLARS_SECONDS;
			break;
        case NOTIFICATION_TYPE_NTDISPATCH:
            notificationTimeOnScreen = NOTIFICATION_NTODISP_SECONDS; 
            break;
        case NOTIFICATION_TYPE_ACHIEV_MSN:
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
        
        if ([[self delegate] respondsToSelector:@selector(messageDidDisappear)])
            [[self delegate] messageDidDisappear];
		
		[self removeFromSuperview];
		notificationCurrentlyOnScreen = NO;
	}
}

- (void)prepareNotificationOrientation:(CGRect)startingFrame
{    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:BeintooNotificationOrientationChanged object:nil];
    
	self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	CGRect windowFrame	 = [[Beintoo getAppWindow] bounds];
    
    int notificationHeight;
    
    int kind = 0;
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"submitScoreCount"];
    
    if ([Beintoo isUserLogged]){
        for (NSString *elem in [Beintoo getFeatureList]){
            if ([elem isEqualToString:@"Marketplace"]){
                if (i >= [[[Beintoo getPlayer] objectForKey:@"minSubmitPerMarketplace"] intValue]){
                    kind = 1;
                    break;
                }
            }
        }
    }
    
    switch (notificationType) {
        case NOTIFICATION_TYPE_PLOGIN:
            notificationHeight = NOTIFICATION_HEIGHT_PLOGIN;
            break;
        case NOTIFICATION_TYPE_ACHIEV:
            notificationHeight = NOTIFICATION_HEIGHT_ACHIEV;
            break;
        case NOTIFICATION_TYPE_SSCORE:
            if (kind == 1 && ![BeintooDevice isiPad])
                notificationHeight = NOTIFICATION_HEIGHT_SSCORE + 18;
            else 
                notificationHeight = NOTIFICATION_HEIGHT_SSCORE;
            break;
        case NOTIFICATION_TYPE_GIVE_BEDOLLARS:
            notificationHeight = NOTIFICATION_HEIGHT_PLOGIN;
            break;
        case NOTIFICATION_TYPE_NTDISPATCH:
            notificationHeight = NOTIFICATION_HEIGHT_NTDISP;
            break;
        case NOTIFICATION_TYPE_ACHIEV_MSN:
            notificationHeight = NOTIFICATION_HEIGHT_ACHIEV_MSN;
            break;

        default:
            break;
    }
    
    int appOrientation = [Beintoo appOrientation];
    
    int offset = 0;
    if ([Beintoo isStatusBarHiddenOnApp] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO)
        offset = 20;
    
	if (appOrientation == UIInterfaceOrientationLandscapeLeft) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width-(notificationHeight/2.f), windowFrame.size.height/2.f) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake((notificationHeight/2.f) + offset, windowFrame.size.height/2.f) ;
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
    }
	else if (appOrientation == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake((notificationHeight/2), windowFrame.size.height/2) ;
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width-(notificationHeight/2.f) - offset, windowFrame.size.height/2) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }

	}
	else if (appOrientation == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;	
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(notificationHeight/2.f));
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width/2, (notificationHeight/2.f) + offset);
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
	}
	
	else if (appOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		self.frame = startingFrame;	
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width/2, (notificationHeight/2.f));
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(notificationHeight/2.f) - offset);
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
	}
    
    switch (notificationType) {
		case NOTIFICATION_TYPE_ACHIEV:
			[self drawAchievement];
			break;
		case NOTIFICATION_TYPE_SSCORE:
			[self drawSubmitScore];
			break;
        case NOTIFICATION_TYPE_NTDISPATCH:
            [self drawNothingToDispatch];
            break;
        case NOTIFICATION_TYPE_ACHIEV_MSN:
            [self drawAchievementWithMission];
            break;
        case NOTIFICATION_TYPE_PLOGIN:
            [self drawPlayerLogin];
            break;
        case NOTIFICATION_TYPE_GIVE_BEDOLLARS:
            [self drawGiveBedollars];
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
    
#ifdef BEINTOO_ARC_AVAILABLE
    current_achievement = _theAchievement;
#else
    current_achievement = [_theAchievement retain];
#endif
	
    notificationType = NOTIFICATION_TYPE_ACHIEV;

	CGSize callerFrameSize = windowSize;
	
	self.frame = CGRectZero;
	CGRect notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_ACHIEV, callerFrameSize.width, NOTIFICATION_HEIGHT_ACHIEV);
	[self setFrame:notification_frame];
	
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8];
	
    [self prepareNotificationOrientation:notification_frame];
}

- (void)setNotificationContentForAchievement:(NSDictionary *)_theAchievement andMissionAchievement:(NSDictionary *)_missionAchievem WithWindowSize:(CGSize)windowSize
{
    
#ifdef BEINTOO_ARC_AVAILABLE
    current_achievement             = _theAchievement;
    achievement_to_complete_mission = _missionAchievem;
#else
    current_achievement             = [_theAchievement retain];
    achievement_to_complete_mission = [_missionAchievem retain];
#endif
    
    notificationType = NOTIFICATION_TYPE_ACHIEV_MSN;
    
	CGSize callerFrameSize = windowSize;
	
	self.frame = CGRectZero;
	CGRect notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_ACHIEV_MSN, callerFrameSize.width, NOTIFICATION_HEIGHT_ACHIEV_MSN);
	[self setFrame:notification_frame];
	
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8];
	
    [self prepareNotificationOrientation:notification_frame];
}

- (void)drawAchievement
{
	[self removeViews];
	
	NSString *msg = NSLocalizedStringFromTable(@"unlockAchievMsg",@"BeintooLocalizable",@"");
	NSString *achievementName = [current_achievement objectForKey:@"name"];
	
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

- (void)drawAchievementWithMission
{
    NSString *achievementName = [current_achievement objectForKey:@"name"];
    NSString *msg             = NSLocalizedStringFromTable(@"unlockAchievMsg",@"BeintooLocalizable",@"");
    NSString *missionText     = NSLocalizedStringFromTable(@"missiontoachieve", @"BeintooLocalizable", @"");
    missionText = [missionText stringByAppendingString:
                   [[[achievement_to_complete_mission objectForKey:@"achievement"] objectForKey:@"app"] objectForKey:@"name"]];
	
	captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 5, [self bounds].size.width-50, 25)];
	captionLabel.backgroundColor = [UIColor clearColor];
	captionLabel.textColor = [UIColor whiteColor];
	captionLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:17];
    captionLabel.text = achievementName;
	[self addSubview:captionLabel];
	
	achievNameLabel	= [[UILabel alloc] initWithFrame:CGRectMake(11, 28, [self bounds].size.width-30, 20)];
	achievNameLabel.backgroundColor = [UIColor clearColor];
	achievNameLabel.textColor = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
	achievNameLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    achievNameLabel.text = msg;	
	[self addSubview:achievNameLabel];
    
    percentageLabel                 = [[UILabel alloc] initWithFrame:CGRectMake([self bounds].size.width-55, 5, 50, 25)];
	percentageLabel.backgroundColor = [UIColor clearColor];
	percentageLabel.textColor       = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
	percentageLabel.font            = [UIFont fontWithName:@"MarkerFelt-Wide" size:17];
    percentageLabel.text            = @"100%";
	[self addSubview:percentageLabel];
    
    missionLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(11, 48, [self bounds].size.width-20, 40)];
	missionLabel.backgroundColor    = [UIColor clearColor];
	missionLabel.textColor          = [UIColor whiteColor];
    missionLabel.numberOfLines      = 2;
	missionLabel.font               = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    missionLabel.text               = missionText;	
    missionLabel.adjustsFontSizeToFitWidth = YES;
	[self addSubview:missionLabel];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    captionLabel.textAlignment = NSTextAlignmentLeft;
    achievNameLabel.textAlignment = NSTextAlignmentLeft;
    percentageLabel.textAlignment = NSTextAlignmentLeft;
    missionLabel.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        captionLabel.textAlignment = NSTextAlignmentLeft;
        achievNameLabel.textAlignment = NSTextAlignmentLeft;
        percentageLabel.textAlignment = NSTextAlignmentLeft;
        missionLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        captionLabel.textAlignment = UITextAlignmentLeft;
        achievNameLabel.textAlignment = UITextAlignmentLeft;
        percentageLabel.textAlignment = UITextAlignmentLeft;
        missionLabel.textAlignment = UITextAlignmentLeft;
    }
#else
    captionLabel.textAlignment = UITextAlignmentLeft;
    achievNameLabel.textAlignment = UITextAlignmentLeft;
    percentageLabel.textAlignment = UITextAlignmentLeft;
    missionLabel.textAlignment = UITextAlignmentLeft;
#endif
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [captionLabel release];
	[beintooLogo release];
	[achievNameLabel release];
    [percentageLabel release];
#endif
	
}


#pragma mark -
#pragma mark Submit_Score & Login

- (void)setNotificationContentForPlayerLogin:(NSDictionary *)_theScore WithWindowSize:(CGSize)windowSize
{
    notificationType = NOTIFICATION_TYPE_PLOGIN;
    
	CGSize callerFrameSize = windowSize;
	
	self.frame = CGRectZero;
	CGRect notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_PLOGIN, callerFrameSize.width, NOTIFICATION_HEIGHT_PLOGIN);
	[self setFrame:notification_frame];
    
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8];
	self.layer.cornerRadius = 2;
	self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
	self.layer.borderWidth = 1;
	
	[self prepareNotificationOrientation:notification_frame];
}

- (void)setNotificationContentForSubmitScore:(NSDictionary *)_theScore WithWindowSize:(CGSize)windowSize
{	
	notificationType = NOTIFICATION_TYPE_SSCORE;

	CGSize callerFrameSize = windowSize;
	
    int kind = 0;
    
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"submitScoreCount"];
    
    if ([Beintoo isUserLogged]){
        for (NSString *elem in [Beintoo getFeatureList]){
            if ([elem isEqualToString:@"Marketplace"]){
                if (i >= [[[Beintoo getPlayer] objectForKey:@"minSubmitPerMarketplace"] intValue]){
                    kind = 1;
                    break;
                }
            }
        }
    }
    
	self.frame = CGRectZero;
    CGRect notification_frame;
    
    //----> Check if submit score count overlaps threshold of Marketplace SubmitScore Message
    //----> If YES, let's show Marketplace SubmitScore Message with increased HEIGHT
    
    if (kind == 1 && ![BeintooDevice isiPad]){
        notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_SSCORE, callerFrameSize.width, NOTIFICATION_HEIGHT_SSCORE + 18);
    }
    else {
        notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_SSCORE, callerFrameSize.width, NOTIFICATION_HEIGHT_SSCORE);
    }
    
	[self setFrame:notification_frame];
	    
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8];
	self.layer.cornerRadius = 2;
	self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
	self.layer.borderWidth = 1;
	
	[self prepareNotificationOrientation:notification_frame];
}

- (void)setNotificationContentForGiveBedollars:(NSDictionary *)_theScore WithWindowSize:(CGSize)windowSize
{	
	notificationType = NOTIFICATION_TYPE_GIVE_BEDOLLARS;
    
	CGSize callerFrameSize = windowSize;
	
    self.frame = CGRectZero;
    CGRect notification_frame;
    
    notification_frame = CGRectMake(0, callerFrameSize.height - NOTIFICATION_HEIGHT_GIVE_BEDOLLARS, callerFrameSize.width, NOTIFICATION_HEIGHT_GIVE_BEDOLLARS);
    
	[self setFrame:notification_frame];
    
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8];
	self.layer.cornerRadius = 2;
	self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
	self.layer.borderWidth = 1;
	
	[self prepareNotificationOrientation:notification_frame];
}

- (void)drawPlayerLogin
{
    [self removeViews];
	
	NSString *loggedUser = [[Beintoo getUserIfLogged] objectForKey:@"nickname"];
	NSString *msg = [NSString stringWithFormat:NSLocalizedStringFromTable(@"playerLoginMsg",@"BeintooLocalizable",@""),loggedUser];
	
	beintooLogo		= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];	
	[beintooLogo setImage:[UIImage imageNamed:@"beintoo_icon.png"]];
	[self addSubview:beintooLogo];
	
	captionLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, [self bounds].size.width-50, 40)];
	captionLabel.backgroundColor    = [UIColor clearColor];
	captionLabel.textColor          = [UIColor whiteColor];
	captionLabel.font               = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    captionLabel.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        captionLabel.textAlignment = NSTextAlignmentLeft;
    else
         captionLabel.textAlignment = UITextAlignmentLeft;
#else
     captionLabel.textAlignment = UITextAlignmentLeft;
#endif
    
    captionLabel.text               = msg;
	[self addSubview:captionLabel];
    
    int unreadNotifications         = [[[Beintoo getPlayer] objectForKey:@"unreadNotification"] intValue];
    if (unreadNotifications > 0) {
        
        captionLabel.frame                          = CGRectMake(45, -5, [self bounds].size.width-50, 40);
        UILabel *unreadNotificationLabel           = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, self.bounds.size.width - 50, 15)];
        unreadNotificationLabel.backgroundColor    = [UIColor clearColor];
        unreadNotificationLabel.textColor          = [UIColor whiteColor];
        unreadNotificationLabel.font               = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        unreadNotificationLabel.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            unreadNotificationLabel.textAlignment = NSTextAlignmentLeft;
        else
            unreadNotificationLabel.textAlignment = UITextAlignmentLeft;
#else
        unreadNotificationLabel.textAlignment = UITextAlignmentLeft;
#endif
        
        if(unreadNotifications == 1){
            unreadNotificationLabel.text        = [NSString stringWithFormat:NSLocalizedStringFromTable(@"messagenotification",@"BeintooLocalizable",@"Try beintoo"),1];								   
        }
        else if(unreadNotifications > 1){
            unreadNotificationLabel.text        = [NSString stringWithFormat:NSLocalizedStringFromTable(@"messagenotificationp",@"BeintooLocalizable",@"Try beintoo"),unreadNotifications];								   
        }
        
        [self addSubview:unreadNotificationLabel];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [unreadNotificationLabel release];
#endif
        
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [captionLabel release];
	[beintooLogo release];
#endif
	
}

- (void)drawSubmitScore
{
	[self removeViews];
	
	NSString *lastSubmittedScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSubmittedScore"];
    
    int kind = 0;
    
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"submitScoreCount"];
    
    if ([Beintoo isUserLogged]){
        for (NSString *elem in [Beintoo getFeatureList]){
            if ([elem isEqualToString:@"Marketplace"]){
                if (i >= [[[Beintoo getPlayer] objectForKey:@"minSubmitPerMarketplace"] intValue]){
                    kind = 1;
                    break;
                }
            }
        }
    }
    
    NSString *msg;
    
    beintooLogo		= [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 24, 24)];	
	[beintooLogo setImage:[UIImage imageNamed:@"beintoo_icon.png"]];
	
	captionLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, [self bounds].size.width-50, 20)];
	captionLabel.backgroundColor    = [UIColor clearColor];
	captionLabel.textColor          = [UIColor whiteColor];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    captionLabel.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        captionLabel.textAlignment = NSTextAlignmentLeft;
    else
        captionLabel.textAlignment = UITextAlignmentLeft;
#else
    captionLabel.textAlignment = UITextAlignmentLeft;
#endif
    
    captionLabel.font               = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0];
    captionLabel.adjustsFontSizeToFitWidth = YES;
    
    if (kind == 0) {
        if ([lastSubmittedScore floatValue] == 1)
            msg = [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsgSinglePoint",@"BeintooLocalizable",@""),lastSubmittedScore];
        else 
            msg = [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsg",@"BeintooLocalizable",@""),lastSubmittedScore];
        
        [[NSUserDefaults standardUserDefaults] setInteger:i + 1 forKey:@"submitScoreCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
	else {
        if ([Beintoo isVirtualCurrencyStored]){
            
            if ([lastSubmittedScore floatValue] == 1)
                msg = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsgSinglePoint",@"BeintooLocalizable",@""), lastSubmittedScore], [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMarketplaceMsg", @"BeintooLocalizable", nil), [Beintoo getVirtualCurrencyBalance], [Beintoo getVirtualCurrencyName]]];
            else 
                msg = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsg",@"BeintooLocalizable",@""),lastSubmittedScore], [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMarketplaceMsg", @"BeintooLocalizable", nil), [Beintoo getVirtualCurrencyBalance], [Beintoo getVirtualCurrencyName]]];
            
            CGSize expectedSize;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
            expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:NSLineBreakByWordWrapping];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:NSLineBreakByWordWrapping];
            else
                expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:UILineBreakModeWordWrap];
#else
            expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:UILineBreakModeWordWrap];
#endif
            
            captionLabel.frame              = CGRectMake(45, 2, [self bounds].size.width-50, expectedSize.height);
            captionLabel.numberOfLines      = 0;
            captionLabel.font               = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0];
            
        }
        else {
            if (![Beintoo isUserLogged]){
                
                if ([lastSubmittedScore floatValue] == 1)
                    msg = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsgSinglePoint",@"BeintooLocalizable",@""),lastSubmittedScore], NSLocalizedStringFromTable(@"submitScoreMarketplacePlayer", @"BeintooLocalizable", nil)];
                else 
                    msg = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsg",@"BeintooLocalizable",@""),lastSubmittedScore], NSLocalizedStringFromTable(@"submitScoreMarketplacePlayer", @"BeintooLocalizable", nil)];
                
                CGSize expectedSize;
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                expectedSize = [msg sizeWithFont:captionLabel.font constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:NSLineBreakByWordWrapping];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    expectedSize = [msg sizeWithFont:captionLabel.font constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:NSLineBreakByWordWrapping];
                else
                    expectedSize = [msg sizeWithFont:captionLabel.font constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:UILineBreakModeWordWrap];
#else
                expectedSize = [msg sizeWithFont:captionLabel.font constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:UILineBreakModeWordWrap];
#endif
                
                captionLabel.frame          = CGRectMake(45, 3, [self bounds].size.width-50, expectedSize.height);
                captionLabel.numberOfLines  = 0;
            }
            else {
                if ([lastSubmittedScore floatValue] == 1)
                    msg = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsgSinglePoint",@"BeintooLocalizable",@""),lastSubmittedScore], [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMarketplaceMsg", @"BeintooLocalizable", nil), [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue], NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)]];
                else 
                    msg = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMsg",@"BeintooLocalizable",@""),lastSubmittedScore], [NSString stringWithFormat:NSLocalizedStringFromTable(@"submitScoreMarketplaceMsg", @"BeintooLocalizable", nil), [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue], NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)]];
                
                CGSize expectedSize;
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:NSLineBreakByWordWrapping];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:NSLineBreakByWordWrapping];
                else
                    expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:UILineBreakModeWordWrap];
#else
                expectedSize = [msg sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0] constrainedToSize:CGSizeMake([self bounds].size.width-50, 60) lineBreakMode:UILineBreakModeWordWrap];
#endif
                
                captionLabel.frame          = CGRectMake(45, 2, [self bounds].size.width-50, expectedSize.height);
                captionLabel.numberOfLines  = 0;
                captionLabel.font           = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0];
            }
        }
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"submitScoreCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    captionLabel.text   = msg;
    
    [self addSubview:captionLabel];
    [self addSubview:beintooLogo];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [captionLabel release];
	[beintooLogo release];
#endif
	
}

- (void)drawGiveBedollars
{
	[self removeViews];
	
	NSString *msg;
    
    beintooLogo		= [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 24, 24)];	
	[beintooLogo setImage:[UIImage imageNamed:@"beintoo_icon.png"]];
	
    float bedollarsAmount = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastGiveBedollarsAmount"];
    int bedollarsIntAmount = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastGiveBedollarsAmount"];
    
    float quot = bedollarsAmount - bedollarsIntAmount;
    if (quot == 0){
        if (bedollarsAmount == 1)
            msg = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"giveBedollarMsg",@"BeintooLocalizable", nil), bedollarsIntAmount]];
        else 
            msg = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"giveBedollarsMsg",@"BeintooLocalizable", nil), bedollarsIntAmount]];
    }
    else {
        if (bedollarsAmount == 1)
            msg = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"giveBedollarFloatMsg",@"BeintooLocalizable", nil), bedollarsAmount]];
        else 
            msg = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:NSLocalizedStringFromTable(@"giveBedollarsFloatMsg",@"BeintooLocalizable", nil), bedollarsAmount]];
    }
    
    captionLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, [self bounds].size.width - 55, NOTIFICATION_HEIGHT_GIVE_BEDOLLARS)];
	captionLabel.backgroundColor    = [UIColor clearColor];
	captionLabel.textColor          = [UIColor whiteColor];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    captionLabel.textAlignment       = NSTextAlignmentLeft;
    captionLabel.minimumScaleFactor = 2.0;

#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        captionLabel.textAlignment       = NSTextAlignmentLeft;
        captionLabel.minimumScaleFactor = 2.0;

    }
    else
    {
        captionLabel.textAlignment       = UITextAlignmentLeft;
        captionLabel.minimumFontSize = 10.0;
    }
#else
    captionLabel.textAlignment       = UITextAlignmentLeft;
    captionLabel.minimumFontSize = 10.0;
#endif
    
    captionLabel.font               = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0];
    captionLabel.adjustsFontSizeToFitWidth = YES;
    captionLabel.numberOfLines = 0;
    
	captionLabel.text               = msg;
    
    [self addSubview:captionLabel];
    [self addSubview:beintooLogo];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [captionLabel release];
	[beintooLogo release];
#endif
    
}

#pragma mark -
#pragma mark Nothing To Dispatch

- (void)setNotificationContentForNothingToDispatchWithWindowSize:(CGSize)windowSize
{
    notificationType = NOTIFICATION_TYPE_NTDISPATCH;
    
	CGSize callerFrameSize = windowSize;
	
	self.frame = CGRectZero;
	CGRect notification_frame = CGRectMake(0, callerFrameSize.height-NOTIFICATION_HEIGHT_NTDISP, callerFrameSize.width, NOTIFICATION_HEIGHT_NTDISP);
	[self setFrame:notification_frame];
	
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8  ];
	self.layer.cornerRadius = 2;
	self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
	self.layer.borderWidth = 1;
	
	[self prepareNotificationOrientation:notification_frame];
}

- (void)drawNothingToDispatch
{
	[self removeViews];
	
	NSString *msg = NSLocalizedStringFromTable(@"nothingToDispatchMsg",@"BeintooLocalizable",@"");
	
	beintooLogo		= [[UIImageView alloc] initWithFrame:CGRectMake(7, 13, 24, 24)];	
	[beintooLogo setImage:[UIImage imageNamed:@"beintoo_icon.png"]];
	[self addSubview:beintooLogo];
	
	captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 3, [self bounds].size.width-50, 40)];
	captionLabel.backgroundColor = [UIColor clearColor];
	captionLabel.textColor = [UIColor whiteColor];
	captionLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    captionLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        captionLabel.textAlignment       = NSTextAlignmentLeft;
    else
        captionLabel.textAlignment       = UITextAlignmentLeft;
#else
    captionLabel.textAlignment       = UITextAlignmentLeft;
#endif
	
    captionLabel.numberOfLines = 2;
	captionLabel.text = msg;
	[self addSubview:captionLabel];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [captionLabel release];
	[beintooLogo release];
#endif
    
}

// --------------- OLD -------------------->

+ (NSString *)getMessageFromCode:(int)code
{
	if (code == WELCOME_MESSAGE) {
		NSString *playerNick = [[Beintoo getUserIfLogged] objectForKey:@"nickname"];
		if (playerNick!=nil) {
			return [NSString stringWithFormat:@"Welcome back %@",playerNick];
		}
		return @"NO_MESSAGE";

	}else if (code==SUBMIT_SCORE_MESSAGGE) {
		return [NSString stringWithFormat:@"You earned %@ point(s).",[[NSUserDefaults standardUserDefaults]objectForKey:@"lastSubmittedScore"]];
	}
	else if (code==NO_CONNECTION_MESSAGE){
		return @"No connection available.";
	}
	else if(code==BEINTOO_ERROR_MESSAGE){
		return @"An errorr occurred.";
	}
	else 
		return @"NO_MESSAGE";
}

- (void)orientationChanged
{    
    [UIView beginAnimations:nil context:nil];
    
    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	CGRect windowFrame	 = [[Beintoo getAppWindow] bounds];
    
    int notificationHeight;
    
    int kind = 0;
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"submitScoreCount"];
    
    if ([Beintoo isUserLogged]){
        for (NSString *elem in [Beintoo getFeatureList]){
            if ([elem isEqualToString:@"Marketplace"]){
                if (i >= [[[Beintoo getPlayer] objectForKey:@"minSubmitPerMarketplace"] intValue]){
                    kind = 1;
                    break;
                }
            }
        }
    }
    
    switch (notificationType) {
        case NOTIFICATION_TYPE_PLOGIN:
            notificationHeight = NOTIFICATION_HEIGHT_PLOGIN;
            break;
        case NOTIFICATION_TYPE_ACHIEV:
            notificationHeight = NOTIFICATION_HEIGHT_ACHIEV;
            break;
        case NOTIFICATION_TYPE_SSCORE:
            if (kind == 1 && ![BeintooDevice isiPad])
                notificationHeight = NOTIFICATION_HEIGHT_SSCORE + 18;
            else 
                notificationHeight = NOTIFICATION_HEIGHT_SSCORE;
            break;
        case NOTIFICATION_TYPE_GIVE_BEDOLLARS:
            notificationHeight = NOTIFICATION_HEIGHT_PLOGIN;
            break;
        case NOTIFICATION_TYPE_NTDISPATCH:
            notificationHeight = NOTIFICATION_HEIGHT_NTDISP;
            break;
        case NOTIFICATION_TYPE_ACHIEV_MSN:
            notificationHeight = NOTIFICATION_HEIGHT_ACHIEV_MSN;
            break;
            
        default:
            break;
    }
    
    int appOrientation = [Beintoo appOrientation];
    
    int offset = 0;
    if ([Beintoo isStatusBarHiddenOnApp] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO)
        offset = 20;
    
	if (appOrientation == UIInterfaceOrientationLandscapeLeft) {
		
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width-(notificationHeight/2.f), windowFrame.size.height/2.f) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake((notificationHeight/2.f) + offset, windowFrame.size.height/2.f) ;
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
    }
	else if (appOrientation == UIInterfaceOrientationLandscapeRight) {
		
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake((notificationHeight/2), windowFrame.size.height/2) ;
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width-(notificationHeight/2.f) - offset, windowFrame.size.height/2) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        
	}
	else if (appOrientation == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(notificationHeight/2.f));
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width/2, (notificationHeight/2.f) + offset);
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
	}
	else if (appOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width/2, (notificationHeight/2.f));
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(notificationHeight/2.f) - offset);
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
	}
    
    [UIView commitAnimations];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[current_achievement release];
    [achievement_to_complete_mission release];
    [super dealloc];
}
#endif

@end
