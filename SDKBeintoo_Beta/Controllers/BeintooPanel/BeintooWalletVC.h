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

@class BTableView,BView,BeintooVGoodShowVC,BeintooFriendsListVC,BeintooPlayer;

@interface BeintooWalletVC : UIViewController <UIActionSheetDelegate,UITableViewDelegate,BeintooVgoodDelegate,BImageDownloadDelegate>{
	
	IBOutlet BView				*walletView;
	IBOutlet BTableView			*vWalletTable;
	IBOutlet UILabel			*noGoodsLabel;
	IBOutlet UILabel			*walletLabel;
	IBOutlet UISegmentedControl *segControl;
	
	BeintooVgood		 *vGood;
	BeintooPlayer		 *_player;
	BeintooVGoodShowVC	 *vgoodShowVC;
	BeintooFriendsListVC *friendsListVC;
	NSMutableArray		 *vGoodArrayList;
	NSMutableArray		 *walletImages;

}

- (IBAction) segmentedControlIndexChanged;

@property(nonatomic,retain) NSMutableArray *vGoodArrayList;
@property(nonatomic,retain) NSMutableArray *walletImages;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segControl;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
