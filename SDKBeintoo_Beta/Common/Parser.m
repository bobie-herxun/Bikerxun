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

#import "Parser.h"
#import "SBJSON.h"
#import "BeintooNetwork.h"
#import "Beintoo.h"

@implementation Parser
@synthesize delegate, callerID, webpage, result;

- (id)init
{
	if (self = [super init])
	{
	}
    return self;
}

- (void)parsePageAtUrl:(NSString *)URL withHeaders:(NSDictionary *)headers fromCaller:(int)caller
{
    // Dispatching asynchronously a task for the request on the main FIFO queue
    dispatch_async([Beintoo beintooDispatchQueue], ^{
        BeintooLOG(@"resource called %@ with parameters %@ on GET", URL, headers);
        @synchronized(self){		
            self.callerID = caller;
            if (![BeintooNetwork connectedToNetwork]) {
                if (caller == PLAYER_SSCORE_NOCONT_CALLER_ID || caller == PLAYER_SSCORE_CONT_CALLER_ID || 
                    caller == PLAYER_GSCOREFORCONT_CALLER_ID || caller == PLAYER_LOGIN_CALLER_ID ||
                    caller == PLAYER_SETBALANCE_CALLER_ID    ||
                    caller == PLAYER_LOGINwDELEG_CALLER_ID   ||
                    caller == ACHIEVEMENTS_GETSUBMITPERCENT_CALLER_ID || caller == ACHIEVEMENTS_GETSUBMITSCORE_CALLER_ID ||
                    caller == ACHIEVEMENTS_GETINCREMENTSCORE_CALLER_ID ||
                    caller == MISSION_GET_CALLER_ID || caller == MISSION_REFUSE_CALLER_ID ||
                    caller == VGOOD_SINGLE_CALLER_ID || caller == VGOOD_SINGLEwDELEG_CALLER_ID ||
                    caller == VGOOD_MULTIPLE_CALLER_ID || caller == VGOOD_MULTIPLEwDELEG_CALLER_ID || caller == VGOOD_CHECK_COVERAGE_CALLER_ID || caller == VGOOD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID || caller == USER_GIVE_BEDOLLARS_CALLER_ID || caller ==  REWARD_GET_AD_CALLER_ID || caller ==  REWARD_GET_AND_DISPLAY_AD_CALLER_ID || callerID == ADS_REQUEST_AND_DISPLAY || callerID == ADS_REQUEST) {
                    BeintooLOG(@"Beintoo - no connection available, check the last action performed!");
                    
                    [self parsingEnd:nil];
                    
                    return;
                }
                
                [BeintooNetwork showNoConnectionAlert];
                
                [self parsingEnd:nil];
                
                return;
            }
            NSURL *serviceURL = [NSURL URLWithString:URL];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serviceURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
            [request setHTTPMethod:@"GET"];
            
            for (id theKey in headers) {
                [request setValue:[NSString stringWithFormat:@"%@", [headers objectForKey:theKey]] forHTTPHeaderField:theKey];
            }
            
            [request setValue:[Beintoo currentVersion] forHTTPHeaderField:@"X-BEINTOO-SDK-VERSION"];
            
            if ([Beintoo isOnSandbox])
            {
                [request setValue:@"true" forHTTPHeaderField:@"sandbox"];
            }
            
            if (self.callerID == VGOOD_MULTIPLE_CALLER_ID || self.callerID == VGOOD_SINGLE_CALLER_ID || self.callerID == VGOOD_MULTIPLEwDELEG_CALLER_ID || self.callerID == VGOOD_SINGLEwDELEG_CALLER_ID || self.callerID == REWARD_GET_AD_CALLER_ID || self.callerID == REWARD_GET_AD_CALLER_ID || self.callerID == REWARD_GET_AND_DISPLAY_AD_CALLER_ID || self.callerID == ADS_REQUEST_AND_DISPLAY || self.callerID == ADS_REQUEST)
            {
                [request setValue:[BeintooNetwork getUserAgent] forHTTPHeaderField:@"User-Agent"];
            }

            [self retrievedWebPage:request];
        }
    });
}

- (void)parsePageAtUrlWithPOST:(NSString *)URL withHeaders:(NSDictionary *)headers fromCaller:(int)caller
{
    // Dispatching asynchronously a task for the request on the main FIFO queue
    dispatch_async([Beintoo beintooDispatchQueue], ^{
        BeintooLOG(@"resource called %@ with parameters %@ on POST",URL,headers);
        
        self.callerID = caller;
        if (![BeintooNetwork connectedToNetwork]) {
            [BeintooNetwork showNoConnectionAlert];
            return;
        }
        
        NSURL *serviceURL = [NSURL URLWithString:URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serviceURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        
        for (id theKey in headers) {
            [request setValue:[NSString stringWithFormat:@"%@", [headers objectForKey:theKey]] forHTTPHeaderField:theKey];
        }
        [request setValue:[Beintoo currentVersion] forHTTPHeaderField:@"X-BEINTOO-SDK-VERSION"];
        
        if ([Beintoo isOnSandbox]) {
            [request setValue:@"true" forHTTPHeaderField:@"sandbox"];
        }
        
        [self retrievedWebPage:request];
    });
}

- (void)parsePageAtUrlWithPOST:(NSString *)URL withHeaders:(NSDictionary *)headers withHTTPBody:(NSString *)httpBody fromCaller:(int)caller
{
    dispatch_async([Beintoo beintooDispatchQueue], ^{
        BeintooLOG(@"resource called %@ with parameters %@ and httpBody %@ on POST",URL,headers,httpBody);
        
        self.callerID = caller;
        
        // Dispatching asynchronously a task for the request on the main FIFO queue
        
        if (![BeintooNetwork connectedToNetwork]) {
            if (caller == MESSAGE_SET_READ_CALLER_ID     || caller == PLAYER_SSCORE_OFFLINE_CALLER_ID ||
                caller == ACHIEVEMENTS_SUBMIT_PERCENT_ID || caller == ACHIEVEMENTS_SUBMIT_SCORE_ID ) {
                
                [self parsingEnd:nil];
                return;
            }
            [BeintooNetwork showNoConnectionAlert];
            
            [self parsingEnd:nil];
            return;
        }
        NSURL *serviceURL = [NSURL URLWithString:URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serviceURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]]; 
        for (id theKey in headers) {
            [request setValue:[NSString stringWithFormat:@"%@",[headers objectForKey:theKey]] forHTTPHeaderField:theKey];
        }
        [request setValue:[Beintoo currentVersion] forHTTPHeaderField:@"X-BEINTOO-SDK-VERSION"];
        
        if ([Beintoo isOnSandbox]) {
            [request setValue:@"true" forHTTPHeaderField:@"sandbox"];
        }
        
        [self retrievedWebPage:request];
    });
}

- (void)retrievedWebPage:(NSMutableURLRequest *)_request
{
    NSError         *requestError	= nil;
	NSData		    *urlData;
	
    NSHTTPURLResponse *responseHTTP;
   
    @try{ 
		urlData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&responseHTTP error:&requestError];
        
        if ([responseHTTP respondsToSelector:@selector(allHeaderFields)]) {
            
            if ([responseHTTP statusCode] != 200 && (callerID == REWARD_GET_AD_CALLER_ID || callerID == REWARD_GET_AND_DISPLAY_AD_CALLER_ID)){
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"-10" forKey:@"messageID"];
                @try {
                    if (self.callerID){
                        if ([[self delegate] respondsToSelector:@selector(didFinishToParsewithResult:forCaller:)]){
                            [[self delegate] didFinishToParsewithResult:dictionary forCaller:self.callerID];
                            
                            return;
                        }
                        else {
                            BeintooLOG(@"Beintoo Parser caller not available: the caller isn't set anymore");
                        }
                    }
                }
                @catch (NSException *exception) {
                    BeintooLOG(@"Exception on Beintoo Parser: %@", exception);
                }
            }
        }
        
		if (responseHTTP == nil) {
			// Errors check
			if (requestError != nil) {
				BeintooLOG(@"[Parser parsePageAtUrl] connection error: %@", requestError);
				webpage = @"{\"messageID\":-1,\"message\":\"Connection Timed-out\",\"kind\":\"error\"};";
			}
		}
		else {
			// Data correctly received, then converted from byte to string
			webpage = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		}
	}
    @catch (NSException *e) {
		BeintooLOG(@"[Connection getPageAtUrl] getPage exception: %@",e);
	}
	
	SBJSON *parser	= [[SBJSON alloc] init];
	NSError *parseError		= nil;
	
	@try {
		result = [parser objectWithString:webpage error:&parseError];
    }
	@catch (NSException * e) {
		BeintooLOG(@"[Connection getPageAtUrl] getPage exception: %@",e);
	}
    
    if (webpage != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [webpage release];
#endif

	}
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [parser release];
#endif
    
	[self performSelectorOnMainThread:@selector(parsingEnd:) withObject:result waitUntilDone:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [_request release];
#endif
	
}

- (void)parsingEnd:(NSDictionary *)theResult
{
    @try {
        if (self.callerID){
            if ([[self delegate] respondsToSelector:@selector(didFinishToParsewithResult:forCaller:)]){
                [[self delegate] didFinishToParsewithResult:theResult forCaller:self.callerID];
            }
            else {
                BeintooLOG(@"Beintoo Parser caller not available: the caller isn't set anymore");
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on Beintoo Parser: %@", exception);
    }
}

- (id)blockerParsePageAtUrl:(NSString *)URL withHeaders:(NSDictionary *)headers
{	
	if (![BeintooNetwork connectedToNetwork]) {
		return nil;
	}
	
	NSURL *serviceURL = [NSURL URLWithString:URL];
	NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:serviceURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request2 setHTTPMethod:@"GET"];
	for (id theKey in headers) {
		[request2 setValue:[NSString stringWithFormat:@"%@", [headers objectForKey:theKey]] forHTTPHeaderField:theKey];
	}
	NSError         *requestError	= nil;
	NSURLResponse   *response		= nil;
	NSData		    *urlData;
	@try{ 
		urlData = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response error:&requestError];
		
		if (response == nil) {
			// Errors check
			if (requestError != nil) {
				BeintooLOG(@"[Parser parsePageAtUrl] connection error: %@",requestError);
			}
		}
		else {
			// Data correctly received, then converted from byte to string
			webpage = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		}
	}@catch (NSException *e) {
		BeintooLOG(@"[Connection getPageAtUrl] getPage exception: %@",e);
	}
	
    SBJSON *parser	= [[SBJSON alloc] init];
	NSError *parseError		= nil;
	result = [parser objectWithString:webpage error:&parseError];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [parser release];
#endif
	
	return result;
}

- (NSString *)createJSONFromObject:(id)object
{
	NSString *json;
	@try {
		SBJsonWriter *parserWriter	= [[SBJsonWriter alloc] init];
		json = [parserWriter stringWithObject:object];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [parserWriter release];
#endif
		
	}
	@catch (NSException * e) {
		BeintooLOG(@"[CreateJson getPageAtUrl] exception: %@",e);
	}
	return json;
}

- (void)dealloc {
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [super dealloc];
#endif
}

@end
