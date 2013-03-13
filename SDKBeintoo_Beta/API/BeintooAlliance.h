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

#define ALLIANCE_ACTION_REMOVE  @"removeme"
#define ALLIANCE_ACTION_ACCEPT  @"ACCEPT"

@protocol BeintooAllianceDelegate;

@interface BeintooAlliance : NSObject <BeintooParserDelegate>{
	
	id <BeintooAllianceDelegate> delegate;
	Parser *parser;
	NSString *rest_resource;
}

- (void)getAllianceWithID:(NSString *)_allianceID;
- (void)getAllianceWithAdminDetailsWithID:(NSString *)_allianceID;
- (void)getAllianceListWithQueryText:(NSString *)_queryText;
- (void)createAllianceWithName:(NSString *)_allianceName andCreatorId:(NSString *)_creatorUserExt;
- (void)performActionOnAlliance:(NSString *)_allianceID withAction:(NSString *)_actionType forUser:(NSString *)_userID;
- (void)allianceAdmin:(NSString *)_adminUserID ofAlliance:(NSString *)_allianceID performAction:(NSString *)_actionType forUser:(NSString *)_userID;
- (void)getPendingRequestsForAlliance:(NSString *)_allianceID withAdmin:(NSString *)_adminUserID;
- (void)sendJoinRequestForUser:(NSString *)_userID toAlliance:(NSString *)_allianceID;
- (void)topScoreFrom:(int)start andRows:(int)rows forContest:(NSString *)codeID;
- (void)allianceAdminInviteFriends:(NSArray *)_friendsIDArray onAlliance:(NSString *)_allianceID;

+ (BOOL)userHasAlliance;
+ (void)setUserWithAlliance:(BOOL)_allianceValue;
+ (BOOL)userIsAllianceAdmin;
+ (void)setUserAllianceAdmin:(BOOL)_adminValue;
+ (NSString *)userAllianceID;
+ (NSString *)userAllianceName;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooAllianceDelegate> delegate;
#else
@property(nonatomic, assign) id <BeintooAllianceDelegate> delegate;
#endif

@property(nonatomic, retain) Parser *parser;

@end

@protocol BeintooAllianceDelegate <NSObject>

@optional
- (void)didGetAlliance:(NSDictionary *)result;
- (void)didGetAlliancesAdminList:(NSDictionary *)result;
- (void)didGetAlliancesList:(NSArray *)result;
- (void)didCreateAlliance:(NSDictionary *)result;
- (void)didGetPendingRequests:(NSArray *)result;
- (void)didAllianceAdminPerformedRequest:(NSDictionary *)result;
- (void)didGetAllianceTopScore:(NSDictionary *)result;
- (void)didInviteFriendsToAllianceWithResult:(NSDictionary *)result;
@end


