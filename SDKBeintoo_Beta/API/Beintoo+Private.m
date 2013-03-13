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

#import "Beintoo+Private.h"

@implementation Beintoo (Private)

static Beintoo* _sharedBeintoo              = nil;
static NSString	*apiBaseUrl                 = @"https://api.beintoo.com/api/rest";
static NSString	*sandboxBaseUrl             = @"https://sandbox-elb.beintoo.com/api/rest";

static NSString	*displayBaseUrl             = @"http://display.beintoo.com/api/rest";
static NSString	*sandboxDisplayBaseUrl      = @"http://display-sand.beintoo.com/api/rest";

NSString *BeintooActiveFeatures             = @"ActiveFeatures";
NSString *BeintooAppOrientation             = @"AppOrientation";
NSString *BeintooForceRegistration          = @"ForceRegistration";
NSString *BeintooApplicationWindow          = @"ApplicationWindow";
NSString *BeintooAchievementNotification    = @"BeintooAchievementNotification";
NSString *BeintooLoginNotification          = @"BeintooLoginNotification";
NSString *BeintooScoreNotification          = @"BeintooScoreNotification";
NSString *BeintooNoRewardNotification       = @"BeintooNoRewardNotification";
NSString *BeintooNotificationPosition       = @"BeintooNotificationPosition";
NSString *BeintooDismissAfterRegistration   = @"BeintooDismissAfterRegistration";
NSString *BeintooTryBeintooWithRewardImage  = @"BeintooTryBeintooWithRewardImage";

NSInteger BeintooNotificationPositionTop    = 1;
NSInteger BeintooNotificationPositionBottom = 2;

// BNS = BeintooNSUserDefaults
NSString *BNSDefLastLoggedPlayers           = @"beintooLastLoggedPlayers"; 
NSString *BNSDefLoggedPlayer                = @"NSLoggedPlayer";
NSString *BNSDefLoggedUser                  = @"NSLoggedUser";
NSString *BNSDefIsUserLogged                = @"beintooIsUserLogged";
NSString *BNSDefForceTryBeintoo             = @"beintooIsForceTryBeintoo";
NSString *BNSDefUserAgent                   = @"beintooDeviceUserAgent";
NSString *BNSDefDeveloperCurrencyName       = @"beintooDeveloperCurrencyName";
NSString *BNSDefDeveloperCurrencyValue      = @"beintooDeveloperCurrencyValue";
NSString *BNSDefDeveloperLoggedUserId       = @"beintooDeveloperLoggedUserId";
NSString *BNSDefUserFriends                 = @"beintooUserFriends";

NSString *BeintooSdkVersion                 = @"2.9.2beta-ios";

NSString *BeintooNotificationSignupClosed           = @"BeintooSignupClosed";
NSString *BeintooNotificationOrientationChanged     = @"BeintooOrientationChanged";
NSString *BeintooNotificationReloadDashboard        = @"BeintooReloadDashboard";
NSString *BeintooNotificationReloadFriendsList      = @"BeintooReloadFriendsList";
NSString *BeintooNotificationChallengeSent          = @"BeintooChallengeSent";
NSString *BeintooNotificationCloseBPickerView       = @"BeintooCloseBPickerView";

#pragma mark - Init methods

+ (Beintoo *)sharedInstance
{
	@synchronized([Beintoo class]){
		return _sharedBeintoo;
	}
}

+ (id)alloc
{
	@synchronized([Beintoo class])
	{
		NSAssert(_sharedBeintoo == nil, @"Attempted to allocate a second instance of Beintoo singleton.");
		_sharedBeintoo = [super alloc];
		return _sharedBeintoo;
	}
	return nil;
}

+ (id)init
{
    if (self == [super init])
	{
	}
    return self;
}

+ (void)createSharedBeintoo
{
	
#ifdef BEINTOO_ARC_AVAILABLE
    @autoreleasepool {
#else
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
	
	_sharedBeintoo = [[Beintoo alloc] init];
	Beintoo *beintooInstance	= [Beintoo sharedInstance];
	
	beintooInstance->apiKey                 = [[NSString alloc] init];
	beintooInstance->apiSecret              = [[NSString alloc] init];
	beintooInstance->locationManager        = [[CLLocationManager alloc] init];
	beintooInstance->userLocation           = nil;
    
    beintooInstance->prizeView              = [[BPrize alloc] init];
    beintooInstance->adView                 = [[BPrize alloc] init];
    beintooInstance->giveBedollarsView      = [[BTemplateGiveBedollars alloc] init];
    
    beintooInstance->prizeView.alpha            = 0.0;
    beintooInstance->adView.alpha               = 0.0;
    beintooInstance->giveBedollarsView.alpha    = 0.0;
    
    beintooInstance->prizeView.isVisible            = NO;
    beintooInstance->adView.isVisible               = NO;
    beintooInstance->giveBedollarsView.isVisible    = NO;

    beintooInstance->missionView            = [[BMissionView alloc] init];
	beintooInstance->lastLoggedPlayers      = [[NSArray alloc] init];
	beintooInstance->featuresArray          = [[NSArray alloc] init];
	beintooInstance->notificationView       = [[BMessageAnimated alloc]init];
    beintooInstance->lastRetrievedMission   = [[NSDictionary alloc] init];
    
    beintooInstance->notificationQueue      = [[BAnimatedNotificationQueue alloc] init];
 
    beintooInstance->beintooDispatchQueue   = dispatch_queue_create("com.Beintoo.beintooQueue", NULL);
    
    beintooInstance->beintooBestoreVC                   = [[BeintooBestoreVC alloc] init];
    beintooInstance->beintooWalletViewController        = [[BeintooWalletVC alloc] init];
    beintooInstance->beintooLeaderboardWithContestVC    = [[BeintooLeaderboardContestVC alloc] init];
    beintooInstance->beintooLeaderboardVC               = [[BeintooLeaderboardVC alloc] init];

#ifdef BEINTOO_ARC_AVAILABLE
    }
#else
    [pool release];
#endif
	
}

+ (BOOL)isBeintooInitialized
{
	if ([Beintoo sharedInstance] != nil) {
		return YES;
	}
	return NO;
}

+ (void)setApiKey:(NSString *)_apikey andApisecret:(NSString *)_apisecret
{
	Beintoo *beintooInstance	= [Beintoo sharedInstance];
    
#ifdef BEINTOO_ARC_AVAILABLE
    beintooInstance->apiKey		= _apikey;
	beintooInstance->apiSecret	= _apisecret;
#else
    beintooInstance->apiKey		= [_apikey retain];
    beintooInstance->apiSecret	= [_apisecret retain];
#endif
	
}

+ (void)initBeintooSettings:(NSDictionary *)_settings{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	
	[Beintoo setAppOrientation:(int)[[_settings objectForKey:BeintooAppOrientation] intValue]];
	[Beintoo setForceRegistration:(BOOL)[[_settings objectForKey:BeintooForceRegistration] boolValue]];
    [Beintoo setShowAchievementNotificatio:(BOOL)[[_settings objectForKey:BeintooAchievementNotification] boolValue]];
    [Beintoo setShowLoginNotification:(BOOL)[[_settings objectForKey:BeintooLoginNotification] boolValue]];
    [Beintoo setShowScoreNotification:(BOOL)[[_settings objectForKey:BeintooScoreNotification] boolValue]];
    [Beintoo setShowNoRewardNotification:(BOOL)[[_settings objectForKey:BeintooNoRewardNotification] boolValue]];
    [Beintoo setDismissBeintooAfterRegistration:(BOOL)[[_settings objectForKey:BeintooDismissAfterRegistration] boolValue]];
    [Beintoo setNotificationPosition:(NSInteger)[[_settings objectForKey:BeintooNotificationPosition] integerValue]];
    
	beintooInstance->featuresArray = (NSArray *)[[_settings objectForKey:BeintooActiveFeatures] copy];
	[Beintoo setApplicationWindow:(UIWindow *)[_settings objectForKey:BeintooApplicationWindow]];
}

- (void)initDelegates
{
	[Beintoo sharedInstance]->prizeView.delegate            = self;
    [Beintoo sharedInstance]->adView.delegate               = self;
    [Beintoo sharedInstance]->giveBedollarsView.delegate    = self;
    [Beintoo sharedInstance]->missionView.delegate          = self;
}

+ (void)initLocallySavedScoresArray
{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedScores"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"locallySavedScores"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)initLocallySavedAchievementsArray
{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedAchievements"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"locallySavedAchievements"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)initUserAgent
{
    UIWebView   *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [webView release];
#endif
    
    [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:BNSDefUserAgent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - API Services

+ (void)initAPI
{
	[Beintoo sharedInstance]->restBaseUrl = apiBaseUrl;
    [Beintoo sharedInstance]->displayBaseUrl = displayBaseUrl;
	[Beintoo sharedInstance]->isOnSandbox = NO;
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
}

+ (void)initVgoodService
{
	if ([Beintoo sharedInstance]->beintooVgoodService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooVgoodService = nil;
#else
        [[Beintoo sharedInstance]->beintooVgoodService release];
#endif
        
	}
    
	[Beintoo sharedInstance]->beintooVgoodService = [[BeintooVgood alloc] init];
	BeintooLOG(@"Vgood API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooVgoodService restResource]);
}

+ (void)initPlayerService
{
	if ([Beintoo sharedInstance]->beintooPlayerService != nil) {

#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooPlayerService = nil;
#else
        [[Beintoo sharedInstance]->beintooPlayerService release];
#endif
        
	}
    [Beintoo sharedInstance]->beintooPlayerService = [[BeintooPlayer alloc] init];
	BeintooLOG(@"Player API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooPlayerService restResource]);
}

+ (void)initUserService
{
	if ([Beintoo sharedInstance]->beintooUserService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooUserService = nil;
#else
        [[Beintoo sharedInstance]->beintooUserService release];
#endif
        
    }
    
	[Beintoo sharedInstance]->beintooUserService = [[BeintooUser alloc] init];
	BeintooLOG(@"User API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooUserService restResource]);
}

+ (void)initAchievementsService
{
	if ([Beintoo sharedInstance]->beintooAchievementsService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooAchievementsService = nil;
#else
        [[Beintoo sharedInstance]->beintooAchievementsService release];
#endif
        
	}
    
	[Beintoo sharedInstance]->beintooAchievementsService = [[BeintooAchievements alloc] init];
	BeintooLOG(@"Achievements API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooAchievementsService restResource]);
}

+ (void)initBestoreService{
	if ([Beintoo sharedInstance]->beintooBestoreService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooBestoreService = nil;
#else
        [[Beintoo sharedInstance]->beintooBestoreService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooBestoreService = [[BeintooBestore alloc] init];
	BeintooLOG(@"Bestore API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooBestoreService restResource]);
}

+ (void)initAppService{
	if ([Beintoo sharedInstance]->beintooAppService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooAppService = nil;
#else
        [[Beintoo sharedInstance]->beintooAppService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooAppService = [[BeintooApp alloc] init];
	BeintooLOG(@"App API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooAppService restResource]);
}

+ (void)initAdService{
	if ([Beintoo sharedInstance]->beintooAdService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooAdService = nil;
#else
        [[Beintoo sharedInstance]->beintooAdService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooAdService = [[BeintooAd alloc] init];
	BeintooLOG(@"Ad API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooAdService restResource]);
}

+ (void)initRewardService{
	if ([Beintoo sharedInstance]->beintooRewardService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooRewardService = nil;
#else
        [[Beintoo sharedInstance]->beintooRewardService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooRewardService = [[BeintooReward alloc] init];
	BeintooLOG(@"Reward API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooRewardService restResource]);
}

#pragma mark - Init Controllers

+ (void)initMainController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->mainController             = [[BeintooMainController alloc] init];
	beintooInstance->mainController.view.alpha  = 0;
}

+ (void)initMainAdController{
	Beintoo *beintooInstance                        = [Beintoo sharedInstance];
	beintooInstance->mainAdController               = [[BeintooMainController alloc] init];
	beintooInstance->mainAdController.view.alpha    = 0;
}

+ (void)initMainNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->mainNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->mainNavigationController setType:NAV_TYPE_MAIN];
    [[beintooInstance->mainNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initBestoreNavigationController{
	Beintoo *beintooInstance                        = [Beintoo sharedInstance];
	beintooInstance->bestoreNavigationController    = [[BeintooNavigationController alloc] init];
    [beintooInstance->bestoreNavigationController setType:NAV_TYPE_BESTORE];
    [[beintooInstance->bestoreNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initLeaderboardNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->leaderboardNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->leaderboardNavigationController setType:NAV_TYPE_LEADERBOARD];
    [[beintooInstance->leaderboardNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initAchievementsNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->achievementsNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->achievementsNavigationController setType:NAV_TYPE_ACHIEVEMENTS];
    [[beintooInstance->achievementsNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initMyOffersNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->myoffersNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->myoffersNavigationController setType:NAV_TYPE_MYOFFERS];
    [[beintooInstance->myoffersNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initNotificationsNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->notificationsNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->notificationsNavigationController setType:NAV_TYPE_NOTIFICATIONS];
    [[beintooInstance->notificationsNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initSignupNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->signupNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->signupNavigationController setType:NAV_TYPE_SIGNUP];
    [[beintooInstance->signupNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initPrivateNotificationsNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->privateNotificationsNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->privateNotificationsNavigationController setType:NAV_TYPE_NOTIFICATIONS_PRIVATE];
    [[beintooInstance->privateNotificationsNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initPrivateSignupNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->privateSignupNavigationController   = [[BeintooNavigationController alloc] init];
    [beintooInstance->privateSignupNavigationController setType:NAV_TYPE_SIGNUP_PRIVATE];
    [[beintooInstance->privateSignupNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initVgoodNavigationController{
	// This navigation controller is not initialized with a Root Controller.
	// The root controller will change based on the type of vgood (Single, Multiple, Recommendation)
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->vgoodNavigationController = [BeintooVgoodNavController alloc];
	[[beintooInstance->vgoodNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initAdNavigationController{
	// This navigation controller is not initialized with a Root Controller.
	// The root controller will change based on the type of vgood (Single, Multiple, Recommendation)
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->adNavigationController = [BeintooVgoodNavController alloc];
	[[beintooInstance->adNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initiPadController{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->ipadController = [[BeintooiPadController alloc] init];
	beintooInstance->ipadController.view.alpha = 0;
}

+ (void)initPopoversForiPad{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->homePopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->homePopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->homePopover setPopoverContentSize:CGSizeMake(320, 455)];
	
	beintooInstance->loginPopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->loginPopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->loginPopover setPopoverContentSize:CGSizeMake(320, 455)];
    
	beintooInstance->vgoodPopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->vgoodPopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->vgoodPopover setPopoverContentSize:CGSizeMake(320, 455)];
    
	beintooInstance->recommendationPopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->recommendationPopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->recommendationPopover setPopoverContentSize:CGSizeMake(320, 455)];
}

#pragma mark - Private methods

+ (void)setAppOrientation:(int)_appOrientation{
    [Beintoo sharedInstance]->appOrientation = _appOrientation;
	BeintooLOG(@"Beintoo: new App orientation set: %d",[Beintoo sharedInstance]->appOrientation);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationOrientationChanged object:self];
}
     
+ (void)setApplicationWindow:(UIWindow *)_window
{
	if (_window != nil) {
		[Beintoo sharedInstance]->applicationWindow = _window;
	}
}

+ (UIWindow *)getApplicationWindow
{
	if ([Beintoo sharedInstance]->applicationWindow != nil) {
		return [Beintoo sharedInstance]->applicationWindow;
	}
	
	NSArray *developerApplicationWindows = [[UIApplication sharedApplication] windows];
	
	NSAssert([developerApplicationWindows count] > 0, @"Beintoo - To launch Beintoo your application needs at least one window!");
	UIWindow* appKeyWindow = [[UIApplication sharedApplication] keyWindow];
	if (!appKeyWindow){
		BeintooLOG(@"Beintoo - No keyWindow found on this app. Beintoo will use the first UIWindow on the stack of app windows."); 
		appKeyWindow = [developerApplicationWindows objectAtIndex:0];
	}
	return appKeyWindow;
}

+ (NSString *)getLastTimeForTryBeintooShowTimestamp
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefForceTryBeintoo];
}

+ (void)setLastTimeForTryBeintooShowTimestamp:(NSString *)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:BNSDefForceTryBeintoo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setForceRegistration:(BOOL)_value
{
	[Beintoo sharedInstance]->forceRegistration = _value;
}

+ (void)setShowAchievementNotificatio:(BOOL)_value
{
    [Beintoo sharedInstance]->showAchievementNotification = _value;
}

+ (void)setShowLoginNotification:(BOOL)_value
{
    [Beintoo sharedInstance]->showLoginNotification = _value;
}

+ (void)setShowScoreNotification:(BOOL)_value
{
    [Beintoo sharedInstance]->showScoreNotification = _value;
}

+ (void)setShowNoRewardNotification:(BOOL)_value
{
    [Beintoo sharedInstance]->showNoRewardNotification = _value;
}

+ (void)setDismissBeintooAfterRegistration:(BOOL)_value
{
    [Beintoo sharedInstance]->dismissBeintooAfterRegistration = _value;    
}

+ (void)setNotificationPosition:(NSInteger)_value
{
    [Beintoo sharedInstance]->notificationPosition  = _value;
}

+ (void)setForceTryBeintoo:(BOOL)_value
{
    [Beintoo sharedInstance]->forceTryBeintoo  = _value;
}

+ (void)setTryBeintooImageTypeReward:(BOOL)_value
{
    [Beintoo sharedInstance]->tryBeintooImageTypeReward = _value;
}

+ (void)_setIsStatusBarHiddenOnApp:(BOOL)_value
{
    [Beintoo sharedInstance]->statusBarHiddenOnApp = _value;
}

#pragma mark - Production/Sandbox environments

+ (void)switchToSandbox
{
	BeintooLOG(@"Beintoo: Going to sandbox");
    [Beintoo sharedInstance]->restBaseUrl = apiBaseUrl;
    [Beintoo sharedInstance]->displayBaseUrl = displayBaseUrl;
	[Beintoo sharedInstance]->isOnSandbox = YES;
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
    [Beintoo initVgoodService];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
}

+ (void)privateSandbox
{
	BeintooLOG(@"Beintoo: Going to private sandbox");
	[Beintoo sharedInstance]->restBaseUrl = sandboxBaseUrl;
    [Beintoo sharedInstance]->displayBaseUrl = sandboxDisplayBaseUrl;
	[Beintoo sharedInstance]->isOnPrivateSandbox = YES;
    [Beintoo sharedInstance]->isOnSandbox = NO;
	[Beintoo initVgoodService];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
}

+ (void)production
{
	BeintooLOG(@"Beintoo: Going to production");
    [self initAPI];
	[Beintoo initVgoodService];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
}

#pragma mark - StatusBar management

+ (void)manageStatusBarOnLaunch
{
    [Beintoo _setIsStatusBarHiddenOnApp:[[UIApplication sharedApplication] isStatusBarHidden]];
    
    if (![BeintooDevice isiPad]){
        if (![Beintoo isStatusBarHiddenOnApp]){
            if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden: withAnimation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
            BeintooLOG(@"Beintoo Status Bar Management: status bar temporarily hidden");
        }
    }
}

+ (void)manageStatusBarOnDismiss
{
    if (![BeintooDevice isiPad]){
        if (![Beintoo isStatusBarHiddenOnApp]){
            if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden: withAnimation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
            BeintooLOG(@"Beintoo Status Bar Management: status bar is visible again");
        }
    }
}

#pragma mark - Launch and Dismiss methods

+ (void)_launchBeintooOnApp
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
	id <BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance               = [Beintoo sharedInstance];
    
    [Beintoo initMainNavigationController];
    
    beintooInstance->beintooPanelRootViewController     = [[BeintooVC alloc] init];
    beintooInstance->mainNavigationController           = [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooPanelRootViewController];

#ifdef BEINTOO_ARC_AVAILABLE

#else
    [[Beintoo sharedInstance]->beintooPanelRootViewController release];
#endif
	    
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
    
    [Beintoo manageStatusBarOnLaunch];
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
		BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
				
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
				
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showBeintooPopover];
	}
}

+ (void)_launchBeintooOnAppWithDeveloperCurrencyValue:(float)_value
{
    [self _setDeveloperCurrencyValue:_value];
	[self _launchBeintooOnApp];
}

+ (void)_launchNotificationsOnApp
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
	id <BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance              = [Beintoo sharedInstance];
    
    [Beintoo initNotificationsNavigationController];
    
    beintooInstance->beintooNotificationsVC     = [[BeintooNotificationListVC alloc] init];
    beintooInstance->notificationsNavigationController = [beintooInstance->notificationsNavigationController initWithRootViewController:beintooInstance->beintooNotificationsVC];
	
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
    
    [Beintoo manageStatusBarOnLaunch];
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
		BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->notificationsNavigationController;
        
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		//[_iPadController showNotificationsPopover];
	}
}

+ (void)_launchMarketplaceOnApp
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    
    [Beintoo initMainNavigationController];
    
    beintooInstance->beintooBestoreVC = [[BeintooBestoreVC alloc] initWithNibName:@"BeintooBestoreVC" bundle:[NSBundle mainBundle]];
    
    beintooInstance->mainNavigationController = [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooBestoreVC];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [beintooInstance->beintooBestoreVC release];
#endif
    
    [Beintoo manageStatusBarOnLaunch];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
	
	if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod        
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showBestorePopover];
	}
}

+ (void)_launchMarketplaceOnAppWithDeveloperCurrencyValue:(float)_value
{
    [self _setDeveloperCurrencyValue:_value];
	[self _launchMarketplaceOnApp];
}

+ (void)_launchWalletOnApp
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	Beintoo *beintooInstance = [Beintoo sharedInstance];
    [Beintoo initMainNavigationController];
    
    beintooInstance->beintooWalletViewController  = [[BeintooWalletVC alloc] initWithNibName:@"BeintooWalletVC" bundle:[NSBundle mainBundle]];
    beintooInstance->mainNavigationController = [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooWalletViewController];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [beintooInstance->beintooWalletViewController release];
#endif
    
    [Beintoo manageStatusBarOnLaunch];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
        [_mainDelegate beintooWillAppear];
    }
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
        [_mainNavController prepareBeintooPanelOrientation];
        [[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
        [_mainNavController show];
    }
    else {  // ----------- iPad
        BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
        [_iPadController preparePopoverOrientation];
        [[Beintoo getApplicationWindow] addSubview:_iPadController.view];
        [_iPadController showMyOffersPopover];
    }
}

+ (void)_launchAchievementsOnApp
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	Beintoo *beintooInstance = [Beintoo sharedInstance];
    
    [Beintoo initMainNavigationController];
    
    BeintooAchievementsVC *achievementsVC = [[BeintooAchievementsVC alloc] initWithNibName:@"BeintooAchievementsVC" bundle:[NSBundle mainBundle]];
    beintooInstance->mainNavigationController = [beintooInstance->mainNavigationController initWithRootViewController:achievementsVC];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [achievementsVC release];
#endif
    
    [Beintoo manageStatusBarOnLaunch];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
        [_mainDelegate beintooWillAppear];
    }
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
        [_mainNavController prepareBeintooPanelOrientation];
        [[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
        [_mainNavController show];
    }
    else {  // ----------- iPad
        BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
        [_iPadController preparePopoverOrientation];
        [[Beintoo getApplicationWindow] addSubview:_iPadController.view];
        [_iPadController showAchievementsPopover];
    }
}

+ (void)_launchLeaderboardOnApp
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    [Beintoo initMainNavigationController];
    BeintooLeaderboardVC *leaderboardVC = [[BeintooLeaderboardVC alloc] initWithNibName:@"BeintooLeaderboardVC" bundle:[NSBundle mainBundle]];
    beintooInstance->mainNavigationController = [beintooInstance->mainNavigationController initWithRootViewController:leaderboardVC];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [leaderboardVC release];
#endif
    
    [Beintoo manageStatusBarOnLaunch];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
        [_mainDelegate beintooWillAppear];
    }
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
        [_mainNavController prepareBeintooPanelOrientation];
        [[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
        [_mainNavController show];
    }
    else {  // ----------- iPad
        BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
        [_iPadController preparePopoverOrientation];
        [[Beintoo getApplicationWindow] addSubview:_iPadController.view];
        [_iPadController showBestorePopover];
    }
}

+ (void)_launchPrizeOnApp
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    
    if (_prizeView.isVisible == NO){
        if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
            [_mainDelegate beintooPrizeAlertWillAppear];
        }
        
        [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:_prizeView];
        
        if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
            [_mainDelegate beintooPrizeAlertDidAppear];
        }	
        [_prizeView setIsVisible:YES];
    }
}

+ (void)_launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    
    if (_prizeView.isVisible == NO){
        _prizeView.globalDelegate = _beintooPrizeDelegate;
    
        if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
            [_beintooPrizeDelegate beintooPrizeAlertWillAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
            [_mainDelegate beintooPrizeAlertWillAppear];
        }
        
        [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:_prizeView];
        
        if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
            [_beintooPrizeDelegate beintooPrizeAlertDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
            [_mainDelegate beintooPrizeAlertDidAppear];
        }
        [_prizeView setIsVisible:YES];
    }    
}

+ (void)_launchAd
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	BPrize	*_adView = [Beintoo sharedInstance]->adView;
    
    if (_adView.isVisible == NO){
        if ([_mainDelegate respondsToSelector:@selector(beintooAdWillAppear)]) {
            [_mainDelegate beintooAdWillAppear];
        }
        
        [_adView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:_adView];
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdDidAppear)]) {
            [_mainDelegate beintooAdDidAppear];
        }
        [_adView setIsVisible:YES];
    }
}

+ (void)_launchAdWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BPrize	*_prizeView = [Beintoo sharedInstance]->adView;
    
    if (_prizeView.isVisible == NO){
        _prizeView.globalDelegate = _beintooPrizeDelegate;
        
        if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooAdWillAppear)]) {
            [_beintooPrizeDelegate beintooAdWillAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdWillAppear)]) {
            [_mainDelegate beintooAdWillAppear];
        }
        
        [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:_prizeView];
        
        if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooAdDidAppear)]) {
            [_beintooPrizeDelegate beintooAdDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdDidAppear)]) {
            [_mainDelegate beintooAdDidAppear];
        }
        [_prizeView setIsVisible:YES];
    }
}

+ (void)_launchGiveBedollarsWithDelegate:(id<BTemplateGiveBedollarsDelegate>)_delegate position:(int)position
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BTemplateGiveBedollars	*template = [Beintoo sharedInstance]->giveBedollarsView;
    
    if (template.isVisible == NO){
        template.notificationPosition = position;
        
        template.globalDelegate = _delegate;
        
        if ([_delegate respondsToSelector:@selector(beintooGiveBedollarsWillAppear)]) {
            [_delegate beintooGiveBedollarsWillAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsWillAppear)]) {
            [_mainDelegate beintooGiveBedollarsWillAppear];
        }
        
        [template setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:template];
        
        if ([_delegate respondsToSelector:@selector(beintooGiveBedollarsDidAppear)]) {
            [_delegate beintooGiveBedollarsDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsDidAppear)]) {
            [_mainDelegate beintooGiveBedollarsDidAppear];
        }
        [template setIsVisible:YES];
    }
}

- (void)dismissGiveBedollars
{    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplateGiveBedollars	*_prizeView = [Beintoo sharedInstance]->giveBedollarsView;
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsWillDisappear)]) {
		[[_prizeView globalDelegate] beintooGiveBedollarsWillDisappear];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsWillDisappear)]) {
		[_mainDelegate beintooGiveBedollarsWillDisappear];
	}
    
	if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsDidDisappear)]) {
		[[_prizeView globalDelegate] beintooGiveBedollarsDidDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsDidDisappear)]) {
		[_mainDelegate beintooGiveBedollarsDidDisappear];
	}
    
    [_prizeView setIsVisible:NO];
}

+ (void)_launchMissionOnApp
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BMissionView	*_missionView = [Beintoo sharedInstance]->missionView;
	
    [Beintoo manageStatusBarOnLaunch];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
	
	[_missionView setMissionContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
	[[Beintoo getApplicationWindow] addSubview:_missionView];
	[_missionView show];
	
	if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
		[_mainDelegate beintooDidAppear];
	}	
}

+ (void)_launchSignupOnApp
{
    if ([Beintoo isUserLogged]){
        [Beintoo playerLogout];
    }
    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    [Beintoo initMainNavigationController];
    beintooInstance->beintooPanelRootViewController     = [[BeintooVC alloc] init];
    beintooInstance->beintooPanelRootViewController.forceSignup = YES;
    
    beintooInstance->mainNavigationController = [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooPanelRootViewController];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [[Beintoo sharedInstance]->beintooPanelRootViewController release];
#endif
    
    [Beintoo manageStatusBarOnLaunch];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
        [_mainDelegate beintooWillAppear];
    }
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
        [_mainNavController prepareBeintooPanelOrientation];
        [[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
        _mainNavController.isSignupDirectLaunch = YES;
        [_mainNavController show];
    }
    else {  // ----------- iPad
        BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
        [_iPadController preparePopoverOrientation];
        [[Beintoo getApplicationWindow] addSubview:_iPadController.view];
        [_iPadController showBeintooPopover];
    }
}

+ (void)_launchPrivateNotificationsOnApp
{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
    [Beintoo initPrivateSignupNavigationController];
    
    [Beintoo initPrivateNotificationsNavigationController];
    
     beintooInstance->beintooNotificationsVC     = [[BeintooNotificationListVC alloc] init];
    beintooInstance->privateNotificationsNavigationController = [beintooInstance->privateNotificationsNavigationController initWithRootViewController:beintooInstance->beintooNotificationsVC];

    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod        
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->privateNotificationsNavigationController;
        
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showPrivateNotificationsPopover];
	}
}

+ (void)_launchPrivateSignupOnApp
{
	Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    
    [Beintoo initPrivateSignupNavigationController];
    
    BeintooLoginVC *beintooLoginVC = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    beintooInstance->privateSignupNavigationController = [beintooInstance->privateSignupNavigationController initWithRootViewController:beintooLoginVC];
    
    if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod        
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->privateSignupNavigationController;
        
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showPrivateSignupPopover];
	}
}

+ (void)_launchIpadLogin
{
	if ([BeintooDevice isiPad]) {
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController showLoginPopover];
	}
}

+ (void)_dismissIpadLogin
{
	if ([BeintooDevice isiPad]) {
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController hideLoginPopover];
	}	
}

+ (void)_launchIpadNotifications
{
	if ([BeintooDevice isiPad]) {
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController showPrivateNotificationsPopover];
	}
}

+ (void)_dismissIpadNotifications
{
	if ([BeintooDevice isiPad]) {
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController hidePrivateNotificationsPopover];
	}
}

+ (void)_dismissBeintoo
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
		
    [Beintoo manageStatusBarOnDismiss];
    
    BeintooNavigationController *_mainController = [Beintoo sharedInstance]->mainNavigationController;
    
	if (![BeintooDevice isiPad]) { // iPhone-iPod
				
		[_mainController popToRootViewControllerAnimated:NO];
		[_mainController hide];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.popoverController dismissPopoverAnimated:NO];
		
        [_iPadController hideBeintooPopover];
	}
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [_mainController release];
#endif
    
}

+ (void)_dismissSignup
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
    
    [Beintoo manageStatusBarOnDismiss];
    
	if (![BeintooDevice isiPad]) { // iPhone-iPod
        
		BeintooNavigationController *_mainController = [Beintoo sharedInstance]->signupNavigationController;
        
        [_mainController hide];
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [_mainController release];
#endif

	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.popoverController dismissPopoverAnimated:NO];
		if (_iPadController.isLoginOngoing) {
			[_iPadController.loginPopoverController dismissPopoverAnimated:NO];
		}
		[_iPadController hideSignupPopover];
	}
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [[Beintoo sharedInstance]->beintooPanelRootViewController release];
#endif
    
}

+ (void)_dismissBeintoo:(int)type
{    
        id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
        
        if (!(type == NAV_TYPE_SIGNUP_PRIVATE || type == NAV_TYPE_NOTIFICATIONS_PRIVATE)){
            if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
                [_mainDelegate beintooWillDisappear];
            }
            [Beintoo manageStatusBarOnDismiss];
        }
        
        BeintooNavigationController *mainController;
        
        if (![BeintooDevice isiPad]) { // iPhone-iPod
            
            if (type == NAV_TYPE_BESTORE)
                mainController = [Beintoo sharedInstance]->bestoreNavigationController;
            else if (type == NAV_TYPE_LEADERBOARD)
                mainController = [Beintoo sharedInstance]->leaderboardNavigationController;
            else if (type == NAV_TYPE_ACHIEVEMENTS)
                mainController = [Beintoo sharedInstance]->achievementsNavigationController;
            else if (type == NAV_TYPE_MYOFFERS)
                mainController = [Beintoo sharedInstance]->myoffersNavigationController;
            else if (type == NAV_TYPE_NOTIFICATIONS)
                mainController = [Beintoo sharedInstance]->notificationsNavigationController;
            else if (type == NAV_TYPE_SIGNUP){
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [[Beintoo sharedInstance]->beintooPanelRootViewController release];
#endif
                
                mainController = [Beintoo sharedInstance]->signupNavigationController;
            }
            else if (type == NAV_TYPE_SIGNUP_PRIVATE)
                mainController = [Beintoo sharedInstance]->privateSignupNavigationController;
            else if (type == NAV_TYPE_NOTIFICATIONS_PRIVATE)
                mainController = [Beintoo sharedInstance]->privateNotificationsNavigationController;
            else if (type == NAV_TYPE_MAIN){
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [[Beintoo sharedInstance]->beintooPanelRootViewController release];
#endif
                
                mainController = [Beintoo sharedInstance]->mainNavigationController;
            }
            
            [mainController hide];
            
#ifdef BEINTOO_ARC_AVAILABLE
            
#else
            [mainController release];
#endif
        
        }
        else {  // ----------- iPad
            
            BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
            
            [_iPadController.popoverController dismissPopoverAnimated:NO];
            
            if (type == NAV_TYPE_BESTORE)
                [_iPadController hideBestorePopover];
            else if (type == NAV_TYPE_LEADERBOARD)
                [_iPadController hideLeaderboardPopover];
            else if (type == NAV_TYPE_ACHIEVEMENTS)
                [_iPadController hideAchievementsPopover];
            else if (type == NAV_TYPE_MYOFFERS)
                [_iPadController hideMyOffersPopover];
            else if (type == NAV_TYPE_NOTIFICATIONS)
                [_iPadController hideNotificationsPopover];
            else if (type == NAV_TYPE_SIGNUP)
                [_iPadController hideSignupPopover];
            else if (type == NAV_TYPE_NOTIFICATIONS_PRIVATE)
                [_iPadController hidePrivateNotificationsPopover];
            else if (type == NAV_TYPE_SIGNUP_PRIVATE)
                [_iPadController hidePrivateSignupPopover];
            else if (type == NAV_TYPE_MAIN)
                [_iPadController hideBeintooPopover];
        }
}

/*
 * Dismiss not animated: immediately remove the Beintoo view (no animation, behaviour similar to 
 * [UIViewController dismissModalViewControllerAnimated:NO]
 */

+ (void)_dismissBeintooNotAnimated
{
    [Beintoo manageStatusBarOnDismiss];

    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
    
	if (![BeintooDevice isiPad]) { // iPhone-iPod
        
		BeintooNavigationController *_mainController = [Beintoo sharedInstance]->mainNavigationController;
		[_mainController hideNotAnimated];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.popoverController dismissPopoverAnimated:NO];
		if (_iPadController.isLoginOngoing) {
			[_iPadController.loginPopoverController dismissPopoverAnimated:NO];
		}
		[_iPadController hideBeintooPopover];
	}
}

+ (void)_dismissMission
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
	
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
		[_mainController hideMissionVgoodNavigationController];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.vgoodPopoverController dismissPopoverAnimated:NO];
		[_iPadController hideMissionVgoodPopover];
	}
}

+ (void)_dismissPrize
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeWillDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeWillDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeWillDisappear)]) {
		[_mainDelegate beintooPrizeWillDisappear];
	}
	
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
		[_mainController hideVgoodNavigationController];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.vgoodPopoverController dismissPopoverAnimated:NO];
		[_iPadController hideVgoodPopover];
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeDidDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeDidDisappear];
	}
    
    [_prizeView setIsVisible:NO];
}

+ (void)_dismissAd
{    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->adView;
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooAdControllerWillDisappear)]) {
		[[_prizeView globalDelegate] beintooAdControllerWillDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerWillDisappear)]) {
		[_mainDelegate beintooAdControllerWillDisappear];
	}
	
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainAdController;
		[_mainController hideAdNavigationController];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.adPopoverController dismissPopoverAnimated:NO];
		[_iPadController hideAdPopover];
        
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
		[[_prizeView globalDelegate] beintooAdControllerDidDisappear];
	}
    
    [_prizeView setIsVisible:NO];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [[Beintoo sharedInstance]->mainAdController release];
#endif
    
}

+ (void)_dismissRecommendation
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    [Beintoo manageStatusBarOnDismiss];
    
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		
		if ([_mainDelegate respondsToSelector:@selector(beintooPrizeWillDisappear)]) {
			[_mainDelegate beintooPrizeWillDisappear];
		}
		
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
		_mainController.view.alpha = 0;
		[_mainController.view removeFromSuperview];
		
		if ([_mainDelegate respondsToSelector:@selector(beintooPrizeDidDisappear)]) {
			[_mainDelegate beintooPrizeDidDisappear];
		}
	}
}

#pragma mark -
#pragma mark Player - user

+ (void)_setBeintooPlayer:(NSDictionary *)_player
{	
	if (_player != nil && [_player objectForKey:@"guid"]!=nil) {
		[[NSUserDefaults standardUserDefaults] setObject:_player forKey:BNSDefLoggedPlayer];
		
		// If the player is connected to a user, we also set the user
		if ([_player objectForKey:@"user"]) {
			[[NSUserDefaults standardUserDefaults] setObject:[_player objectForKey:@"user"] forKey:BNSDefLoggedUser];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:BNSDefIsUserLogged];
		}
		else {
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:BNSDefIsUserLogged];
		}
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)_playerLogout
{
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:BNSDefIsUserLogged];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:BNSDefLoggedPlayer];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:BNSDefLoggedUser];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
    // Here we delete all facebook cookies, to prevent the auto-login of another user
	for (cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:@".facebook.com"] || [[cookie name] isEqualToString:@"fbs_152837841401121"]) {
            [storage deleteCookie:cookie];
        }
	}
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

+ (void)_setBeintooUser:(NSDictionary *)_user
{
	if (_user != nil && [_user objectForKey:@"id"]) {
		[[NSUserDefaults standardUserDefaults] setObject:_user forKey:BNSDefLoggedUser];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:BNSDefIsUserLogged];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)_setBeintooUserFriends:(NSArray *)friends
{	
	if ([Beintoo isUserLogged] && [friends count] > 0) {
		[[NSUserDefaults standardUserDefaults] setObject:friends forKey:BNSDefUserFriends];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefUserFriends];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray *)_getBeintooUserFriends
{	
	if ([Beintoo isUserLogged] && [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefUserFriends]) {
		return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefUserFriends];
    }
    return nil;
}

+ (BOOL)_isAFriendOfMine:(NSString *)_friendID
{	
	if ([Beintoo isUserLogged] && [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefUserFriends]) {
        NSArray *friendsArray = [Beintoo getBeintooUserFriends];
        for (NSDictionary *singleFriend in friendsArray){
            if ([[singleFriend objectForKey:@"id"] isEqualToString:_friendID]){
                return YES;
                break;
            }
        }
    }
    return NO;
}

+ (void)_setLastVgood:(BVirtualGood *)_vgood
{
    BPrize *_prize = [Beintoo sharedInstance]->prizeView;
    if (_prize.isVisible == NO){
        if ([Beintoo sharedInstance]->lastGeneratedGood != nil) {
            
#ifdef BEINTOO_ARC_AVAILABLE
            
#else
           [[Beintoo sharedInstance]->lastGeneratedGood release];
#endif
            
        }
        _prize.type = REWARD;
        [Beintoo sharedInstance]->lastGeneratedGood     = _vgood;
    }
}

+ (void)_setLastAd:(BVirtualGood *)_ad
{
    BPrize *_adView = [Beintoo sharedInstance]->adView;
    if (_adView.isVisible == NO){
        if ([Beintoo sharedInstance]->lastGeneratedAd != nil) {
            
#ifdef BEINTOO_ARC_AVAILABLE
            
#else
            [[Beintoo sharedInstance]->lastGeneratedAd release];
#endif
            
        }
         _adView.type = AD;
        [Beintoo sharedInstance]->lastGeneratedAd     = _ad;
    }
}

+ (void)_setLastLoggedPlayers:(NSArray *)_players
{
	if ([_players count] < 1) {
		return;
	}
	[Beintoo sharedInstance]->lastLoggedPlayers = _players;
}

+ (void)_setLastGiveBedollars:(BVirtualGood *)_content
{
    BTemplateGiveBedollars *_giveBedollarsView = [Beintoo sharedInstance]->giveBedollarsView;
    if (_giveBedollarsView.isVisible == NO){
        if ([Beintoo sharedInstance]->lastGeneratedGiveBedollars != nil) {
            
#ifdef BEINTOO_ARC_AVAILABLE
            
#else
            [[Beintoo sharedInstance]->lastGeneratedGiveBedollars release];
#endif
            
        }
        _giveBedollarsView.type = GIVE_BEDOLLARS;
        [Beintoo sharedInstance]->lastGeneratedGiveBedollars     = _content;
    }
}

#pragma mark - Virtual Currency Methods

+ (void)_setDeveloperCurrencyName:(NSString *)_name
{
    [[NSUserDefaults standardUserDefaults] setObject:_name forKey:BNSDefDeveloperCurrencyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)_getDeveloperCurrencyName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperCurrencyName];
}

+ (void)_setDeveloperUserId:(NSString *)_id
{
    [[NSUserDefaults standardUserDefaults] setObject:_id forKey:BNSDefDeveloperLoggedUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)_getDeveloperUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperLoggedUserId];
}

+ (void)_setDeveloperCurrencyValue:(float)_value
{
    [[NSUserDefaults standardUserDefaults] setFloat:_value forKey:BNSDefDeveloperCurrencyValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)_getDeveloperCurrencyValue
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:BNSDefDeveloperCurrencyValue];
}

+ (void)_removeStoredCurrencyAndUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperCurrencyName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperCurrencyValue];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperLoggedUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)_removeUserId
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperLoggedUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)_isCurrencyStored
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperCurrencyName] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperCurrencyName] length] > 0)
        return YES;
    
    else 
        return NO;
}

+ (BOOL)_isLoggedUserIdStored
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperLoggedUserId] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperLoggedUserId] length] > 0)
        return YES;
    
    else 
        return NO;
}

#pragma mark -
#pragma mark PopoverDelegate

#ifdef UI_USER_INTERFACE_IDIOM
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[Beintoo _dismissBeintoo];
}
#endif

#pragma mark -
#pragma mark PrizeDelegate

- (void)userDidTapOnThePrize
{	
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
    [Beintoo manageStatusBarOnLaunch];
    
	BeintooVgoodNavController *iPadVgoodNavigatorController = [Beintoo getVgoodNavigationController];
	BeintooMainController *mainNavigatorController          = [Beintoo sharedInstance]->mainController;
	
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    mainNavigatorController.viewControllers     = nil;
    iPadVgoodNavigatorController.viewControllers    = nil;
	
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    
	if ([lastVgood isRecommendation]) { // ----------  RECOMMENDATION ------------- //
		// Initialization of the Recommendation Controller with the recommendation URL
        
		mainNavigatorController.recommendationVC= [mainNavigatorController.recommendationVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:lastVgood.getItRealURL];
        
        [mainNavigatorController.recommendationVC setType:REWARD];
        
        if ([BeintooDevice isiPad]) {
            iPadVgoodNavigatorController = [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
        }
        else{
            mainNavigatorController = [mainNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
        }
	}
	else if ([lastVgood isMultiple]) {  // ----------  MULTIPLE VGOOD ------------- //
		// Initialize the Multiple vgood Controller with the list of options
		NSArray *vgoodList = [Beintoo getLastGeneratedVGood].theGoodsList;
        
		mainNavigatorController.multipleVgoodVC = [mainNavigatorController.multipleVgoodVC initWithNibName:@"BeintooMultipleVgoodVC" bundle:[NSBundle mainBundle]
                                                      andOptions:[NSDictionary dictionaryWithObjectsAndKeys:vgoodList,@"vgoodArray",/*self.popoverVgoodController,@"popoverController",*/nil]];
        if ([BeintooDevice isiPad]) {
            iPadVgoodNavigatorController = [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.multipleVgoodVC];
        }
        else{
            mainNavigatorController = [mainNavigatorController initWithRootViewController:mainNavigatorController.multipleVgoodVC];
        }
	}
	else {								// ----------  SINGLE VGOOD ------------- //
		// Initialize the Single vgood Controller with the generated vgood
        
        mainNavigatorController.singleVgoodVC.theVirtualGood = [Beintoo getLastGeneratedVGood];
        if ([BeintooDevice isiPad]) {
            iPadVgoodNavigatorController = [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.singleVgoodVC];
        }
        else{
            mainNavigatorController = [mainNavigatorController initWithRootViewController:mainNavigatorController.singleVgoodVC];
        }
	}
    
	if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeWillAppear)]) {
		[[_prizeView globalDelegate] beintooPrizeWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooPrizeWillAppear)]) {
		[_mainDelegate beintooPrizeWillAppear];
	}
    
	if (![BeintooDevice isiPad]) { // --- iPhone,iPod
		[mainNavigatorController prepareBeintooVgoodOrientation];
		[[Beintoo getApplicationWindow] addSubview:mainNavigatorController.view];
		[mainNavigatorController showVgoodNavigationController];
	}
	else {  // --- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showVgoodPopoverWithVGoodController:iPadVgoodNavigatorController];
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeDidAppear)]) {
		[[_prizeView globalDelegate] beintooPrizeDidAppear];
	}
}

- (void)userDidTapOnClosePrize
{    
    BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeAlertWillDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeAlertWillDisappear];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertWillDisappear)]) {
		[_mainDelegate beintooPrizeAlertWillDisappear];
	}
    
	if ([lastVgood isMultiple]) {
		
		@synchronized(self){
			BeintooVgood *_vgoodService = [Beintoo beintooVgoodService];
			[_vgoodService acceptGoodWithId:lastVgood.vGoodID];
		}
	}
	
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeAlertDidDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeAlertDidDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidDisappear)]) {
		[_mainDelegate beintooPrizeAlertDidDisappear];
	}
    
    [_prizeView setIsVisible:NO];
}

- (void)userDidTapOnTheAd
{	
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedAd];
    [Beintoo manageStatusBarOnLaunch];
    
    [Beintoo initAdNavigationController];
    [Beintoo initMainAdController];
    
	BeintooVgoodNavController *iPadVgoodNavigatorController = [Beintoo sharedInstance]->adNavigationController;
	BeintooMainController *mainNavigatorController          = [Beintoo sharedInstance]->mainAdController;
    
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    mainNavigatorController.recommendationVC = [mainNavigatorController.recommendationVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:lastVgood.getItRealURL];
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->adView;
    [mainNavigatorController.recommendationVC setType:AD];
    
    if ([BeintooDevice isiPad]) {
        iPadVgoodNavigatorController = [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
    }
    else{
        mainNavigatorController = [mainNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
    }
	
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooAdControllerWillAppear)]) {
		[[_prizeView globalDelegate] beintooAdControllerWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerWillAppear)]) {
		[_mainDelegate beintooAdControllerWillAppear];
	}
    
	if (![BeintooDevice isiPad]) { // --- iPhone,iPod
		[mainNavigatorController prepareBeintooVgoodOrientation];
		[[Beintoo getApplicationWindow] addSubview:mainNavigatorController.view];
		[mainNavigatorController showAdNavigationController];
	}
	else {  // --- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		
		[_iPadController preparePopoverOrientation];
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showAdPopoverWithVGoodController:iPadVgoodNavigatorController];
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
		[[_prizeView globalDelegate] beintooAdControllerDidAppear];
	}
}

- (void)userDidTapOnCloseAd
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->adView;
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooAdWillDisappear)]) {
		[[_prizeView globalDelegate] beintooAdWillDisappear];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(beintooAdWillDisappear)]) {
		[_mainDelegate beintooAdWillDisappear];
	}
    
	if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooAdDidDisappear)]) {
		[[_prizeView globalDelegate] beintooAdDidDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooAdDidDisappear)]) {
		[_mainDelegate beintooAdDidDisappear];
	}
    
    [_prizeView setIsVisible:NO];
}

- (void)launchGiveBedollarsController
{	
	BVirtualGood *giveBedollars = [Beintoo getLastGeneratedGiveBedollars];
    [Beintoo manageStatusBarOnLaunch];
    
    [Beintoo initAdNavigationController];
    [Beintoo initMainAdController];
    
	BeintooVgoodNavController *iPadVgoodNavigatorController = [Beintoo sharedInstance]->adNavigationController;
	BeintooMainController *mainNavigatorController          = [Beintoo sharedInstance]->mainAdController;
    
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    mainNavigatorController.recommendationVC = [mainNavigatorController.recommendationVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:giveBedollars.getItRealURL];
    
    BTemplateGiveBedollars	*_prizeView = [Beintoo sharedInstance]->giveBedollarsView;
    [mainNavigatorController.recommendationVC setType:GIVE_BEDOLLARS];
    
    if ([BeintooDevice isiPad]) {
        iPadVgoodNavigatorController = [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
    }
    else{
        mainNavigatorController = [mainNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
    }
	
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerWillAppear)]) {
		[[_prizeView globalDelegate] beintooGiveBedollarsControllerWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerWillAppear)]) {
		[_mainDelegate beintooGiveBedollarsControllerWillAppear];
	}
    
	if (![BeintooDevice isiPad]) { // --- iPhone,iPod
		[mainNavigatorController prepareBeintooVgoodOrientation];
		[[Beintoo getApplicationWindow] addSubview:mainNavigatorController.view];
		[mainNavigatorController showGiveBedollarsNC];
	}
	else {  // --- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		
		[_iPadController preparePopoverOrientation];
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showAdPopoverWithVGoodController:iPadVgoodNavigatorController];
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
		[[_prizeView globalDelegate] beintooGiveBedollarsControllerDidAppear];
	}
}

+ (void)_dismissGiveBedollarsController
{    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
    BTemplateGiveBedollars	*_prizeView = [Beintoo sharedInstance]->giveBedollarsView;
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerWillDisappear)]) {
		[[_prizeView globalDelegate] beintooGiveBedollarsControllerWillDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerWillDisappear)]) {
		[_mainDelegate beintooGiveBedollarsControllerWillDisappear];
	}
	
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainAdController;
		[_mainController hideGiveBedollarsNC];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.adPopoverController dismissPopoverAnimated:NO];
		[_iPadController hideAdPopover];
        
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
		[[_prizeView globalDelegate] beintooGiveBedollarsControllerDidDisappear];
	}
    
    [_prizeView setIsVisible:NO];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [[Beintoo sharedInstance]->mainAdController release];
#endif
    
}

- (void)userDidTapOnCloseMission
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
		[_mainDelegate beintooDidDisappear];
	}
}

- (void)userDidTapOnMissionGetItReal
{
    NSDictionary *lastMission   = [Beintoo getLastRetrievedMission];
    NSString *getItRealUrl      = [[lastMission objectForKey:@"vgood"] objectForKey:@"getRealURL"];
	BeintooVgoodNavController *vgoodNavController = [Beintoo getVgoodNavigationController];
	BeintooMainController *_vgoodController = [Beintoo sharedInstance]->mainController;
    _vgoodController.viewControllers = nil;
	
    // Initialization of the Recommendation Controller with the recommendation URL
    _vgoodController.webViewVC = [_vgoodController.webViewVC initWithNibName:@"BeintooWebViewVC" bundle:[NSBundle mainBundle] urlToOpen:getItRealUrl];
    if ([BeintooDevice isiPad]) {
        vgoodNavController = [vgoodNavController initWithRootViewController:_vgoodController.webViewVC];
    }
    else{
        _vgoodController = [_vgoodController initWithRootViewController:_vgoodController.webViewVC];
    }
	
	if (![BeintooDevice isiPad]) { // --- iPhone,iPod
		[_vgoodController prepareBeintooVgoodOrientation];
		[[Beintoo getApplicationWindow] addSubview:_vgoodController.view];
		[_vgoodController showMissionVgoodNavigationController];
		
	}
	else {  // --- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showMissionVgoodPopoverWithVGoodController:vgoodNavController];
	}
}

+ (void)_beintooUserDidLogin
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooUserDidLogin)]) {
		[_mainDelegate beintooUserDidLogin];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(userDidLogin)]) {
		[_mainDelegate userDidLogin];
	}
}

+ (void)_beintooUserDidSignup
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooUserDidSignup)]) {
		[_mainDelegate beintooUserDidSignup];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(userDidSignup)]) {
		[_mainDelegate userDidSignup];
	}
}

#pragma mark - Location management

+ (void)_updateUserLocation
{
	BOOL isLocationServicesEnabled;
    
	CLLocationManager *_locationManager = [Beintoo sharedInstance]->locationManager;
	_locationManager.delegate = [Beintoo sharedInstance];
	
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];	       
	}
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    else {
        isLocationServicesEnabled = _locationManager.locationServicesEnabled;
	}
#endif
    
    if(!isLocationServicesEnabled){
        BeintooLOG(@"Beintoo - User has not accepted to use location services.");
        return;
    }
	[_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{    
    if([Beintoo sharedInstance]->userLocation != nil){
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [[Beintoo sharedInstance]->userLocation release];
#endif
        
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [Beintoo sharedInstance]->userLocation = [newLocation retain];
#endif
    
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	BeintooLOG(@"Error in localizing player: %@", [error description]);
}

#pragma mark - Notifications

+ (void)_beintooDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
		[_mainDelegate beintooDidAppear];
	}
}

+ (void)_beintooWillDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
}

+ (void)_beintooDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
		[_mainDelegate beintooDidDisappear];
	}
}

+ (void)_prizeDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeDidAppear)]) {
		[_mainDelegate beintooPrizeDidAppear];
	}
}

+ (void)_prizeDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeDidDisappear)]) {
		[_mainDelegate beintooPrizeDidDisappear];
	}
}

+ (void)_adControllerDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
		[_mainDelegate beintooAdControllerDidAppear];
	}
}

+ (void)_adControllerDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
		[_mainDelegate beintooAdControllerDidDisappear];
	}
}

+ (void)_giveBedollarsControllerDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
		[_mainDelegate beintooGiveBedollarsControllerDidAppear];
	}
}

+ (void)_giveBedollarsControllerDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
		[_mainDelegate beintooGiveBedollarsControllerDidDisappear];
	}
}

@end
