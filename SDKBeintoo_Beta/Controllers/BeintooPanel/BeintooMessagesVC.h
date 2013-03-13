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
#import "BeintooMessage.h"
#import "BImageDownload.h"
#import "BTableView.h"
#import "BeintooUser.h"
#import "BeintooPlayer.h"
#import <QuartzCore/QuartzCore.h>
#import "BeintooDevice.h"

#define MSGFORPAGE 10

@class BView,BeintooMessage,BeintooPlayer,BButton,BeintooMessagesShowVC,BeintooNewMessageVC;

@interface BeintooMessagesVC : UIViewController <UITableViewDelegate,BeintooPlayerDelegate,BeintooTableViewDelegate,BeintooMessageDelegate,BeintooUserDelegate,BImageDownloadDelegate> {
	
	IBOutlet BView			*messagesView;
	IBOutlet BTableView		*elementsTable;
	IBOutlet UILabel		*titleLabel;
	IBOutlet UILabel		*noMessagesLabel;
    IBOutlet UIToolbar      *toolBar;
    IBOutlet UIBarButtonItem *newMessageButton;
	NSMutableArray			*elementsArrayList;
	NSMutableArray			*elementsImages;
	NSDictionary			*selectedMessage;
	NSDictionary			*startingOptions;
	
	BeintooMessage			*_message;
	BeintooPlayer			*_player;
	BeintooUser				*_user;
	BeintooMessagesShowVC	*beintooMessageShowVC;
	BeintooNewMessageVC		*newMessageVC;
	
	int						loadMoreCount;
	int						cellsToLoad;		// if other messages has to be loaded, cells to load = [elements count]+1 	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;
- (void)loadmoreMessages;
- (IBAction)newMessage;

@property(nonatomic,retain) IBOutlet BTableView *elementsTable;
@property(nonatomic,retain)	NSMutableArray	*elementsArrayList;
@property(nonatomic,retain) NSMutableArray	*elementsImages;
@property(nonatomic,retain)	NSDictionary	*selectedMessage;
@property(nonatomic,retain)	NSDictionary	*startingOptions;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
