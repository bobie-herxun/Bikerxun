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

@class BeintooVC;

#define NAV_TYPE_MAIN                   1
#define NAV_TYPE_BESTORE                2
#define NAV_TYPE_LEADERBOARD            3
#define NAV_TYPE_ACHIEVEMENTS           4
#define NAV_TYPE_MYOFFERS               5
#define NAV_TYPE_NOTIFICATIONS          6
#define NAV_TYPE_SIGNUP                 7

#define NAV_TYPE_SIGNUP_PRIVATE         8
#define NAV_TYPE_NOTIFICATIONS_PRIVATE  9

@interface BeintooNavigationController : UINavigationController
{	
	UIView *ipadView;
	NSString *transitionEnterSubtype;
	NSString *transitionExitSubtype;
}

- (void)show;
- (void)hide;
- (void)hideNotAnimated;
- (void)prepareBeintooPanelOrientation;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isSignupDirectLaunch;

@end