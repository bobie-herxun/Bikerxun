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
#import <UIKit/UIKit.h>
#import "BeintooUser.h"
#import "BeintooPlayer.h"
#import "BNavigationController.h"

@class BView, BeintooNavigationController,BButton,BTableView,BeintooVgood,BeintooLoginVC,
	BeintooProfileVC,BeintooLeaderboardVC,BeintooWalletVC,BeintooChallengesVC,BeintooAchievementsVC,BeintooMessagesVC,BeintooBrowserVC,BGradientView, BeintooNotificationListVC, BeintooMarketplaceVC, BeintooBestoreVC;

@interface BeintooVC : UIViewController <UITableViewDelegate, UITableViewDataSource, BeintooPlayerDelegate, BeintooUserDelegate> {
	    
    BView                   *tryBeintooView;
	IBOutlet BView			*homeView;
	IBOutlet UILabel		*userNick;
	IBOutlet BTableView		*homeTable;
	IBOutlet UILabel		*bedollars;
    
    // Notifications views
    IBOutlet BGradientView  *notificationView;
    IBOutlet BGradientView  *notificationLogoView;
    IBOutlet UILabel        *notificationLogoLabel;
    IBOutlet UILabel        *notificationMainLabel;
    IBOutlet BGradientView  *notificationNumbersView;
    IBOutlet UILabel        *notificationNumbersLabel;
    
    // Notifications views Landscape
    IBOutlet BGradientView  *notificationViewLandscape;
    IBOutlet BGradientView  *notificationLogoViewLandscape;
    IBOutlet UILabel        *notificationLogoLabelLandscape;
    IBOutlet UILabel        *notificationMainLabelLandscape;
    IBOutlet BGradientView  *notificationNumbersViewLandscape;
    IBOutlet UILabel        *notificationNumbersLabelLandscape;

	BOOL isBeintoo;
    BOOL homeTablePlayerAnimationPerformed;
    BOOL isAlreadyLogging;
    BOOL isNotificationCenterOpen;
    
    UIView                  *signupViewForPlayers;
    
	NSMutableArray			*retrievedPlayersArray;
	NSMutableArray			*featuresArray;
	UIViewController		*homeSender;
	BeintooNavigationController	*homeNavController;
	BNavigationController	*loginNavController;
    BNavigationController	*notificationNavController;

    UIBarButtonItem         *notificationButtonItem;
    UIBarButtonItem         *fixedSpace;
    IBOutlet UIToolbar      *toolBar;
    
#ifdef UI_USER_INTERFACE_IDIOM    
	UIPopoverController		*popOverController;
	UIPopoverController		*loginPopoverController;
    UIPopoverController     *notificationPopover;
#endif
	
	BeintooPlayer               *beintooPlayer;
	BeintooUser                 *_user;
	BeintooLoginVC              *loginVC;
	BeintooProfileVC            *beintooProfileVC;
	BeintooLeaderboardVC        *beintooLeaderboardVC;
	BeintooWalletVC             *beintooWalletVC;
	BeintooChallengesVC         *beintooChallengesVC;
	BeintooAchievementsVC       *beintooAchievementsVC;
	BeintooMessagesVC           *messagesVC;
    BeintooBrowserVC            *tipsAndForumVC;
    BeintooNotificationListVC   *beintooNotificationListVC;
    
    BeintooBestoreVC *beintooBestoreVC;
}

// Beintoo Initializer 
- (void)setBeintooFeatures:(NSArray *)_featuresArray;
   
- (IBAction)tryBeintoo;


@property(nonatomic,retain) BeintooPlayer *beintooPlayer;
@property(nonatomic,retain) BeintooUser   *_user;
@property(nonatomic,retain) BNavigationController *loginNavController;
@property(nonatomic,retain) NSMutableArray *retrievedPlayersArray;
@property(nonatomic,assign) BOOL isNotificationCenterOpen;
@property(nonatomic,retain) BeintooLoginVC *loginVC;
@property(nonatomic,retain) NSMutableArray	*featuresArray;
@property (nonatomic, assign) BOOL isFromSignup;
@property (nonatomic, assign) BOOL forceSignup;

#ifdef UI_USER_INTERFACE_IDIOM
@property(nonatomic,retain) UIPopoverController *popOverController;
@property(nonatomic,retain) UIPopoverController *loginPopoverController;
#endif

@end
