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

#import "BImageDownload.h"
#import "BeintooDevice.h"

@interface BImageDownload()
@property (nonatomic, retain) NSMutableData *receivedData;
@end


@implementation BImageDownload

@synthesize urlString, image, delegate, receivedData, tag;

#pragma mark -

- (UIImage *)image
{    
    if (image == nil){
        BImageCache *imageCache = [[BImageCache alloc] init];
        if ([imageCache isRemoteFileCached:self.urlString]){
            self.image = [UIImage imageWithContentsOfFile:[imageCache getCachedRemoteFile:urlString]];
        }
        else if (!downloading){
            if (urlString != nil && [urlString length] > 0){
                NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
                NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
                [con scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                [con start];
                
                if (con) {
                    NSMutableData *data = [[NSMutableData alloc] init];
                    self.receivedData   = data;
                    
#ifdef BEINTOO_ARC_AVAILABLE
#else
                    [data release];
#endif
                    
                }
                else {
                    NSError *error = [NSError errorWithDomain:BeintooDownloadErrorDomain
                                                         code:BeintooDownloadErrorNoConnection
                                                     userInfo:nil];
                    if ([self.delegate respondsToSelector:@selector(bImageDownload:didFailWithError:)])
                        [delegate bImageDownload:self didFailWithError:error];
                }
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [req release];
#endif
               
                downloading = YES;
            }
        }
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [imageCache release];
#endif
        
    }
    
    return image;
}

- (NSString *)filename
{
    return [urlString lastPathComponent];
}

#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [connection release];
#endif
    
    if ([delegate respondsToSelector:@selector(bImageDownload:didFailWithError:)])
        [delegate bImageDownload:self didFailWithError:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try{
        self.image = [UIImage imageWithData:receivedData];
        
        if (delegate && delegate != nil){
            if ([delegate respondsToSelector:@selector(bImageDownloadDidFinishDownloading:)])
                [delegate bImageDownloadDidFinishDownloading:self];
        }
    
        BImageCache *imageCache = [[BImageCache alloc] init];
        [imageCache addRemoteFileToCache:urlString withData:receivedData];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [imageCache release];
#endif
        
    }
    @catch (NSException *e) {
         
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [connection release];
#endif
    
    self.receivedData = nil;
}

#pragma mark -
#pragma mark Comparison

- (NSComparisonResult)compare:(id)theOther
{
    BImageDownload *other = (BImageDownload *)theOther;
    return [self.filename compare:other.filename];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    delegate = nil;
    
    [urlString release];
    [image release];
    [receivedData release];
    [super dealloc];
}
#endif

@end