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
#import "BImageDownload.h"
#import "BeintooDevice.h"

@class BeintooSigninVC;
@class BView;
@class BButton;
@class BTableView;
@class BeintooSigninFacebookVC, BeintooMarketplaceVC;

@interface BeintooLoginVC : UIViewController <UITableViewDelegate,BImageDownloadDelegate,BeintooPlayerDelegate>{
		
	IBOutlet BView			*loginView;
	IBOutlet BTableView		*retrievedPlayersTable;	
	IBOutlet UILabel		*useAnotherBtnLabel;
	IBOutlet BButton		*anotherPlayerButton;
	
	IBOutlet UILabel		*titleLabel1;
	IBOutlet UILabel		*titleLabel2;
    
    IBOutlet UIToolbar      *toolBar;
    IBOutlet UIBarButtonItem    *buttonItem;
	
	BeintooSigninFacebookVC	*registrationFBVC;
	BeintooSigninVC			*registrationVC;
	
	NSArray					*retrievedUsers;
	NSMutableArray			*userImages;
	BeintooPlayer			*_player;
}

- (NSString *)translateLevel:(NSNumber *)levelNumber;
- (IBAction)otherPlayer;
- (UIButton *)closeButton;
- (void)generatePlayerIfNotExists;

@property (nonatomic,retain) NSArray                *retrievedUsers;
@property (nonatomic,retain) NSMutableArray         *userImages;
@property (nonatomic,retain) BeintooMarketplaceVC   *callerIstance;
@property (nonatomic,retain) NSString               *caller;

@end
