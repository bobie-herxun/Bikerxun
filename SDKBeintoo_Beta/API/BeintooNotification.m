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

#import "BeintooNotification.h"
#import "Beintoo.h"


@implementation BeintooNotification

@synthesize delegate, parser, callingDelegate;

-(id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
		
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/notification",[Beintoo getRestBaseUrl]]];
	}
    return self;
}


- (NSString *)restResource
{
	return rest_resource;
}

#pragma mark -
#pragma mark Private API

- (void)getNotificationListWithStart:(int)_start andRows:(int)_rows
{
    if ([Beintoo getPlayerID] == nil) {
        BeintooLOG(@"BeintooNotifications error: player not logged.");
        return;
    }
    NSString *res		 = [NSString stringWithFormat:@"%@?start=%d&rows=%d",rest_resource,_start,_rows];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [Beintoo getPlayerID], @"guid",nil];
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:NOTIFICATION_GETLIST_CALLER_ID];
    
}

- (void)setNotificationReadWithNotificationID:(NSString *)_notificationID
{
    if ([Beintoo getPlayerID] == nil) {
        BeintooLOG(@"BeintooNotifications error: player not logged.");
        return;
    }
    
    NSString *res		 = [NSString stringWithFormat:@"%@/%@",rest_resource, _notificationID];
    NSString *httpBody   = [NSString stringWithFormat:@"status=READ"];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [Beintoo getPlayerID], @"guid",nil];
    
   [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:NOTIFICATION_SETREAD_CALLER_ID];
}

- (void)setAllNotificationReadUpToNotification:(NSString *)_notificationID
{
    if ([Beintoo getPlayerID] == nil) {
        BeintooLOG(@"BeintooNotifications error: player not logged.");
        return;
    }
    
    NSString *res		 = [NSString stringWithFormat:@"%@/upto/%@",rest_resource, _notificationID];
    NSString *httpBody   = [NSString stringWithFormat:@"status=READ"];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [Beintoo getPlayerID], @"guid",nil];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:NOTIFICATION_SETREAD_CALLER_ID];
}

#pragma mark -
#pragma mark Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
	switch (callerID){
		case NOTIFICATION_GETLIST_CALLER_ID:{
            
            if ([[self delegate] respondsToSelector:@selector(didGetNotificationListWithResult:)]){
                [[self delegate] didGetNotificationListWithResult:(NSArray *)result];
            }
            
		}
			break;
           
            
        case NOTIFICATION_SETREAD_CALLER_ID:{
            
            if ([[self delegate] respondsToSelector:@selector(didSetNotificationReadWithResult:)]){
                [[self delegate] didSetNotificationReadWithResult:(NSArray *)result];
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

- (void)dealloc
{
    parser.delegate = nil;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[rest_resource release];
    [super dealloc];
#endif
    
}

@end
