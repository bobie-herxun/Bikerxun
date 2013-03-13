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

#import "BeintooBestoreVC.h"
#import "BeintooDevice.h"

@implementation BeintooBestoreVC
@synthesize isFromNotification;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    beintooPlayer = [[BeintooPlayer alloc] init];
    
    int appOrientation = [Beintoo appOrientation];
	
	UIImageView *logo;
    
	if( !([BeintooDevice isiPad]) && 
       (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) ){
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo_34.png"]];
    }
	else { 
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
    }
    
	self.navigationItem.titleView = logo;
	
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
    [self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [logo release];
    [barCloseBtn release];
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    beintooPlayer.delegate = self;
    
    [BLoadingView startActivity:self.view];
    
    if (![BeintooNetwork connectedToNetwork]){
        
        [BLoadingView stopActivity];
        
        [BeintooNetwork showNoConnectionAlert];
        
    }
    else {
        
        NSString *urlAddress;
        
        if ([Beintoo isOnPrivateSandbox])
            urlAddress      = [NSString stringWithFormat:@"https://sandbox-elb.beintoo.com/m/marketplace.html"]; 
        else 
            urlAddress      = [NSString stringWithFormat:@"https://www.beintoo.com/m/marketplace.html"];
        
        
        urlAddress          = [urlAddress stringByAppendingFormat:@"?apikey=%@", [Beintoo getApiKey]];
        
        if ([Beintoo getPlayerID])
            urlAddress          = [urlAddress stringByAppendingFormat:@"&guid=%@", [Beintoo getPlayerID]];
        
        CLLocation *loc     = [Beintoo getUserLocation];
        if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
            || (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
        }
        else	
            urlAddress      = [urlAddress stringByAppendingFormat:@"&lat=%f&lng=%f&acc=%f", loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];	
        
        if ([Beintoo isVirtualCurrencyStored]){
            urlAddress      = [urlAddress stringByAppendingFormat:@"&developer_user_guid=%@&virtual_currency_amount=%f", [Beintoo getDeveloperUserId], [Beintoo getVirtualCurrencyBalance]];
        }
        
        urlAddress = [urlAddress stringByAppendingFormat:@"&os_source=ios"];
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        webView.delegate = self;
        
        //Load the request in the UIWebView.
        [webView loadRequest:requestObj];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    
    beintooPlayer.delegate = nil;
    webView.delegate = nil;
    
    @try {
        
        [BLoadingView stopActivity];
        for (UIView *view in [self.view subviews]) {
            if([view isKindOfClass:[BLoadingView class]]){
                [view removeFromSuperview];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (UIView *)closeButton
{
    UIView *_vi             = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image        = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode  = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame          = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    NSMutableURLRequest *_request = (NSMutableURLRequest *)request;
	
    NSURL *url = _request.URL;
	NSString *urlString = [url path];
	
    NSURL *urlToGetParams = _request.URL;
	NSString *urlStringToGet = [urlToGetParams absoluteString];
    
    if ([urlString isEqualToString:@"/m/set_app_and_redirect.html"]) {
        
        BeintooUrlParser *urlParser = [[BeintooUrlParser alloc] initWithURLString:urlStringToGet];
        
        if ([urlParser valueForVariable:@"guid"])
            [beintooPlayer getPlayerByGUID:[urlParser valueForVariable:@"guid"]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [urlParser release];
#endif
		return YES;
	}

    // Check if we are going to open a content on the App Store or Itunes
    
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
			[[UIApplication sharedApplication] openURL:url];
			
            if (isFromNotification){
                if ([BeintooDevice isiPad]){
                    [Beintoo dismissIpadNotifications];
                }
                else {
                    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
            [self dismissViewControllerAnimated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [self dismissViewControllerAnimated:YES completion:nil];
            else
                [self dismissModalViewControllerAnimated:YES];
#else
            [self dismissModalViewControllerAnimated:YES];
#endif
                }
            }
            else
                [Beintoo dismissBeintoo];
            
        }
			
        return NO;
	}
	
    return YES;
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result
{
    if (![[result objectForKey:@"kind"] isEqualToString:@"error"]) {
        if ([result objectForKey:@"guid"] != nil) {
            
            NSString *playerGUID	= [result objectForKey:@"guid"];
            NSString *playerUser	= [result objectForKey:@"user"];
            
            if (playerUser != nil && playerGUID != nil) {	
                [Beintoo setUserLogged:YES];
            }
            [Beintoo setBeintooPlayer:result];
            
            // Alliance check
            if ([result objectForKey:@"alliance"] != nil) {
                [BeintooAlliance setUserWithAlliance:YES];
            }else{
                [BeintooAlliance setUserWithAlliance:NO];
            }
        }
    }
}

- (void)closeBeintoo
{
    if (isFromNotification){
        if ([BeintooDevice isiPad]){
            [Beintoo dismissIpadNotifications];
        }
        else {
            
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
            [self dismissViewControllerAnimated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [self dismissViewControllerAnimated:YES completion:nil];
            else
                [self dismissModalViewControllerAnimated:YES];
#else
            [self dismissModalViewControllerAnimated:YES];
#endif

        }
    }
    else
        [Beintoo dismissBeintoo];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    [BLoadingView stopActivity];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   [BLoadingView stopActivity];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc{
    [beintooPlayer release];
    
    [super dealloc];
}
#endif

@end
