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

#import "BeintooVGoodShowVC.h"
#import "Beintoo.h"

@implementation BeintooVGoodShowVC

@synthesize urlToOpen, caller, callerIstance, type, isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.urlToOpen = [[NSString alloc] init];
		self.urlToOpen = URL;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Beintoo";
    
    beintooPlayer = [[BeintooPlayer alloc] init];
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
		
	vGoodWebView.scalesPageToFit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    vGoodWebView.delegate = self;
    beintooPlayer.delegate = self;
    
    [BLoadingView startActivity:self.view];
    	
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
	
	/*
	 *  Check if the vgood is pushed from a multipleVgoodVC, if yes hides back button.
	 */
    NSArray *VCArray = self.navigationController.viewControllers;
    for (int i = 0; i < [VCArray count]; i++) {
        if ([[VCArray objectAtIndex:i] isKindOfClass:[BeintooMultipleVgoodVC class]]) {
            [self.navigationItem setHidesBackButton:YES];
        }
    }
    
    if (type != AD){
        if ([urlToOpen rangeOfString: @"?"].location == NSNotFound)
            urlToOpen = [urlToOpen stringByAppendingFormat:@"?os_source=ios"];
        else 
            urlToOpen = [urlToOpen stringByAppendingFormat:@"&os_source=ios"];
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    [vGoodWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlToOpen]]];
#else
    [vGoodWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlToOpen retain]]]];
#endif
	
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    beintooPlayer.delegate = nil;
    vGoodWebView.delegate = nil;
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

#pragma mark -
#pragma mark webViewDelegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
	
    NSURL *url = request.URL;
	NSString *urlString = [url path];
	
    NSURL *urlToGetParams = request.URL;
	NSString *urlStringToGet = [urlToGetParams absoluteString];
    
    if ([urlString isEqualToString:@"/m/set_app_and_redirect.html"]) {
        
        BeintooUrlParser *urlParser = [[BeintooUrlParser alloc] initWithURLString:urlStringToGet];
        
        if ([urlParser valueForVariable:@"guid"])
            [beintooPlayer getPlayerByGUID:[urlParser valueForVariable:@"guid"]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [urlParser release];
#endif
        
    }
    
    didOpenTheRecommendation = NO;
	
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
		// ******** Remember that this will NOT work on the simulator ******* //
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
			[[UIApplication sharedApplication] openURL:url];
			[BLoadingView stopActivity];
			didOpenTheRecommendation = YES;
			if (didOpenTheRecommendation) {
                //[Beintoo dismissRecommendation];
                if (isFromWallet) { 
                    [Beintoo dismissBeintoo];
                }
                else if (isFromNotification){
                    if ([BeintooDevice isiPad]){
                        [Beintoo dismissIpadNotifications];
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
                else {
                    if (type == REWARD)
                        [Beintoo dismissPrize];
                    else if (type == AD)
                        [Beintoo dismissAd];
                }
			}
			
			return NO;
		}
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

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{    
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
	[BLoadingView stopActivity];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) return;
	
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
	
	[BLoadingView stopActivity];
}

- (void)setIsFromWallet:(BOOL)value
{
	isFromWallet = value;
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
    if (isFromWallet) {
		[Beintoo dismissBeintoo];
	}
    else if (isFromNotification){
        
    }
    else {
        if (type == REWARD)
            [Beintoo dismissPrize];
        else if (type == AD)
            [Beintoo dismissAd];
        else if (type == GIVE_BEDOLLARS)
            [Beintoo dismissGiveBedollarsController];
	}
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
	[vGoodWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

#ifdef UI_USER_INTERFACE_IDIOM
- (void)setRecommendationPopoverController:(UIPopoverController *)_recommPopover
{
	recommendPopoverController = _recommPopover;
}
#endif


#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [beintooPlayer release];
    [super dealloc];
}
#endif

@end
