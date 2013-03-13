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

#define NUMBER_OF_ROWS_ALLIANCE	25

@class BView,BTableView;

@interface BeintooAlliancesLeaderboardVC : UIViewController<UITableViewDelegate,BImageDownloadDelegate,BeintooPlayerDelegate,BeintooUserDelegate, UIActionSheetDelegate, BeintooAllianceDelegate> {
	
	IBOutlet BView				*leaderboardContestView;
	IBOutlet BTableView			*leaderboardContestTable;
    IBOutlet UILabel            *noAlliancesLabel;
	
	NSDictionary	*allScores;
	NSMutableArray	*players;
	NSMutableArray	*leaderboardEntries;
	NSMutableArray	*leaderboardImages;
	NSDictionary	*selectedPlayer;
	NSDictionary	*currentUser;
	BeintooUser		*user;
	BeintooPlayer	*_player;
    BeintooAlliance *_alliance;
	
	int				plusOneCell;
	int				startRows;
}

@property(nonatomic,retain) NSMutableArray *players;
@property(nonatomic,retain) NSMutableArray *leaderboardEntries;
@property(nonatomic,retain) NSMutableArray *leaderboardImages;
@property(nonatomic,retain) NSDictionary *selectedPlayer;

@property(nonatomic, assign) BOOL   isFromAlliances;
@property(nonatomic, assign) BOOL   isFromDirectLaunch;

@end
