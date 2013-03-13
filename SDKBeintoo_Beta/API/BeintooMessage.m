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

#import "BeintooMessage.h"
#import "Beintoo.h"

@implementation BeintooMessage

@synthesize delegate,parser;

-(id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
		
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/message/", [Beintoo getRestBaseUrl]]];

	}
    return self;
}

#pragma mark -
#pragma mark API

- (void)showMessagesFrom:(int)start andRows:(int)rows
{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@?start=%d&rows=%d",rest_resource,start,rows];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",userID,@"to",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:MESSAGE_SHOW_CALLER_ID];	
}

- (void)sendMessageTo:(NSString *)userID withText:(NSString *)text
{
	NSString *thisUserID = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@",rest_resource];
	NSString *httpBody   = [NSString stringWithFormat:@"from=%@&to=%@&text=%@",thisUserID,userID,text];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MESSAGE_SEND_CALLER_ID];
}

- (void)setToReadMessageWithID:(NSString *)messageid
{
	NSString *thisUserID = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@%@",rest_resource,messageid];
	NSString *httpBody   = [NSString stringWithFormat:@"status=READ"];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",thisUserID,@"userExt",	nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MESSAGE_SET_READ_CALLER_ID];
}

- (void)deleteMessageWithID:(NSString *)messageid
{
	NSString *thisUserID = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@%@",rest_resource,messageid];
	NSString *httpBody   = [NSString stringWithFormat:@"status=ARCHIVED"];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",thisUserID,@"userExt",	nil];
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MESSAGE_DELETE_CALLER_ID];
}


#pragma mark -
#pragma mark Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
	switch (callerID){
		case MESSAGE_SHOW_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didFinishToLoadMessagesWithResult:)])
				[[self delegate] didFinishToLoadMessagesWithResult:(NSArray *)result];
		}
			break;
			
		case MESSAGE_SEND_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didSendMessageWithResult:)]){
				if ([[result objectForKey:@"status"] isEqualToString:@"UNREAD"])
					[[self delegate] didSendMessageWithResult:YES];
				else 
					[[self delegate] didSendMessageWithResult:NO];
			}
		}
			break;
			
		case MESSAGE_SET_READ_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didUserReadAMessage:)]){
				if ([[result objectForKey:@"status"] isEqualToString:@"READ"])
					[[self delegate] didUserReadAMessage:YES];
				else 
					[[self delegate] didUserReadAMessage:NO];
			}		}
			break;
			
		case MESSAGE_DELETE_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didDeleteMessageWithResult:)]){
				if ([[result objectForKey:@"status"] isEqualToString:@"ARCHIVED"])
					[[self delegate] didDeleteMessageWithResult:YES];
				else 
					[[self delegate] didDeleteMessageWithResult:NO];
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

+ (int)unreadMessagesCount
{
	NSString *unread = [[NSUserDefaults standardUserDefaults] objectForKey:@"unreadMessages"];
	return [unread intValue];
}

+ (int)totalMessagesCount
{
	NSString *total = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalMessages"];
	return [total intValue];	
}

+ (void)setUnreadMessages:(NSString *)totalMessages
{
	[[NSUserDefaults standardUserDefaults] setObject:totalMessages forKey:@"unreadMessages"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setTotalMessages:(NSString *)totalMessages
{
	[[NSUserDefaults standardUserDefaults] setObject:totalMessages forKey:@"totalMessages"];
	[[NSUserDefaults standardUserDefaults] synchronize];
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
