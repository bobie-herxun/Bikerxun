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

#import "BeintooUser.h"
#import "Beintoo.h"

NSString *GIVE_1_BEDOLLAR = @"GIVE_BEDOLLARS_1";
NSString *GIVE_2_BEDOLLAR = @"GIVE_BEDOLLARS_2";
NSString *GIVE_5_BEDOLLAR = @"GIVE_BEDOLLARS_5";

@implementation BeintooUser

@synthesize delegate, parser, callingDelegate, userParams, showGiveBedollarsNotification, giveBedollarsContent, notificationPosition;

- (id)init
{
	if (self = [super init])
	{
        parser          = [[Parser alloc] init];
		parser.delegate = self;
		rest_resource   = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/user/",[Beintoo getRestBaseUrl]]];
        app_rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/app/",[Beintoo getRestBaseUrl]]];
        
        giveBedollarsContent   = [[BVirtualGood alloc] init];
	}
    return self;
}

- (NSString *)restResource
{
	return rest_resource;
}

- (NSString *)appRestResource
{
	return app_rest_resource;
}

+ (void)setUserDelegate:(id)_caller
{
	BeintooUser *userService = [Beintoo beintooUserService];
	userService.delegate = _caller;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooUser *userService = [Beintoo beintooUserService];
	userService.delegate = _delegate;
}

- (void)showGiveBedollarsAlert
{	
	UIWindow *appWindow = [Beintoo getAppWindow];
    
    BTemplateGiveBedollars	*_prizeView = [[BTemplateGiveBedollars alloc] init];
    
    if (_prizeView.isVisible == NO){
        
        
        /*if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
         [_mainDelegate beintooPrizeAlertDidAppear];
         }*/
        
        _prizeView.type = GIVE_BEDOLLARS;
        BVirtualGood *virtualGood = [[BVirtualGood alloc] init];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:@"<html><head><script type=\"text/javascript\">function show_signup(){ document.getElementById(\"be-banner-signup\").style.display = \"inherit\";} var timer=setTimeout(function(){closeTimer()},3500); function closeTimer(){window.close();window.location.href = \"#ios-close\";}function clearTimer(){clearInterval(timer);}</script><body style=\"margin:0 auto\"><link rel=stylesheet href=\"http://static.beintoo.com/vgoodsdk/give-bedollars-style.css\"><div class=be-give-main id=b-container-player><a href=\"#ios-close\" id=close onclick=\"window.close()\">x</a><a href=\"#\" onclick=\"clearTimer();show_signup();\"></a><div id=b-container><img src=\"http://static.beintoo.com/vgoodsdk/style.png\" id=b-logo-img><div id=b-text-container><div id=b-title>You're doing great!</div><div>{{sponsor}}<span style=\"color: #c4c3c3\">wants to reward your<br>achievement with</span><span id=b-amount>{{amount}} Bedollars</span></div><div id=b-claim>TAP TO CLAIM</div><div id=b-logo><img src=\"http://static.beintoo.com/vgoodsdk/logob.png\"></div></div></div><div id=be-banner-signup><div id=b-signup-player><form action=\"{{{form_url}}}\" id=email-form class=btn-input><fieldset><input placeholder=\"Insert your email\" id=email name=email><input type=hidden id=guid name=guid value=\"{{guid}}\"><input id=sbt type=submit value=CLAIM></fieldset></form><p class=be-disclaimer>Enter your email to claim this offer. By clicking on 'CLAIM' you agree to the Terms and Privacy Policy.</p></div></div></div>" forKey:@"content"];
        virtualGood.theGood = dictionary;
        _prizeView.contentHTML = virtualGood;
        
        [_prizeView setPrizeContentWithWindowSize:appWindow.bounds.size];
        [appWindow addSubview:_prizeView];
        
        [_prizeView setIsVisible:YES];
    }
}

#pragma mark -
#pragma mark API

- (void)getUser
{	
	NSString *userExt = [Beintoo getUserID];
	if (userExt == nil) {
		return;
	}
	NSString *res		 = [NSString stringWithFormat:@"%@%@",rest_resource,userExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSER_CALLER_ID];
}

- (void)getUserByM:(NSString *)m andP:(NSString *)p
{
	NSString *res		 = [NSString stringWithFormat:@"%@byemail/",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",m,@"email",p,@"password", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSERBYMP_CALLER_ID];
}

- (void)getUserByUDID
{
	NSString *res		 = [NSString stringWithFormat:@"%@bydeviceUDID/%@/",rest_resource,[BeintooDevice getUDID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSERBYUDID_CALLER_ID];	
}

- (void)showChallengesbyStatus:(int)status
{
	NSString *res		 = [NSString stringWithFormat:@"%@challenge/show/%@/%@/",rest_resource,
							[Beintoo getUserID], [self getStatusCode:status]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SHOWCHALLENGES_CALLER_ID];
}

- (void)challengeRequestfrom:(NSString *)userIDFrom	to:(NSString *)userIDTo withAction:(NSString *)action forContest:(NSString *)contest
{
	NSString *res		 = [NSString stringWithFormat:@"%@challenge/%@/%@/%@",rest_resource,userIDFrom,action,userIDTo];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",contest,@"codeID", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_CHALLENGEREQ_CALLER_ID];
}

- (void)challengeRequestfrom:(NSString *)userIDFrom	to:(NSString *)userIDTo withAction:(NSString *)action forContest:(NSString *)contest withBedollarsToBet:(NSString *)_bedollars andScoreToReach:(NSString *)_scoreToReach forKindOfChallenge:(NSString *)_challengeKind andActor:(NSString *)actor
{
	
    NSString *res		 = [NSString stringWithFormat:@"%@challenge/%@/%@/%@",rest_resource,userIDFrom,action,userIDTo];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",contest,@"codeID", nil];
    
    if(_bedollars != nil){
        res = [res stringByAppendingString:[NSString stringWithFormat:@"?bet=%@",_bedollars]];
    }
    if (_scoreToReach != nil) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&score=%@",_scoreToReach]];
    }
    if (actor != nil) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&userActor=%@",actor]];
    }
    if (_challengeKind != nil) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&kind=%@",_challengeKind]];
    }
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_CHALLENGEREQ_CALLER_ID];
}

- (void)getChallangePrereequisitesFromUser:(NSString *)userIDFrom toUser:(NSString *)userIDTo forContest:(NSString *)codeID
{
	NSString *res		 = [NSString stringWithFormat:@"%@challenge/%@/PREREQUISITE/%@",rest_resource,userIDFrom,userIDTo];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", codeID, @"codeID", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_CHALLENGEPREREQ_CALLER_ID];  
}

- (void)getFriendsByExtid
{
	NSString *res		 = [NSString stringWithFormat:@"%@friend/%@/",rest_resource,[Beintoo getUserID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GFRIENDS_CALLER_ID];	
}

- (void)removeUDIDConnectionFromUserID:(NSString *)userID
{
	NSString *res		 = [NSString stringWithFormat:@"%@removeUDID/%@/%@/", rest_resource, [BeintooDevice getUDID], userID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey", 
                            [BeintooOpenUDID value], @"openudid",
                            nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_REMOVEUDID_CALLER_ID];		
}

- (void)getBalanceFrom:(int)start andRowns:(int)numOfRows
{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@balance/%@/?start=%d&rows=%d",rest_resource,userID,start,numOfRows];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETBALANCE_CALLER_ID];		
}

- (void)getUsersByQuery:(NSString *)query andSkipFriends:(BOOL)skip
{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res;
	if (skip) 
		res		 = [NSString stringWithFormat:@"%@byquery?query=%@&userExt=%@&skipFriends=true",rest_resource,query,userID];
	else
		res		 = [NSString stringWithFormat:@"%@byquery?query=%@&userExt=%@&skipFriends=false",rest_resource,query,userID];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETBYQUERY_CALLER_ID];			
}

- (void)sendFriendshipRequestTo:(NSString *)toUserExt
{
	NSString *myUserExt	 = [Beintoo getUserID];
	NSString *res = [NSString stringWithFormat:@"%@friendshiprequest/%@/invite/%@",rest_resource,myUserExt,toUserExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SENDFRIENDSHIP_CALLER_ID];			
}

- (void)getFriendRequests
{
	NSString *myUserExt	 = [Beintoo getUserID];
	NSString *res = [NSString stringWithFormat:@"%@friendshiprequest/%@",rest_resource,myUserExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETFRIENDSHIP_CALLER_ID];				
}

- (void)sendUnfriendshipRequestTo:(NSString *)toUserExt
{
	NSString *res = [NSString stringWithFormat:@"%@unfriend/%@", rest_resource, toUserExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            [Beintoo getUserID], @"userExt",
                            nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SEND_UNFRIENDSHIP_CALLER_ID];	
}

- (void)replyToFriendshipRequestWithAnswer:(NSInteger)answer toUser:(NSString *)toUserExt{
	NSString *myUserExt	 = [Beintoo getUserID];
	NSString *res;
	if (answer == USER_ACCEPT_FRIENDSHIP) {
		res	= [NSString stringWithFormat:@"%@friendshiprequest/%@/accept/%@",rest_resource,myUserExt,toUserExt];
	}
	else
		res = [NSString stringWithFormat:@"%@friendshiprequest/%@/ignore/%@",rest_resource,myUserExt,toUserExt];

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SENDFRIENDSHIP_CALLER_ID];				
}

- (void)registerUserToGuid:(NSString *)_guid withEmail:(NSString *)_email nickname:(NSString *)_nick password:(NSString *)_pass name:(NSString *)_name
					  country:(NSString *)_country address:(NSString *)_address gender:(NSString *)_gender sendGreetingsEmail:(BOOL)_sendGreet
{		
	if (_guid == nil) {
		BeintooLOG(@"* Beintoo * RegisterUser error: no guid provided.");
		return;
	}
	if (_email == nil) {
		BeintooLOG(@"* Beintoo * RegisterUser error: email not provided.");
		return;
	}
	int userGender;
	
	if([_gender isEqualToString:@"MALE"])
		userGender = 1;
	else if ([_gender isEqualToString:@"FEMALE"]) 
		userGender = 2;
	else
		userGender = 0;
	
	NSString *httpBody;
	if(!userGender)
		httpBody = [NSString stringWithFormat:@"email=%@",_email];
	else
		httpBody = [NSString stringWithFormat:@"email=%@&gender=%d",_email,userGender];
	
	if (_nick != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&nickname=%@",_nick]];
	if (_pass != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&password=%@",_pass]];
	if (_name != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&name=%@",_name]];
	if (_country != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&country=%@",_country]];
	if (_address != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&address=%@",_address]];
	if(_sendGreet)
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=true"];
	else
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=false"];
	
	NSString *res			 = [NSString stringWithFormat:@"%@set", rest_resource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Beintoo getApiKey], @"apikey",
                                _guid, @"guid",
                                [BeintooOpenUDID value], @"openudid",
                                nil];	
    
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_REGISTER_CALLER_ID];
}

- (void)backgroundRegisterUserToGuid:(NSString *)_guid withEmail:(NSString *)_email nickname:(NSString *)_nick password:(NSString *)_pass name:(NSString *)_name
                   country:(NSString *)_country address:(NSString *)_address gender:(NSString *)_gender sendGreetingsEmail:(BOOL)_sendGreet
{   
    BeintooUser *userService = [Beintoo beintooUserService];
    
    if (_guid == nil) {
        
        userService.userParams = [[NSMutableDictionary alloc] init];
        if (_guid != nil)
            [userService.userParams setObject:[_guid copy] forKey:@"guid"];
        if (_email != nil)
            [userService.userParams setObject:[_email copy] forKey:@"email"];
        if (_nick != nil)
            [userService.userParams setObject:[_nick copy] forKey:@"nick"];
        if (_pass != nil)
            [userService.userParams setObject:[_pass copy] forKey:@"pass"];
        if (_name != nil)
            [userService.userParams setObject:[_name copy] forKey:@"name"];
        if (_address != nil)
            [userService.userParams setObject:[_address copy] forKey:@"address"];
        if (_gender != nil)
            [userService.userParams setObject:[_gender copy] forKey:@"gender"];
        if (_country != nil)
            [userService.userParams setObject:[_country copy] forKey:@"country"];
        if (_sendGreet)
            [userService.userParams setObject:[NSNumber numberWithBool:_sendGreet] forKey:@"sendGreetings"];
        
        [BeintooPlayer setPlayerDelegate:self];
        [BeintooPlayer login];
        
		return;
	}
    
	if (_email == nil) {
		BeintooLOG(@"* Beintoo * RegisterUser error: email not provided.");
        
        if ([[self delegate] respondsToSelector:@selector(didNotCompleteBackgroundRegistration)]) 
            [[self delegate] didNotCompleteBackgroundRegistration];
        
        return;
	}
	int userGender;
	
	if([_gender isEqualToString:@"MALE"])
		userGender = 1;
	else if ([_gender isEqualToString:@"FEMALE"]) 
		userGender = 2;
	else
		userGender = 0;
	
	NSString *httpBody;
	if(!userGender)
		httpBody = [NSString stringWithFormat:@"email=%@",_email];
	else
		httpBody = [NSString stringWithFormat:@"email=%@&gender=%d",_email,userGender];
	
	if (_nick != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&nickname=%@",_nick]];
	if (_pass != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&password=%@",_pass]];
	if (_name != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&name=%@",_name]];
	if (_country != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&country=%@",_country]];
	if (_address != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&address=%@",_address]];
	if(_sendGreet)
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=true"];
	else
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=false"];
	
	NSString *res			 = [NSString stringWithFormat:@"%@set", userService.restResource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Beintoo getApiKey], @"apikey",
                                _guid, @"guid", 
                                [BeintooOpenUDID value], @"openudid",
                                nil];
	
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_BACKGROUND_REGISTER_CALLER_ID];
    
}

- (void)updateUser:(NSString *)_userExt withNickname:(NSString *)_nick
{
	if(_userExt == nil){
		return;
	}	
	NSString *httpBody = @"";
	if (_nick != nil){
		httpBody = [NSString stringWithFormat:@"nickname=%@",_nick];
	}
	
	NSString *res			 = [NSString stringWithFormat:@"%@update",rest_resource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Beintoo getApiKey], @"apikey",
                                _userExt, @"userExt", 
                                [BeintooOpenUDID value], @"openudid",
                                nil];	
    
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_NICKUPDATE_CALLER_ID];
}

+ (void)giveBedollarsByString:(NSString *)_reason showNotification:(BOOL)_showNotification
{
    BeintooLOG(@"Deprecated method, user [BeintooApp giveBedollars:showNotification:withPosition:] instead");
    return;
    
    if (![Beintoo getUserID]){
        BeintooLOG(@"Give Bedollars: no user found");
        return;
    }
    
    if (!_reason){
        BeintooLOG(@"Give Bedollars: no reason provided");
        return;
    }
    
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	BeintooUser *userService = [Beintoo beintooUserService];
	
    userService.showGiveBedollarsNotification = _showNotification;
    
    NSString *res		 = [NSString stringWithFormat:@"%@givebedollars/%@", userService.appRestResource, [Beintoo getUserID]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"reason=%@", _reason];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
	}
	else
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    [userService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_GIVE_BEDOLLARS_CALLER_ID];
}

- (void)giveBedollarsByString:(NSString *)_reason showNotification:(BOOL)_showNotification
{
    BeintooLOG(@"Deprecated method, user [BeintooApp giveBedollars:showNotification:withPosition:] instead");
    return;
    
    if (![Beintoo getUserID]){
        BeintooLOG(@"Give Bedollars: no user found");
        return;
    }
    
    if (!_reason){
        BeintooLOG(@"Give Bedollars: no reason provided");
        return;
    }
    
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
    
    showGiveBedollarsNotification = _showNotification;
    
    NSString *res		 = [NSString stringWithFormat:@"%@givebedollars/%@", app_rest_resource, [Beintoo getUserID]];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"reason=%@", _reason];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
	}
	else
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_GIVE_BEDOLLARS_CALLER_ID];
}

+ (void)giveBedollars:(float)_amount showNotification:(BOOL)_showNotification
{
    BeintooLOG(@"Deprecated method, user [BeintooApp giveBedollars:showNotification:withPosition:] instead");
    return;
    
    if (![Beintoo getUserID]){
     BeintooLOG(@"Give Bedollars: no user found");
     return;
     }
    
    if (!_amount){
        BeintooLOG(@"Give Bedollars: no amount provided");
        return;
    }
    
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
    
    BeintooUser *userService = [Beintoo beintooUserService];
	
    userService.showGiveBedollarsNotification = _showNotification;
    
    NSString *res		 = [NSString stringWithFormat:@"%@givebedollars/%@", userService.appRestResource, [Beintoo getUserID]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"amount=%f", _amount];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
	}
	else
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    [userService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_GIVE_BEDOLLARS_CALLER_ID];
}

- (void)giveBedollars:(float)_amount showNotification:(BOOL)_showNotification
{
    BeintooLOG(@"Deprecated method, user [BeintooApp giveBedollars:showNotification:withPosition:] instead");
    return;
    
    if (![Beintoo getUserID]){
        BeintooLOG(@"Give Bedollars: no user found");
        return;
    }
    
    if (!_amount){
        BeintooLOG(@"Give Bedollars: no amount provided");
        return;
    }
    
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
    
    showGiveBedollarsNotification = _showNotification;
    
    NSString *res		 = [NSString stringWithFormat:@"%@givebedollars/%@", app_rest_resource, [Beintoo getUserID]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"amount=%f", _amount];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
	}
	else
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_GIVE_BEDOLLARS_CALLER_ID];
}

- (void)forgotPassword:(NSString *)email
{    
    NSString *res		 = [NSString stringWithFormat:@"%@forgotpassword", rest_resource];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"email=%@", email];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_FORGOT_PASSWORD_CALLER_ID];
}

#pragma mark -
#pragma mark parser delegate response

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
	switch (callerID){
		case USER_GUSER_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUser:)]) {
				[[self delegate] didGetUser:result];
			}
		}
			break;
			
		case USER_GUSERBYMP_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUserByMail:)]) {
				[[self delegate] didGetUserByMail:result];
			}
			//BeintooLOG(@"getUserByUDID result: %@",result);
		}
			break;
		
		case USER_GUSERBYUDID_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUserByUDID:)]) {
				[[self delegate] didGetUserByUDID:(NSMutableArray *)result];
			}
			//BeintooLOG(@"getUserByUDID result: %@",result);
		}
			break;
			
		case USER_SHOWCHALLENGES_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didShowChallengesByStatus:)]) {
				[[self delegate] didShowChallengesByStatus:(NSMutableArray *)result];
			}
			//BeintooLOG(@"showChallenges result: %@",result);
		}
			break;
		
        case USER_CHALLENGEPREREQ_CALLER_ID:{
            if ([[self delegate] respondsToSelector:@selector(didGetChallangePrerequisites:)]) {
				[[self delegate] didGetChallangePrerequisites:(NSDictionary *)result];
			}
        }
			break;

		case USER_CHALLENGEREQ_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(challengeRequestFinishedWithResult:)]) {
				[[self delegate] challengeRequestFinishedWithResult:result];
			}
		}
			break;
			
		case USER_GFRIENDS_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetFriendsByExtid:)]) {
				[[self delegate] didGetFriendsByExtid:(NSMutableArray *)result];
			}
		}
			break;
			
		case USER_REMOVEUDID_CALLER_ID:{
			//BeintooLOG(@"remove UDID result: %@",result);
		}
			break;

		case USER_GETBALANCE_CALLER_ID:{
			//BeintooLOG(@"getBalance result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetBalance:)]) {
				[[self delegate]didGetBalance:(NSMutableArray *)result];
			}
		}
			break;

		case USER_GETBYQUERY_CALLER_ID:{
			//BeintooLOG(@"getBalance result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetUserByQuery:)]) {
				[[self delegate]didGetUserByQuery:(NSMutableArray *)result];
			}
		}
			break;
			
		case USER_SENDFRIENDSHIP_CALLER_ID:{
			//BeintooLOG(@"send friend request result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetFriendRequestResponse:)]) {
				[[self delegate]didGetFriendRequestResponse:result];
			}
		}
			break;
            
        case USER_SEND_UNFRIENDSHIP_CALLER_ID:{
			BeintooLOG(@"Send Unfriend Request: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetUnfriendRequestResponse:)]) {
				[[self delegate] didGetUnfriendRequestResponse:result];
			}
		}
			break;
			
		case USER_GETFRIENDSHIP_CALLER_ID:{
			//BeintooLOG(@"get friend request result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetFriendRequests:)]) {
				[[self delegate]didGetFriendRequests:(NSMutableArray *)result];
			}
		}
			break;
			
		case USER_REGISTER_CALLER_ID:{
			if ([result objectForKey:@"message"] != nil) {
				BeintooLOG(@"Beintoo: error in user registration: %@", [result objectForKey:@"message"]);
            }
            if ([[self delegate]respondsToSelector:@selector(didCompleteRegistration:)]) 
                [[self delegate]didCompleteRegistration:result];
		}
			break;
            
        case USER_BACKGROUND_REGISTER_CALLER_ID:{
            
            if ([result objectForKey:@"id"]){
            
                BeintooPlayer *_player = [Beintoo beintooPlayerService];
                [_player setDelegate:self];
                
                NSString *newUserID = [result objectForKey:@"id"];
                
                if (newUserID != nil) {
                    [_player backgroundLogin:newUserID];
                }
            }
            else {
                BeintooLOG(@"Beintoo: error in user registration: %@",[result objectForKey:@"message"]);
                if ([[self delegate] respondsToSelector:@selector(didNotCompleteBackgroundRegistration)]) 
                    [[self delegate] didNotCompleteBackgroundRegistration];
            }
        }
            break;
			
		case USER_NICKUPDATE_CALLER_ID:{
			if ([result objectForKey:@"message"] != nil) {
				BeintooLOG(@"Beintoo: error in user registration: %@",[result objectForKey:@"message"]);
            }
            if ([[self delegate]respondsToSelector:@selector(didCompleteUserNickUpdate:)]) 
                [[self delegate]didCompleteUserNickUpdate:result];
		}
			break;
            
        case USER_GIVE_BEDOLLARS_CALLER_ID:{
            
            if ([[self delegate]respondsToSelector:@selector(didReceiveGiveBedollarsResponse:)])
                [[self delegate] didReceiveGiveBedollarsResponse:result];
            
            if ([result objectForKey:@"message"] || ![result objectForKey:@"content"]) {
				BeintooLOG(@"Beintoo: error in Give Bedollars call: %@", [result objectForKey:@"message"]);
                return;
            }
            
            if (showGiveBedollarsNotification == YES){
                /* float bedollarsAmount = [[result objectForKey:@"value"] floatValue];
                 
                 if (bedollarsAmount > 0){
                 [[NSUserDefaults standardUserDefaults] setFloat:bedollarsAmount forKey:@"lastGiveBedollarsAmount"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 //[self showGiveBedollarsAlert]; */
                
                [giveBedollarsContent setVgoodContent:result];
                [giveBedollarsContent setTheGood:result];
                [Beintoo setLastGeneratedGiveBedollars:giveBedollarsContent];
                
                [Beintoo launchGiveBedollarsWithDelegate:nil position:notificationPosition];
                // }
            }
		}
			break;
            
        case USER_FORGOT_PASSWORD_CALLER_ID:{
            
            if ([[self delegate]respondsToSelector:@selector(didCompleteForgotPassword:)]) 
                [[self delegate] didCompleteForgotPassword:result];
		}
			break;
			
		default:{
			//statements
		}
			break;
	}	
}

- (void)playerDidLoginWithResult:(NSDictionary *)result
{	
    BeintooUser *userService = [Beintoo beintooUserService];
    [BeintooUser setUserDelegate:userService.callingDelegate];
    
    NSString *_email = nil;
    NSString *_nick = nil;
    NSString *_pass = nil;
    NSString *_address = nil;
    NSString *_name = nil;
    NSString *_gender = nil;
    NSString *_country = nil;
    BOOL _sendGreeting;    
    
    if ([userService.userParams objectForKey:@"email"])
        _email = [userService.userParams objectForKey:@"email"];
    if ([userService.userParams objectForKey:@"name"])
        _name = [userService.userParams objectForKey:@"name"];
    if ([userService.userParams objectForKey:@"pass"])
        _pass = [userService.userParams objectForKey:@"pass"];
    if ([userService.userParams objectForKey:@"nick"])
        _nick = [userService.userParams objectForKey:@"nick"];
    if ([userService.userParams objectForKey:@"address"])
        _address = [userService.userParams objectForKey:@"address"];
    if ([userService.userParams objectForKey:@"gender"])
        _gender = [userService.userParams objectForKey:@"gender"];
    if ([userService.userParams objectForKey:@"country"])
        _country = [userService.userParams objectForKey:@"country"];
    if ([userService.userParams objectForKey:@"sendGreetings"])
        _sendGreeting = (BOOL) [userService.userParams objectForKey:@"sendGreetings"];
    
    [self backgroundRegisterUserToGuid:[Beintoo getPlayerID] withEmail:_email nickname:_nick password:_pass name:_name country:_country address:_address gender:_address sendGreetingsEmail:_sendGreeting];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [userService.userParams release];
#endif    
    
}

- (void)playerDidCompleteBackgroundLogin:(NSDictionary *)result
{    
    if ([[self delegate] respondsToSelector:@selector(didCompleteBackgroundRegistration:)]) 
        [[self delegate] didCompleteBackgroundRegistration:result];
     
}

- (void)playerDidNotCompleteBackgroundLogin
{    
    if ([[self delegate] respondsToSelector:@selector(didNotCompleteBackgroundRegistration)]) 
        [[self delegate] didNotCompleteBackgroundRegistration];
   
}

- (void)playerDidFailLoginWithResult:(NSString *)error
{
	BeintooLOG(@"playerLogin error: %@", error);
}

- (NSString *)getStatusCode:(int)code
{
	if (code == CHALLENGES_TO_BE_ACCEPTED) {
		return @"TO_BE_ACCEPTED";
	}else if (code == CHALLENGES_STARTED) {
		return @"STARTED";
	}else if (code == CHALLENGES_ENDED) {
		return @"ENDED";
	}else {
		return @"TO_BE_ACCEPTED";
	}	
}

- (void)dealloc {
    parser.delegate = nil;
  
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[rest_resource release];
    [app_rest_resource release];
    [super dealloc];
#endif
    
}

@end
