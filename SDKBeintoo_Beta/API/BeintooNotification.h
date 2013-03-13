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

@protocol BeintooNotificationDelegate;

@interface BeintooNotification : NSObject <BeintooParserDelegate>{
	
	id <BeintooNotificationDelegate> delegate;
	Parser *parser;
	NSString *rest_resource;
    
    id callingDelegate;
}

- (NSString *)restResource;

- (void)getNotificationListWithStart:(int)_start andRows:(int)_rows;
- (void)setNotificationReadWithNotificationID:(NSString *)_notificationID;
- (void)setAllNotificationReadUpToNotification:(NSString *)_notificationID;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooNotificationDelegate> delegate;
@property(nonatomic, retain) id callingDelegate;
#else
@property(nonatomic, assign) id <BeintooNotificationDelegate> delegate;
@property(nonatomic, assign) id callingDelegate;
#endif

@property(nonatomic,retain) Parser *parser;

@end

@protocol BeintooNotificationDelegate <NSObject>

- (void)didGetNotificationListWithResult:(NSArray *)result;
- (void)didSetNotificationReadWithResult:(NSArray *)result;

@optional

@end


