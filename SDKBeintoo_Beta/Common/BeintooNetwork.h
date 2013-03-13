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

#define BEINTOO_IOS_4_0  40000
#define BEINTOO_IOS_5_0  50000
#define BEINTOO_IOS_5_1  50100
#define BEINTOO_IOS_6_0  60000

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_4_0
    #import <CoreTelephony/CTTelephonyNetworkInfo.h>
    #import <CoreTelephony/CTCarrier.h>
#endif

@interface BeintooNetwork : NSObject {
	
}

+ (void)showNoConnectionAlert;
+ (BOOL)connectedToNetwork;
+ (NSString *)convertToCurrentDate:(NSString *)date;
+ (NSString *)getUserAgent;
+ (NSData *)getSynchImageWithUA:(NSString *)url;
+ (NSString *)getCarrierBuiltString;

@end
