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

#import "BeintooDevice.h"
#import "Beintoo.h"
#import "UIDevice+IdentifierAddition.h"

@implementation BeintooDevice

- (id)init
{
	if (self = [super init])
	{
	}
    return self;
}

+ (BOOL)isiPad
{
	return (CGRectGetMaxX([[UIScreen mainScreen] bounds]) >= 768);
}

+ (NSString *)getUDID
{
	return [[UIDevice currentDevice] uniqueDeviceIdentifier];
}

+ (NSString *)getMacAddress
{
	return [[UIDevice currentDevice] _getMacAddress];
}

+ (NSString *)getISOLanguage
{
	NSString   *language = [[NSLocale preferredLanguages] objectAtIndex:0];
	if ([language length] == 2) {
		return language;
	}
	return nil;
}

+ (NSString *)getFormattedTimestampNow
{
    //Create the dateformatter object
#ifdef BEINTOO_ARC_AVAILABLE
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
#else
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
#endif
	
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	
	//Get the string date
	NSString* timeStamp = [formatter stringFromDate:[NSDate date]];		
	return timeStamp;
}

+ (int)elapsedHoursSinceTimestamp:(NSString *)_timestamp
{
    
#ifdef BEINTOO_ARC_AVAILABLE
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
#else
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
#endif
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    if (!_timestamp) {
        return 100000;   // No timestamp, we return a very big number of hours (to say like infinite)
    }
    NSDate *timestampDate = [formatter dateFromString:_timestamp];
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(kCFCalendarUnitHour) fromDate:timestampDate toDate:nowDate options:0];
    NSInteger hour = [components hour];
    return hour;
}


+ (NSString *)getASIdentifier
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    if ([ASIdentifierManager sharedManager])
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    else
        return nil;
    #else
        return nil;
    #endif
}

+ (NSString *)isASIdentifierEnabledByUser
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    if ([ASIdentifierManager sharedManager]){
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] == TRUE)
            return @"true";
        else
            return @"false";
    }
    else
        return 0;
    #else
    return 0;
    #endif
}

+ (BOOL)isASIdentifierSupported
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    if ([ASIdentifierManager sharedManager])
        return TRUE;
    else
        return FALSE;
    #else
        return FALSE;
    #endif
}


+ (NSString *)getSystemVersion
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)])
        return [[UIDevice currentDevice] systemVersion];
    else
        return @"systemVersion";
}

+ (NSString *)getDeviceType
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)])
        return [[UIDevice currentDevice] model];
    else
        return @"deviceType";
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
