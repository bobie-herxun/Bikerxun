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
#import "Parser.h"
#import "BVirtualGood.h"
#import "BeintooDevice.h"

@protocol BeintooAdDelegate;

@interface BeintooAd : NSObject <BeintooParserDelegate>
{
    Parser                  *parser;
	
    id <BeintooAdDelegate> delegate;
	
    NSString                *rest_resource;
    NSString                *display_rest_resource;
	
	id callingDelegate;
    
    BVirtualGood            *adContent;
}

+ (void)requestAndDisplayAdWithDeveloperUserGuid:(NSString *)_developerUserGuid;
+ (void)requestAdWithDeveloperUserGuid:(NSString *)_developerUserGuid;

// Init methods
- (id)initWithDelegate:(id)_delegate;
+ (void)setDelegate:(id)_delegate;
- (NSString *)restResource;
- (NSString *)getDisplayRestResource;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooAdDelegate> delegate;
@property(nonatomic, retain) id  callingDelegate;
#else
@property(nonatomic, assign) id <BeintooAdDelegate> delegate;
@property(nonatomic, assign) id  callingDelegate;
#endif

@property(nonatomic,retain) Parser          *parser;
@property(nonatomic,retain) BVirtualGood    *adContent;


@end

@protocol BeintooAdDelegate <NSObject>

- (void)didBeintooGenerateAnAd:(BVirtualGood *)theAd;
- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error;

@end