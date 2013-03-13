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

#import <Foundation/Foundation.h>
#import "BeintooPlayer.h"
#import "Parser.h"
#import "BVirtualGood.h"

@protocol BeintooAppDelegate;

@interface BeintooApp : NSObject <BeintooParserDelegate>
{
    id <BeintooAppDelegate>     delegate;
	Parser                      *parser;
	
	NSString                    *rest_resource;
    NSString                    *app_rest_resource;
    
    int                         notificationPosition;
    BOOL                        showGiveBedollarsNotification;
    
    BVirtualGood                *giveBedollarsContent;
}

#ifdef BEINTOO_ARC_AVAILABLE
@property (nonatomic, strong) id <BeintooAppDelegate> delegate;
@property (nonatomic, strong) Parser *parser;
@property (nonatomic, strong) BVirtualGood  *giveBedollarsContent;
#else
@property (nonatomic, assign) id <BeintooAppDelegate> delegate;
@property (nonatomic, retain) Parser *parser;
@property (nonatomic, retain) BVirtualGood  *giveBedollarsContent;
#endif

@property (nonatomic, assign) id            callingDelegate;
@property (nonatomic, assign) BOOL          showGiveBedollarsNotification;
@property (nonatomic, assign) int           notificationPosition;

- (id)initWithDelegate:(id)caller;

- (NSString *)restResource;
+ (void)setDelegate:(id)_caller;

+ (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification withPosition:(int)position;
- (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification;

@end

@protocol BeintooAppDelegate <NSObject>

@optional
- (void)didReceiveGiveBedollarsResponse:(NSDictionary *)result;

@end
