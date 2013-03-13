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
@class BScrollView;
@class BeintooPlayer;

@interface BeintooSigninAlreadyVC : UIViewController <UITextFieldDelegate, BeintooPlayerDelegate, BeintooUserDelegate, UIAlertViewDelegate> {

	IBOutlet BScrollView    *scrollView;
	IBOutlet BView          *beintooView;
	IBOutlet UITextField    *pTF;
	IBOutlet UITextField    *eTF;
	IBOutlet UILabel        *title1;
	IBOutlet UILabel        *title2;
	IBOutlet BButton        *loginButton;
    IBOutlet UIView         *mainView;
    IBOutlet UIView         *portraitView;
    IBOutlet UIView         *landscapeView;
    IBOutlet UITextField    *pTFLand;
	IBOutlet UITextField    *eTFLand;
    IBOutlet UILabel        *title1Land;
    IBOutlet BButton        *loginButtonLand;
    IBOutlet UILabel        *mainLabel;
    IBOutlet UILabel        *mainLabelLand;
    IBOutlet UIButton       *forgotPassword;
    IBOutlet UIButton       *forgotPasswordLand;
    
    IBOutlet BButton        *forgotPasswordButton;
    IBOutlet UILabel        *forgotPasswordLabel;
    IBOutlet UITextField    *forgotPasswordTextField;
    IBOutlet UIView         *forgotPasswordView;
	
    UIView                  *forgotPasswordBase;
    
	BeintooUser             *user;
	BeintooPlayer           *_player;
	BeintooSignupVC         *registrationVC;
	BeintooSignupVC         *registrationFBVC;
	
    NSString                *newUSerURL;
    BOOL                    isAccessoryInputViewNotSupported;
    UIToolbar               *keyboardToolbar;
    UIToolbar               *keyboardToolbarForgot;
}

@property (nonatomic, retain) NSString  *caller;
@property (nonatomic, assign) BOOL      isFromDirectLaunch;

- (IBAction)login;

@end
