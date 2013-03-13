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
#import "BeintooVGood.h"
#import "BImageDownload.h"

@class BView, BTableView, BeintooPlayer, BeintooProfileVC , BPickerView;

@interface BeintooFriendsListVC : UIViewController <BeintooUserDelegate,BeintooVgoodDelegate,BImageDownloadDelegate,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate> {
	
	IBOutlet BView			*friendsView;
	IBOutlet BTableView		*friendsTable;
	IBOutlet UILabel		*selectFriendLabel;
	IBOutlet UILabel		*noFriendsLabel;
	NSMutableArray			*friendsArrayList;
	NSMutableArray			*friendsImages;
	NSDictionary			*selectedFriend;
	NSDictionary			*startingOptions;
	BeintooUser				*user;
	BeintooPlayer			*_player;
	BeintooVgood			*vGood;
	
	BeintooProfileVC		*profileVC;
    
    BPickerView             *bPickerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;

- (void)openSelectedFriendToSendAGift;
- (void)pickAFriendToSendMessage;
- (void)pickaFriendToShowProfile;

@property(nonatomic,retain) IBOutlet BTableView                 *friendsTable;
@property(nonatomic,retain)	NSMutableArray                      *friendsArrayList;
@property(nonatomic,retain) NSMutableArray                      *friendsImages;
@property(nonatomic,retain)	NSDictionary                        *selectedFriend;
@property(nonatomic,retain) BeintooVgood                        *vGood;
@property(nonatomic,retain)	NSDictionary                        *startingOptions;
@property(nonatomic,assign) BOOL                                backFromWebView;
@property(nonatomic,retain) NSString                            *caller;
@property (nonatomic, assign) BOOL      isFromNotification;

@end
