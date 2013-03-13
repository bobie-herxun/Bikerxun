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

#define	KEYBOARD_OFFSET 60

@class BeintooFriendsListVC, BView,BButton;

@interface BeintooNewMessageVC : UIViewController <BeintooMessageDelegate,UIAlertViewDelegate,BeintooPlayerDelegate,UITextViewDelegate,UITextFieldDelegate>{
	
	IBOutlet BView			*sendMessageView;
	IBOutlet UILabel		*titleLabel;
	IBOutlet UILabel		*toLabel;
	IBOutlet UILabel		*textLabel;
	IBOutlet UITextField	*receiverTextField;
	IBOutlet UITextView		*messageTextView;
	IBOutlet BButton		*sendButton;
	IBOutlet UILabel		*toNickLabel;
	
	UIToolbar				*keyboardToolbar;
	NSDictionary			*startingOptions;
	NSDictionary			*selectedFriend;
	BOOL					keyboardIsShown;
	BOOL					isAccessoryInputViewNotSupported;
	
	BeintooFriendsListVC	*friendsListVC;

	BeintooMessage			*_message;
	BeintooPlayer			*_player;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;
- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;

- (IBAction)sendMessage;
- (IBAction)pickAFriend;

@property(nonatomic,retain)	NSDictionary *startingOptions;
@property(nonatomic,retain) UIToolbar	 *keyboardToolbar;
@property(nonatomic,retain) NSDictionary *selectedFriend;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
