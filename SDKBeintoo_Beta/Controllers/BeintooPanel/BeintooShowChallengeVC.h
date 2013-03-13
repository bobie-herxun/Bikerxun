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
@class BView,BButton;
@class BGradientView;

@interface BeintooShowChallengeVC : UIViewController <BeintooUserDelegate, UITabBarDelegate, UITableViewDataSource,BImageDownloadDelegate> {

	NSDictionary			*challengeStatus;
	BeintooUser				*user;
	NSString				*myUserExt;
	NSString				*toUserExt;
    
    NSMutableArray          *userImages;
    
    BImageDownload *downloadImage2;
    BImageDownload *downloadImage1;
    
    BOOL showStartEndDate;
    BOOL showTargetScore;
    IBOutlet UITableView *table;
    IBOutlet BView *viewBack;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andChallengeStatus:(NSDictionary *)status;
- (NSString *)translateStatusCode:(NSString *)code;

- (IBAction)acceptChallenge;
- (IBAction)refuseChallenge;

@property(nonatomic,retain) NSDictionary *challengeStatus;
@property(nonatomic,retain) NSString *myUserExt;
@property(nonatomic,retain) NSString *toUserExt;
@property(nonatomic,retain) NSMutableArray *userImages;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
