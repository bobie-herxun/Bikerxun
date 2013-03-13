//
//  BeintooAlliancesAddFriends.h
//  SampleBeintoo
//
//  Created by Giuseppe Piazzese on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTableView.h"
#import "BView.h"
#import "BImageDownload.h"
#import "BeintooAlliance.h"
#import "BeintooUser.h"
#import "BeintooDevice.h"

@interface BeintooAlliancesAddFriends : UIViewController <UITableViewDelegate, UITableViewDataSource, BeintooAllianceDelegate, BeintooUserDelegate, BImageDownloadDelegate, UIAlertViewDelegate> {
    
    IBOutlet BView			*friendsActionView;
	IBOutlet BTableView		*elementsTable;
	IBOutlet UILabel		*noResultLabel;
	IBOutlet UILabel		*titleLabel;
    IBOutlet UIToolbar      *toolBar;
    
    BeintooAlliance         *_alliance;
    BeintooUser             *_user;
    NSMutableArray          *imagesArray;
    NSMutableArray          *elementsArray;
    NSMutableArray          *selectedFriends;
    
    IBOutlet UIBarButtonItem         *barButton;
}

@property (nonatomic, retain) NSMutableArray *startingOptions;
@property(nonatomic,assign) BOOL            isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSMutableArray *)options;

@end
