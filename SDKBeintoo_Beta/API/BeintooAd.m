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

#import "BeintooAd.h"
#import "Beintoo.h"

@implementation BeintooAd
@synthesize adContent, callingDelegate, delegate, parser;

#pragma mark - Init methods

- (id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
        
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/vgood/", [Beintoo getRestBaseUrl]]];
        display_rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/display/", [Beintoo getRestBaseUrl]]];
        
		adContent   = [[BVirtualGood alloc] init];
	}
    return self;
}

- (id)initWithDelegate:(id)_delegate
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
        
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/vgood/", [Beintoo getRestBaseUrl]]];
        display_rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/display/", [Beintoo getRestBaseUrl]]];
        
		adContent   = [[BVirtualGood alloc] init];
        
        [self setDelegate:_delegate];
	}
    return self;
}

#pragma mark - Common methods

- (NSString *)restResource
{
	return rest_resource;
}

- (NSString *)getDisplayRestResource
{
	return display_rest_resource;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooAd *service   = [Beintoo beintooAdService];
	service.callingDelegate = _delegate;
}

#pragma mark - Methods

+ (void)requestAndDisplayAdWithDeveloperUserGuid:(NSString *)_developerUserGuid
{
    [Beintoo updateUserLocation];
    
    BeintooAd *service   = [Beintoo beintooAdService];
    
    NSString *res;
    res = [NSString stringWithFormat:@"%@/display/serve", [Beintoo getDisplayBaseUrl]];
    
    CLLocation *loc	 = [Beintoo getUserLocation];
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res	= [NSString stringWithFormat:@"%@?wrapInJson=true", res];
	}
	else
		res	= [NSString stringWithFormat:@"%@?wrapInJson=true&latitude=%f&longitude=%f&radius=%f",
               res, loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    if (_developerUserGuid != nil){
        res = [res stringByAppendingFormat:@"&developer_user_guid=%@", _developerUserGuid];
    }
    
    NSDictionary *params;
    
    if ([Beintoo getPlayerID] != nil){
        if ([BeintooDevice isASIdentifierSupported]){
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
        }
        else {
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
        }
    }
    else {
        if ([BeintooDevice isASIdentifierSupported]){
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          nil];
            }
        }
        else {
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          nil];
            }
        }
    }
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:ADS_REQUEST_AND_DISPLAY];
}

+ (void)requestAdWithDeveloperUserGuid:(NSString *)_developerUserGuid
{
    [Beintoo updateUserLocation];
    
    BeintooAd *service   = [Beintoo beintooAdService];
    
    NSString *res;
    res = [NSString stringWithFormat:@"%@/display/serve", [Beintoo getDisplayBaseUrl]];
    
    CLLocation *loc	 = [Beintoo getUserLocation];
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res	= [NSString stringWithFormat:@"%@?wrapInJson=true", res];
	}
	else
		res	= [NSString stringWithFormat:@"%@?wrapInJson=true&latitude=%f&longitude=%f&radius=%f",
               res, loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    if (_developerUserGuid != nil){
        res = [res stringByAppendingFormat:@"&developer_user_guid=%@", _developerUserGuid];
    }
    
    NSDictionary *params;
    
    if ([Beintoo getPlayerID] != nil){
        if ([BeintooDevice isASIdentifierSupported]){
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
        }
        else {
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [Beintoo getPlayerID], @"guid",
                          nil];
            }
        }
    }
    else {
        if ([BeintooDevice isASIdentifierSupported]){
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooDevice getASIdentifier], @"iosaid",
                          [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                          nil];
            }
        }
        else {
            if ([BeintooNetwork getCarrierBuiltString] != nil){
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          [BeintooNetwork getCarrierBuiltString], @"carrier",
                          nil];
            }
            else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Beintoo getApiKey], @"apikey",
                          [BeintooDevice getUDID], @"deviceUUID",
                          [BeintooDevice getMacAddress], @"macaddress",
                          [BeintooOpenUDID value], @"openudid",
                          nil];
            }
        }
    }
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:ADS_REQUEST];
}

#pragma mark - Parser delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
    switch (callerID)
    {
        case ADS_REQUEST: {
            if ([result objectForKey:@"messageID"]) {
                if ([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) {
                    
                    [Beintoo notifyAdGenerationErrorOnMainDelegate:result];
                    [BeintooAd notifyAdGenerationErrorOnUserDelegate:result];
                    
                    return;
                }
                
                if ([[result objectForKey:@"messageID"] intValue] == -1) {
                    
                    [Beintoo notifyAdGenerationErrorOnMainDelegate:result];
                    [BeintooAd notifyAdGenerationErrorOnUserDelegate:result];
                    
                    return;
                }
                
            }
            
            if (![result objectForKey:@"content"])
            {
                [Beintoo notifyAdGenerationErrorOnMainDelegate:result];
                [BeintooAd notifyAdGenerationErrorOnUserDelegate:result];
                
                return;
            }
            
            [adContent setVgoodContent:result];
            [adContent setTheGood:result];
            [Beintoo setLastGeneratedAd:adContent];
            
            [Beintoo notifyAdGenerationOnMainDelegate];
            [BeintooAd notifyAdGenerationOnUserDelegate];
            
        }
            break;
            
        case ADS_REQUEST_AND_DISPLAY: {
            if ([result objectForKey:@"messageID"]) {
                if ([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) {
                    
                    [Beintoo notifyAdGenerationErrorOnMainDelegate:result];
                    [BeintooAd notifyAdGenerationErrorOnUserDelegate:result];
                    
                    return;
                }
                
                if ([[result objectForKey:@"messageID"] intValue] == -1) {
                    
                    [Beintoo notifyAdGenerationErrorOnMainDelegate:result];
                    [BeintooAd notifyAdGenerationErrorOnUserDelegate:result];
                    
                    return;
                }
            }
            
            if (![result objectForKey:@"content"])
            {
                [Beintoo notifyAdGenerationErrorOnMainDelegate:result];
                [BeintooAd notifyAdGenerationErrorOnUserDelegate:result];
                
                return;
            }
            
            [adContent setVgoodContent:result];
            [adContent setTheGood:result];
            [Beintoo setLastGeneratedAd:adContent];
            
            [Beintoo notifyAdGenerationOnMainDelegate];
            [BeintooAd notifyAdGenerationOnUserDelegate];
            
            if (callingDelegate != nil)
                [Beintoo displayAdWithDelegate:callingDelegate];
            else
                [Beintoo displayAd];
            
        }
            break;
            
        default:{
			//statements
		}
			break;
    }
}

#pragma mark - Notificatioons on developer's delegate

+ (void)notifyAdGenerationOnUserDelegate
{
	BeintooAd *service = [Beintoo beintooAdService];
	id _callingDelegate = service.callingDelegate;
    
    if ([_callingDelegate respondsToSelector:@selector(didBeintooGenerateAnAd:)]) {
		[_callingDelegate didBeintooGenerateAnAd:[Beintoo getLastGeneratedAd]];
	}
}

+ (void)notifyAdGenerationErrorOnUserDelegate:(NSDictionary *)_error
{
	BeintooAd *service = [Beintoo beintooAdService];
	id _callingDelegate = service.callingDelegate;
    
    if ([_callingDelegate respondsToSelector:@selector(didBeintooFailToGenerateAnAdWithError:)]) {
		[_callingDelegate didBeintooFailToGenerateAnAdWithError:_error];
	}
}

#pragma mark - Dealloc

- (void)dealloc
{
    parser.delegate = nil;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[rest_resource release];
    [display_rest_resource release];
    [adContent release];
    
	[super dealloc];
#endif
    
}

@end
