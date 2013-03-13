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

#define NO_CONNECTION_MESSAGE			9
#define WELCOME_MESSAGE					1
#define SUBMIT_SCORE_MESSAGGE			2
#define CHALLENGE_ACCEPTED_MESSAGE		3
#define CHALLENGE_REJECTED_MESSAGE		4
#define CHALLENGE_TOBEACCEPTED_MESSAGE	5
#define GIFT_SEND_MESSAGE				6
#define GIFT_NOTSEND_MESSAGE			7

#define NOTIFICATION_HEIGHT_ACHIEV      55  // pixels. Achievement standard
#define NOTIFICATION_HEIGHT_ACHIEV_MSN  95  // pixels. Achievement + Mission text
#define NOTIFICATION_HEIGHT_SSCORE      35  // pixels. Submit score
#define NOTIFICATION_HEIGHT_PLOGIN      45  // pixels. Submit score
#define NOTIFICATION_HEIGHT_GIVE_BEDOLLARS      45  // pixels. Submit score
#define NOTIFICATION_HEIGHT_NTDISP      50  // pixels. Nothing to dispatch
#define NOTIFICATION_HEIGHT_MISSION     140 // pixels. Get Mission
#define NOTIFICATION_MARGIN             10

#define NOTIFICATION_SSCORE_SECONDS     3.0 // seconds
#define NOTIFICATION_PLOGIN_SECONDS     3.0 // seconds
#define NOTIFICATION_ACHIEVEM_SECONDS   4.5 // seconds
#define NOTIFICATION_NTODISP_SECONDS    3.5 // seconds
#define NOTIFICATION_GIVE_BEDOLLARS_SECONDS     3.0 // seconds

#define NOTIFICATION_TYPE_SSCORE        123
#define NOTIFICATION_TYPE_ACHIEV        124
#define NOTIFICATION_TYPE_NTDISPATCH    125
#define NOTIFICATION_TYPE_ACHIEV_MSN    126
#define NOTIFICATION_TYPE_MISSION       127
#define NOTIFICATION_TYPE_PLOGIN        128
#define NOTIFICATION_TYPE_GIVE_BEDOLLARS  129

#define BEINTOO_ERROR_MESSAGE 99

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BMessageAnimatedDelegate;

@interface BMessageAnimated : UIView{
	
	UIImageView		*beintooLogo;
	UILabel			*captionLabel;
	UILabel			*achievNameLabel;
    UILabel         *percentageLabel;
    UILabel         *missionLabel;
	NSDictionary	*current_achievement;
    NSDictionary    *achievement_to_complete_mission;
	BOOL			notificationCurrentlyOnScreen;
	int				notificationType;
	
	NSString		*transitionEnterSubtype;
	NSString		*transitionExitSubtype;
    
    id <BMessageAnimatedDelegate> delegate;
}

@property(nonatomic, retain) id <BMessageAnimatedDelegate> delegate;

- (void)showNotification;
- (void)closeNotification;
- (void)prepareNotificationOrientation:(CGRect)startingFrame;
- (void)closeAchievement;
- (void)removeViews;

- (void)drawAchievement;
- (void)drawAchievementWithMission;
- (void)drawSubmitScore;
- (void)drawPlayerLogin;
- (void)drawNothingToDispatch;

- (void)setNotificationContentForAchievement:(NSDictionary *)_theAchievement WithWindowSize:(CGSize)windowSize;
- (void)setNotificationContentForAchievement:(NSDictionary *)_theAchievement andMissionAchievement:(NSDictionary *)_missionAchievem WithWindowSize:(CGSize)windowSize;
- (void)setNotificationContentForSubmitScore:(NSDictionary *)_theScore WithWindowSize:(CGSize)windowSize;
- (void)setNotificationContentForPlayerLogin:(NSDictionary *)_theScore WithWindowSize:(CGSize)windowSize;
- (void)setNotificationContentForNothingToDispatchWithWindowSize:(CGSize)windowSize;
- (void)setNotificationContentForGiveBedollars:(NSDictionary *)_theScore WithWindowSize:(CGSize)windowSize;


+ (NSString *)getMessageFromCode:(int)code;

@end

@protocol BMessageAnimatedDelegate <NSObject>
@optional

- (void)messageDidAppear;
- (void)messageDidDisappear;

@end
