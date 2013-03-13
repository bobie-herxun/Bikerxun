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
#import "BeintooUser.h"

@class BeintooSignupVC;
@class BButton;
@class BView;
@class BeintooPlayer;
@class BeintooSigninAlreadyVC;

@interface BeintooSigninVC : UIViewController <UITextFieldDelegate, BeintooPlayerDelegate, BeintooUserDelegate, UIAlertViewDelegate, UIWebViewDelegate> {

    BeintooUser             *user;
	BeintooPlayer           *_player;
	BeintooSignupVC         *registrationVC;
	BeintooSignupVC         *registrationFBVC;
	 
    IBOutlet UIView         *mainView;
	IBOutlet UIScrollView *scrollView;
	IBOutlet BView		 *beintooView;
    IBOutlet BView		 *beintooViewLand;
	IBOutlet UITextField *emailTF;
	IBOutlet UITextField *nickTF;
	IBOutlet UILabel	 *title1;
    IBOutlet UILabel	 *orLabel;
	IBOutlet UITextView	 *disclaimer;
	IBOutlet UIButton	 *facebookButton;
	IBOutlet BButton	 *newUserButton;
	IBOutlet UIButton	 *loginWithDifferent;
    
    IBOutlet UITextField *emailTFLand;
	IBOutlet UITextField *nickTFLand;
	IBOutlet UILabel	 *title1Land;
    IBOutlet UILabel	 *orLabelLand;
	IBOutlet UITextView	 *disclaimerLand;
	IBOutlet UIButton	 *facebookButtonLand;
	IBOutlet BButton	 *newUserButtonLand;
	IBOutlet UIButton	 *loginWithDifferentLand;
    
    UIToolbar            *keyboardToolbar;
	
	
	NSString                *newUSerURL;
	NSString                *nickname;
    BOOL                    isAccessoryInputViewNotSupported;
    
    UIWebView               *webview;
    UIWebView               *webviewLand;
    UILabel                 *registrazioneComplete;
    UILabel                 *registrazioneCompleteLand;
    UILabel                 *confirmNickname;
    UILabel                 *confirmNicknameLand;
    BButton                 *fbButton;
    BButton                 *fbButtonLand;
}

- (IBAction)newUser;
- (void)startNickAnimation;
- (BOOL)NSStringIsValidEmail:(NSString *)email;
- (IBAction)loginWithDifferent;
- (IBAction)loginFB;
- (void)generatePlayerIfNotExists;


@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *caller;
@property (nonatomic, assign) BOOL     isFromDirectLaunch;

@end
