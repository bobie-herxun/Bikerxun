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
#import "BeintooUser.h"
#import "BImageDownload.h"

@class BeintooShowChallengeVC,BView,BTableView,BeintooPlayer;

@interface BeintooChallengesVC : UIViewController <UITableViewDelegate,BeintooUserDelegate,BImageDownloadDelegate> {

	IBOutlet BView				*challengesView;
	IBOutlet BTableView			*challengesTable;
	IBOutlet UISegmentedControl *segControl;
    IBOutlet UIToolbar			*toolBar;
    IBOutlet UIBarButtonItem    *sendNewChallengeButton;
	IBOutlet UILabel			*titleLabel;
	IBOutlet UILabel			*titleLabel1;
	IBOutlet UILabel			*titleLabel2;

	NSMutableArray	*challengesArrayList;
    NSMutableArray  *challengeImages;
	NSDictionary	*selectedChallenge;
	BeintooUser		*user;
	BeintooPlayer	*_player;
	BeintooShowChallengeVC *showChallengeVC;
	NSData *myImage;
    
    NSMutableArray          *challengesPlayerFromImagesArray;
    NSMutableArray          *challengesPlayerToImagesArray;
}

- (IBAction) segmentedControlIndexChanged;
- (IBAction)sendNewChallenge;

@property(nonatomic,retain) NSMutableArray *challengesArrayList;
@property(nonatomic,retain) NSDictionary *selectedChallenge;
@property(nonatomic,retain) BeintooShowChallengeVC *showChallengeVC;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segControl;
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) NSData *myImage;
@property(nonatomic,retain) NSMutableArray *challengeImages;
@property(nonatomic,assign) BOOL            isFromNotification;

@end