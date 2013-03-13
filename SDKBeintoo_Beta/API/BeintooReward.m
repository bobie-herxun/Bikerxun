/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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

#import "BeintooReward.h"
#import "Beintoo.h"

@implementation BeintooReward

@synthesize delegate, generatedVGood, parser, callingDelegate, vgood;

- (id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
        
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/vgood/",[Beintoo getRestBaseUrl]]];
        
		_player     = [[BeintooPlayer alloc] init];
        vgood       = [[BVirtualGood alloc] init];
	}
    return self;
}

- (id)initWithDelegate:(id)_delegate
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
        
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/vgood/",[Beintoo getRestBaseUrl]]];
        
		_player     = [[BeintooPlayer alloc] init];
        vgood       = [[BVirtualGood alloc] init];
        
        [self setDelegate:_delegate];
	}
    return self;
}

- (NSString *)restResource
{
	return rest_resource;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooReward *service   = [Beintoo beintooRewardService];
	service.callingDelegate = _delegate;
}

#pragma mark - Reward Notification

+ (void)showNotificationForNothingToDispatch
{
	// The main delegate is not called: a notification is shown and hidden by Beintoo on top of the app window
	// After the -showAchievementNotification, an animation is triggered and on complete the view is removed
    
#ifdef BEINTOO_ARC_AVAILABLE
    BMessageAnimated *_notification = [[BMessageAnimated alloc] init];
#else
    BMessageAnimated *_notification = [[[BMessageAnimated alloc] init] autorelease];
#endif
	
    UIWindow *appWindow = [Beintoo getAppWindow];
	
	[_notification setNotificationContentForNothingToDispatchWithWindowSize:appWindow.bounds.size];
	
	[appWindow addSubview:_notification];
	[_notification showNotification];
}

#pragma mark - Check for the availability of rewards

+ (void)checkRewardsCoverage
{
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@coverage", [service restResource]];
	}
	else
		res	= [NSString stringWithFormat:@"%@coverage?latitude=%f&longitude=%f&radius=%f",
               [service restResource], loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            [BeintooDevice getUDID], @"deviceUUID",
                            [BeintooDevice getMacAddress], @"macaddress",
                            [BeintooOpenUDID value], @"openudid",
                            nil];
	[service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_CHECK_COVERAGE_CALLER_ID];
}

+ (void)isEligibleForReward
{
    if ([Beintoo getPlayerID] == nil){
        BeintooLOG(@"Is Eligible For Reward needs a Player ID, retry.");
        return;
    }
    
    [Beintoo updateUserLocation];
    
    BeintooReward *service = [Beintoo beintooRewardService];
    
    NSString *res;
    res = [NSString stringWithFormat:@"%@iseligible/byguid/%@", [service restResource], [Beintoo getPlayerID]];
    
    CLLocation *loc	 = [Beintoo getUserLocation];
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res	= [NSString stringWithFormat:@"%@?allowBanner=true&rows=1",  res];
	}
	else
		res	= [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
               res, loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            [BeintooDevice getUDID], @"deviceUUID",
                            [BeintooDevice getMacAddress], @"macaddress",
                            [BeintooOpenUDID value], @"openudid",
                            nil];
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID];
}

#pragma mark - Get Reward

+ (void)getReward
{
    [Beintoo updateUserLocation];
    
	NSString *guid = [Beintoo getPlayerID];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	if (guid == nil) {
		BeintooLOG(@"Beintoo: unable to generate a Reward. No player found.");
		return;
	}
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@byguid/%@?allowBanner=true&rows=1",[service restResource],guid];
	}
	else
		res	= [NSString stringWithFormat:@"%@byguid/%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
               [service restResource],guid,loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
	
	NSDictionary *params;
    
    if ([BeintooDevice isASIdentifierSupported]){
        params  = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Beintoo getApiKey], @"apikey",
                   [BeintooDevice getMacAddress], @"macaddress",
                   [BeintooDevice getASIdentifier], @"iosaid",
                   [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                   nil];
    }
    else {
        params  = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Beintoo getApiKey], @"apikey",
                   [BeintooDevice getMacAddress], @"macaddress",
                   nil];
    }
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_SINGLE_CALLER_ID];
}

+ (void)getRewardWithDelegate:(id)_delegate
{
	NSString *guid = [Beintoo getPlayerID];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	if (guid == nil) {
		BeintooLOG(@"Beintoo: unable to generate a Reward. No player found.");
		return;
	}
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@byguid/%@?allowBanner=true&rows=1",[service restResource],guid];
	}
	else
		res	= [NSString stringWithFormat:@"%@byguid/%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
			   [service restResource],guid,loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
	
	service.callingDelegate = _delegate;
    
    NSDictionary *params;
    
    if ([BeintooDevice isASIdentifierSupported]){
        params  = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Beintoo getApiKey], @"apikey",
                   [BeintooDevice getMacAddress], @"macaddress",
                   [BeintooDevice getASIdentifier], @"iosaid",
                   [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                   nil];
    }
    else {
        params  = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Beintoo getApiKey], @"apikey",
                   [BeintooDevice getMacAddress], @"macaddress",
                   nil];
    }
    
	[service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_SINGLEwDELEG_CALLER_ID];
}

+ (void)getRewardWithContest:(NSString *)contestID
{
    NSString *guid = [Beintoo getPlayerID];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	if (guid == nil) {
		BeintooLOG(@"Beintoo: unable to generate a Reward. No player found.");
		return;
	}
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@byguid/%@?allowBanner=true&rows=1",[service restResource],guid];
	}
	else
		res	= [NSString stringWithFormat:@"%@byguid/%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
               [service restResource],guid,loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
	
    NSDictionary *params;
    if (!contestID) {
        
        if ([BeintooDevice isASIdentifierSupported]){
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       [BeintooDevice getMacAddress], @"macaddress",
                       [BeintooDevice getASIdentifier], @"iosaid",
                       [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                       nil];
        }
        else {
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       [BeintooDevice getMacAddress], @"macaddress",
                       nil];
        }
        
        BeintooLOG(@"Warning: you called getReward with a contestID, but the constestID you have provided is nil");
    }
    else{
        
        if ([BeintooDevice isASIdentifierSupported]){
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       [BeintooDevice getMacAddress], @"macaddress",
                       contestID,@"codeID",
                       [BeintooDevice getASIdentifier], @"iosaid",
                       [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                       nil];
        }
        else {
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       [BeintooDevice getMacAddress], @"macaddress",
                       contestID,@"codeID",
                       nil];
        }
    }
    
	[service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_SINGLE_CALLER_ID];
}

// -------------------------------------------------------------------------------------
// Private Vgoods Api Calls
// -------------------------------------------------------------------------------------

+ (void)getPlayerPrivateVgoods
{
    NSString *guid = [Beintoo getPlayerID];
    BeintooReward *service = [Beintoo beintooRewardService];
    
    if (guid == nil) {
        BeintooLOG(@"Beintoo: unable to generate a private vgood. No user logged.");
        return;
    }
    
    NSString *res = [NSString stringWithFormat:@"%@privatevgood/show/",[service restResource]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            guid, @"guid",
                            [BeintooDevice getUDID],@"deviceUUID",
                            [BeintooDevice getMacAddress], @"macaddress",
                            nil];
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_GETPRIVATEVGOODS_CALLER_ID];
}

+ (void)assignToPlayerPrivateVgood:(NSString *)vgoodID
{
    NSString *guid = [Beintoo getPlayerID];
    BeintooReward *service = [Beintoo beintooRewardService];
    
    if (guid == nil) {
        BeintooLOG(@"Beintoo error. No user logged.");
        return;
    }
    
    NSString *res = [NSString stringWithFormat:@"%@privatevgood/assign/%@/%@/",[service restResource],vgoodID,guid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [BeintooDevice getMacAddress], @"macaddress", nil];
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_ASSIGNPRIVATEVGOOD_CALLER_ID];
}

+ (void)removeFromPlayerPrivateVgood:(NSString *)vgoodID
{
    NSString *guid = [Beintoo getPlayerID];
    BeintooReward *service = [Beintoo beintooRewardService];
    
    if (guid == nil) {
        BeintooLOG(@"Beintoo error. No user logged.");
        return;
    }
    
    NSString *res = [NSString stringWithFormat:@"%@privatevgood/remove/%@/%@/",[service restResource],vgoodID,guid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",
                            [BeintooDevice getMacAddress], @"macaddress",
                            nil];
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_REMOVEPRIVATEVGOOD_CALLER_ID];
}

+ (void)notifyVGoodGenerationOnUserDelegate
{
	BeintooReward *service = [Beintoo beintooRewardService];
	id _callingDelegate = service.callingDelegate;
    
    if ([_callingDelegate respondsToSelector:@selector(didBeintooGenerateAReward:)]) {
		[_callingDelegate didBeintooGenerateAReward:[Beintoo getLastGeneratedVGood]];
	}
}

+ (void)notifyVGoodGenerationErrorOnUserDelegate:(NSDictionary *)_error
{
	BeintooReward *service = [Beintoo beintooRewardService];
	id _callingDelegate = service.callingDelegate;
    
	if ([_callingDelegate respondsToSelector:@selector(didBeintooFailToGenerateARewardWithError:)]) {
		[_callingDelegate didBeintooFailToGenerateARewardWithError:_error];
	}
}

+ (void)notifyAdGenerationOnUserDelegate
{
	BeintooReward *service = [Beintoo beintooRewardService];
	id _callingDelegate = service.callingDelegate;
    
    if ([_callingDelegate respondsToSelector:@selector(didBeintooGenerateAnAd:)]) {
		[_callingDelegate didBeintooGenerateAnAd:[Beintoo getLastGeneratedAd]];
	}
}

+ (void)notifyAdGenerationErrorOnUserDelegate:(NSDictionary *)_error
{
	BeintooReward *service = [Beintoo beintooRewardService];
	id _callingDelegate = service.callingDelegate;
    
	if ([_callingDelegate respondsToSelector:@selector(didBeintooFailToGenerateAnAdWithError:)]) {
		[_callingDelegate didBeintooFailToGenerateAnAdWithError:_error];
	}
}

#pragma mark -
#pragma mark API

- (void)showGoodsByUserForState:(int)state
{
	NSString *res;
	if (state == TO_BE_CONVERTED)
		res  = [NSString stringWithFormat:@"%@show/byuser/%@",rest_resource,[Beintoo getUserID]];
	if (state == CONVERTED) {
		res = [NSString stringWithFormat:@"%@show/byuser/%@/?onlyConverted=true",rest_resource,[Beintoo getUserID]];
	}
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_SHOWBYUSER_CALLER_ID];
}

- (void)showGoodsByPlayerForState:(int)state
{
	NSString *res;
	if (state == TO_BE_CONVERTED)
		res  = [NSString stringWithFormat:@"%@show/",rest_resource];
	if (state == CONVERTED) {
		res = [NSString stringWithFormat:@"%@show/?onlyConverted=true",rest_resource];
	}
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",[Beintoo getPlayerID], @"guid", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_SHOWBYUSER_CALLER_ID];
    
}

- (void)sendGoodWithID:(NSString *)good_id asGiftToUser:(NSString *)ext_id_to
{
	NSString *res  = [NSString stringWithFormat:@"%@sendasgift/%@/%@/%@",rest_resource,good_id,[Beintoo getUserID],ext_id_to];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_SENDGIFT_CALLER_ID];
}

- (void)acceptGoodWithId:(NSString *)good_id
{
	NSString *res  = [NSString stringWithFormat:@"%@accept/%@/",rest_resource,good_id];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",[Beintoo getPlayerID], @"guid", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_ACCEPT_CALLER_ID];
}

#pragma mark -
#pragma mark MARKETPLACE VGOODS

- (void)setRatingForVgoodId:(NSString *)_vgoodId andUser:(NSString *)_userExt withRate:(int)_rating
{
    NSString *res		 = [NSString stringWithFormat:@"%@comment", rest_resource];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", _userExt, @"userExt", nil];
    
    NSString *body = [NSString stringWithFormat:@"rating=%i&vgood=%@", _rating, _vgoodId];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:body fromCaller:VGOOD_SET_RATING_CALLER_ID];
}

- (void)getCommentListForVgoodId:(NSString *)_vgoodId
{
    NSString *res		 = [NSString stringWithFormat:@"%@comment?vgood=%@", rest_resource, _vgoodId];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
    
    [parser parsePageAtUrl:res withHeaders:params fromCaller:VGOOD_GET_COMMENTS_LIST_CALLER_ID];
}

- (void)setCommentForVgoodId:(NSString *)_vgoodId andUser:(NSString *)_userExt withComment:(NSString *)_comment
{
    NSString *res		 = [NSString stringWithFormat:@"%@comment", rest_resource];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", _userExt, @"userExt", nil];
    
    NSString *body = [NSString stringWithFormat:@"text=%@&vgood=%@", _comment, _vgoodId];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:body fromCaller:VGOOD_SET_COMMENT_CALLER_ID];
}

#pragma mark -
#pragma mark MARKETPLACE

- (void)sellVGood:(NSString *)vGood_Id
{
	NSString *res  = [NSString stringWithFormat:@"%@/marketplace/sell/%@/%@",rest_resource,vGood_Id,[Beintoo getUserID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:MARKET_SELLVGOOD_CALLER_ID];
	BeintooLOG(@"CALL %@ with params %@",res,params);
}

- (void)showGoodsToBuy
{
	NSString *res  = [NSString stringWithFormat:@"%@/marketplace/show/",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:MARKET_GOODSTOBUY_CALLER_ID];
	BeintooLOG(@"CALL %@ with params %@",res,params);
}

- (void)showGoodsToBuyFeatured
{
	NSString *res  = [NSString stringWithFormat:@"%@/marketplace/show/?featured=true",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:MARKET_GOODSTOBUY_CALLER_ID];
	BeintooLOG(@"CALL %@ with params %@",res,params);
}

- (void)buyGoodFromUser:(NSString *)vGood_Id
{
	NSString *res  = [NSString stringWithFormat:@"%@/marketplace/buy/%@/%@",rest_resource,vGood_Id,[Beintoo getUserID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:MARKET_BUYVGOOD_CALLER_ID];
	BeintooLOG(@"CALL %@ with params %@",res,params);
}

- (void)buyGoodFeatured:(NSString *)vGood_Id
{
	NSString *res  = [NSString stringWithFormat:@"%@/marketplace/featured/buy/%@/%@",rest_resource,vGood_Id,[Beintoo getUserID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params fromCaller:MARKET_BUYVGOOD_CALLER_ID];
	BeintooLOG(@"CALL %@ with params %@",res,params);
}

#pragma mark -
#pragma mark parser delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
    switch (callerID){
            
        case VGOOD_CHECK_COVERAGE_CALLER_ID:
        {
            BeintooReward *beintooReward = [Beintoo beintooRewardService];
            if ([result objectForKey:@"isCovered"]){
                
                if ([[result objectForKey:@"isCovered"] boolValue] == TRUE){
                    
                    if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooHasRewardsCoverage)]){
                        [beintooReward.callingDelegate beintooHasRewardsCoverage];
                    }
                    return;
                }
            }
            
            if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooHasNotRewardsCoverage)])
                [beintooReward.callingDelegate beintooHasNotRewardsCoverage];
            
        }
            break;
            
        case VGOOD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID:
        {
            BeintooReward *beintooReward = [Beintoo beintooRewardService];
            
            if ([result objectForKey:@"messageID"]){
                if ([[result objectForKey:@"messageID"] intValue] == 0){
                    
                    if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooPlayerIsEligibleForReward)]){
                        [beintooReward.callingDelegate beintooPlayerIsEligibleForReward];
                    }
                    return;
                }
                else if ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE){
                    
                    if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooPlayerIsNotEligibleForReward)]){
                        [beintooReward.callingDelegate beintooPlayerIsNotEligibleForReward];
                    }
                    
                    if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooPlayerIsOverQuotaForReward)]){
                        [beintooReward.callingDelegate beintooPlayerIsOverQuotaForReward];
                    }
                    return;
                }
                else if ([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE || [[result objectForKey:@"messageID"] intValue] == -21){
                    
                    if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooPlayerIsNotEligibleForReward)]){
                        [beintooReward.callingDelegate beintooPlayerIsNotEligibleForReward];
                    }
                    
                    if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooPlayerGotNothingToDispatchForReward)]){
                        [beintooReward.callingDelegate beintooPlayerGotNothingToDispatchForReward];
                    }
                    return;
                }
            }
            
            if ([beintooReward.callingDelegate respondsToSelector:@selector(beintooPlayerIsNotEligibleForReward)]){
                [beintooReward.callingDelegate beintooPlayerIsNotEligibleForReward];
            }
            
        }
            break;
            
        case VGOOD_SINGLE_CALLER_ID:{  // -------------------- SINGLE NO DELEGATE
			@try {
				
                if ([result objectForKey:@"messageID"]) {
					// No vgood is generated. a notification is sent to the main delegate
					[Beintoo notifyVGoodGenerationErrorOnMainDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
                }
				NSArray *vgoodList = [result objectForKey:@"vgoods"];
                
				if (vgoodList == nil || [vgoodList count]<1) {
					[Beintoo notifyVGoodGenerationErrorOnMainDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
				
				generatedVGood = [vgoodList objectAtIndex:0];
                
                [vgood setVgoodContent:generatedVGood];
				[vgood setTheGood:generatedVGood];
				[Beintoo setLastGeneratedVgood:vgood];
				
				[Beintoo notifyVGoodGenerationOnMainDelegate];
                
                if (callingDelegate != nil)
                    [Beintoo launchPrizeOnAppWithDelegate:callingDelegate];
                else
                    [Beintoo launchPrize];
                
			}
			@catch (NSException * e) {
				//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			}
		}
			break;
			
		case VGOOD_SINGLEwDELEG_CALLER_ID:{ // -------------------- SINGLE WITH DELEGATE
			@try {
				if ([result objectForKey:@"messageID"]) {
					// No vgood is generated. a notification is sent to the main delegate
					[BeintooVgood notifyVGoodGenerationErrorOnUserDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
				NSArray *vgoodList = [result objectForKey:@"vgoods"];
				
				if (vgoodList == nil || [vgoodList count]<1) {
					[BeintooReward notifyVGoodGenerationErrorOnUserDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
				
				generatedVGood = [vgoodList objectAtIndex:0];
                
				[vgood setVgoodContent:generatedVGood];
				[vgood setTheGood:generatedVGood];
				[Beintoo setLastGeneratedVgood:vgood];
				
				[Beintoo notifyVGoodGenerationOnMainDelegate];
                
                if (callingDelegate != nil)
                    [Beintoo launchPrizeOnAppWithDelegate:callingDelegate];
                else
                    [Beintoo launchPrize];
                
            }
			@catch (NSException * e) {
				//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			}
		}
			break;
            
		case VGOOD_MULTIPLE_CALLER_ID:{  // -------------------- MULTIPLE NO DELEGATE
			@try {
				//BeintooLOG(@"multiple vgood result %@",result);
				if ([result objectForKey:@"messageID"]) {
					// No vgood is generated. a notification is sent to the main delegate
					[Beintoo notifyVGoodGenerationErrorOnMainDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
				NSArray *vgoodList = [result objectForKey:@"vgoods"];
				
				if (vgoodList == nil || [vgoodList count]<1) {
					[Beintoo notifyVGoodGenerationErrorOnMainDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
                
				if ([vgoodList count]==1 || ([[vgoodList objectAtIndex:0] objectForKey:@"isBanner"]!=nil) ) {
					// ------ We received only one vgood or a recommendation
					generatedVGood = [vgoodList objectAtIndex:0];
					
					[vgood setVgoodContent:generatedVGood];
					[vgood setTheGood:generatedVGood];
					[Beintoo setLastGeneratedVgood:vgood];
					
					[Beintoo notifyVGoodGenerationOnMainDelegate];
                    
                    if (callingDelegate != nil)
                        [Beintoo launchPrizeOnAppWithDelegate:callingDelegate];
                    else
                        [Beintoo launchPrize];
                    
                }
				if ([vgoodList count]>1 && ([[vgoodList objectAtIndex:0] objectForKey:@"isBanner"]==nil) ) { // ------ We received a list of vgood: this is a real multiple vgood
					
                    [vgood setTheGoodsList:vgoodList];
					[vgood setVgoodContent:[vgoodList objectAtIndex:0]];
					[vgood setIsMultiple:YES];
					[Beintoo setLastGeneratedVgood:vgood];
					
                    [Beintoo notifyVGoodGenerationOnMainDelegate];
                    
                }
			}
			@catch (NSException * e) {
				//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			}
		}
			break;
            
		case VGOOD_MULTIPLEwDELEG_CALLER_ID:{  // -------------------- MULTIPLE WITH DELEGATE
			@try {
				//BeintooLOG(@"multiple vgood result %@",result);
				if ([result objectForKey:@"messageID"]) {
					// No vgood is generated. a notification is sent to the main delegate
					[BeintooVgood notifyVGoodGenerationErrorOnUserDelegate:[result objectForKey:@"message"]];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooVgood showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
				NSArray *vgoodList = [result objectForKey:@"vgoods"];
				
				if (vgoodList == nil || [vgoodList count]<1) {
					[BeintooVgood notifyVGoodGenerationErrorOnUserDelegate:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooVgood showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
				
				if ([vgoodList count] == 1 || ([[vgoodList objectAtIndex:0] objectForKey:@"isBanner"] != nil) ) {
					// ------ We received only one vgood or a recommendation
					generatedVGood = [vgoodList objectAtIndex:0];
					
					[vgood setVgoodContent:generatedVGood];
					[vgood setTheGood:generatedVGood];
					[Beintoo setLastGeneratedVgood:vgood];
					
					[Beintoo notifyVGoodGenerationOnMainDelegate];
                    
                    if (callingDelegate != nil)
                        [Beintoo launchPrizeOnAppWithDelegate:callingDelegate];
                    else
                        [Beintoo launchPrize];
                    
                }
				if ([vgoodList count] > 1 && ([[vgoodList objectAtIndex:0] objectForKey:@"isBanner"] == nil) ) { // ------ We received a list of vgood: this is a real multiple vgood
					
                    [vgood setTheGoodsList:vgoodList];
					[vgood setVgoodContent:[vgoodList objectAtIndex:0]];
					[vgood setIsMultiple:YES];
					[Beintoo setLastGeneratedVgood:vgood];
					
                    [BeintooVgood notifyVGoodGenerationOnUserDelegate];
                    
                    if (callingDelegate != nil)
                        [Beintoo launchPrizeOnAppWithDelegate:callingDelegate];
                    else
                        [Beintoo launchPrize];
                    
				}
			}
			@catch (NSException * e) {
				//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			}
		}
			break;
            
        case VGOOD_GETPRIVATEVGOODS_CALLER_ID:{
            BeintooLOG(@"get private result %@",result);
            if ([[self delegate] respondsToSelector:@selector(didGetAllPrivateVgoods:)]){
                [[self delegate] didGetAllPrivateVgoods:(NSArray *)result];
            }
		}
			break;
            
        case VGOOD_ASSIGNPRIVATEVGOOD_CALLER_ID:{
            BeintooLOG(@"assign private %@",result);
            if ([[self delegate] respondsToSelector:@selector(didAssignPrivateVgoodToPlayerWithResult:)]) {
                [[self delegate] didAssignPrivateVgoodToPlayerWithResult:result];
            }
		}
			break;
            
        case VGOOD_REMOVEPRIVATEVGOOD_CALLER_ID:{
            if ([[self delegate] respondsToSelector:@selector(didRemovePrivateVgoodToPlayerWithResult:)]) {
                [[self delegate] didRemovePrivateVgoodToPlayerWithResult:result];
            }
		}
			break;
			
            
            // ----------------------------------------------------------------------------------------------------
            // ----------------------------------------------------------------------------------------------------
            
			
		case VGOOD_SHOWBYUSER_CALLER_ID:{
			[[self delegate]didGetAllvGoods:(NSArray *)result];
		}
			break;
			
		case VGOOD_ACCEPT_CALLER_ID:{
			//BeintooLOG(@"ACCEPT RES: %@",result);
			if ([[self delegate] respondsToSelector:@selector(didAcceptVgood)]) {
				[[self delegate] didAcceptVgood];
			}
		}
			break;
			
		case VGOOD_SENDGIFT_CALLER_ID:{
			if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) {
				[[self delegate]didSendVGoodAsGift:YES];
			}
			else {[[self delegate]didSendVGoodAsGift:NO];}
		}
			break;
            
            /* ------ MARKETPLACE VGOODS ------- */
            
        case VGOOD_SET_RATING_CALLER_ID:{
            
            //BeintooLOG(@"resul rating marketplace %@", result);
			if ([result objectForKey:@"rating"]){
                if ([[self delegate] respondsToSelector:@selector(didSetRating:)]) {
                    [[self delegate] didSetRating:(NSDictionary *)result];
                }
            }
            else {
                BeintooLOG(@"Beintoo Vgood set rating: did encour an error");
            }
		}
			break;
            
        case VGOOD_GET_COMMENTS_LIST_CALLER_ID:{
            
            //BeintooLOG(@"resul comments get  marketplace %@", result);
			
            if ([[self delegate] respondsToSelector:@selector(didGetCommentsList:)]) {
                [[self delegate] didGetCommentsList:(NSMutableArray *)result];
            }
            
        }
			break;
            
        case VGOOD_SET_COMMENT_CALLER_ID:{
            
            //BeintooLOG(@"resul comments get  marketplace %@", result);
			
            if ([[self delegate] respondsToSelector:@selector(didSetCommentForVgood:)]) {
                [[self delegate] didSetCommentForVgood:(NSDictionary *)result];
            }
            
        }
			break;
            
            /* ------ MARKETPLACE ------- */
			
		case MARKET_SELLVGOOD_CALLER_ID:{
			//BeintooLOG(@"sellVGOOD result: %@",result);
			if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) {
				[[self delegate]didSellVGood:YES];
			}
			else {[[self delegate]didSellVGood:NO];}
		}
			break;
		case MARKET_GOODSTOBUY_CALLER_ID:{
			//BeintooLOG(@"vgood to buy result: %@",result);
			[[self delegate]didGetVGoodsToBuy:(NSArray *)result];
		}
			break;
		case MARKET_BUYVGOOD_CALLER_ID:{
			//BeintooLOG(@"vgood bought result: %@",result);
			[[self delegate]didBuyVgoodWithResult:result];
		}
			break;
			
		default:{
			//statements
		}
			break;
	}
}

- (void)dealloc
{
    parser.delegate = nil;
    _player.delegate = nil;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[_player release];
	[rest_resource release];
    [vgood release];
    
	[super dealloc];
#endif
    
}

@end
