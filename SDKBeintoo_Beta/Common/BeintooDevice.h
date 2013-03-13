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

#define BEINTOO_IOS_2_0  20000
#define BEINTOO_IOS_3_0  30000
#define BEINTOO_IOS_4_0  40000
#define BEINTOO_IOS_5_0  50000
#define BEINTOO_IOS_5_1  50100
#define BEINTOO_IOS_6_0  60000
#define BEINTOO_IOS_6_1  60100

#if __has_feature(objc_arc) && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_4_0
    #define BEINTOO_ARC_AVAILABLE
    // ARC is available and enabled!
#elif !__has_feature(objc_arc)
    // ARC is not enabled 
#elif __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    // Your project's iOS Deployment Target is lower than 4.0, then ARC is unavailable");
    #warning "Your project's iOS Deployment Target is lower than 4.0, then ARC could not be applied on Beintoo";
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BeintooDevice : NSObject {
}

+ (BOOL)isiPad;
+ (NSString *)getUDID;
+ (NSString *)getISOLanguage;
+ (NSString *)getFormattedTimestampNow;
+ (int)elapsedHoursSinceTimestamp:(NSString *)_timestamp;
+ (NSString *)getMacAddress;

+ (NSString *)getASIdentifier;
+ (NSString *)isASIdentifierEnabledByUser;
+ (BOOL)isASIdentifierSupported;

+ (NSString *)getSystemVersion;
+ (NSString *)getDeviceType;

@end
