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

@class BGradientView;

@interface BSignupLayouts : NSObject{
	
}

+ (UIView *)getBeintooDashboardSignupViewWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller;

// Leaderboard
+ (UIView *)getBeintooLeaderboardSignupViewWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller;

+ (UIView *)getBeintooDashboardViewForLockedFeatureWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller andFeature:(NSDictionary *)_feature;

+ (UIView *)getBeintooSignupViewForProfileWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller;

// Profile
+ (UIView *)getBeintooDashboardViewForLockedFeatureProfileWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller;

// Marketplace
+ (UIView *)getBeintooDashboardViewForLockedFeatureMarketplaceWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller;

// Challenges
+ (UIView *)getBeintooDashboardViewForLockedFeatureChallengesWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller;

// TipsAndForum
+ (UIView *)getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller;

@end

