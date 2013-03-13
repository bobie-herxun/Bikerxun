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
#import "BImageDownload.h"
#import "BeintooAlliance.h"
#import "BNavigationController.h"

#define NUMBER_OF_ROWS	25

@class BView, BTableView, BeintooProfileVC, BGradientView, BeintooLoginVC;

@interface BeintooLeaderboardContestVC : UIViewController <UITableViewDelegate,BImageDownloadDelegate,BeintooPlayerDelegate,BeintooUserDelegate, UIActionSheetDelegate>
{	
	IBOutlet BView				*leaderboardContestView;
	IBOutlet BTableView			*leaderboardContestTable;
	IBOutlet UISegmentedControl *segControl;
    IBOutlet UILabel            *noScoresLabel;
	
	NSDictionary	*allScores;
	NSMutableArray	*players;
	NSMutableArray	*leaderboardEntries;
	NSMutableArray	*leaderboardImages;
	NSDictionary	*selectedPlayer;
	NSDictionary	*currentUser;
	BeintooUser		*user;
	BeintooPlayer	*_player;
	
	int				plusOneCell;
	int				startRows;
    BOOL            isLeaderboardCloseToUser;
    BOOL            homeTablePlayerAnimationPerformed;
    BOOL            isAlreadyLogging;

    
    BeintooProfileVC                *profileVC;
    UIView                          *signupViewForPlayers;
    BeintooLoginVC                  *loginVC;
    BNavigationController          *loginNavController;
}

- (void)openSelectedPlayer;
- (IBAction) segmentedControlIndexChanged;

@property(nonatomic,retain) IBOutlet UISegmentedControl *segControl;
@property(nonatomic,retain) NSMutableArray  *players;
@property(nonatomic,retain) NSMutableArray  *leaderboardEntries;
@property(nonatomic,retain) NSMutableArray  *leaderboardImages;
@property(nonatomic,retain) NSDictionary    *selectedPlayer;
@property(nonatomic,assign) BOOL            isFromNotification;
@property(nonatomic,assign) BOOL            isFromDirectLaunch;

@end
