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
#import "BeintooVGood.h"
#import "BImageDownload.h"
#import "BeintooAchievements.h"
#import "BPopup.h"

@class BTableView, BView, BeintooPlayer;

@interface BeintooAchievementsVC : UIViewController <UITableViewDelegate,BeintooAchievementsDelegate,BImageDownloadDelegate>{
	
	IBOutlet BView				*walletView;
	IBOutlet BTableView			*achievementsTable;
	IBOutlet UILabel			*noAchievementsLabel;
	IBOutlet UILabel			*walletLabel;
	
	BeintooAchievements	 *_achievements;
	BeintooPlayer		 *_player;

	NSMutableArray		 *achievementsArrayList;
	NSMutableArray		 *achievementsImages;
    NSMutableArray		 *archiveAchievements;
    
    BPopup *popup;

}


@property(nonatomic, retain) NSMutableArray *achievementsArrayList;
@property(nonatomic, retain) NSMutableArray *achievementsImages;
@property(nonatomic, assign) BOOL            isFromNotification;
@property(nonatomic, retain) BPopup *popup;

@end
