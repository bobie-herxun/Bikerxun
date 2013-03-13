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
#import "BeintooPlayer.h"
#import "Beintoo.h"

@class BView, BButton, BGradientView, BeintooNewMessageVC;

@interface BeintooMessagesShowVC : UIViewController <BeintooMessageDelegate,BeintooPlayerDelegate> {
	
	IBOutlet BView			*showMessageView;
	IBOutlet BGradientView	*messageView;
	IBOutlet UIImageView	*fromPicture;
	IBOutlet BButton		*replyButton;
	IBOutlet BButton		*deleteButton;
	IBOutlet UILabel		*fromLabel;
	IBOutlet UILabel		*dateLabel;
	IBOutlet UILabel		*fromLabelText;
	IBOutlet UILabel		*dateLabelText;
	IBOutlet UITextView		*messageText;
	
	NSDictionary			*currentMessage;
	BeintooNewMessageVC		*newMessageVC;
	
	BeintooMessage			*_message;
	BeintooPlayer			*_player;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;

- (IBAction)deleteMessage;
- (IBAction)replyToMessage;

@property(nonatomic,retain)	NSDictionary *currentMessage;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
