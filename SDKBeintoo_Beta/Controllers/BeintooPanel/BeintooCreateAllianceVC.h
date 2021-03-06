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
#import "BeintooAlliance.h"

@class BView, BButton, BTableView, BeintooUser, BeintooPlayer;

@interface BeintooCreateAllianceVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate, UITextFieldDelegate,BeintooAllianceDelegate,BeintooUserDelegate> {
	
	IBOutlet BView			*findFriendsView;
	IBOutlet BTableView		*elementsTable;
	IBOutlet UITextField	*allianceTextField;
	IBOutlet UILabel		*noResultLabel;
    IBOutlet UILabel        *titleLabel;
    IBOutlet BButton        *createAllianceButton;
	
	NSMutableArray			*elementsArrayList;
	NSMutableArray			*elementsImages;
	NSDictionary			*selectedElement;
	NSDictionary			*startingOptions;
    NSMutableArray          *selectedFriendsArray;
	
	BeintooPlayer			*_player;
	BeintooAlliance         *_alliance;
    BeintooUser             *_user;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;

- (IBAction)createAlliance;

@property(nonatomic,retain) IBOutlet BTableView *elementsTable;
@property(nonatomic,retain)	NSMutableArray	*elementsArrayList;
@property(nonatomic,retain) NSMutableArray	*elementsImages;
@property(nonatomic,retain)	NSDictionary	*selectedElement;
@property(nonatomic,retain)	NSDictionary	*startingOptions;

@end
