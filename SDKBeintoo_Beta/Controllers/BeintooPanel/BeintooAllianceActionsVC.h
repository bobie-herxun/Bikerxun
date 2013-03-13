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

@class BView, BTableView, BeintooPlayer, BeintooViewAllianceVC, BeintooAlliancesListVC, BeintooCreateAllianceVC;

@interface BeintooAllianceActionsVC : UIViewController <UITableViewDelegate,BeintooPlayerDelegate> {
	
	IBOutlet BView			*alliancesActionView;
	IBOutlet BTableView		*elementsTable;
		
	NSMutableArray			*elementsArrayList;
	NSDictionary			*selectedElement;
	NSDictionary			*startingOptions;
	
	BeintooPlayer			*_player;
    
    BeintooViewAllianceVC   *viewAllianceVC;
    BeintooAlliancesListVC  *allianceListVC;
    BeintooCreateAllianceVC *allianceCreateVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;

@property(nonatomic,retain) IBOutlet BTableView *elementsTable;
@property(nonatomic,retain)	NSMutableArray	*elementsArrayList;
@property(nonatomic,retain)	NSDictionary	*selectedElement;
@property(nonatomic,retain)	NSDictionary	*startingOptions;

@end
