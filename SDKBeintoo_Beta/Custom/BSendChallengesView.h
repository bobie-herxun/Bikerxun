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
#import <UIKit/UIKit.h>

#define BSENDCHALLENGE_VIEW_TAG 100

@class BGradientView, BSendChallengeDetailsView;

@interface BSendChallengesView : UIView <UITableViewDelegate, UITableViewDataSource> {

	NSMutableArray                  *elementsArrayList;
    
    BSendChallengeDetailsView       *sendChallengeView1;
    BSendChallengeDetailsView       *sendChallengeView2;
    BSendChallengeDetailsView       *sendChallengeView3;
    
}

- (void)drawSendChallengeView;
- (void)initTableArrayElements;
- (void)closeMainView;

@property(nonatomic,retain) NSString        *selectedContest;
@property(nonatomic,retain) NSDictionary    *challengeSender;
@property(nonatomic,retain) NSString        *challengeReceiver;

@end

