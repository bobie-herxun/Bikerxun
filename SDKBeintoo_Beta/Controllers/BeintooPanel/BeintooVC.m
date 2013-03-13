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

#import "BeintooVC.h"
#import <QuartzCore/QuartzCore.h>
#import "BeintooTutorialVC.h"

@implementation BeintooVC

@synthesize beintooPlayer, loginNavController, retrievedPlayersArray, loginVC, featuresArray, isNotificationCenterOpen, isFromSignup, forceSignup, _user;

#ifdef UI_USER_INTERFACE_IDIOM
@synthesize popOverController,loginPopoverController;
#endif

- (id)init
{
	if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupClosed) name:BeintooNotificationSignupClosed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBeintoo) name:BeintooNotificationReloadDashboard object:nil];
    }
	return self;
}

#pragma mark -
#pragma mark BeintooInitialization

- (void)setBeintooFeatures:(NSArray *)_featuresArray
{
	// initial clean
	[self.featuresArray removeAllObjects];
	
	for (NSString *elem in _featuresArray) {
		NSMutableDictionary *panelElement = [[NSMutableDictionary alloc] init];
        [panelElement setObject:elem forKey:@"featureKey"];
		@try {
			if ([elem isEqualToString:@"Profile"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"profile",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"profileDesc",@"BeintooLocalizable",@"see your stats") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_profile.png" forKey:@"featureImg"];
				[panelElement setObject:beintooProfileVC forKey:@"featureVC"];
			}
            if ([elem isEqualToString:@"Marketplace"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"MPmarketplaceTitle",@"BeintooLocalizable", nil) forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"MPdescription",@"BeintooLocalizable", nil) forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_marketplace.png" forKey:@"featureImg"];
				//[panelElement setObject:marketplaceVC forKey:@"featureVC"];
                [panelElement setObject:beintooBestoreVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Leaderboard"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"leaderboard",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"leaderboardDesc",@"BeintooLocalizable",@"see the global scoring") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_leaderboard.png" forKey:@"featureImg"];
				[panelElement setObject:beintooLeaderboardVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Wallet"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"wallet",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"walletDesc",@"BeintooLocalizable",@"manage your virtual goods") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_wallet.png" forKey:@"featureImg"];
				[panelElement setObject:beintooWalletVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Challenges"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"challenges",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"challengesDesc",@"BeintooLocalizable",@"manage your challenges") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_challenges.png" forKey:@"featureImg"];
				[panelElement setObject:beintooChallengesVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Achievements"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"achievements",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"achievementsDesc",@"BeintooLocalizable",@"") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_achievements.png" forKey:@"featureImg"];
				[panelElement setObject:beintooAchievementsVC forKey:@"featureVC"];
			}
            if ([elem isEqualToString:@"TipsAndForum"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"tipsandforum",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"tipsandforumDesc",@"BeintooLocalizable",@"") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_forum.png" forKey:@"featureImg"];
				[panelElement setObject:tipsAndForumVC forKey:@"featureVC"];
			}
			
		}
		@catch (NSException * e){ 
            BeintooLOG(@"Beintoo Error: Check your Beintoo feature settings, %@",e);
        }
		[self.featuresArray addObject:panelElement];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [panelElement release];
#endif
		
	}
}

- (UIView *)closeButton
{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo
{
    [Beintoo dismissBeintoo];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    // ----------- User service initialization ---------------
	_user           = [[BeintooUser alloc]init];
	beintooPlayer   = [[BeintooPlayer alloc]init];
    
    _user.delegate          = self;
	beintooPlayer.delegate  = self;
	
    // ----------- Setup notification view to receive single taps --------------
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                              initWithTarget:self action:@selector(handleNotificationSingleTap:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [notificationView addGestureRecognizer:singleTapGestureRecognizer];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [singleTapGestureRecognizer release];
#endif
        
        UITapGestureRecognizer *singleTapGestureRecognizerLand = [[UITapGestureRecognizer alloc]
                                                                  initWithTarget:self action:@selector(handleNotificationSingleTap:)];
        singleTapGestureRecognizerLand.numberOfTapsRequired = 1;
        [notificationViewLandscape addGestureRecognizer:singleTapGestureRecognizerLand];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [singleTapGestureRecognizerLand release];
#endif

    }
	// ----------- ViewControllers initialization ------------
	self.loginVC            = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
	beintooProfileVC        = [[BeintooProfileVC alloc]initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle]];
    beintooBestoreVC = [[BeintooBestoreVC alloc] initWithNibName:@"BeintooBestoreVC" bundle:[NSBundle mainBundle]];
    beintooLeaderboardVC    = [[BeintooLeaderboardVC alloc]initWithNibName:@"BeintooLeaderboardVC" bundle:[NSBundle mainBundle]];
	beintooWalletVC         = [[BeintooWalletVC alloc]initWithNibName:@"BeintooWalletVC" bundle:[NSBundle mainBundle]];
	beintooChallengesVC     = [[BeintooChallengesVC alloc]initWithNibName:@"BeintooChallengesVC" bundle:[NSBundle mainBundle]];
	beintooAchievementsVC   = [[BeintooAchievementsVC alloc]initWithNibName:@"BeintooAchievementsVC" bundle:[NSBundle mainBundle]];
	messagesVC              = [[BeintooMessagesVC alloc] initWithNibName:@"BeintooMessagesVC" bundle:[NSBundle mainBundle] andOptions:nil];
    tipsAndForumVC          = [[BeintooBrowserVC alloc] initWithNibName:@"BeintooBrowserVC" bundle:[NSBundle mainBundle] urlToOpen:nil];
    [tipsAndForumVC setAllowCloseWebView:YES];
    
    featuresArray = [[NSMutableArray alloc] init];		
	[self setBeintooFeatures:[Beintoo getFeatureList]];
	
	homeNavController = [Beintoo getMainNavigationController];
	
	UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	self.loginNavController = [[BNavigationController alloc] initWithRootViewController:self.loginVC];
	[[self.loginNavController navigationBar] setTintColor:barColor];
    
	UIImageView *logo;
	if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo_34.png"]];
    }
	else { 
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	}
    
	self.navigationItem.titleView = logo;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [logo release];
#endif
		
	[homeView setTopHeight:33.0f];
	[homeView setBodyHeight:444.0f];	
    homeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [notificationView setGradientType:GRADIENT_FOOTER_LIGHT];
    
    [notificationLogoView setGradientType:GRADIENT_NOTIF_CELL];
    notificationLogoView.layer.cornerRadius = 12.5f;
    notificationLogoView.layer.masksToBounds = YES;
    notificationLogoView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
    notificationLogoView.layer.borderWidth = 0.5f;
    
    [notificationNumbersView setGradientType:GRADIENT_NOTIF_CELL];
    notificationNumbersView.layer.cornerRadius = 8.5f;
    notificationNumbersView.layer.masksToBounds = YES;
    notificationNumbersView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
    notificationNumbersView.layer.borderWidth = 0.5f;
    
    [notificationViewLandscape setGradientType:GRADIENT_FOOTER_LIGHT];
    
    [notificationLogoViewLandscape setGradientType:GRADIENT_NOTIF_CELL];
    notificationLogoViewLandscape.layer.cornerRadius = 12.5f;
    notificationLogoViewLandscape.layer.masksToBounds = YES;
    notificationLogoViewLandscape.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
    notificationLogoViewLandscape.layer.borderWidth = 0.5f;
    
    [notificationNumbersViewLandscape setGradientType:GRADIENT_NOTIF_CELL];
    notificationNumbersViewLandscape.layer.cornerRadius = 8.5f;
    notificationNumbersViewLandscape.layer.masksToBounds = YES;
    notificationNumbersViewLandscape.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
    notificationNumbersViewLandscape.layer.borderWidth = 0.5f;

    fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = -11;
    
    notificationButtonItem = [UIBarButtonItem alloc];
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIDeviceOrientationLandscapeLeft || [Beintoo appOrientation] == UIDeviceOrientationLandscapeRight))
        notificationButtonItem = [notificationButtonItem initWithCustomView:notificationViewLandscape];
        
    else 
        notificationButtonItem = [notificationButtonItem initWithCustomView:notificationView];
    
    [toolBar setItems:[NSArray arrayWithObjects: fixedSpace, notificationButtonItem, fixedSpace, nil]];
    
	homeTable.rowHeight = 70;
	homeTable.delegate = self;
	homeTable.dataSource = self;
        
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
    // Notifications
    notificationMainLabel.text = NSLocalizedStringFromTable(@"notifications", @"BeintooLocalizable", nil);
    notificationMainLabelLandscape.text = NSLocalizedStringFromTable(@"notifications", @"BeintooLocalizable",nil);
    
    [toolBar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        
        notificationButtonItem.width = [UIScreen mainScreen].bounds.size.height;
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width - 32);
        
        toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y + 12, toolBar.frame.size.width, 32);
        homeTable.frame = CGRectMake(homeTable.frame.origin.x, homeTable.frame.origin.y, homeTable.frame.size.width, homeTable.frame.size.height + 12);
        
    }
    else {
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y, toolBar.frame.size.width, 44);
        homeTable.frame = CGRectMake(homeTable.frame.origin.x, homeTable.frame.origin.y, homeTable.frame.size.width, homeTable.frame.size.height);
        
        notificationButtonItem.width = 320;
    }
    
    isNotificationCenterOpen = NO;
    isAlreadyLogging         = NO;
    
    // --------------- forum&tips url
    if ([Beintoo isUserLogged]) {
        NSString *tipsUrl = [NSString stringWithFormat:@"http://appsforum.beintoo.com/?apikey=%@&userExt=%@#main",
                             [Beintoo getApiKey],[Beintoo getUserID]];
        [tipsAndForumVC setUrlToOpen:tipsUrl];
    }
    
    if (signupViewForPlayers != nil) {
        signupViewForPlayers = nil;
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [signupViewForPlayers release];
#endif
        
    }
    
    [[self.view viewWithTag:1111] removeFromSuperview];
    
#ifdef BEINTOO_ARC_AVAILABLE
    signupViewForPlayers = [BSignupLayouts getBeintooDashboardSignupViewWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 110) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
    signupViewForPlayers = [[BSignupLayouts getBeintooDashboardSignupViewWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 110) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
    
    signupViewForPlayers.tag = 1111;
    [self.view addSubview:signupViewForPlayers];
    
    if ([[Beintoo getPlayer] objectForKey:@"unreadNotification"] != nil) {
        notificationNumbersLabel.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
        notificationNumbersLabelLandscape.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
    }
    else {
        notificationNumbersLabel.text = @"0";
        notificationNumbersLabelLandscape.text = @"0";
    }
    
	if ((![Beintoo isUserLogged] && [Beintoo isRegistrationForced]) || ![Beintoo getPlayerID] || forceSignup == YES) {
        
        [toolBar setHidden:YES];
        [bedollars setHidden:YES];
        [userNick setHidden:YES];
        [homeTable setHidden:YES];
        [signupViewForPlayers setHidden:YES];
        
        if ([BeintooNetwork connectedToNetwork]) {
            [BLoadingView startActivity:self.view];
            [_user performSelector:@selector(getUserByUDID) withObject:nil afterDelay:0.4];
        }
        else {
            [BeintooNetwork showNoConnectionAlert];
        }
    }
	else {
        
        [toolBar setHidden:NO];
        [bedollars setHidden:NO];
        [userNick setHidden:NO];
        [homeTable setHidden:NO];
        
        [signupViewForPlayers setHidden:YES];
        homeTable.userInteractionEnabled = YES;
		[homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:NO];
        
        if (![Beintoo isUserLogged]) {
            /*
             * ------------------- Dashboard for player! -----------------------
             */
            [signupViewForPlayers setHidden:NO];
            
            if(!homeTablePlayerAnimationPerformed){
                CGRect currentFrame = homeTable.frame;
                homeTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + 77, currentFrame.size.width, currentFrame.size.height - 77);
                homeTablePlayerAnimationPerformed = YES;
            }
        }
        else{
            /*
             * ------------------- Dashboard for users! -----------------------
             */
            @try {
                [signupViewForPlayers setHidden:YES];
                
                NSDictionary *currentUser = [Beintoo getUserIfLogged];
                
                userNick.text		= [currentUser objectForKey:@"nickname"];
                bedollars.text      = [NSString stringWithFormat:@"%.2f Bedollars", [[currentUser objectForKey:@"bedollars"] floatValue]];
                
                if(homeTablePlayerAnimationPerformed){
                    CGRect currentFrame = homeTable.frame;
                    homeTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y - 77, currentFrame.size.width, currentFrame.size.height + 77);
                    homeTablePlayerAnimationPerformed = NO;
                }
            }
            @catch (NSException * e) {
            }
            
            if ([Beintoo getPlayerID] != nil && [Beintoo isUserLogged]) {
                [beintooPlayer getPlayerByGUID:[Beintoo getPlayerID]];
            }
        }
        [homeTable reloadData];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    _user.delegate          = self;	
	beintooPlayer.delegate  = self;
    
    if ([[Beintoo getPlayer] objectForKey:@"unreadNotification"] != nil) {
        notificationNumbersLabel.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
        notificationNumbersLabelLandscape.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
    }
    else{
        notificationNumbersLabel.text = @"0";
        notificationNumbersLabelLandscape.text = @"0";
    }
}

#pragma mark - Taps Gesture 

- (void)handleNotificationSingleTap:(UITapGestureRecognizer *)sender
{    
    if ([BeintooDevice isiPad]) {
        [Beintoo launchIpadNotifications];
    }
    else {
        BeintooNotificationListVC *beintooNotificationVC   = [[BeintooNotificationListVC alloc] init];
        BNavigationController *notificationNavigationController = [[BNavigationController alloc] initWithRootViewController:beintooNotificationVC];
        
        UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
        [[notificationNavigationController navigationBar] setTintColor:barColor];
        
        isNotificationCenterOpen    = YES;
        
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
        [self presentViewController:notificationNavigationController animated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
            [self presentViewController:notificationNavigationController animated:YES completion:nil];
        else
            [self presentModalViewController:notificationNavigationController animated:YES];
#else
        [self presentModalViewController:notificationNavigationController animated:YES];
#endif
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [beintooNotificationVC release];
        [notificationNavigationController release];
#endif
        
    }
}

- (void)reloadBeintoo
{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    [homeTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    isAlreadyLogging = NO;
    
    if (signupViewForPlayers != nil) {
        signupViewForPlayers = nil;
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [signupViewForPlayers release];
#endif
        
    }
    
    _user.delegate = self;	
    beintooPlayer.delegate = self;	
    
    [[self.view viewWithTag:1111] removeFromSuperview];
    
#ifdef BEINTOO_ARC_AVAILABLE
    signupViewForPlayers = [BSignupLayouts getBeintooDashboardSignupViewWithFrame:CGRectMake(0, 0 , homeTable.frame.size.width, 110) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
    signupViewForPlayers = [[BSignupLayouts getBeintooDashboardSignupViewWithFrame:CGRectMake(0, 0 , homeTable.frame.size.width, 110) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
    
    signupViewForPlayers.tag = 1111;
    [self.view addSubview:signupViewForPlayers];
    
    // Top logo
    int appOrientation = [Beintoo appOrientation];
    
    UIImageView *logo;
    
    if( !([BeintooDevice isiPad]) && 
       (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) ){
        logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo_34.png"]];
    }
    else { 
        logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
    }
    
    self.navigationItem.titleView = logo;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [logo release];
#endif
    
    if ([[Beintoo getPlayer] objectForKey:@"unreadNotification"] != nil) {
        notificationNumbersLabel.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
        notificationNumbersLabelLandscape.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
    }
    else{
        notificationNumbersLabel.text = @"0";
        notificationNumbersLabelLandscape.text = @"0";
    }
    
    if ((![Beintoo isUserLogged] && [Beintoo isRegistrationForced]) || ![Beintoo getPlayerID] /*|| (![Beintoo isUserLogged] && [Beintoo isTryBeintooForced])*/) {
        
        [toolBar setHidden:YES];
        [bedollars setHidden:YES];
        [userNick setHidden:YES];
        [homeTable setHidden:YES];
        [signupViewForPlayers setHidden:YES];
        
        if (!isAlreadyLogging) {
            isAlreadyLogging = YES;
            
            [BLoadingView startActivity:self.view];
            [_user performSelector:@selector(getUserByUDID) withObject:nil afterDelay:0.4];
            //[_user getUserByUDID];
        }
    }
    else {        
        
        [toolBar setHidden:NO];
        [bedollars setHidden:NO];
        [userNick setHidden:NO];
        [homeTable setHidden:NO];
        
        [signupViewForPlayers setHidden:YES];
        homeTable.userInteractionEnabled = YES;
        [homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:NO];
        
        if (![Beintoo isUserLogged]) { 
            /*
             * ------------------- Dashboard for player! -----------------------
             */
            [signupViewForPlayers setHidden:NO];
            
            if(!homeTablePlayerAnimationPerformed){
                CGRect currentFrame = homeTable.frame;
                homeTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y+77, currentFrame.size.width, currentFrame.size.height-77);
                homeTablePlayerAnimationPerformed = YES;
            }
        }
        else{
            /*
             * ------------------- Dashboard for users! -----------------------
             */
            @try {
                [signupViewForPlayers setHidden:YES];
                
                NSDictionary *currentUser = [Beintoo getUserIfLogged];
                
                userNick.text		= [currentUser objectForKey:@"nickname"];
                bedollars.text      = [NSString stringWithFormat:@"%.2f Bedollars",[[currentUser objectForKey:@"bedollars"] floatValue]];
                
                if(homeTablePlayerAnimationPerformed){
                    CGRect currentFrame = homeTable.frame;
                    homeTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y-77, currentFrame.size.width, currentFrame.size.height+77);
                    homeTablePlayerAnimationPerformed = NO;
                }
            }
            @catch (NSException * e) {
                
            }
            
            if ([Beintoo getPlayerID] != nil && [Beintoo isUserLogged]) {
                [beintooPlayer getPlayerByGUID:[Beintoo getPlayerID]];
            }
        }
        [homeTable reloadData];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
        toolBar.hidden = NO;
    else 
        toolBar.hidden = YES;
}

- (void)signupClosed
{
    if ([Beintoo getPlayerID] == nil || forceSignup){
        if (![BeintooDevice isiPad])
            [self closeBeintoo];
        else
        {
            [self performSelector:@selector(closeBeintoo) withObject:nil afterDelay:0.01];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationSignupClosed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationReloadDashboard object:nil];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.featuresArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];

	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
    
    float alphaValueForCell = 1.0;
    if (![Beintoo isUserLogged]) {
        NSString *featureName = [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureKey"];
        if([featureName isEqualToString:@"TipsAndForum"] || [featureName isEqualToString:@"Challenges"]){
            alphaValueForCell = 0.4;
        }
    }
    
	@try {
		cell.textLabel.text				= [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureName"];
		cell.textLabel.font				= [UIFont systemFontOfSize:18];
        cell.textLabel.alpha            = alphaValueForCell;
        
		cell.detailTextLabel.text		= [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureDesc"];
        cell.detailTextLabel.alpha      = alphaValueForCell;
        cell.detailTextLabel.numberOfLines = 0;
        
		cell.imageView.image			= [UIImage imageNamed:[[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureImg"]];
        cell.imageView.alpha            = alphaValueForCell;
        
    }
	@catch (NSException * e){
		//[beintooPlayer logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![Beintoo isUserLogged]) {
        
        /*
         *  If the user is not logged, some features are disables. 
         *  When one of those feature is selected, a subview is added to go to the signup.
         */
        
        NSString *featureName = [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureKey"];
        if([featureName isEqualToString:@"TipsAndForum"]){
            
#ifdef BEINTOO_ARC_AVAILABLE
            UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
            UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
            
            featureView.tag = 3333;
            [self.view addSubview:featureView];
            [self.view bringSubviewToFront:featureView];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [featureView release];
            
#endif
            
            [homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:YES];
        }
        else if([featureName isEqualToString:@"Challenges"]){
            
#ifdef BEINTOO_ARC_AVAILABLE
            UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
            UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
            
            featureView.tag = 3333;
            [self.view addSubview:featureView];
            [self.view bringSubviewToFront:featureView];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [featureView release];
            
#endif
            
            [homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:YES];

        }
        else{
            [self.navigationController pushViewController:[[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureVC"] animated:YES];
        }
    }
    else{
        [self.navigationController pushViewController:[[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureVC"] animated:YES];   
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}  

#pragma mark -
#pragma mark IBActions

- (IBAction)tryBeintoo
{    
        @try {
            if ([BeintooNetwork connectedToNetwork]) {
                [BLoadingView startActivity:homeView];
            }
            [_user getUserByUDID];
        }
        @catch (NSException * e) {
        }
}


#pragma mark -
#pragma mark player delegate

- (void)didGetUserByUDID:(NSMutableArray *)result
{
	@synchronized(self){
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo setLastLoggedPlayers:(NSArray *)result];
#else
        [Beintoo setLastLoggedPlayers:[(NSArray *)result retain]];
#endif
        
        [BLoadingView stopActivity]; 
        
        if ([BeintooDevice isiPad]){
            [Beintoo launchIpadLogin];
        }
        else {
            BeintooLoginVC *signinVC            = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
            
            UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
            BNavigationController *signinNavController = [[BNavigationController alloc] initWithRootViewController:signinVC];
            [[signinNavController navigationBar] setTintColor:barColor];
  
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
            [self presentViewController:signinNavController animated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [self presentViewController:signinNavController animated:YES completion:nil];
            else  [self presentModalViewController:signinNavController animated:YES];
#else
            [self presentModalViewController:signinNavController animated:YES];
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
            [signinVC release];
            [signinNavController release];
#endif
        }
     }
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result
{
	@try {
        if ([result objectForKey:@"user"] != nil) {
			[Beintoo setBeintooPlayer:result];
			userNick.text  = [[Beintoo getUserIfLogged]objectForKey:@"nickname"];
			bedollars.text = [NSString stringWithFormat:@"%.2f Bedollars",[[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue]];
			
			[BeintooMessage setTotalMessages:[[result objectForKey:@"user"]objectForKey:@"messages"]];
			[BeintooMessage setUnreadMessages:[[result objectForKey:@"user"]objectForKey:@"unreadMessages"]];

            // Alliance check
            if ([result objectForKey:@"alliance"] != nil) {
                [BeintooAlliance setUserWithAlliance:YES];
            }else{
                [BeintooAlliance setUserWithAlliance:NO];
            }
            
            // Notification Checking 
            if ([result objectForKey:@"unreadNotification"] != nil) {
                notificationNumbersLabel.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"unreadNotification"]];
                notificationNumbersLabelLandscape.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"unreadNotification"]];
            }
            
            [_user getFriendsByExtid];
		}
	}
	@catch (NSException * e) {
	}
}

- (void)didGetFriendsByExtid:(NSMutableArray *)result
{
    [Beintoo setBeintooUserFriends:(NSArray *)result];
}

- (void)dismissFeatureSignupView
{
    UIView *featureView = [self.view viewWithTag:3333];
    [featureView removeFromSuperview];
}

/*#ifdef UI_USER_INTERFACE_IDIOM
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[Beintoo dismissBeintoo];
}
#endif*/

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _user.delegate         = nil;  
    beintooPlayer.delegate = nil;  
    
    @try {
       UIView *featureView = [self.view viewWithTag:3333];
        [featureView removeFromSuperview];
       
	}
	@catch (NSException * e) {
    }
    
    @try {
        [BLoadingView stopActivity];
        for (UIView *view in [self.view subviews]) {
            if([view isKindOfClass:[BLoadingView class]]){
                [view removeFromSuperview];
            }
        }
	}
	@catch (NSException * e) {
	}
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationSignupClosed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationReloadDashboard object:nil];
    
    _user.delegate = nil;
    beintooPlayer.delegate = nil;

#ifdef BEINTOO_ARC_AVAILABLE
#else
    if ([beintooPlayer retainCount] > 0)
        [beintooPlayer release];
    
    if ([_user retainCount] > 0)
        [_user release];
    
	[featuresArray release];
	[messagesVC release];
	[beintooProfileVC release];
	[beintooLeaderboardVC release];
	[beintooWalletVC release];
	[beintooChallengesVC release];
	[beintooAchievementsVC release];
    [tipsAndForumVC release];
	[loginVC release];
    [signupViewForPlayers release];
    [beintooBestoreVC release];
    
    [super dealloc];
#endif
    
}

@end
