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
#import "Parser.h"

@protocol BeintooAchievementsDelegate;

NSString *currentGlobalAchievementId;

@interface BeintooAchievements : NSObject <BeintooParserDelegate>
{	
	id <BeintooAchievementsDelegate> delegate;
	Parser          *parser;
	
	id              callingDelegate;
	NSString        *rest_resource;
	
	// current Achievement informations
	NSString        *currentAchievementID;
	int             currentPercentage;
	int             currentScore;
    
    NSMutableArray  *achievementQueue;
}

- (NSString *)restResource;
+ (void)setDelegate:(id)delegate;
+ (void)setAchievementsDelegate:(id)_caller;

+ (void)unlockAchievement:(NSString *)_achievementID;
+ (void)unlockAchievement:(NSString *)_achievementID showNotification:(BOOL)showNotification;

+ (void)setAchievement:(NSString *)_achievementID withPercentage:(int)_percentageFromZeroTo100;
+ (void)setAchievement:(NSString *)_achievementID withPercentage:(int)_percentageFromZeroTo100 showNotification:(BOOL)showNotification;

+ (void)setAchievement:(NSString *)_achievementID withScore:(int)_score;
+ (void)incrementAchievement:(NSString *)_achievementID withScore:(int)_score;
+ (void)notifyAchievementSubmitSuccessWithResult:(NSDictionary *)result;
+ (void)notifyAchievementSubmitErrorWithResult:(NSString *)error;
+ (void)getAchievementStatusAndPercentage:(NSString *)_achievementId;

// BY OBJECT ID
+ (void)unlockAchievementByObjectID:(NSString *)_objectID showNotification:(BOOL)showNotification;
+ (void)setAchievementByObjectID:(NSString *)_objectID withPercentage:(int)_percentageFromZeroTo100 showNotification:(BOOL)showNotification;
+ (void)unlockAchievementsInBackground:(NSArray *)achievementArray;
+ (void)unlockAchievementsByObjectIDInBackground:(NSArray *)achievementArray;

+ (void)saveUnlockedAchievementLocally:(NSDictionary *)_theAchievement;
+ (NSMutableArray *)getAllLocalAchievements;
+ (BOOL)checkIfAchievementIsSavedLocally:(NSString *)_achievementID;
+ (void)resetAllLocallyAchievementsUnlocked;

// Internal API
- (void)getAchievementsForCurrentUser;

// Achievement notification
+ (void)showNotificationForUnlockedAchievement:(NSDictionary *)_achievement;
+ (void)showNotificationForUnlockedAchievement:(NSDictionary *)_achievement withMissionAchievement:(NSDictionary *)_missionAchiev;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooAchievementsDelegate> delegate;
@property(nonatomic, retain) id  callingDelegate;
#else
@property(nonatomic, assign) id <BeintooAchievementsDelegate> delegate;
@property(nonatomic, assign) id  callingDelegate;
#endif

@property(nonatomic, retain) Parser *parser;
@property(nonatomic, retain) NSString *currentAchievementID;
@property(nonatomic, assign) int currentPercentage;
@property(nonatomic, assign) int currentScore;
@property(nonatomic, assign) BOOL showNotification;
@property(nonatomic, retain) NSMutableArray *achievementQueue;

@end

@protocol BeintooAchievementsDelegate <NSObject>

@optional
- (void)didGetAllUserAchievementsWithResult:(NSArray *)result;
- (void)didSubmitAchievementWithResult:(NSDictionary *)result;
- (void)didFailToSubmitAchievementWithError:(NSString *)error;
- (void)didGetAchievementStatus:(NSString *)_status andPercentage:(int)_percentage forAchievementId:(NSString *)_achievementId;
@end