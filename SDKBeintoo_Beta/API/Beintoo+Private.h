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

#import <Foundation/Foundation.h>
#import "Beintoo.h"

#define HOURS_TO_SHOW_TRYBEINTOO   24*7

@interface Beintoo (Private) <CLLocationManagerDelegate,
#ifdef UI_USER_INTERFACE_IDIOM 
    UIPopoverControllerDelegate, 
#endif 
BeintooPrizeDelegate, BeintooMissionViewDelegate, BTemplateGiveBedollarsDelegate>

#pragma mark - Init methods

+ (void)setApiKey:(NSString *)_apikey andApisecret:(NSString *)_apisecret;
+ (void)createSharedBeintoo;
+ (Beintoo *)sharedInstance;

+ (BOOL)isBeintooInitialized;

+ (void)initBeintooSettings:(NSDictionary *)_settings;
+ (void)initLocallySavedScoresArray;
+ (void)initLocallySavedAchievementsArray;
+ (void)initUserAgent;
- (void)initDelegates;

#pragma mark - Common methods

+ (void)setApplicationWindow:(UIWindow *)_window;
+ (void)setAppOrientation:(int)_appOrientation;
+ (void)setForceRegistration:(BOOL)_value;
+ (void)setShowAchievementNotificatio:(BOOL)_value;
+ (void)setShowLoginNotification:(BOOL)_value;
+ (void)setShowScoreNotification:(BOOL)_value;
+ (void)setShowNoRewardNotification:(BOOL)_value;
+ (void)setForceTryBeintoo:(BOOL)_value;
+ (void)setDismissBeintooAfterRegistration:(BOOL)_value;
+ (void)setTryBeintooImageTypeReward:(BOOL)_value;
+ (void)setNotificationPosition:(NSInteger)_value;

#pragma mark - API Services

+ (void)initAPI;
+ (void)initPlayerService;
+ (void)initUserService;
+ (void)initVgoodService;
+ (void)initAchievementsService;
+ (void)initBestoreService;
+ (void)initAppService;
+ (void)initAdService;
+ (void)initRewardService;

#pragma mark - Init Controllers

+ (void)initMainController;
+ (void)initMainAdController;
+ (void)initVgoodNavigationController;
+ (void)initMainNavigationController;
+ (void)initAdNavigationController;
+ (void)initiPadController;
+ (void)initPopoversForiPad;

#pragma mark - Production/Sandbox environments

+ (void)switchToSandbox;
+ (void)privateSandbox;

#pragma mark - Launch and Dismiss methods

+ (void)_launchBeintooOnApp;
+ (void)_launchBeintooOnAppWithDeveloperCurrencyValue:(float)_value;
+ (void)_launchNotificationsOnApp;
+ (void)_launchMarketplaceOnApp;
+ (void)_launchMarketplaceOnAppWithDeveloperCurrencyValue:(float)_value;
+ (void)_launchWalletOnApp;
+ (void)_launchLeaderboardOnApp;
+ (void)_launchAchievementsOnApp;
+ (void)_launchPrizeOnApp;
+ (void)_launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate;
+ (void)_launchAd;
+ (void)_launchAdWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate;
+ (void)_launchMissionOnApp;
+ (void)_launchSignupOnApp;
+ (void)_launchPrivateSignupOnApp;
+ (void)_launchPrivateNotificationsOnApp;
+ (void)_launchIpadLogin;
+ (void)_dismissIpadLogin;
+ (void)_launchIpadNotifications;
+ (void)_dismissIpadNotifications;
+ (void)_dismissBeintoo;
+ (void)_dismissSignup;
+ (void)_dismissBeintoo:(int)type;
+ (void)_dismissBeintooNotAnimated;
+ (void)_dismissPrize;
+ (void)_dismissAd;
+ (void)_dismissMission;
+ (void)_dismissRecommendation;
+ (void)_launchGiveBedollarsWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate position:(int)position;
+ (void)_dismissGiveBedollarsController;

#pragma mark - Private methods

+ (UIWindow *)getApplicationWindow;
+ (void)_setBeintooPlayer:(NSDictionary *)_player;
+ (void)_setBeintooUser:(NSDictionary *)_user;
+ (void)_setLastLoggedPlayers:(NSArray *)_players;
+ (void)_setLastVgood:(BVirtualGood *)_vgood;
+ (void)_setLastAd:(BVirtualGood *)_ad;
+ (void)_setLastGiveBedollars:(BVirtualGood *)_content;
+ (void)setLastTimeForTryBeintooShowTimestamp:(NSString *)_value;
+ (void)_setBeintooUserFriends:(NSArray *)friends;

+ (void)_playerLogout;

+ (BOOL)_isAFriendOfMine:(NSString *)_friendID;

+ (NSString *)getLastTimeForTryBeintooShowTimestamp;
+ (NSArray *)_getBeintooUserFriends;

#pragma mark - Virtual Currency Methods

+ (void)_setDeveloperCurrencyName:(NSString *)_name;
+ (NSString *)_getDeveloperCurrencyName; 
+ (void)_setDeveloperUserId:(NSString *)_id;
+ (NSString *)_getDeveloperUserId;
+ (void)_setDeveloperCurrencyValue:(float)_value;
+ (float)_getDeveloperCurrencyValue;
+ (void)_removeStoredCurrencyAndUser;
+ (BOOL)_isCurrencyStored;
+ (BOOL)_isLoggedUserIdStored;

#pragma mark - Location management

+ (void)_updateUserLocation;

#pragma mark - StatusBar management

+ (void)manageStatusBarOnLaunch;
+ (void)manageStatusBarOnDismiss;
+ (void)_setIsStatusBarHiddenOnApp:(BOOL)_value;

#pragma mark - Notifications

+ (void)_beintooUserDidLogin;
+ (void)_beintooUserDidSignup;

+ (void)_adControllerDidAppear;
+ (void)_adControllerDidDisappear;

+ (void)_giveBedollarsControllerDidAppear;
+ (void)_giveBedollarsControllerDidDisappear;

+ (void)_beintooDidAppear;
+ (void)_beintooWillDisappear;
+ (void)_beintooDidDisappear;

+ (void)_prizeDidAppear;
+ (void)_prizeDidDisappear;

@end
