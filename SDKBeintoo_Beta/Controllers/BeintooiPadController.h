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

#import <UIKit/UIKit.h>
#import "BNavigationController.h"

@class BeintooVGoodVC,BeintooMultipleVgoodVC,BeintooVGoodShowVC,BeintooLoginVC, BeintooNotificationListVC;

@interface BeintooiPadController : UIViewController<
#ifdef UI_USER_INTERFACE_IDIOM
    UIPopoverControllerDelegate
#endif
    >{


#ifdef UI_USER_INTERFACE_IDIOM
	UIPopoverController *popoverController;
	UIPopoverController *loginPopoverController;
	UIPopoverController *vgoodPopoverController;
    UIPopoverController *adPopoverController;
    UIPopoverController *notificationsPopoverController;
    UIPopoverController *privateNotificationsPopoverController;
    UIPopoverController *privateSignupPopoverController;
    UIPopoverController *leaderboardPopoverController;
    UIPopoverController *myOffersPopoverController;
    UIPopoverController *achievementsPopoverController;
#endif
    
	BNavigationController	*loginNavController;
	CGRect startingRect;
	
	BeintooLoginVC *loginVC;
	BOOL		isLoginOngoing;
	BOOL		isVgoodPopoverVisible;
	BOOL		isMainPopoverVisible;

	NSString *transitionEnterSubtype;
	NSString *transitionExitSubtype;
	
    BNavigationController *beintooPrivateNotificationController;
    BeintooNotificationListVC *notificationVC;
}

#ifdef UI_USER_INTERFACE_IDIOM
    @property(nonatomic,retain) UIPopoverController *popoverController;
    @property(nonatomic,retain) UIPopoverController *loginPopoverController;
    @property(nonatomic,retain) UIPopoverController *vgoodPopoverController;
    @property(nonatomic,retain) UIPopoverController *notificationsPopoverController;
    @property(nonatomic,retain) UIPopoverController *privateNotificationsPopoverController;
    @property(nonatomic,retain) UIPopoverController *privateSignupPopoverController;
    @property(nonatomic,retain) UIPopoverController *leaderboardPopoverController;
    @property(nonatomic,retain) UIPopoverController *myOffersPopoverController;
    @property(nonatomic,retain) UIPopoverController *achievementsPopoverController;
    @property(nonatomic,retain) UIPopoverController *adPopoverController;
#endif
@property(nonatomic,assign) BOOL isLoginOngoing;

- (void)showBeintooPopover;
- (void)hideBeintooPopover;

- (void)showLoginPopover;
- (void)hideLoginPopover;

- (void)showVgoodPopoverWithVGoodController:(UINavigationController *)_vgoodNavController;
- (void)hideVgoodPopover;

- (void)showMissionVgoodPopoverWithVGoodController:(UINavigationController *)_vgoodNavController;
- (void)hideMissionVgoodPopover;

- (void)showAdPopoverWithVGoodController:(UINavigationController *)_vgoodNavController;
- (void)hideAdPopover;

- (void)showBestorePopover;
- (void)hideBestorePopover;

- (void)showLeaderboardPopover;
- (void)hideLeaderboardPopover;

- (void)showAchievementsPopover;
- (void)hideAchievementsPopover;

- (void)showMyOffersPopover;
- (void)hideMyOffersPopover;

- (void)showNotificationsPopover;
- (void)hideNotificationsPopover;

- (void)showSignupPopover;
- (void)hideSignupPopover;

// Internal calls, from the Dashboard

- (void)showPrivateNotificationsPopover;
- (void)hidePrivateNotificationsPopover;
- (void)showPrivateSignupPopover;
- (void)hidePrivateSignupPopover;


- (void)preparePopoverOrientation;

@end
