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

@class BView, BTableView, BeintooUser, BeintooPlayer, BeintooFriendsListVC, BeintooFindFriendsVC;

@interface BeintooFriendRequestsVC : UIViewController <UIActionSheetDelegate, UITableViewDelegate,UITableViewDataSource,BeintooUserDelegate,BImageDownloadDelegate> {
	
	IBOutlet BView			*friendsActionView;
	IBOutlet BTableView		*elementsTable;
	IBOutlet UILabel		*noResultLabel;
	
	IBOutlet UILabel		*titleLabel;

	NSMutableArray			*elementsArrayList;
	NSDictionary			*selectedElement;
	NSDictionary			*startingOptions;
	NSMutableArray			*elementsImages;
	NSInteger				friendResponseKind;
	
	BeintooPlayer			*_player;
	BeintooUser				*_user;
	
	BeintooFriendsListVC	*friendsVC;
	BeintooFindFriendsVC	*findFriendsVC;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;

@property(nonatomic,retain) IBOutlet BTableView *elementsTable;
@property(nonatomic,retain)	NSMutableArray	*elementsArrayList;
@property(nonatomic,retain)	NSDictionary	*selectedElement;
@property(nonatomic,retain)	NSDictionary	*startingOptions;
@property(nonatomic,retain) NSMutableArray	*elementsImages;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
