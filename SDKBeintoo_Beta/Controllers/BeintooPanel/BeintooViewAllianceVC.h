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
#import "BeintooPlayer.h"
#import "BeintooUser.h"
#import "BeintooAlliance.h"
#import "BImageDownload.h"

#define ALLIANCE_REQUEST_JOIN   123
#define ALLIANCE_REQUEST_LEAVE  124

@class BView, BButton, BTableView, BeintooUser, BeintooPlayer, BeintooAlliance, BeintooWebViewVC, BeintooAlliancePendingVC, BeintooAlliancesAddFriends, BeintooProfileVC;

@interface BeintooViewAllianceVC : UIViewController <UITableViewDelegate, BeintooAllianceDelegate, UIActionSheetDelegate, BImageDownloadDelegate, BeintooUserDelegate>
{	
	IBOutlet BView			*alliancesActionView;
	IBOutlet BTableView		*elementsTable;
    IBOutlet UIScrollView   *scrollView;
    IBOutlet UIToolbar      *toolbar;
    IBOutlet UILabel        *allianceNameLabel;
    IBOutlet UILabel        *allianceMembersLabel;
    IBOutlet UILabel        *allianceAdminLabel;
    IBOutlet UIImageView    *allianceImageView;
    
    IBOutlet BButton        *leaveAllianceButton;
	IBOutlet BButton        *pendingRequestsButton;
    IBOutlet BButton        *askToJoinAllianceButton;

    NSMutableArray			*elementsArrayImages;
	NSMutableArray			*elementsArrayList;
	NSDictionary			*selectedElement;
	NSDictionary			*startingOptions;
    NSDictionary            *globalResult;
    NSString                *allianceAdminUserID;
    NSString                *allianceId;
    int                     requestType;
	
	BeintooPlayer			*_player;
    BeintooUser             *_user;
    BeintooAlliance         *_alliance;
    
    BeintooAlliancePendingVC    *pendingRequestsVC;
    BeintooProfileVC            *profileVC;
    BeintooAlliancesAddFriends  *allianceAddFriends;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;
- (IBAction)leaveAlliance;
- (IBAction)getPendingRequests;
- (IBAction)joinAlliance;

@property(nonatomic,retain) IBOutlet BTableView *elementsTable;
@property(nonatomic,retain)	NSMutableArray	*elementsArrayList;
@property(nonatomic,retain)	NSDictionary	*selectedElement;
@property(nonatomic,retain)	NSDictionary	*startingOptions;
@property(nonatomic,retain) NSDictionary    *globalResult;

@property(nonatomic,assign) BOOL           isMineAlliance;
@property(nonatomic,assign) BOOL           isFromLeaderboard;
@property(nonatomic,assign) BOOL            isFromNotification;
@property(nonatomic,assign) BOOL            isFromDirectLaunch;

@property(nonatomic, assign) BOOL           needPendingRequest;
@property(nonatomic, assign) BOOL           needLeaveAlliance;
@property(nonatomic, assign) BOOL           needJoinAlliance;
@property(nonatomic, assign) BOOL           needAddToAlliance;

@end
