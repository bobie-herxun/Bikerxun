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

@class BeintooSignupVC;
@class BView,BButton,BeintooPlayer;

@interface BeintooSigninFacebookVC : UIViewController {

	BeintooSignupVC *registrationVC;
	BeintooPlayer	*_player;
		
	IBOutlet BView    *beintooView;
	IBOutlet UILabel  *titleLabel1;
	IBOutlet UILabel  *titleLabel2;
	IBOutlet BButton  *loginButton;
	IBOutlet BButton  *newUserButton;
}

- (IBAction)newUserWithFB;
- (IBAction)loginFB;

@end
