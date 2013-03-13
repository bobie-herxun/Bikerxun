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

#import <Foundation/Foundation.h>
#import "BeintooUser.h"
#import "BImageDownload.h"
#import <UIKit/UIKit.h>

#define BSENDCHALLENGEDETAILS_VIEW_TAG  200

#define SENDCHALLENGE_TYPE_BET_OTHER    1
#define SENDCHALLENGE_TYPE_BET_ME       2
#define SENDCHALLENGE_TYPE_TIME         3

@class BGradientView;

@interface BSendChallengeDetailsView : UIView <UITableViewDelegate,UITextFieldDelegate,UITableViewDataSource,BeintooUserDelegate,BImageDownloadDelegate, UIAlertViewDelegate>{

	NSMutableArray  *elementsArrayList;
    NSMutableArray  *imagesArray;
    UITableView     *elementsTable;
    UIView  *shadowView;
    
    BeintooUser     *_user;
    
    UITextField     *bedollarsTextField;
    UITextField     *pointsTextField;    
    
    BOOL            textFieldAnimationPerformed;
    int             challengeType;
    
    UIActivityIndicatorView *activityForSenderImage;
    UIActivityIndicatorView *activityForReceiverImage;
    
    NSDictionary   *challengeReceiverDef;
    NSDictionary   *challengeSenderDef;
    NSDictionary   *challengeContest;
    
    BImageDownload *imageToDownload1;
    BImageDownload *imageToDownload2;
    int  remainToDowload;
    
}

- (void)drawSendChallengeView;
- (void)initTableArrayElements;
- (void)checkTextFieldInputs;

@property(nonatomic, retain) NSString       *selectedContest;
@property(nonatomic, retain) NSDictionary   *challengeSender;
@property(nonatomic, retain) NSString       *challengeReceiver;
@property(nonatomic, assign) int            challengeType;

@end

