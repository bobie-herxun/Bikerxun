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
#import "BeintooDevice.h"

#define LOGIN_NO_PLAYER	  2
#define LOGIN_NO_ERROR	  0

@class BeintooUser,BScore;

@protocol BeintooPlayerDelegate;

@interface BeintooPlayer : NSObject <BeintooParserDelegate>
{	
	id <BeintooPlayerDelegate> delegate;
    id callingDelegate;
    
	int loginError;
	Parser *parser;
	
    NSString *rest_resource;
	NSString *app_rest_resource;
}

+ (void)setPlayerDelegate:(id)_caller;
+ (void)setDelegate:(id)_delegate;

/* 
 * PLAYER LOGIN: 
 *	
 * Delegate callback response on:
 * - (void)playerDidLoginWithResult:(NSDictionary *)result{
 * - (void)playerDidFailLoginWithResult:(NSString *)error{
 */
+ (void)login;

/* 
 * PLAYER SUBMITSCORE: 
 *	
 * Delegate callback response on:
 * - (void)playerDidSumbitScoreWithResult:(NSString *)result;
 * - (void)playerDidFailSubmitScoreWithError:(NSString *)error;
 */
+ (void)submitScore:(int)_score;
+ (void)submitScore:(int)_score forContest:(NSString *)_contestName;
+ (void)submitScoreAndGetRewardForScore:(int)_score andContest:(NSString *)_contestName withThreshold:(int)_threshold;

+ (void)submitScoreAndGetVgoodForScore:(int)_score andContest:(NSString *)_contestName withThreshold:(int)_threshold andVgoodMultiple:(BOOL)_isMultiple __attribute__((deprecated("use '[Beintoo submitScoreAndGetRewardForScore:andContest:withThreshold:]' instead")));
/* 
 * PLAYER GETSCORE: 
 *	
 * Delegate callback response on:
 * - (void)playerDidGetScoreWithResult:(NSString *)result;
 * - (void)playerDidFailGetScoreWithError:(NSString *)error;
 */
+ (void)getScore;

/* 
 * PLAYER SETBALANCE: 
 *	
 * Delegate callback response on:
 * - (void)playerDidSetBalanceWithResult:(NSString *)result;
 * - (void)playerDidFailSetBalanceWithError:(NSString *)error;
 */
+ (void)setBalance:(int)_playerBalance forContest:(NSString *)_contest;

// ---------------------------------------------------------------------------------------

+ (void)notifyPlayerLoginSuccessWithResult:(NSDictionary *)result;
+ (void)notifyPlayerLoginErrorWithResult:(NSString *)result;
+ (void)notifySubmitScoreSuccessWithResult:(NSString *)result;
+ (void)notifySubmitScoreErrorWithResult:(NSString *)error;
+ (void)notifyPlayerGetScoreSuccessWithResult:(NSDictionary *)result;
+ (void)notifyPlayerGetScoreErrorWithResult:(NSString *)error;	
+ (void)notifyPlayerSetBalanceSuccessWithResult:(NSString *)result;
+ (void)notifyPlayerSetBalanceErrorWithResult:(NSString *)error;	

// ----------- Internal API -------------------
- (void)login;
- (void)login:(NSString *)userid;
- (NSDictionary *)blockingLogin:(NSString *)userid;
- (void)getPlayerByGUID:(NSString *)guid;
- (void)getPlayerByUserID:(NSString *)userID;
- (void)backgroundLogin:(NSString *)userid;
- (void)getAllScores;

// APP REST
- (void)topScoreFrom:(int)start andRows:(int)rows forUser:(NSString *)userExt andContest:(NSString *)codeId;
- (void)topScoreFrom:(int)start andRows:(int)rows closeToUser:(NSString *)userExt andContest:(NSString *)codeId;
- (void)showContestList;
- (void)logException:(NSString *    )exception;

- (int)loginError;
- (NSString *)restResource;

// Notifications
+ (void)showNotificationForSubmitScore;
+ (void)showNotificationForLogin;

// Player Score Threshold methods
+ (int)getVgoodThresholdScoreForPlayerKey:(NSString *)_playerKey;
+ (void)setVgoodThresholdScoreForPlayerKey:(NSString *)_playerKey andScore:(int)_score;
+ (void)resetVgoodThresholdScoreForPlayerKey:(NSString *)_playerKey andScore:(int)_score;
+ (int)getThresholdScoreForCurrentPlayerWithContest:(NSString *)codeID;
+ (void)resetVgoodThresholdScoreForContest:(NSString *)_codeId;
    
// Offline SubmitScore handlers
+ (void)addScoreToLocallySavedScores:(NSString *)scoreValue forContest:(NSString *)codeID;
+ (void)flushLocallySavedScore;
+ (void)submitScoreForOfflineScores:(NSString *)scores;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooPlayerDelegate> delegate;
@property(nonatomic, retain) id  callingDelegate;
#else
@property(nonatomic, assign) id <BeintooPlayerDelegate> delegate;
@property(nonatomic, assign) id  callingDelegate;
#endif

@property(nonatomic, retain) Parser *parser;

@end

@protocol BeintooPlayerDelegate <NSObject>

@optional

- (void)playerDidLoginWithResult:(NSDictionary *)result;
- (void)playerDidFailLoginWithResult:(NSString *)error;
- (void)playerDidSumbitScoreWithResult:(NSString *)result;
- (void)playerDidFailSubmitScoreWithError:(NSString *)error;
- (void)playerDidGetScoreWithResult:(NSDictionary *)result;
- (void)playerDidFailGetScoreWithError:(NSString *)error;
- (void)playerDidSetBalanceWithResult:(NSString *)result;
- (void)playerDidFailSetBalanceWithError:(NSString *)error;
- (void)playerDidBackgroundLoginWithResult:(NSDictionary *)result;
- (void)playerDidCompleteBackgroundLogin:(NSDictionary *)result;
- (void)playerDidNotCompleteBackgroundLogin;

- (void)playerDidLogin:(BeintooPlayer *)player;
- (void)player:(BeintooPlayer *)player didSubmitScorewithResult:(NSString *)result andPoints:(NSString *)points;
- (void)appDidGetTopScoreswithResult:(NSDictionary *)result;
- (void)appDidGetContestsForApp:(NSArray *)result;
- (void)didgetPlayerByUser:(NSDictionary *)result;
- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result;

- (void)player:(BeintooPlayer *)player didGetAllScores:(NSDictionary *)result;

@end

