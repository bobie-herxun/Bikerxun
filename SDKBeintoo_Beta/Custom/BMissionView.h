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
#import "BeintooDevice.h"

#define MISSION_TYPE_NEW					1
#define MISSION_TYPE_ONGOING                2
#define MISSION_TYPE_ACCOMPLISHED           3

#define MISSION_NORMAL_PADDING              5
#define MISSION_SUBVIEWS_PADDING            7
#define MISSION_PIXELS_PER_ACHIEVEM         90
#define ACHIEVEMENT_IMAGESIZE               50

#define ALERT_HEIGHT_VGOOD                  69
#define RECOMMENDATION_TEXTHEIGHT           25      

@class BButton;

@protocol BeintooMissionViewDelegate;

@interface BMissionView : UIView <UIWebViewDelegate>{
	
	UIImageView		*prizeThumb;
	UILabel			*textLabel;
	UILabel			*detailedTextLabel;
	UIButton		*closeBtn;
	BOOL			firstTouch;
	
	NSString		*transitionEnterSubtype;
	NSString		*transitionExitSubtype;
	
	int				missionType;
	
	id <BeintooMissionViewDelegate> delegate;
}

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooMissionViewDelegate> delegate;
#else
@property(nonatomic, assign) id <BeintooMissionViewDelegate> delegate;
#endif

@property(nonatomic,retain) UIImageView *beintooLogo;
@property(nonatomic,retain) UIImageView *prizeThumb;
@property(nonatomic,retain) UIImageView *prizeImg;
@property(nonatomic,retain) UILabel *textLabel;
@property(nonatomic,retain) UILabel *detailedTextLabel;
@property(nonatomic) int missionType;

- (void)removeViews;
- (void)show;
- (void)drawMission;
- (void)setMissionContentWithWindowSize:(CGSize)windowSize;
- (void)prepareMissionAlertOrientation:(CGRect)startingFrame;
- (void)setContentForAchievementsView:(UIView *)_achievView withSponsAch:(NSDictionary *)_sponsoredAch andPlayerAch:(NSDictionary *)_playerAch;
- (void)setContentForOngoingAcceptview:(UIView *)_ongoingAcceptView;
- (void)setContentForMissionOverView:(UIView *)_missionOverView;
- (void)setContentForMissionOverLandscapeView:(UIView *)_missionOverView;
- (void)setContentForMissionNewView:(UIView *)_missionNewView;

@end

@protocol BeintooMissionViewDelegate <NSObject>

@optional
- (void)userDidTapOnTheMission; // ? not sure to need this
- (void)userDidTapOnCloseMission;
- (void)userDidTapOnMissionGetItReal;
@end

