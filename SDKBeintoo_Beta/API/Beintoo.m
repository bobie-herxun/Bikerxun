/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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

#import "Beintoo.h"
#import "Beintoo+Private.h"

@implementation Beintoo

#pragma mark - Init Beintoo

+ (void)initWithApiKey:(NSString *)_apikey andApiSecret:(NSString *)_apisecret 
										   andBeintooSettings:(NSDictionary *)_settings 
										   andMainDelegate:(id<BeintooMainDelegate>)beintooMainDelegate
{
	if ([Beintoo sharedInstance]) { 
		return; // -- Beintoo already initialized -- //
	}
    
    [Beintoo createSharedBeintoo];
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	
	beintooInstance->mainDelegate = beintooMainDelegate;
	
	[beintooInstance initDelegates];
	
	[Beintoo initAPI];
	[Beintoo setApiKey:_apikey andApisecret:_apisecret];
	[Beintoo initLocallySavedScoresArray];
	[Beintoo initLocallySavedAchievementsArray];
    [Beintoo initUserAgent];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initVgoodService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
	
	// Settings initialization
	[Beintoo initBeintooSettings:_settings];

	[Beintoo initMainController];
	[Beintoo initVgoodNavigationController];
	[Beintoo initiPadController];
	
	// Popover initialization
    if ([BeintooDevice isiPad]) {
        [Beintoo initPopoversForiPad];
    }
}

#pragma mark - Player methods

+ (void)login
{
    [BeintooPlayer login];
}

+ (void)submitScore:(int)score
{
    [BeintooPlayer submitScore:score];
}

+ (void)submitScore:(int)score forContest:(NSString *)contestID
{
    [BeintooPlayer submitScore:score forContest:contestID];
}

+ (void)submitScore:(int)score forContest:(NSString *)contestID withThreshold:(int)threshold
{
    [BeintooPlayer submitScoreAndGetRewardForScore:score andContest:contestID withThreshold:threshold];
}

+ (void)submitScoreAndGetRewardForScore:(int)score andContest:(NSString *)codeID withThreshold:(int)threshold
{
    [BeintooPlayer submitScoreAndGetRewardForScore:score andContest:codeID withThreshold:threshold];
}

+ (int)getThresholdScoreForCurrentPlayerWithContest:(NSString *)codeID
{
    return [BeintooPlayer getThresholdScoreForCurrentPlayerWithContest:codeID];
}

+ (void)getScore
{
    [BeintooPlayer getScore];
}

#pragma mark - Give Bedollars methods

+ (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification withPosition:(int)position
{
    [BeintooApp giveBedollars:amount showNotification:showNotification withPosition:position];
}

#pragma mark - Rewards methods

+ (void)getReward
{
    [BeintooReward getReward];
}

+ (void)getRewardWithDelegate:(id)_delegate
{
    [BeintooReward getRewardWithDelegate:_delegate];
}

+ (void)getRewardWithContest:(NSString *)contestID
{
    [BeintooReward getRewardWithContest:contestID];
}

#pragma mark - Request AD methods

+ (void)requestAndDisplayAdWithDeveloperUserGuid:(NSString *)_developerUserGuid
{
    [BeintooAd requestAndDisplayAdWithDeveloperUserGuid:nil];
}

+ (void)requestAdWithDeveloperUserGuid:(NSString *)_developerUserGuid
{
    [BeintooAd requestAdWithDeveloperUserGuid:nil];
}

#pragma mark - Achievements methods

+ (void)unlockAchievement:(NSString *)achievementID
{
    [BeintooAchievements unlockAchievement:achievementID];
}

+ (void)unlockAchievement:(NSString *)achievementID showNotification:(BOOL)showNotification
{
    [Beintoo unlockAchievement:achievementID showNotification:showNotification];
}

+ (void)setAchievement:(NSString *)achievementID withPercentage:(int)percentage {
    [Beintoo setAchievement:achievementID withPercentage:percentage];
}

+ (void)setAchievement:(NSString *)achievementID withPercentage:(int)percentage showNotification:(BOOL)showNotification{
    [Beintoo setAchievement:achievementID withPercentage:percentage showNotification:showNotification];
}

+ (void)setAchievement:(NSString *)achievementID withScore:(int)score
{
    [BeintooAchievements setAchievement:achievementID withScore:score];
}

+ (void)incrementAchievement:(NSString *)achievementID withScore:(int)score
{
    [BeintooAchievements incrementAchievement:achievementID withScore:score];
}

+ (void)getAchievementStatusAndPercentage:(NSString *)achievementID
{
    [BeintooAchievements getAchievementStatusAndPercentage:achievementID];
}

// BY OBJECT ID

+ (void)unlockAchievementByObjectID:(NSString *)objectID showNotification:(BOOL)showNotification
{
    [BeintooAchievements unlockAchievementByObjectID:objectID showNotification:showNotification];
}

+ (void)setAchievementByObjectID:(NSString *)objectID withPercentage:(int)percentage showNotification:(BOOL)showNotification
{
    [BeintooAchievements setAchievementByObjectID:objectID withPercentage:percentage showNotification:showNotification];
}

+ (void)unlockAchievementsInBackground:(NSArray *)achievementArray
{
    [BeintooAchievements unlockAchievementsInBackground:achievementArray];
}

+ (void)unlockAchievementsByObjectIDInBackground:(NSArray *)achievementArray
{
    [BeintooAchievements unlockAchievementsByObjectIDInBackground:achievementArray];
}

#pragma mark - Set Delegates methods

+ (void)setPlayerDelegate:(id)delegate
{
    [BeintooPlayer setDelegate:delegate];
}

+ (void)setUserDelegate:(id)delegate
{
    [BeintooUser setDelegate:delegate];
}

+ (void)setAchievementsDelegate:(id)delegate
{
    [BeintooAchievements setDelegate:delegate];
}

+ (void)setRewardDelegate:(id)delegate
{
    [BeintooReward setDelegate:delegate];
}

+ (void)setVgoodDelegate:(id)delegate
{
    [BeintooVgood setDelegate:delegate];
}

+ (void)setAppDelegate:(id)delegate
{
    [BeintooApp setDelegate:delegate];
}

+ (void)setAdDelegate:(id)delegate
{
    [BeintooAd setDelegate:delegate];
}

#pragma mark - Launch and Dismiss methods

+ (void)launchBeintoo{
	[Beintoo _launchBeintooOnApp];
}

+ (void)launchBeintooOnAppWithVirtualCurrencyBalance:(float)_value{
	[Beintoo _launchBeintooOnAppWithDeveloperCurrencyValue:_value];
}

+ (void)launchNotifications{
	[Beintoo _launchNotificationsOnApp];
}

+ (void)launchMarketplace{
    [Beintoo _launchMarketplaceOnApp];
}

+ (void)launchMarketplaceOnAppWithVirtualCurrencyBalance:(float)_value{
	[Beintoo _launchMarketplaceOnAppWithDeveloperCurrencyValue:_value];
}

+ (void)launchBestore{
    [Beintoo _launchMarketplaceOnApp];
}

+ (void)launchBestoreWithVirtualCurrencyBalance:(float)_value{
	[Beintoo _launchMarketplaceOnAppWithDeveloperCurrencyValue:_value];
}

+ (void)launchWallet{
	[Beintoo _launchWalletOnApp];
}

+ (void)launchMyOffers{
	[Beintoo _launchWalletOnApp];
}

+ (void)launchAchievements{
	[Beintoo _launchAchievementsOnApp];
}

+ (void)launchLeaderboard{
	[Beintoo _launchLeaderboardOnApp];
}

+ (void)launchPrize{
	[Beintoo _launchPrizeOnApp];
}

+ (void)launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate{
    [Beintoo _launchPrizeOnAppWithDelegate:_beintooPrizeDelegate];
}

+ (void)launchGiveBedollarsWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate position:(int)position{
    [Beintoo _launchGiveBedollarsWithDelegate:_beintooPrizeDelegate position:position];
}

+ (void)dismissGiveBedollarsController{
	[Beintoo _dismissGiveBedollarsController];
}

+ (void)displayAd{
	[Beintoo _launchAd];
}

+ (void)displayAdWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate{
    [Beintoo _launchAdWithDelegate:_beintooPrizeDelegate];
}

+ (void)launchAd{
	[Beintoo _launchAd];
}

+ (void)launchAdWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate{
    [Beintoo _launchAdWithDelegate:_beintooPrizeDelegate];
}

+ (void)launchMission{
    [Beintoo _launchMissionOnApp];
}

+ (void)launchIpadLogin{
	[Beintoo _launchIpadLogin];
}

+ (void)dismissIpadLogin{
	[Beintoo _dismissIpadLogin];
}

+ (void)launchIpadNotifications{
	[Beintoo _launchIpadNotifications];
}

+ (void)dismissIpadNotifications{
	[Beintoo _dismissIpadNotifications];
}

+ (void)launchSignup{
	[Beintoo _launchSignupOnApp];
}

+ (void)_launchPrivateSignup{
	[Beintoo _launchPrivateSignupOnApp];
}

+ (void)_launchPrivateNotifications{
	[Beintoo _launchPrivateNotificationsOnApp];
}

#pragma mark - Global Services

+ (BeintooVgood *)beintooVgoodService{
	return [Beintoo sharedInstance]->beintooVgoodService;
}

+ (BeintooPlayer *)beintooPlayerService{
	return [Beintoo sharedInstance]->beintooPlayerService;
}

+ (BeintooUser *)beintooUserService{
	return [Beintoo sharedInstance]->beintooUserService;
}

+ (BeintooAchievements *)beintooAchievementService{
	return [Beintoo sharedInstance]->beintooAchievementsService;
}

+ (BeintooBestore *)beintooBestoreService{
    return [Beintoo sharedInstance]->beintooBestoreService;
}

+ (BeintooApp *)beintooAppService{
    return [Beintoo sharedInstance]->beintooAppService;
}

+ (BeintooAd *)beintooAdService{
    return [Beintoo sharedInstance]->beintooAdService;
}

+ (BeintooReward *)beintooRewardService
{
    return [Beintoo sharedInstance]->beintooRewardService;
}

#pragma mark - Global Controllers

+ (UIViewController *)getMainController{
	return [Beintoo sharedInstance]->mainController;
}

+ (BAnimatedNotificationQueue *)getNotificationQueue
{
    return [Beintoo sharedInstance]->notificationQueue;
}

+ (BeintooNavigationController *)getMainNavigationController{
	return [Beintoo sharedInstance]->mainNavigationController;
}

+ (BeintooNavigationController *)getBestoreNavigationController{
	return [Beintoo sharedInstance]->bestoreNavigationController;
}

+ (BeintooNavigationController *)getLeaderboardsNavigationController{
	return [Beintoo sharedInstance]->leaderboardNavigationController;
}

+ (BeintooNavigationController *)getMyOffersNavigationController{
	return [Beintoo sharedInstance]->myoffersNavigationController;
}

+ (BeintooNavigationController *)getAchievementsNavigationController{
	return [Beintoo sharedInstance]->achievementsNavigationController;
}

+ (BeintooNavigationController *)getNotificationsNavigationController{
	return [Beintoo sharedInstance]->notificationsNavigationController;
}

+ (BeintooNavigationController *)getSignupNavigationController{
	return [Beintoo sharedInstance]->signupNavigationController;
}

+ (BeintooNavigationController *)getPrivateNotificationsNavigationController{
	return [Beintoo sharedInstance]->privateNotificationsNavigationController;
}

+ (BeintooNavigationController *)getPrivateSignupNavigationController{
	return [Beintoo sharedInstance]->privateSignupNavigationController;
}

+ (BeintooVgoodNavController *)getVgoodNavigationController{
	return [Beintoo sharedInstance]->vgoodNavigationController;
}

+ (BeintooNotificationListVC *)getPrivateNotificationsViewController{
	return [Beintoo sharedInstance]->beintooNotificationsVC;
}

#pragma mark - Private Methods

+ (dispatch_queue_t)beintooDispatchQueue{
    return [Beintoo sharedInstance]->beintooDispatchQueue;
}


+ (NSString *)getApiKey{

	return [Beintoo sharedInstance]->apiKey;
}

+ (NSArray *)getFeatureList{
	return [Beintoo sharedInstance]->featuresArray;
}

+ (NSArray *)getLastLoggedPlayers{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
    
#ifdef BEINTOO_ARC_AVAILABLE
    return beintooInstance->lastLoggedPlayers;
#else
	return [beintooInstance->lastLoggedPlayers retain];
#endif
}

+ (NSDictionary *)getLastRetrievedMission{
    return [Beintoo sharedInstance]->lastRetrievedMission;
}

+ (void)setLastRetrievedMission:(NSDictionary *)_mission
{
    
#ifdef BEINTOO_ARC_AVAILABLE
    [Beintoo sharedInstance]->lastRetrievedMission = _mission;
#else
	[Beintoo sharedInstance]->lastRetrievedMission = [_mission retain];
#endif
    
}
								
+ (NSString *)currentVersion{
	return BeintooSdkVersion;
}

+ (NSInteger)notificationPosition{
    return [Beintoo sharedInstance]->notificationPosition;
}

+ (BOOL)isUserLogged{
	return [[NSUserDefaults standardUserDefaults] boolForKey:BNSDefIsUserLogged];
}

+ (BOOL)isRegistrationForced{
	return [Beintoo sharedInstance]->forceRegistration;
}
+ (BOOL)showAchievementNotification{
    return [Beintoo sharedInstance]->showAchievementNotification;
}
+ (BOOL)showLoginNotification{
    return [Beintoo sharedInstance]->showLoginNotification;
}
+ (BOOL)showScoreNotification{
    return [Beintoo sharedInstance]->showScoreNotification;
}
+ (BOOL)showNoRewardNotification{
    return [Beintoo sharedInstance]->showNoRewardNotification;
}
+ (BOOL)dismissBeintooOnRegistrationEnd{
    return [Beintoo sharedInstance]->dismissBeintooAfterRegistration;
}
+ (BOOL)isStatusBarHiddenOnApp{
    return [Beintoo sharedInstance]->statusBarHiddenOnApp;
}

+ (BOOL)isTryBeintooForced{
    return [Beintoo sharedInstance]->forceTryBeintoo;
}
+ (BOOL)isOnSandbox{
	if ([Beintoo sharedInstance]) {
		return [Beintoo sharedInstance]->isOnSandbox;
	}
	return NO;
}
+ (BOOL)isTryBeintooImageTypeReward{
    return [Beintoo sharedInstance]->tryBeintooImageTypeReward;
}

+ (BOOL)isOnPrivateSandbox{
	if ([Beintoo sharedInstance]) {
		return [Beintoo sharedInstance]->isOnPrivateSandbox;
	}
	return NO;
}

+ (void)_privateSandbox
{
	[Beintoo privateSandbox];
}

+ (void)_setUserLocation:(CLLocation *)_location{
	[Beintoo sharedInstance]->userLocation = _location;
}

+ (BOOL)userHasAllowedLocationServices{
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    CLLocationManager *_locationManager = [Beintoo sharedInstance]->locationManager;
#endif
	BOOL isLocationServicesEnabled;
    
    if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];	
	}
#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    else {
		isLocationServicesEnabled = _locationManager.locationServicesEnabled;
	}
#endif
    
	return isLocationServicesEnabled;
}

+ (void)setUserLogged:(BOOL)isLoggedValue{
	[[NSUserDefaults standardUserDefaults] setBool:isLoggedValue forKey:BNSDefIsUserLogged];
	if (!isLoggedValue) {
		[Beintoo _playerLogout];
	}
}

+ (NSString *)getMissionTimestamp{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSeenMissionTimestamp"];
}

+ (void)setMissionTimestamp:(NSString *)_timestamp{
    [[NSUserDefaults standardUserDefaults] setObject:_timestamp forKey:@"LastSeenMissionTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getPlayer{
	return [[NSUserDefaults standardUserDefaults]objectForKey:BNSDefLoggedPlayer];
}

+ (void)setBeintooPlayer:(NSDictionary *)_player{
	[self _setBeintooPlayer:_player];
}

+ (void)playerLogout{
	[self _playerLogout];
}

+ (NSDictionary *)getUserIfLogged
{
	return [[NSUserDefaults standardUserDefaults]objectForKey:BNSDefLoggedUser];
}

+ (void)setBeintooUser:(NSDictionary *)_user
{
	[self _setBeintooUser:_user];
}

+ (void)setBeintooUserFriends:(NSArray *)friends
{
    [Beintoo _setBeintooUserFriends:friends];    
}

+ (NSArray *)getBeintooUserFriends
{
    return [Beintoo _getBeintooUserFriends];
}    

+ (BOOL)isAFriendOfMine:(NSString *)_friendID
{
    return [Beintoo _isAFriendOfMine:_friendID];
}

+ (BVirtualGood *)getLastGeneratedVGood{
	@synchronized(self){
    
#ifdef BEINTOO_ARC_AVAILABLE
        return [Beintoo sharedInstance]->lastGeneratedGood;
#else
        return [[Beintoo sharedInstance]->lastGeneratedGood retain];
#endif
        
	}
}

+ (BVirtualGood *)getLastGeneratedAd{
	@synchronized(self){
#ifdef BEINTOO_ARC_AVAILABLE
        return [Beintoo sharedInstance]->lastGeneratedAd;
#else
        return [[Beintoo sharedInstance]->lastGeneratedAd retain];
#endif
	}
}

+ (BOOL)isAdReady{
    if ([Beintoo sharedInstance]->lastGeneratedAd != nil)
        return YES;
    else
        return NO;
}

+ (BVirtualGood *)getLastGeneratedGiveBedollars{
	@synchronized(self){
#ifdef BEINTOO_ARC_AVAILABLE
        return [Beintoo sharedInstance]->lastGeneratedGiveBedollars;
#else
        return [[Beintoo sharedInstance]->lastGeneratedGiveBedollars retain];
#endif
	}
}

+ (void)setLastGeneratedGiveBedollars:(BVirtualGood *)_content{
	@synchronized(self){
		[self _setLastGiveBedollars:_content];
	}
}

+ (NSDictionary *)getAppVgoodThresholds{
    return [[Beintoo getPlayer] objectForKey:@"vgoodThreshold"];
}

#pragma mark - Virtual Currency Methods

+ (void)setVirtualCurrencyName:(NSString *)_name{
    [Beintoo _setDeveloperCurrencyName:_name];
}

+ (NSString *)getVirtualCurrencyName{
    return [Beintoo _getDeveloperCurrencyName];
}

+ (void)setVirtualCurrencyBalance:(float)_value{
    [Beintoo _setDeveloperCurrencyValue:_value];
}

+ (float)getVirtualCurrencyBalance{
    return [Beintoo _getDeveloperCurrencyValue];
}

+ (void)setDeveloperUserId:(NSString *)_id{
    [Beintoo _setDeveloperUserId:_id];
}

+ (NSString *)getDeveloperUserId{
    return [Beintoo _getDeveloperUserId];
}

+ (void)setDeveloperUserId:(NSString *)_userId withBalance:(float)_value{
    [Beintoo _setDeveloperCurrencyValue:_value];
    [Beintoo _setDeveloperUserId:_userId];
}

+ (void)setVirtualCurrencyName:(NSString *)_name forUserId:(NSString *)_userId withBalance:(float)_value{
    [Beintoo _setDeveloperCurrencyName:_name];
    [Beintoo _setDeveloperCurrencyValue:_value];
    [Beintoo _setDeveloperUserId:_userId];
}

+ (void)removeStoredVirtualCurrency{
    [Beintoo _removeStoredCurrencyAndUser];
}

+ (BOOL)isVirtualCurrencyStored{
    return [Beintoo _isCurrencyStored];
}

#pragma mark - Common methods

+ (void)setLastGeneratedVgood:(BVirtualGood *)_theVGood{
	@synchronized(self){
		[self _setLastVgood:_theVGood];
	}
}

+ (void)setLastGeneratedAd:(BVirtualGood *)_theAd{
	@synchronized(self){
		[self _setLastAd:_theAd];
	}
}

+ (int)appOrientation{
	return [Beintoo sharedInstance]->appOrientation;
}

+ (void)changeBeintooOrientation:(int)_orientation{
	if ([Beintoo isBeintooInitialized]) {
		[Beintoo setAppOrientation:_orientation];
       
        BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
        if (_prizeView.alpha == 1){
            [_prizeView preparePrizeAlertOrientation:_prizeView.frame];
        }
        
        BPrize	*_adView = [Beintoo sharedInstance]->adView;
        if (_adView.alpha == 1){
            [_adView preparePrizeAlertOrientation:_adView.frame];
        }
    }
}

+ (NSString *)getRestBaseUrl{
	return [Beintoo sharedInstance]->restBaseUrl;
}

+ (NSString *)getDisplayBaseUrl{
	return [Beintoo sharedInstance]->displayBaseUrl;
}

+ (NSString *)getPlayerID{
	NSDictionary *_beintooPlayer = [Beintoo getPlayer];
	if(_beintooPlayer!= nil){
		return [_beintooPlayer objectForKey:@"guid"];
	}
	return nil;
}

+ (NSString *)getUserID{
	NSDictionary *_beintooUser = [Beintoo getUserIfLogged];
	if(_beintooUser!= nil){
		return [_beintooUser objectForKey:@"id"];
	}
	return nil;	
}

+ (void)switchBeintooToSandbox{
	[Beintoo switchToSandbox];
	BeintooLOG(@"------------------------------------- Beintoo Sandbox ON -------------------------------------");
}

+ (NSString *)getUserLocationForURL{
	CLLocation *loc = [Beintoo getUserLocation];
	NSString *locationForURL = nil;
	
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)){
		return nil;
	}
	locationForURL = [NSString stringWithFormat:@"&lat=%f&lng=%f&acc=%f",loc.coordinate.latitude,
					  loc.coordinate.longitude,loc.horizontalAccuracy];
	return locationForURL;
}

+ (BeintooVC *)getBeintooPanelRootViewController{
	return [Beintoo sharedInstance]->beintooPanelRootViewController;
}

+ (UIWindow *)getAppWindow{
	return [Beintoo getApplicationWindow];
}

+ (BMessageAnimated *)getNotificationView{
	return [Beintoo sharedInstance]->notificationView;
}

+ (id<BeintooMainDelegate>)getMainDelegate{
	return [Beintoo sharedInstance]->mainDelegate;
}

+ (void)updateUserLocation{
	[self _updateUserLocation];
}

+ (CLLocation *)getUserLocation{
	return [Beintoo sharedInstance]->userLocation;
}

+ (void)setLastLoggedPlayers:(NSArray *)_players{
	[Beintoo _setLastLoggedPlayers:_players];
}

#pragma mark - Notifications

+ (void)notifyVGoodGenerationOnMainDelegate{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooGenerateAReward:)]) {
		[_mainDelegate didBeintooGenerateAReward:[Beintoo sharedInstance]->lastGeneratedGood];
	}
}

+ (void)notifyVGoodGenerationErrorOnMainDelegate:(NSDictionary *)_error{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooFailToGenerateARewardWithError:)]) {
		[_mainDelegate didBeintooFailToGenerateARewardWithError:_error];
	}
}

+ (void)notifyAdGenerationOnMainDelegate{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooGenerateAnAd:)]) {
		[_mainDelegate didBeintooGenerateAnAd:[Beintoo sharedInstance]->lastGeneratedAd];
	}
}

+ (void)notifyAdGenerationErrorOnMainDelegate:(NSDictionary *)_error{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooFailToGenerateAnAdWithError:)]) {
		[_mainDelegate didBeintooFailToGenerateAnAdWithError:_error];
	}
}

+ (void)dismissBeintoo{
	[Beintoo _dismissBeintoo];
}

+ (void)dismissBeintoo:(int)type{
	[Beintoo _dismissBeintoo:type];
}

+ (void)dismissSignup{
	[Beintoo _dismissSignup];
}

+ (void)dismissBeintooNotAnimated{
    [Beintoo _dismissBeintooNotAnimated];
}

+ (void)dismissMission{
	[Beintoo _dismissMission];
}

+ (void)dismissPrize{
	[Beintoo _dismissPrize];
}

+ (void)dismissAd{
	[Beintoo _dismissAd];
}

+ (void)dismissRecommendation{
	[Beintoo _dismissRecommendation];
}

+ (void)beintooDidAppear{
	[Beintoo _beintooDidAppear];
}

+ (void)beintooWillDisappear{
	[Beintoo _beintooWillDisappear];
}

+ (void)beintooDidDisappear{
	[Beintoo _beintooDidDisappear];
}

+ (void)prizeDidAppear{
	[Beintoo _prizeDidAppear];
}

+ (void)prizeDidDisappear{
	[Beintoo _prizeDidDisappear];
}

+ (void)adControllerDidAppear{
	[Beintoo _adControllerDidAppear];
}

+ (void)adControllerDidDisappear{
	[Beintoo _adControllerDidDisappear];
}

+ (void)giveBedollarsControllerDidAppear{
	[Beintoo _giveBedollarsControllerDidAppear];
}

+ (void)giveBedollarsControllerDidDisappear{
	[Beintoo _giveBedollarsControllerDidDisappear];
}

#pragma mark - Post Notifications

+ (void)postNotificationBeintooUserDidLogin{
	[Beintoo _beintooUserDidLogin];
}

+ (void)postNotificationBeintooUserDidSignup{
	[Beintoo _beintooUserDidSignup];
}

#pragma mark - Shutdown and release

+ (void)shutdownBeintoo{
	
	Beintoo *beintooInstance = [Beintoo sharedInstance];

	if (beintooInstance == nil){
		return;
	}
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    /* --------------------------------------------- */
	[beintooInstance->apiKey release];
	beintooInstance->apiKey = nil;
	/* --------------------------------------------- */
	[beintooInstance->apiSecret release];
	beintooInstance->apiSecret = nil;
	/* --------------------------------------------- */
	[beintooInstance->locationManager release];
	beintooInstance->locationManager = nil;
	/* --------------------------------------------- */
	[beintooInstance->userLocation release];
	beintooInstance->userLocation = nil;
	/* --------------------------------------------- */
	[beintooInstance->lastGeneratedGood release];
	beintooInstance->lastGeneratedGood = nil;
	/* --------------------------------------------- */
	[beintooInstance->lastLoggedPlayers release];
	beintooInstance->lastLoggedPlayers = nil;
	/* --------------------------------------------- */
	[beintooInstance->prizeView release];
	beintooInstance->prizeView = nil;
    /* --------------------------------------------- */
	[beintooInstance->lastRetrievedMission release];
	beintooInstance->lastRetrievedMission = nil;
    /* --------------------------------------------- */
	[beintooInstance->missionView release];
	beintooInstance->missionView = nil;
	/* --------------------------------------------- */
	[beintooInstance->notificationView release];
	beintooInstance->notificationView = nil;
	/* --------------------------------------------- */
	[beintooInstance->mainNavigationController release];
	beintooInstance->mainNavigationController = nil;
	/* --------------------------------------------- */
	[beintooInstance->vgoodNavigationController release];
	beintooInstance->vgoodNavigationController = nil;
	/* --------------------------------------------- */
	[beintooInstance->mainController release];
	beintooInstance->mainController = nil;
	/* --------------------------------------------- */
	[beintooInstance->featuresArray release];
	beintooInstance->featuresArray = nil;
	/* --------------------------------------------- */  
	[beintooInstance->beintooPanelRootViewController release];  // Released
	beintooInstance->beintooPanelRootViewController = nil;
    /* --------------------------------------------- */
	[beintooInstance->beintooWalletViewController release];  // Released
	beintooInstance->beintooWalletViewController = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardVC release];  // Released
	beintooInstance->beintooLeaderboardVC = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardWithContestVC release];  // Released
	beintooInstance->beintooLeaderboardWithContestVC = nil;
	/* --------------------------------------------- */  
	[beintooInstance->beintooWalletViewController release];  // Released
	beintooInstance->beintooWalletViewController = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardVC release];  // Released
	beintooInstance->beintooLeaderboardVC = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardWithContestVC release];  // Released
	beintooInstance->beintooLeaderboardWithContestVC = nil;
	/* --------------------------------------------- */
	[[Beintoo sharedInstance]->beintooPlayerService release];
	[Beintoo sharedInstance]->beintooPlayerService = nil;
    /* --------------------------------------------- */
	[[Beintoo sharedInstance]->beintooUserService release];
	[Beintoo sharedInstance]->beintooUserService = nil;
	/* --------------------------------------------- */
	[beintooInstance->beintooVgoodService release];
	beintooInstance->beintooVgoodService = nil;	
	/* --------------------------------------------- */
	[beintooInstance->beintooAchievementsService release];
	beintooInstance->beintooAchievementsService = nil;
    /* --------------------------------------------- */
    [beintooInstance->beintooBestoreService release];
    beintooInstance->beintooBestoreService = nil;
    /* --------------------------------------------- */
	
	[beintooInstance release];
#endif
    
    beintooInstance = nil;
}

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[super dealloc];

#endif

}

@end
