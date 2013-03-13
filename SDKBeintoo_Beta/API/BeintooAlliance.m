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

#import "BeintooAlliance.h"
#import "Beintoo.h"


@implementation BeintooAlliance

@synthesize delegate,parser;

- (id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
		
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/alliance/", [Beintoo getRestBaseUrl]]];
	}
    return self;
}


#pragma mark -
#pragma mark API

- (void)getAllianceWithID:(NSString *)_allianceID
{
    NSString *res		 = [NSString stringWithFormat:@"%@%@",rest_resource,_allianceID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:ALLIANCE_GET_CALLER_ID];
}

- (void)getAllianceWithAdminDetailsWithID:(NSString *)_allianceID
{
    NSString *res		 = [NSString stringWithFormat:@"%@%@?userExt=%@", rest_resource, _allianceID, [Beintoo getUserID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:ALLIANCE_ADMIN_GET_CALLER_ID];
}

- (void)getAllianceListWithQueryText:(NSString *)_queryText
{
    NSString *res;
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    
    if (!_queryText || [_queryText length]<=0) {
        res = [NSString stringWithFormat:@"%@",rest_resource];
    }
    else{
        res = [NSString stringWithFormat:@"%@?query=%@",rest_resource,_queryText];
    }
    [parser parsePageAtUrl:res withHeaders:params fromCaller:ALLIANCE_GETLIST_CALLER_ID];
}

- (void)createAllianceWithName:(NSString *)_allianceName andCreatorId:(NSString *)_creatorUserExt
{
    NSString *res        = [NSString stringWithFormat:@"%@",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    NSString *httpBody   = [NSString stringWithFormat:@"userExt=%@&name=%@",_creatorUserExt,_allianceName];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ALLIANCE_CREATE_CALLER_ID];
}

- (void)performActionOnAlliance:(NSString *)_allianceID withAction:(NSString *)_actionType forUser:(NSString *)_userID
{
    NSString *res = [NSString stringWithFormat:@"%@%@/%@/%@",rest_resource,_allianceID,_actionType,_userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:ALLIANCE_ADMINACTION_CALLER_ID];
}

- (void)allianceAdmin:(NSString *)_adminUserID ofAlliance:(NSString *)_allianceID performAction:(NSString *)_actionType forUser:(NSString *)_userID
{
    NSString *res = [NSString stringWithFormat:@"%@%@/%@/%@/%@",rest_resource,_allianceID,_adminUserID,_actionType,_userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    
    [parser parsePageAtUrl:res withHeaders:params fromCaller:ALLIANCE_ADMINACTION_CALLER_ID];
}

- (void)getPendingRequestsForAlliance:(NSString *)_allianceID withAdmin:(NSString *)_adminUserID
{        
    NSString *res        = [NSString stringWithFormat:@"%@%@/%@/PENDING",rest_resource,_allianceID,_adminUserID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    [parser parsePageAtUrl:res withHeaders:params fromCaller:ALLIANCE_GETPENDINGREQUESTS_CALLER_ID];
}

- (void)sendJoinRequestForUser:(NSString *)_userID toAlliance:(NSString *)_allianceID
{
    NSString *res        = [NSString stringWithFormat:@"%@%@/addme/%@",rest_resource,_allianceID,_userID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];

    [parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:ALLIANCE_ADMINACTION_CALLER_ID];
}

- (void)topScoreFrom:(int)start andRows:(int)rows forContest:(NSString *)codeID
{
    NSString *res        = [NSString stringWithFormat:@"%@topscore?start=%d&rows=%d",rest_resource,start,rows];
	NSDictionary *params;
    
    if (codeID != nil) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",codeID,@"codeID",nil];
    }
    else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];      
    }
    if ([BeintooAlliance userHasAlliance]) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&id=%@",[BeintooAlliance userAllianceID]]];
    }
    
    [parser parsePageAtUrl:res withHeaders:params fromCaller:ALLIANCE_TOPSCORE_CALLER_ID];
}

- (void)allianceAdminInviteFriends:(NSArray *)_friendsIDArray onAlliance:(NSString *)_allianceID
{
    NSString *res        = [NSString stringWithFormat:@"%@%@/invite/",rest_resource,_allianceID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
    
    NSString *httpBody   = [NSString stringWithFormat:@"inputJson=%@",[parser createJSONFromObject:_friendsIDArray]];
    
   [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ALLIANCE_INVITEFRIENDS_CALLER_ID];
}

#pragma mark -
#pragma mark Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID{	
	switch (callerID){
		case ALLIANCE_GET_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didGetAlliance:)]) {
                [[self delegate] didGetAlliance:result];
            }
		}
			break;
            
        case ALLIANCE_ADMIN_GET_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didGetAlliancesAdminList:)]) {
                [[self delegate] didGetAlliancesAdminList:result];
            }
		}
						
		case ALLIANCE_GETLIST_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didGetAlliancesList:)]) {
                [[self delegate] didGetAlliancesList:(NSArray *)result];
            }
		}
			break;
		
        case ALLIANCE_CREATE_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didCreateAlliance:)]) {
                [[self delegate] didCreateAlliance:(NSDictionary *)result];
            }
		}
			break;
            
        case ALLIANCE_GETPENDINGREQUESTS_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didGetPendingRequests:)]) {
                [[self delegate] didGetPendingRequests:(NSArray *)result];
            }
		}
			break;
            
        case ALLIANCE_ADMINACTION_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didAllianceAdminPerformedRequest:)]) {
                [[self delegate] didAllianceAdminPerformedRequest:(NSDictionary *)result];
            }
		}
			break;
		case ALLIANCE_TOPSCORE_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didGetAllianceTopScore:)]) {
                [[self delegate] didGetAllianceTopScore:(NSDictionary *)result];
            }
		}
			break;
            
        case ALLIANCE_INVITEFRIENDS_CALLER_ID:{
            if ([[self delegate]respondsToSelector:@selector(didInviteFriendsToAllianceWithResult:)]) {
                [[self delegate] didInviteFriendsToAllianceWithResult:(NSDictionary *)result];
            }
		}
			break;
            
        default:{
			//statements
		}
			break;
	}	
}

#pragma mark -
#pragma mark Class Methods

+ (BOOL)userHasAlliance
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hasUserAlliance"];
}

+ (void)setUserWithAlliance:(BOOL)_allianceValue
{
    [[NSUserDefaults standardUserDefaults] setBool:_allianceValue forKey:@"hasUserAlliance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)userIsAllianceAdmin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isAllianceAdmin"];
}

+ (void)setUserAllianceAdmin:(BOOL)_adminValue
{
    [[NSUserDefaults standardUserDefaults] setBool:_adminValue forKey:@"isAllianceAdmin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userAllianceID
{
    return [[[Beintoo getPlayer] objectForKey:@"alliance"] objectForKey:@"id"];
}

+ (NSString *)userAllianceName
{
    return [[[Beintoo getPlayer] objectForKey:@"alliance"] objectForKey:@"name"];
}

- (void)dealloc {
    parser.delegate = nil;
	
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [parser release];
	[rest_resource release];
    [super dealloc];
#endif
}

@end
