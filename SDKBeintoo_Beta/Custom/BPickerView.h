//
//  BPickerView.h
//  SampleBeintoo
//
//  Created by Giuseppe Piazzese on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BImageDownload.h"
#import "BeintooUser.h"
#import "BeintooPlayer.h"

@class BeintooUser, BeintooPlayer;

@interface BPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource, BeintooUserDelegate, BeintooPlayerDelegate, UIAlertViewDelegate> {
    
    UIPickerView        *pickerView;
    UIToolbar           *toolbar;
    
    BeintooPlayer       *player;
    BeintooUser         *user;
    
    NSMutableArray      *contestsDictionary;
    NSMutableArray      *contestsCodeIDDictionary;
    
    NSString            *selectedContest;

}

@property(nonatomic, retain) NSDictionary *options;

- (void)startPickerFilling;
- (id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)_options;

@end
