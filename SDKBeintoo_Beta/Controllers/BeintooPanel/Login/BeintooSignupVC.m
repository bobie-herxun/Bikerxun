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

#import "BeintooSigninVC.h"
#import "Beintoo.h"
#import "BeintooTutorialVC.h"

@implementation BeintooSignupVC

@synthesize urlToOpen, registrationWebView, caller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.urlToOpen = URL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	int appOrientation = [Beintoo appOrientation];
	
	UIImageView *logo;
    if( !([BeintooDevice isiPad]) && 
       (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) )
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo_34.png"]];
    else
        logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
    
    self.navigationItem.titleView = logo;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [logo release];
#endif
	
	// Registration View Initial Settings
	registrationWebView.delegate = self;
	registrationWebView.scalesPageToFit = YES;
    
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	_player = [[BeintooPlayer alloc] init];
	_player.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    kindOfDelegateNotification = 0;
    
    if ([Beintoo isUserLogged]){
        [Beintoo playerLogout];
    }

    NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
    // Here we delete all facebbok cookies, to prevent the auto-login of another user
	for (cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:@".facebook.com"] || [[cookie name] isEqualToString:@"fbs_152837841401121"]) {
            [storage deleteCookie:cookie];
        }
	}
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlToOpen]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [self.registrationWebView loadRequest:request];	
}

#pragma mark -
#pragma mark WebViewDelegates

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [BLoadingView startActivity:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [BLoadingView stopActivity];
    
    for (UIView *view in [self.view subviews]) {
        if([view isKindOfClass:[BLoadingView class]]){
            [view removeFromSuperview];
        }
    }
    
    @try {
		NSString *url = [[[theWebView request] URL] absoluteString];
		NSRange id_range		= [url rangeOfString:@"userext="];
		NSString *ext_id = nil;
		
        if ([url rangeOfString:@"landing_register_ok.html"].location != NSNotFound)
            kindOfDelegateNotification = BEINTOO_FACEBOOK_SIGNUP;
        else if ([url rangeOfString:@"landing_logged.html"].location != NSNotFound)
            kindOfDelegateNotification = BEINTOO_FACEBOOK_LOGIN;
        
		if( (id_range.location < 200) && ([url rangeOfString:@"#close"].location > 200) && ([url rangeOfString:@"already_logged.html"].location>200) ) {
			ext_id = [url substringFromIndex:(id_range.location+id_range.length)];
			[_player login:ext_id];	
		}
	}
	@catch (NSException * e) {
	}
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	@try {
		NSString *url           = [[request URL] absoluteString];
		NSRange registr_ok		= [url rangeOfString:@"#close"]; // Welcome in beintoo (registration ok)
		NSRange logged_ok		= [url rangeOfString:@"#close_login"];    // Welcome back! You are now logged in
		//NSRange closeFacebook	= [url rangeOfString:@"error_reason=user_denied"];
		NSRange backButton		= [url rangeOfString:@"back"];			  // Already registered with this account, please go to login	
		
		if(registr_ok.location != NSNotFound){
			[_player getPlayerByGUID:[Beintoo getPlayerID]]; 
		}
		
		if (logged_ok.location != NSNotFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];
			[self closeButton];
		}
        
		if (backButton.location != NSNotFound) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	@catch (NSException * e) {

	}
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BLoadingView stopActivity];
    
    for (UIView *view in [self.view subviews]) {
        if([view isKindOfClass:[BLoadingView class]]){
            [view removeFromSuperview];
        }
    }
}

#pragma mark Delegates
- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result
{
	[Beintoo setBeintooPlayer:result];	
	[_player login];
	[Beintoo setUserLogged:YES];
}

- (void)playerDidLogin:(BeintooPlayer *)player
{
	if ([Beintoo getUserIfLogged] != nil) {
        
        if (kindOfDelegateNotification == BEINTOO_FACEBOOK_LOGIN){
            [Beintoo postNotificationBeintooUserDidLogin];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];
            
            kindOfDelegateNotification = 0;
            
            if ([BeintooDevice isiPad]){
                [Beintoo dismissIpadLogin];
            }
            else {
                
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0)
                [self dismissViewControllerAnimated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    [self dismissViewControllerAnimated:YES completion:nil];
                else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
                    [self dismissModalViewControllerAnimated:YES];
#else
                [self dismissModalViewControllerAnimated:YES];
#endif

            }
        }
        else if (kindOfDelegateNotification == BEINTOO_FACEBOOK_SIGNUP){
            [Beintoo postNotificationBeintooUserDidSignup];
            
            kindOfDelegateNotification = 0;
            
            BeintooTutorialVC *beintooTutorialVC = [[BeintooTutorialVC alloc] initWithNibName:@"BeintooTutorialVC" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:beintooTutorialVC animated:YES];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [beintooTutorialVC release];
#endif
            
        }
	}
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [registrationWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    registrationWebView.delegate = nil;
    
    @try {
		[BLoadingView stopActivity]; 
        for (UIView *view in [self.view subviews]) {
            if([view isKindOfClass:[BLoadingView class]]){
                [view removeFromSuperview];
            }
        }
	}
	@catch (NSException * e) {
	}
}

- (UIView *)closeButton
{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationSignupClosed object:self];
    
    if ([BeintooDevice isiPad]){
        [Beintoo dismissIpadLogin];
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

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[_player release];
    [super dealloc];
}
#endif

@end
