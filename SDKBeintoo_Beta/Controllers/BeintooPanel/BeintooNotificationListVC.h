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
#import "BeintooNotification.h"
#import "BImageDownload.h"

@class BView, BTableView, BeintooPlayer;
@class BeintooMessagesVC, BeintooFriendRequestsVC,BeintooChallengesVC,BeintooAchievementsVC,BeintooAlliancePendingVC,BeintooBrowserVC,BeintooWalletVC,BeintooViewAllianceVC;

@interface BeintooNotificationListVC : UIViewController <BeintooNotificationDelegate, BImageDownloadDelegate, UITableViewDelegate, UITableViewDataSource> {
	
    BView                       *mainView;
    BTableView                  *notificationTable;
	NSMutableArray              *notificationArrayList;
	NSMutableArray              *notificationImages;
	NSMutableDictionary         *selectedNotification;
	NSDictionary                *startingOptions;
    UILabel                     *noNotificationLabel;
    BeintooNotification         *_notification;
    
    // ViewControllers to be opened on notification select
    BeintooMessagesVC           *messagesVC;
    BeintooFriendRequestsVC     *friendRequestVC;
    BeintooChallengesVC         *challengesVC;
    BeintooAchievementsVC       *achievementVC;
    BeintooAlliancePendingVC    *pendigAllianceReqVC;
    BeintooBrowserVC            *tipsAndForumVC;
    BeintooWalletVC             *walletVC;
    BeintooViewAllianceVC       *viewAllianceVC;
}

- (UIButton *)closeButton;

@property(nonatomic,retain) BTableView *notificationTable;
@property(nonatomic,retain)	NSMutableArray *notificationArrayList;
@property(nonatomic,retain) NSMutableArray *notificationImages;
@property(nonatomic,retain)	NSMutableDictionary *selectedNotification;
@property(nonatomic,retain)	NSDictionary *startingOptions;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
