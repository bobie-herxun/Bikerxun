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

#import <Foundation/Foundation.h>
#import "BeintooMacros.h"
#import <UIKit/UIKit.h>
#import "BeintooDevice.h"

@interface BImageCache : NSObject 
{
    NSFileManager *filemgr;
    
	NSString *documentsDirectory;
	NSString *cacheFileUrl;
    
	NSDictionary *dictCache;
    NSString *currentpath;
}

@property (nonatomic, retain) NSDictionary *dictCache;

+ (BImageCache *)instance;

- (BOOL)isRemoteFileCached:(NSString*)url;
- (NSString *)getCachedRemoteFile:(NSString*)url;
- (BOOL)addRemoteFileToCache:(NSString*)url withData:(NSData*)data;
- (NSString*) makeKeyFromUrl:(NSString*)url;

@end
