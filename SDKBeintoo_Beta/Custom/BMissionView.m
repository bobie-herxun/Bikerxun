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

#import "BMissionView.h"
#import <QuartzCore/QuartzCore.h>
#import "BButton.h"
#import "Beintoo.h"

@implementation BMissionView

@synthesize beintooLogo,prizeImg,prizeThumb,textLabel,detailedTextLabel,delegate,missionType;

- (id)init
{
	if (self = [super init]){
		
	}
    return self;
}

- (void)setMissionContentWithWindowSize:(CGSize)windowSize
{
	firstTouch = YES;
	
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7];
	self.layer.cornerRadius = 0;
	self.layer.borderColor  = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
	self.layer.borderWidth  = 0;
	
    BOOL isNew  = [[[Beintoo getLastRetrievedMission] objectForKey:@"isNew"] boolValue];
    missionType = isNew ? MISSION_TYPE_NEW : MISSION_TYPE_ONGOING;
    
    if ([[[Beintoo getLastRetrievedMission] objectForKey:@"status"] isEqualToString:@"OVER"]) {
        missionType = MISSION_TYPE_ACCOMPLISHED;
    }

	self.frame = CGRectZero;
	
	// Banner frame initialization: a vgood frame is a little bit smaller than a recommendation
	CGRect vgoodFrame = CGRectMake(0, 0, windowSize.width, windowSize.height);
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight ) {
        vgoodFrame = CGRectMake(0, 0, windowSize.height, windowSize.width);
    }
    	
	[self setFrame:vgoodFrame];
	[self prepareMissionAlertOrientation:vgoodFrame];
}

- (void)show
{	
	self.alpha = 0;
		
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.7f];
	[applicationLoadViewIn setValue:@"load" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	//applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	self.alpha = 1;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
	}
}

- (void)drawMission
{
    @try {
       
        NSDictionary *lastMission           = [Beintoo getLastRetrievedMission];
        NSArray *sponsoredAchievements      = [lastMission objectForKey:@"sponsoredAchievements"];
        NSArray *playerAchievements         = [lastMission objectForKey:@"playerAchievements"];
        
        int numberOfAchievementsToShow      = [sponsoredAchievements count] + [playerAchievements count];

        [self removeViews];
        //[self setThumbnail:lastVgood.vGoodImageData];	
            
        CGSize viewSize =  self.bounds.size;
        
        float labelsStartingXPoint = (2 * MISSION_NORMAL_PADDING) + ACHIEVEMENT_IMAGESIZE + 15;
        // -------------- Title Label 1
        float welcomeToLabelWidth  = viewSize.width * 0.75;
        UILabel *welcomeToLabel    = [[UILabel alloc] initWithFrame:CGRectMake(labelsStartingXPoint,
                                                                             5 + MISSION_NORMAL_PADDING, 
                                                                             welcomeToLabelWidth, 
                                                                             22)];
        welcomeToLabel.font                = [UIFont fontWithName:@"MarkerFelt-Thin" size:22];
        welcomeToLabel.adjustsFontSizeToFitWidth = YES;
        welcomeToLabel.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
        welcomeToLabel.backgroundColor     = [UIColor clearColor];
        welcomeToLabel.textColor           = [UIColor colorWithWhite:1 alpha:1];
        welcomeToLabel.text                = (missionType == MISSION_TYPE_NEW) ? NSLocalizedStringFromTable(@"missionwelcometo",@"BeintooLocalizable",@"") : NSLocalizedStringFromTable(@"missionstatusof",@"BeintooLocalizable",@"") ;
        
        // -------------- Title Label 2
        float missionOTWLabelWidth  = viewSize.width * 0.75;
        NSString *missionText       = (missionType ==  MISSION_TYPE_ACCOMPLISHED) ? NSLocalizedStringFromTable(@"missionaccomplished",@"BeintooLocalizable",@"") : NSLocalizedStringFromTable(@"missionoftheweek",@"BeintooLocalizable",@"");
        UILabel *missionOTWLabel    = [[UILabel alloc] initWithFrame:CGRectMake(labelsStartingXPoint,
                                                                            32 + MISSION_NORMAL_PADDING, 
                                                                            missionOTWLabelWidth, 
                                                                            25)];
        missionOTWLabel.font            = [UIFont fontWithName:@"MarkerFelt-Thin" size:24];
        missionOTWLabel.numberOfLines   = 1;
        missionOTWLabel.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
        missionOTWLabel.backgroundColor = [UIColor clearColor];
        missionOTWLabel.textColor       = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        missionOTWLabel.text            = missionText;
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        welcomeToLabel.textAlignment       = NSTextAlignmentLeft;
        missionOTWLabel.textAlignment      = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            welcomeToLabel.textAlignment       = NSTextAlignmentLeft;
            missionOTWLabel.textAlignment      = NSTextAlignmentLeft;
        }
        else
        {
            missionOTWLabel.textAlignment      = UITextAlignmentLeft;
            welcomeToLabel.textAlignment       = UITextAlignmentLeft;
        }
#else
        missionOTWLabel.textAlignment      = UITextAlignmentLeft;
        welcomeToLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        // --------------- Achievement subview
        float heightWhereMissionTitleEnds      = missionOTWLabel.frame.origin.y + missionOTWLabel.frame.size.height;
        float achievementViewHeight            = numberOfAchievementsToShow * MISSION_PIXELS_PER_ACHIEVEM;
        UIView *achievementSubview             = [[UIView alloc] initWithFrame:CGRectMake(MISSION_SUBVIEWS_PADDING,
                                                                                   heightWhereMissionTitleEnds + 5,
                                                                                   viewSize.width - (2*MISSION_SUBVIEWS_PADDING), achievementViewHeight)];
        achievementSubview.backgroundColor     = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        achievementSubview.layer.borderColor   = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
        achievementSubview.layer.cornerRadius  = 2.0;
        achievementSubview.layer.borderWidth   = 1.0;
        achievementSubview.autoresizingMask    = UIViewAutoresizingFlexibleWidth;

        
        NSDictionary *sponsoredAchievement = nil;
        NSDictionary *playerAchievement = nil;
        if ([sponsoredAchievements count] > 0){
            sponsoredAchievement = [sponsoredAchievements objectAtIndex:0];
        }
        if ([playerAchievements count] > 0){
            playerAchievement    = [playerAchievements objectAtIndex:0];
        }
        
       [self setContentForAchievementsView:achievementSubview withSponsAch:sponsoredAchievement andPlayerAch:playerAchievement];
        
        
        float heightWhereAchievemViewEnds      = achievementSubview.frame.origin.y + achievementSubview.frame.size.height;
        // --------------- Other subviews
        if (missionType == MISSION_TYPE_ONGOING) {
            float ongoingAcceptViewHeight          = 60;
            UIView *ongoingAcceptSubview           = [[UIView alloc] initWithFrame:CGRectMake(MISSION_SUBVIEWS_PADDING,
                                                                                              heightWhereAchievemViewEnds + 5,
                                                                                              viewSize.width - (2*MISSION_SUBVIEWS_PADDING), ongoingAcceptViewHeight)];
            ongoingAcceptSubview.backgroundColor     = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
            ongoingAcceptSubview.layer.borderColor   = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
            ongoingAcceptSubview.layer.cornerRadius  = 2.0;
            ongoingAcceptSubview.layer.borderWidth   = 0.0;
            ongoingAcceptSubview.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
            
            [self setContentForOngoingAcceptview:ongoingAcceptSubview];
            [self addSubview:ongoingAcceptSubview];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [ongoingAcceptSubview release];
#endif
            
        }else if(missionType == MISSION_TYPE_NEW){
            float missionNewViewHeight =  ([lastMission objectForKey:@"vgood"] != nil) ? 145 : 45 ;

            UIView *missionOverSubview           = [[UIView alloc] initWithFrame:CGRectMake(MISSION_SUBVIEWS_PADDING,
                                                                                            heightWhereAchievemViewEnds + 5,
                                                                                            viewSize.width - (2*MISSION_SUBVIEWS_PADDING), missionNewViewHeight)];
            missionOverSubview.backgroundColor     = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
            missionOverSubview.layer.borderColor   = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
            missionOverSubview.layer.cornerRadius  = 2.0;
            missionOverSubview.layer.borderWidth   = 0.0;
            missionOverSubview.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
            
            [self setContentForMissionNewView:missionOverSubview];
            [self addSubview:missionOverSubview];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [missionOverSubview release];
#endif
                        
        }else if(missionType == MISSION_TYPE_ACCOMPLISHED){
            
            BOOL isLandscapeMode = ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight);

            float missionOverViewHeight = isLandscapeMode ? 65 : 145;

            UIView *missionOverSubview           = [[UIView alloc] initWithFrame:CGRectMake(MISSION_SUBVIEWS_PADDING,
                                                                                              heightWhereAchievemViewEnds + 5,
                                                                                              viewSize.width - (2*MISSION_SUBVIEWS_PADDING), missionOverViewHeight)];
            missionOverSubview.backgroundColor     = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
            missionOverSubview.layer.borderColor   = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
            missionOverSubview.layer.cornerRadius  = 2.0;
            missionOverSubview.layer.borderWidth   = 0.0;
            missionOverSubview.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
            
            if (isLandscapeMode) {
                [self setContentForMissionOverLandscapeView:missionOverSubview];
            }
            else{
                [self setContentForMissionOverView:missionOverSubview];
            }
            [self addSubview:missionOverSubview];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [missionOverSubview release];
#endif
            
        }

        [self addSubview:achievementSubview];
        if (missionType != MISSION_TYPE_ACCOMPLISHED) {
            [self addSubview:welcomeToLabel];
        }
        [self addSubview:missionOTWLabel];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achievementSubview release];
        [welcomeToLabel release];
        [missionOTWLabel release];
#endif
    
    }
    @catch (NSException *exception) {
        BeintooLOG(@"BeintooMission Exception: %@", exception);
    }
}

#pragma mark - Content for mission

- (void)setContentForAchievementsView:(UIView *)_achievView withSponsAch:(NSDictionary *)_sponsoredAch andPlayerAch:(NSDictionary *)_playerAch
{
    NSMutableArray *achievementsToShow = [NSMutableArray array];
    CGSize viewSize = _achievView.frame.size;
    
    if (_playerAch != nil && [_playerAch count] > 0) {
        [achievementsToShow addObject:_playerAch];
    }
    // The sponsored achievement will be shown after the playerAchievement (the app achievement)
    if (_sponsoredAch != nil && [_sponsoredAch count] > 0) {
        [achievementsToShow addObject:_sponsoredAch];
    }

    float elementHeight = 10;
    
    // foreach loop to create and add elements to the achievement view
    for (int i = 0; i < [achievementsToShow count]; i++) {
        float descriptionOffset = 0;
        NSDictionary *_achiev = [achievementsToShow objectAtIndex:i];
        // --------------- achievement image
        UIImageView *achievImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MISSION_NORMAL_PADDING,
                                                                                   elementHeight+3,
                                                                                   ACHIEVEMENT_IMAGESIZE, ACHIEVEMENT_IMAGESIZE)];
        NSString *_imageURL     = [[_achiev objectForKey:@"achievement"]objectForKey:@"imageURL"];
        achievImageView.image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
        
        // --------------- achievement name
        NSString *appName      = [[[_achiev objectForKey:@"achievement"]objectForKey:@"app"] objectForKey:@"name"];
        NSString *achievmPercent    = ![_achiev objectForKey:@"percentage"] ? @"0" : [_achiev objectForKey:@"percentage"];
        NSString *nameText          = (missionType == MISSION_TYPE_NEW) ? appName : [NSString stringWithFormat:@"%@ - %@%%",      
                                                                                          appName,achievmPercent];
        
        UILabel *appNameLabel    = [[UILabel alloc] initWithFrame:
                                       CGRectMake((2 * MISSION_NORMAL_PADDING) + ACHIEVEMENT_IMAGESIZE + 10, 
                                                  elementHeight - 2, 
                                                  viewSize.width * 0.75, 
                                                  22)];
        appNameLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        appNameLabel.numberOfLines    = 1;
        appNameLabel.adjustsFontSizeToFitWidth = YES;
        appNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        appNameLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            appNameLabel.textAlignment       = NSTextAlignmentLeft;
        else
            appNameLabel.textAlignment       = UITextAlignmentLeft;
#else
        appNameLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        appNameLabel.backgroundColor  = [UIColor clearColor];
        appNameLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        appNameLabel.text             = nameText;
        
        if (i == 1) {  // Sponsored achievement, we need to show a "go to app" button
            descriptionOffset = 23;
            BButton *goToApp = [[BButton alloc] initWithFrame:CGRectMake((2 * MISSION_NORMAL_PADDING) + ACHIEVEMENT_IMAGESIZE + 10,
                                                                          elementHeight + 23,
                                                                          85,
                                                                          20)];
            [goToApp setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
            [goToApp setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
            [goToApp setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
            [goToApp setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
            [goToApp setTitle:NSLocalizedStringFromTable(@"missiondownloadnow",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
            [goToApp addTarget:self action:@selector(goToAppAction) forControlEvents:UIControlEventTouchUpInside];
            [goToApp setButtonTextSize:13];
            
            [_achievView addSubview:goToApp];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [goToApp release];
#endif
            
        }

        // --------------- achievement description
        UILabel *achievDescLabel    = [[UILabel alloc] initWithFrame:
                                       CGRectMake((2 * MISSION_NORMAL_PADDING) + ACHIEVEMENT_IMAGESIZE + 10, 
                                                  elementHeight + descriptionOffset +22, 
                                                  viewSize.width * 0.75, 
                                                  40)];
        achievDescLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
        achievDescLabel.numberOfLines    = 2;
        achievDescLabel.adjustsFontSizeToFitWidth = YES;
        achievDescLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        achievDescLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            achievDescLabel.textAlignment       = NSTextAlignmentLeft;
        else
            achievDescLabel.textAlignment       = UITextAlignmentLeft;
#else
        achievDescLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        achievDescLabel.backgroundColor  = [UIColor clearColor];
        achievDescLabel.textColor        = [UIColor colorWithWhite:1 alpha:1];
        achievDescLabel.text             = [[_achiev objectForKey:@"achievement"]objectForKey:@"description"];
        
        [_achievView addSubview:achievImageView];
        [_achievView addSubview:appNameLabel];
        [_achievView addSubview:achievDescLabel];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achievImageView release];
        [appNameLabel release];
        [achievDescLabel release];
#endif

        elementHeight += 80;
    }
}

#pragma mark - Content for mission Ongoing subview

- (void)setContentForOngoingAcceptview:(UIView *)_ongoingAcceptView
{
    CGSize viewSize = _ongoingAcceptView.frame.size;
    
    // --------------- text1
    
    UILabel *achYourMissionLabel    = [[UILabel alloc] initWithFrame:
                                   CGRectMake((2 * MISSION_NORMAL_PADDING), 
                                              10, 
                                              viewSize.width * 0.7, 
                                              20)];
    achYourMissionLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
    achYourMissionLabel.numberOfLines    = 1;
    achYourMissionLabel.adjustsFontSizeToFitWidth = YES;
    achYourMissionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    achYourMissionLabel.backgroundColor  = [UIColor clearColor];
    achYourMissionLabel.textColor        = [UIColor colorWithWhite:1 alpha:1];
    achYourMissionLabel.text             = NSLocalizedStringFromTable(@"missionachieveyour",@"BeintooLocalizable",@"");
    
    // --------------- text2
    UILabel *andWinRewardLabel    = [[UILabel alloc] initWithFrame:
                                   CGRectMake((2 * MISSION_NORMAL_PADDING), 
                                              33, 
                                              viewSize.width * 0.7, 
                                              20)];
    andWinRewardLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:18];
    andWinRewardLabel.numberOfLines    = 2;
    andWinRewardLabel.adjustsFontSizeToFitWidth = YES;
    andWinRewardLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    andWinRewardLabel.backgroundColor  = [UIColor clearColor];
    andWinRewardLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
    andWinRewardLabel.text             = NSLocalizedStringFromTable(@"missionandwinreward",@"BeintooLocalizable",@"");
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
    andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
        andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
    }
    else
    {
        achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
        andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
    }
#else
    achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
    andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
#endif
    
    // ----------------- ok button
    BButton *okButton = [[BButton alloc] initWithFrame:CGRectMake(andWinRewardLabel.frame.size.width+30,
                                                                  22,
                                                                  55,
                                                                  30)];
    [okButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
    [okButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
    [okButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
    [okButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(dismissMissionView) forControlEvents:UIControlEventTouchUpInside];
    [okButton setButtonTextSize:14];

    [_ongoingAcceptView addSubview:achYourMissionLabel];
    [_ongoingAcceptView addSubview:andWinRewardLabel];
    [_ongoingAcceptView addSubview:okButton];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [achYourMissionLabel release];
    [andWinRewardLabel release];
    [okButton release];
#endif
    
}

#pragma mark - Content for mission Over subview

- (void)setContentForMissionOverView:(UIView *)_missionOverView
{
    CGSize viewSize = _missionOverView.frame.size;
    
    NSDictionary *_mission = [Beintoo getLastRetrievedMission];
    
    if ([_mission objectForKey:@"vgood"] == nil) {
        // Here when no vgood is attached to the mission. We will show a "bedollars" prize instead
        // --------------- achievement image
        UIImageView *achievImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MISSION_NORMAL_PADDING,
                                                                                     10,
                                                                                     ACHIEVEMENT_IMAGESIZE+13, 
                                                                                     ACHIEVEMENT_IMAGESIZE+13)];
        NSString *_imageURL     = @"http://static.beintoo.com/test_img/good001b.jpg";
        achievImageView.image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
        
        
        // --------------- text1
        
        UILabel *achYourMissionLabel    = [[UILabel alloc] initWithFrame:
                                           CGRectMake((2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25), 
                                                      10, 
                                                      viewSize.width * 0.7, 
                                                      20)];
        achYourMissionLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        achYourMissionLabel.numberOfLines    = 1;
        achYourMissionLabel.adjustsFontSizeToFitWidth = YES;
        achYourMissionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        achYourMissionLabel.backgroundColor  = [UIColor clearColor];
        achYourMissionLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        achYourMissionLabel.text             = NSLocalizedStringFromTable(@"missiongetrewardnow",@"BeintooLocalizable",@"");

        // --------------- text2
        UILabel *andWinRewardLabel    = [[UILabel alloc] initWithFrame:
                                         CGRectMake(2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25, 
                                                    40, 
                                                    viewSize.width * 0.7, 
                                                    60)];
        andWinRewardLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:17];
        andWinRewardLabel.numberOfLines    = 3;
        andWinRewardLabel.adjustsFontSizeToFitWidth = YES;
        andWinRewardLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        andWinRewardLabel.backgroundColor  = [UIColor clearColor];
        andWinRewardLabel.textColor        = [UIColor colorWithWhite:1 alpha:1];
        andWinRewardLabel.text             = NSLocalizedStringFromTable(@"missiongetbedollars",@"BeintooLocalizable",@"");
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
        andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
            andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
        }
        else
        {
            achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
            andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
        }
#else
        achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
        andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        // ----------------- redeem button
        BButton *okButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width -  80 - 10,
                                                                      105,
                                                                      80,
                                                                      30)];
        [okButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setTitle:NSLocalizedStringFromTable(@"missionredeem",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(startBeintooAction) forControlEvents:UIControlEventTouchUpInside];
        [okButton setButtonTextSize:14];
        
        [_missionOverView addSubview:achYourMissionLabel];
        [_missionOverView addSubview:okButton];
        [_missionOverView addSubview:andWinRewardLabel];
        [_missionOverView addSubview:achievImageView];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achYourMissionLabel release];
        [okButton release];
        [andWinRewardLabel release];
        [achievImageView release];
#endif
        
    }
    else{
         
        // --------------- achievement image
        UIImageView *achievImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MISSION_NORMAL_PADDING,
                                                                                     10,
                                                                                     ACHIEVEMENT_IMAGESIZE+13, 
                                                                                     ACHIEVEMENT_IMAGESIZE+13)];
        NSString *_imageURL     = [[_mission objectForKey:@"vgood"]objectForKey:@"imageSmallUrl"];
        achievImageView.image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
        
        
        // --------------- text1
        
        UILabel *achYourMissionLabel    = [[UILabel alloc] initWithFrame:
                                           CGRectMake((2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25), 
                                                      10, 
                                                      viewSize.width * 0.7, 
                                                      20)];
        achYourMissionLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        achYourMissionLabel.numberOfLines    = 1;
        achYourMissionLabel.adjustsFontSizeToFitWidth = YES;
        achYourMissionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        achYourMissionLabel.backgroundColor  = [UIColor clearColor];
        achYourMissionLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        achYourMissionLabel.text             = NSLocalizedStringFromTable(@"missiongetrewardnow",@"BeintooLocalizable",@"");
        
        // --------------- text2
        UILabel *andWinRewardLabel    = [[UILabel alloc] initWithFrame:
                                         CGRectMake(2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25, 
                                                    40, 
                                                    viewSize.width * 0.7, 
                                                    60)];
        andWinRewardLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:17];
        andWinRewardLabel.numberOfLines    = 3;
        andWinRewardLabel.adjustsFontSizeToFitWidth = YES;
        andWinRewardLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        andWinRewardLabel.backgroundColor  = [UIColor clearColor];
        andWinRewardLabel.textColor        = [UIColor colorWithWhite:1 alpha:1];
        andWinRewardLabel.text             = [[_mission objectForKey:@"vgood"]objectForKey:@"description"];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
        andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
            andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
        }
        else
        {
            achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
            andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
        }
#else
        achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
        andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        // ----------------- redeem button
        BButton *okButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width -  80 - 10,
                                                                      105,
                                                                      80,
                                                                      30)];
        [okButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setTitle:NSLocalizedStringFromTable(@"missionredeem",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(getItRealAction) forControlEvents:UIControlEventTouchUpInside];
        [okButton setButtonTextSize:14];
        
        [_missionOverView addSubview:achYourMissionLabel];
        [_missionOverView addSubview:andWinRewardLabel];
        [_missionOverView addSubview:okButton];
        [_missionOverView addSubview:achievImageView];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achYourMissionLabel release];
        [andWinRewardLabel release];
        [okButton release];
        [achievImageView release];
#endif
        
    }
}

- (void)setContentForMissionOverLandscapeView:(UIView *)_missionOverView
{
    CGSize viewSize = _missionOverView.frame.size;
    
    NSDictionary *_mission = [Beintoo getLastRetrievedMission];
    
    if ([_mission objectForKey:@"vgood"] == nil) {
        // Here when no vgood is attached to the mission. We will show a "bedollars" prize instead
        // --------------- achievement image
        UIImageView *achievImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MISSION_NORMAL_PADDING,
                                                                                     5,
                                                                                     ACHIEVEMENT_IMAGESIZE, 
                                                                                     ACHIEVEMENT_IMAGESIZE)];
        NSString *_imageURL     = @"http://static.beintoo.com/test_img/good001b.jpg";
        achievImageView.image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
        
        
        // --------------- text1
        
        UILabel *achYourMissionLabel    = [[UILabel alloc] initWithFrame:
                                           CGRectMake((2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25), 
                                                      5, 
                                                      viewSize.width * 0.7, 
                                                      20)];
        achYourMissionLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:16];
        achYourMissionLabel.numberOfLines    = 1;
        achYourMissionLabel.adjustsFontSizeToFitWidth = YES;
        achYourMissionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
        else
            achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
#else
        achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        achYourMissionLabel.backgroundColor  = [UIColor clearColor];
        achYourMissionLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        achYourMissionLabel.text             = NSLocalizedStringFromTable(@"missiongetrewardnow",@"BeintooLocalizable",@"");
        
        // ----------------- redeem button
        BButton *okButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width -  80 - 10,
                                                                      30,
                                                                      80,
                                                                      30)];
        [okButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setTitle:NSLocalizedStringFromTable(@"missionredeem",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(startBeintooAction) forControlEvents:UIControlEventTouchUpInside];
        [okButton setButtonTextSize:14];
        
        [_missionOverView addSubview:achYourMissionLabel];
        [_missionOverView addSubview:okButton];
        [_missionOverView addSubview:achievImageView];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achYourMissionLabel release];
        [okButton release];
        [achievImageView release];
#endif
        
    }
    else{
        
        // --------------- achievement image
        UIImageView *achievImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MISSION_NORMAL_PADDING,
                                                                                     5,
                                                                                     ACHIEVEMENT_IMAGESIZE, 
                                                                                     ACHIEVEMENT_IMAGESIZE)];
        NSString *_imageURL     = [[_mission objectForKey:@"vgood"]objectForKey:@"imageSmallUrl"];
        achievImageView.image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
        
        
        // --------------- text1
        
        UILabel *achYourMissionLabel    = [[UILabel alloc] initWithFrame:
                                           CGRectMake((2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25), 
                                                      5, 
                                                      viewSize.width * 0.7, 
                                                      20)];
        achYourMissionLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        achYourMissionLabel.numberOfLines    = 1;
        achYourMissionLabel.adjustsFontSizeToFitWidth = YES;
        achYourMissionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
        else
            achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
#else
        achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        achYourMissionLabel.backgroundColor  = [UIColor clearColor];
        achYourMissionLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        achYourMissionLabel.text             = NSLocalizedStringFromTable(@"missiongetrewardnow",@"BeintooLocalizable",@"");
        
            
        // ----------------- redeem button
        BButton *okButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width -  80 - 10,
                                                                      30,
                                                                      80,
                                                                      30)];
        [okButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [okButton setTitle:NSLocalizedStringFromTable(@"missionredeem",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(getItRealAction) forControlEvents:UIControlEventTouchUpInside];
        [okButton setButtonTextSize:14];
        
        [_missionOverView addSubview:achYourMissionLabel];
        [_missionOverView addSubview:okButton];
        [_missionOverView addSubview:achievImageView];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achYourMissionLabel release];
        [okButton release];
        [achievImageView release];
#endif
        
    }
}

#pragma mark - Content for mission New subview

- (void)setContentForMissionNewView:(UIView *)_missionNewView
{
    CGSize viewSize = _missionNewView.frame.size;
    
    NSDictionary *_mission = [Beintoo getLastRetrievedMission];
    
    if ([_mission objectForKey:@"vgood"] != nil) { // We have a vgood data to show
        UIImageView *achievImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MISSION_NORMAL_PADDING,
                                                                                     10,
                                                                                     ACHIEVEMENT_IMAGESIZE+13, 
                                                                                     ACHIEVEMENT_IMAGESIZE+13)];
        NSString *_imageURL     = @"http://static.beintoo.com/test_img/good001b.jpg";
        achievImageView.image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
        
        
        // --------------- text1
        
        UILabel *achYourMissionLabel    = [[UILabel alloc] initWithFrame:
                                           CGRectMake((2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25), 
                                                      10, 
                                                      viewSize.width * 0.7, 
                                                      20)];
        achYourMissionLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        achYourMissionLabel.numberOfLines    = 1;
        achYourMissionLabel.adjustsFontSizeToFitWidth = YES;
        achYourMissionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        achYourMissionLabel.backgroundColor  = [UIColor clearColor];
        achYourMissionLabel.textColor        = [UIColor colorWithRed:171.0/255 green:194.0/255 blue:54.0/255 alpha:1.0];
        achYourMissionLabel.text             = NSLocalizedStringFromTable(@"missiongetrewardnow",@"BeintooLocalizable",@"");
        
        // --------------- text2
        UILabel *andWinRewardLabel    = [[UILabel alloc] initWithFrame:
                                         CGRectMake(2 * MISSION_NORMAL_PADDING + ACHIEVEMENT_IMAGESIZE + 25, 
                                                    40, 
                                                    viewSize.width * 0.7, 
                                                    60)];
        andWinRewardLabel.font             = [UIFont fontWithName:@"MarkerFelt-Thin" size:17];
        andWinRewardLabel.numberOfLines    = 3;
        andWinRewardLabel.adjustsFontSizeToFitWidth = YES;
        andWinRewardLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        andWinRewardLabel.backgroundColor  = [UIColor clearColor];
        andWinRewardLabel.textColor        = [UIColor colorWithWhite:1 alpha:1];
        andWinRewardLabel.text             = NSLocalizedStringFromTable(@"missiongetbedollars",@"BeintooLocalizable",@"");
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
        andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            achYourMissionLabel.textAlignment       = NSTextAlignmentLeft;
            andWinRewardLabel.textAlignment       = NSTextAlignmentLeft;
        }
        else
        {
            achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
            andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
        }
#else
        achYourMissionLabel.textAlignment       = UITextAlignmentLeft;
        andWinRewardLabel.textAlignment       = UITextAlignmentLeft;
#endif
        
        // ----------------- joinnow button
        BButton *joinNowButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width -  100 - 10,
                                                                      105,
                                                                      100,
                                                                      30)];
        [joinNowButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setTitle:NSLocalizedStringFromTable(@"missionjoinnow",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [joinNowButton addTarget:self action:@selector(dismissMissionView) forControlEvents:UIControlEventTouchUpInside];
        [joinNowButton setButtonTextSize:15];
        
        // ----------------- later button
        BButton *laterButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width - 80 - 10 - 100 - 10, // equal sfhift of 2 buttons
                                                                      105,
                                                                      80,
                                                                      30)];
        [laterButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setTitle:NSLocalizedStringFromTable(@"missionlater",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [laterButton addTarget:self action:@selector(missionLaterAction) forControlEvents:UIControlEventTouchUpInside];
        [laterButton setButtonTextSize:14];
        
        [_missionNewView addSubview:achYourMissionLabel];
        [_missionNewView addSubview:joinNowButton];
        [_missionNewView addSubview:andWinRewardLabel];
        [_missionNewView addSubview:achievImageView];
        [_missionNewView addSubview:laterButton];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [achYourMissionLabel release];
        [joinNowButton release];
        [andWinRewardLabel release];
        [achievImageView release];
        [laterButton release];
#endif
        
    }
    else{ // No vgood to show, only buttons
        
        // ----------------- joinnow button
        BButton *joinNowButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width -  100 - 10,
                                                                           7,
                                                                           100,
                                                                           30)];
        [joinNowButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [joinNowButton setTitle:NSLocalizedStringFromTable(@"missionjoinnow",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [joinNowButton addTarget:self action:@selector(dismissMissionView) forControlEvents:UIControlEventTouchUpInside];
        [joinNowButton setButtonTextSize:15];
        
        // ----------------- later button
        BButton *laterButton = [[BButton alloc] initWithFrame:CGRectMake(viewSize.width - 80 - 10 - 100 - 10, // equal sfhift of 2 buttons
                                                                         7,
                                                                         80,
                                                                         30)];
        [laterButton setHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setMediumHighColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setMediumLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setLowColor:[UIColor colorWithRed:171.0/255 green:194.0/255 blue:55.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(171.0, 2)/pow(255,2) green:pow(194.0, 2)/pow(255,2) blue:pow(55, 2)/pow(255,2) alpha:1]];
        [laterButton setTitle:NSLocalizedStringFromTable(@"missionlater",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [laterButton addTarget:self action:@selector(missionLaterAction) forControlEvents:UIControlEventTouchUpInside];
        [laterButton setButtonTextSize:14];
        
        [_missionNewView addSubview:joinNowButton];
        [_missionNewView addSubview:laterButton];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [joinNowButton release];
        [laterButton release];
#endif
       
    }
}

- (void)dismissMissionView
{
    [Beintoo beintooWillDisappear];
    self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnCloseMission)]){
        [[self delegate] userDidTapOnCloseMission];
    }
}

- (void)missionLaterAction
{
    [Beintoo beintooWillDisappear];
    self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnCloseMission)]){
        [[self delegate] userDidTapOnCloseMission];
    }
    
    //[BeintooMission refuseMission];
}

- (void)getItRealAction
{    
    self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
        
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnMissionGetItReal)]){
        [[self delegate] userDidTapOnMissionGetItReal];
    }
}

- (void)startBeintooAction
{
    self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    [Beintoo launchBeintoo];
}

- (void)goToAppAction
{
    NSArray *sponsoredAchievements   = [[Beintoo getLastRetrievedMission] objectForKey:@"sponsoredAchievements"];    
    NSDictionary *downloadUrls =[[[[sponsoredAchievements objectAtIndex:0] objectForKey:@"achievement"]objectForKey:@"app"] objectForKey:@"download_url"];
    NSString *appURL = [downloadUrls objectForKey:@"IOS"] ? [downloadUrls objectForKey:@"IOS"] : [downloadUrls objectForKey:@"WEB"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
}


- (void)removeViews
{
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)closeMission
{
	self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnCloseMission)]) {
        [[self delegate] userDidTapOnCloseMission];
    }
}

- (void)prepareMissionAlertOrientation:(CGRect)startingFrame
{
	self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	CGRect windowFrame	 = [[Beintoo getAppWindow] bounds];
    
    int alertHeight;
    
    switch (missionType) {
        case MISSION_TYPE_NEW:
            alertHeight = windowFrame.size.height;
            break;
            
        case MISSION_TYPE_ONGOING:
            alertHeight = windowFrame.size.height;
            break;
            
        case MISSION_TYPE_ACCOMPLISHED:
            alertHeight = windowFrame.size.height;
            break;
        
        default:
            alertHeight = windowFrame.size.height;
            break;
    }
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
		self.center = CGPointMake(windowFrame.size.width/2.f, windowFrame.size.height/2.f);
		transitionEnterSubtype = kCATransitionFromRight;
		transitionExitSubtype  = kCATransitionFromLeft;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
		self.center = CGPointMake(windowFrame.size.width/2.f, windowFrame.size.height/2) ;
		transitionEnterSubtype = kCATransitionFromLeft;
		transitionExitSubtype  = kCATransitionFromRight;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;	
		self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(alertHeight/2.f));
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	
	if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		self.frame = startingFrame;	
		self.center = CGPointMake(windowFrame.size.width/2, (alertHeight/2.f));
		transitionEnterSubtype = kCATransitionFromBottom;
		transitionExitSubtype  = kCATransitionFromTop;
	}
    @try {
        [self drawMission];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"BeintooMission Exception: %@", exception);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*if (firstTouch && (missionType == PRIZE_GOOD)) {
		[self setBackgroundColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:0.7]];
		if (missionType == PRIZE_RECOMMENDATION) {
			self.prizeThumb.alpha = 0.7;
		}
	}*/
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*if (missionType == PRIZE_GOOD) {
        [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [[self delegate] userDidTapOnThePrize];
        self.alpha  = 0;
        
        firstTouch = YES;
        
        [self removeViews];
        [self removeFromSuperview];
    }*/
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
