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

// PLAYER:from 1 to 29
#define PLAYER_LOGIN_CALLER_ID                  1
#define PLAYER_SSCORE_NOCONT_CALLER_ID          2
#define PLAYER_SSCORE_CONT_CALLER_ID            3
#define PLAYER_GSCORE_ALL_CALLER_ID             4
#define PLAYER_GSCORE_CONT_CALLER_ID            5
#define PLAYER_LOGINwDELEG_CALLER_ID            6
#define PLAYER_GPLAYERBYUSER_CALLER_ID          7
#define PLAYER_GALLSCORES_CALLER_ID             8
#define PLAYER_GPLAYERBYGUID_CALLER_ID          9
#define PLAYER_GSCOREFORCONT_CALLER_ID          10
#define PLAYER_SETBALANCE_CALLER_ID             11
#define PLAYER_FORCE_SSCORE_CALLER_ID           12
#define PLAYER_SSCORE_OFFLINE_CALLER_ID         13
#define PLAYER_BACKGROUND_LOGIN_CALLER_ID       14

// USER:from 30 to 59
#define USER_GUSERBYMP_CALLER_ID                30
#define USER_GUSERBYUDID_CALLER_ID              31
#define USER_SHOWCHALLENGES_CALLER_ID           32
#define USER_CHALLENGEREQ_CALLER_ID             33
#define USER_GFRIENDS_CALLER_ID                 34
#define USER_REMOVEUDID_CALLER_ID               35
#define USER_GUSER_CALLER_ID                    36
#define USER_GETBALANCE_CALLER_ID               37
#define USER_GETBYQUERY_CALLER_ID               38
#define USER_SENDFRIENDSHIP_CALLER_ID           39
#define USER_GETFRIENDSHIP_CALLER_ID            40
#define	USER_REGISTER_CALLER_ID                 41
#define	USER_NICKUPDATE_CALLER_ID               42
#define USER_CHALLENGEPREREQ_CALLER_ID          43
#define USER_BACKGROUND_REGISTER_CALLER_ID      44
#define USER_GIVE_BEDOLLARS_CALLER_ID           45 // deprecated
#define USER_FORGOT_PASSWORD_CALLER_ID          46
#define	USER_SEND_UNFRIENDSHIP_CALLER_ID        47

// VGOOD:from 60 to 79
#define VGOOD_SHOWBYUSER_CALLER_ID              60
#define VGOOD_GET_CALLER_ID                     61
#define VGOOD_SENDGIFT_CALLER_ID                62
#define VGOOD_ACCEPT_CALLER_ID                  63
#define VGOOD_SINGLE_CALLER_ID                  64
#define VGOOD_SINGLEwDELEG_CALLER_ID            65
#define VGOOD_MULTIPLE_CALLER_ID                66
#define VGOOD_MULTIPLEwDELEG_CALLER_ID          67
#define VGOOD_GETPRIVATEVGOODS_CALLER_ID        68
#define VGOOD_ASSIGNPRIVATEVGOOD_CALLER_ID      69
#define VGOOD_REMOVEPRIVATEVGOOD_CALLER_ID      70
#define VGOOD_SET_RATING_CALLER_ID              71
#define VGOOD_GET_COMMENTS_LIST_CALLER_ID       72
#define VGOOD_SET_COMMENT_CALLER_ID             73
#define VGOOD_CHECK_COVERAGE_CALLER_ID          74
#define VGOOD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID  75
#define REWARD_GET_AD_CALLER_ID                 76
#define REWARD_GET_AND_DISPLAY_AD_CALLER_ID     77

// MARKET:from 80 to 89
#define MARKET_SELLVGOOD_CALLER_ID              80
#define MARKET_GOODSTOBUY_CALLER_ID             81
#define MARKET_BUYVGOOD_CALLER_ID               82

// APP:from 90 to 99
#define APP_GTOPSCORES_CALLER_ID                90
#define APP_GCONTESTFORAPP_CALLER_ID            91
#define APP_LOG_EXCEPTION                       92

// MESSAGEfrom 100 to 109
#define MESSAGE_SHOW_CALLER_ID                  100
#define MESSAGE_SEND_CALLER_ID                  101
#define MESSAGE_SET_READ_CALLER_ID              102
#define MESSAGE_DELETE_CALLER_ID                103

// ALLIANCE: from 120 to 129
#define ALLIANCE_GET_CALLER_ID                   120
#define ALLIANCE_GETLIST_CALLER_ID               121
#define ALLIANCE_CREATE_CALLER_ID                122
#define ALLIANCE_GETPENDINGREQUESTS_CALLER_ID    123
#define ALLIANCE_ADMINACTION_CALLER_ID           124
#define ALLIANCE_TOPSCORE_CALLER_ID              125
#define ALLIANCE_INVITEFRIENDS_CALLER_ID         126
#define ALLIANCE_ADMIN_GET_CALLER_ID             127

// MISSION: from 130 to 139
#define MISSION_GET_CALLER_ID                    130
#define MISSION_REFUSE_CALLER_ID                 131

// NOTIFICATION: from 140 to 149
#define NOTIFICATION_GETLIST_CALLER_ID           140
#define NOTIFICATION_SETREAD_CALLER_ID           141

//MARKETPLACE: from 150 to 160
#define MARKETPLACE_GET_CONTENT_CALLER_ID               150
#define MARKETPLACE_GET_CATEGORY_CONTENT_CALLER_ID      151
#define MARKETPLACE_GET_CATEGORIES_CALLER_ID            152

// ACHIEVEMENTS:from 200 to 229
#define ACHIEVEMENTS_GET_CALLER_ID                                  200
#define ACHIEVEMENTS_SUBMIT_PERCENT_ID                              201
#define ACHIEVEMENTS_SUBMIT_SCORE_ID                                202
#define ACHIEVEMENTS_GETSUBMITPERCENT_CALLER_ID                     203
#define ACHIEVEMENTS_GETSUBMITSCORE_CALLER_ID                       204
#define ACHIEVEMENTS_GETINCREMENTSCORE_CALLER_ID                    205
#define ACHIEVEMENTS_GET_PRIVATE_CALLER_ID                          206
#define ACHIEVEMENTS_GETSUBMITPERCENT_CUSTOM_NOTIFICATION_CALLER_ID 207
#define ACHIEVEMENTS_SUBMIT_PERCENT_CUSTOM_NOTIFICATION_ID          208
#define ACHIEVEMENTS_BACKGROUND_ARRAY_ID                            209
#define ACHIEVEMENTS_BACKGROUND_ARRAY_OBJECTID_ID                   210
#define ACHIEVEMENTS_GET_BACKGROUND_ARRAY_ID                        211
#define ACHIEVEMENTS_GET_BACKGROUND_ARRAY_OBJECTID_ID               212
#define ACHIEVEMENTS_GET_SUBMIT_BY_OBJECTID_ID                      213
#define ACHIEVEMENTS_SUBMIT_BY_OBJECTID_ID                          214

// APPS: from 230 to 249
#define APPS_GIVE_BEDOLLARS_CALLER_ID                               230

// APPS: from 250 to 270
#define ADS_REQUEST                                                 250
#define ADS_REQUEST_AND_DISPLAY                                     251

@protocol BeintooParserDelegate;

@interface Parser : NSObject
{	
    NSMutableData	*responseData;
	NSInteger       callerID;
	id              result;
	id <BeintooParserDelegate> delegate;
}

- (void)parsePageAtUrl:(NSString *)URL withHeaders:(NSDictionary *)headers fromCaller:(int)caller;
- (void)parsePageAtUrlWithPOST:(NSString *)URL withHeaders:(NSDictionary *)headers fromCaller:(int)caller;
- (void)parsePageAtUrlWithPOST:(NSString *)URL withHeaders:(NSDictionary *)headers withHTTPBody:(NSString *)httpBody fromCaller:(int)caller;
- (id)blockerParsePageAtUrl:(NSString *)URL withHeaders:(NSDictionary *)headers;
- (NSString *)createJSONFromObject:(id)object;
- (void)retrievedWebPage:(NSMutableURLRequest *)_request;
- (void)parsingEnd:(NSDictionary *)theResult;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, strong) id <BeintooParserDelegate> delegate;
@property(nonatomic, strong) id result;
#else
@property(nonatomic, assign) id <BeintooParserDelegate> delegate;
@property(nonatomic, assign) id result;
#endif

@property(nonatomic, assign) NSInteger callerID;
@property(nonatomic, retain) NSString *webpage;

@end

@protocol BeintooParserDelegate <NSObject>
@optional
- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID;
@end
