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

#define BEINTOO_FACEBOOK_SIGNUP     1
#define BEINTOO_FACEBOOK_LOGIN      2

@interface BeintooSignupVC : UIViewController<UIWebViewDelegate, BeintooPlayerDelegate>{

    IBOutlet UIWebView		*registrationWebView;
	NSString				*urlToOpen;
	BeintooPlayer			*_player;
    int                     kindOfDelegateNotification;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL;

@property(nonatomic,retain) NSString *urlToOpen;
@property(nonatomic, retain) IBOutlet UIWebView *registrationWebView;
@property(nonatomic,retain) NSString *caller;

@end
