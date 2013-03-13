/*******************************************************************************
 * Copyright 2011 Beintoo - author gpiazzese@beintoo.com
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

#import "BAnimatedNotificationQueue.h"
#import "Beintoo.h"

@implementation BAnimatedNotificationQueue
@synthesize notificationQueue;

- (id)init
{
    self = [super init];
    if (self) {
        notificationQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addNotificationToTheQueue:(BMessageAnimated *)message
{
    message.delegate = self;
    [notificationQueue addObject:message];
    
    [self checkQueue];
}

- (void)checkQueue
{
    if ([notificationQueue count] <= 1 && messageOnScreen == NO)
        [self executeQueue];
}

- (void)executeQueue
{   
    BMessageAnimated *message;
    
    if ([notificationQueue count] > 0 && messageOnScreen == NO) {
        message = [notificationQueue objectAtIndex:0];
    
        UIWindow *appWindow = [Beintoo getAppWindow];
        [appWindow addSubview:message];
        [message showNotification];
        
        [notificationQueue removeObject:message];
    }
}

- (void)messageDidAppear
{
    BeintooLOG(@"Animated message did appear");
    messageOnScreen = YES;
}

- (void)messageDidDisappear
{
    BeintooLOG(@"Animated message did disappear");
    messageOnScreen = NO;
    [self executeQueue];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc
{
    [notificationQueue release];
    [super dealloc];
}
#endif

@end
