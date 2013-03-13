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

#import "BImageCache.h"

static BImageCache *sharedInstance = nil;

@implementation BImageCache
@synthesize dictCache;

- (id)init
{
	if ( (self = [super init]) )
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsDirectory = [paths objectAtIndex:0];

        filemgr = [NSFileManager defaultManager];
        currentpath = [documentsDirectory stringByAppendingPathComponent:@"/beintoo/image_cache_folder/"];
        if (![filemgr contentsOfDirectoryAtPath:currentpath error:NULL]){
            [filemgr createDirectoryAtPath:currentpath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
	}
	
	return self;
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc
{
    [super dealloc];
}
#endif

+ (BImageCache *) instance
{
	@synchronized(self)
	{
		if ( sharedInstance == nil )
		{
			sharedInstance = [[BImageCache alloc] init];
		}
	}
	return sharedInstance;
}

- (BOOL)isRemoteFileCached:(NSString*)url
{
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-YY HH:mm:ss"];
        
        NSString *cachedFileDictionary = [currentpath stringByAppendingFormat:@"/%@",[self makeKeyFromUrl:url]];	
        NSData *cachedFile = [filemgr contentsAtPath:cachedFileDictionary]; 
        if (cachedFile != nil){
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [dateFormatter release];
#endif
            
            return YES;
        }
        else {
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [dateFormatter release];
#endif
            
            return NO;
        }
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [dateFormatter release];
#endif
        
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on image cache file check: %@", exception);
    }
    
    return NO;
}

- (NSString *)getCachedRemoteFile:(NSString*)url
{
    @try {
        NSString *cachedFileDictionary = [currentpath stringByAppendingFormat:@"/%@", [self makeKeyFromUrl:url]];	
        
        NSData *cachedFile = [filemgr contentsAtPath:cachedFileDictionary];

        if (cachedFile != nil){
            return cachedFileDictionary;
        }
        else{
            return nil;
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on image cache file check: %@", exception);
    }

    return nil;
}

- (BOOL) addRemoteFileToCache:(NSString*)url withData:(NSData*)data
{
    @try {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MM-YY HH:mm:ss"];
        
        NSString *imageName = [self makeKeyFromUrl:url];
        
        NSString *cachedFileDictionary = [currentpath stringByAppendingFormat:@"/%@", imageName];
        NSData *cachedFile = [filemgr contentsAtPath:cachedFileDictionary];
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:currDate forKey:NSFileCreationDate];  
        
        NSDictionary *cachedFileAttributes = [filemgr attributesOfItemAtPath:cachedFileDictionary error:NULL];
        NSDate *cacheFileCreationDate = [cachedFileAttributes objectForKey:NSFileCreationDate];
        
        int timeInterval = [currDate timeIntervalSinceDate:cacheFileCreationDate];
        
        if (timeInterval > 3600 * 24 * 7 || cachedFile == nil){
            [filemgr removeItemAtPath:cachedFileDictionary error:NULL];
            [filemgr createFileAtPath:cachedFileDictionary contents:data attributes:attributes];
            
            if ([self isRemoteFileCached:url]){
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [dateFormatter release];
                [attributes release];
#endif
                
                return  YES;
            }
            else {
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [dateFormatter release];
                [attributes release];
#endif
                
                return NO;
            }
        }
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [dateFormatter release];
        [attributes release];
#endif
        
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on image cache file save: %@", exception);
    }
    return NO;
}

#pragma mark -
#pragma mark Private Methods

- (NSString*)makeKeyFromUrl:(NSString*)url
{
	NSString *key = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    
	return key;
}

@end
