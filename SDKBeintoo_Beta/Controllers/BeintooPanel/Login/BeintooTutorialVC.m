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

#import "BeintooTutorialVC.h"
#import "Beintoo.h"

@interface BeintooTutorialVC ()

@end

@implementation BeintooTutorialVC
@synthesize isFromDirectLaunch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
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

	if(([BeintooDevice isiPad]) || 
       !(appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) ){
        webview1 = [[UIWebView alloc] initWithFrame:label1.frame];
        webview1.delegate = self;
        webview1.alpha = 0.0;
        webview1.backgroundColor = [UIColor clearColor];
        [webview1 setOpaque:NO];
        webview1.userInteractionEnabled = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
            for (UIView *subview in webview1.subviews){
                if ([subview isKindOfClass:[UIScrollView class]]){
                    UIScrollView *scroll = (UIScrollView *)subview;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.bounces = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else {
            webview1.scrollView.showsHorizontalScrollIndicator = NO;
            webview1.scrollView.bounces = YES;
            webview1.scrollView.showsVerticalScrollIndicator = NO;
            webview1.scrollView.backgroundColor = [UIColor clearColor];
        }
        
        label1.hidden = YES;
        
        NSString *htmlString1 = [NSString stringWithFormat:@"<html><head> <style> body {font-family: 'Helvetica', sans-serif; background-color: transparent; } </style></head><body><div style=\"width:160px; height:100px \'><span style=\"font-size:16px; font-weight:bold; color:#2E4467; width:160px; height:100px; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"font-size:14px; color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span></div> </body></html>", NSLocalizedStringFromTable(@"tutorialFirstSentenceBold", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"tutorialFirstSentence", @"BeintooLocalizable", nil)];
        [webview1 loadHTMLString:htmlString1 baseURL:nil];
        
        [mainView addSubview:webview1];
        
        
        webview2 = [[UIWebView alloc] initWithFrame:label2.frame];
       // webview2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        webview2.delegate = self;
        webview2.alpha = 0.0;
        webview2.backgroundColor = [UIColor clearColor];
        [webview2 setOpaque:NO];
        webview2.backgroundColor = [UIColor clearColor];
        webview2.userInteractionEnabled = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
            for (UIView *subview in webview2.subviews){
                if ([subview isKindOfClass:[UIScrollView class]]){
                    UIScrollView *scroll = (UIScrollView *)subview;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.bounces = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else {
            webview2.scrollView.showsHorizontalScrollIndicator = NO;
            webview2.scrollView.bounces = YES;
            webview2.scrollView.showsVerticalScrollIndicator = NO;
            webview2.scrollView.backgroundColor = [UIColor clearColor];
        }
        
        label2.hidden = YES;
        
        NSString *htmlString2 = [NSString stringWithFormat:@"<html><head> <style> body {font-family: 'Helvetica', sans-serif; background-color: transparent; } </style></head><body><div style=\"width:160px; height:100px \"><span style=\"font-size:16px; font-weight:bold; color:#2E4467; width:160px; height:100px; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"font-size:14px; color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span></div> </body></html>", NSLocalizedStringFromTable(@"tutorialSecondSentenceBold", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"tutorialSecondSentence", @"BeintooLocalizable", nil)];
        [webview2 loadHTMLString:htmlString2 baseURL:nil];
        [mainView addSubview:webview2];
        
        webview3 = [[UIWebView alloc] initWithFrame:label3.frame];
       // webview3.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        webview3.delegate = self;
        webview3.alpha = 0.0;
        webview3.backgroundColor = [UIColor clearColor];
        [webview3 setOpaque:NO];
        webview3.userInteractionEnabled = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
            for (UIView *subview in webview3.subviews){
                if ([subview isKindOfClass:[UIScrollView class]]){
                    UIScrollView *scroll = (UIScrollView *)subview;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.bounces = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else {
            webview3.scrollView.showsHorizontalScrollIndicator = NO;
            webview3.scrollView.bounces = YES;
            webview3.scrollView.showsVerticalScrollIndicator = NO;
            webview3.scrollView.backgroundColor = [UIColor clearColor];
        }
        
        label3.hidden = YES;
        
        NSString *htmlString3 = [NSString stringWithFormat:@"<html><head> <style> body {font-family: 'Helvetica', sans-serif; background-color: transparent; } </style></head><body><div style=\"width:160px; height:100px \"><span style=\"font-size:16px; font-weight:bold; color:#2E4467; width:160px; height:100px; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"font-size:14px; color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span></div> </body></html>", NSLocalizedStringFromTable(@"tutorialThirdSentenceBold", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"tutorialThirdSentence", @"BeintooLocalizable", nil)];
        [webview3 loadHTMLString:htmlString3 baseURL:nil];
        [mainView addSubview:webview3];
    }
    else {
       
        webview1Land = [[UIWebView alloc] initWithFrame:labelLand1.frame];
        webview1Land.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        webview1Land.delegate = self;
        webview1Land.alpha = 0.0;
        webview1Land.backgroundColor = [UIColor clearColor];
        [webview1Land setOpaque:NO];
        webview1Land.userInteractionEnabled = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
            for (UIView *subview in webview1Land.subviews){
                if ([subview isKindOfClass:[UIScrollView class]]){
                    UIScrollView *scroll = (UIScrollView *)subview;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.bounces = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else {
            webview1Land.scrollView.showsHorizontalScrollIndicator = NO;
            webview1Land.scrollView.bounces = YES;
            webview1Land.scrollView.showsVerticalScrollIndicator = NO;
            webview1Land.scrollView.backgroundColor = [UIColor clearColor];
        }
        
        labelLand1.hidden = YES;
        
        NSString *htmlString4 = [NSString stringWithFormat:@"<html><head> <style> body {font-family: 'Helvetica', sans-serif; background-color: transparent; } </style></head><body><div style=\"width:120px; height:100px \"><span style=\"font-size:15px; font-weight:bold; color:#2E4467; width:120px; height:100px; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"font-size:13px; color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span></div> </body></html>", NSLocalizedStringFromTable(@"tutorialFirstSentenceBold", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"tutorialFirstSentence", @"BeintooLocalizable", nil)];
        [webview1Land loadHTMLString:htmlString4 baseURL:nil];
        [landView addSubview:webview1Land];
        
        
        webview2Land = [[UIWebView alloc] initWithFrame:labelLand2.frame];
        webview2Land.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        webview2Land.delegate = self;
        webview2Land.alpha = 0.0;
        [webview2Land setOpaque:NO];
        webview2Land.backgroundColor = [UIColor clearColor];
        webview2Land.userInteractionEnabled = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
            for (UIView *subview in webview2Land.subviews){
                if ([subview isKindOfClass:[UIScrollView class]]){
                    UIScrollView *scroll = (UIScrollView *)subview;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.bounces = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else {
            webview2Land.scrollView.showsHorizontalScrollIndicator = NO;
            webview2Land.scrollView.bounces = YES;
            webview2Land.scrollView.showsVerticalScrollIndicator = NO;
            webview2Land.scrollView.backgroundColor = [UIColor clearColor];
        }
        
        labelLand2.hidden = YES;
        
        NSString *htmlString5 = [NSString stringWithFormat:@"<html><head> <style> body {font-family: 'Helvetica', sans-serif; background-color: transparent; } </style></head><body><div style=\"width:120px; height:100px \"><span style=\"font-size:15px; font-weight:bold; color:#2E4467; width:120px; height:100px; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"font-size:13px; color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span></div> </body></html>", NSLocalizedStringFromTable(@"tutorialSecondSentenceBold", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"tutorialSecondSentence", @"BeintooLocalizable", nil)];
        [webview2Land loadHTMLString:htmlString5 baseURL:nil];
        [landView addSubview:webview2Land];
        
        webview3Land = [[UIWebView alloc] initWithFrame:labelLand3.frame];
        webview3Land.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        webview3Land.delegate = self;
        webview3Land.alpha = 0.0;
        webview3Land.backgroundColor = [UIColor clearColor];
        [webview3Land setOpaque:NO];
        webview3Land.userInteractionEnabled = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
            for (UIView *subview in webview3Land.subviews){
                if ([subview isKindOfClass:[UIScrollView class]]){
                    UIScrollView *scroll = (UIScrollView *)subview;
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.bounces = YES;
                    scroll.showsVerticalScrollIndicator = NO;
                    scroll.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else {
            webview3Land.scrollView.showsHorizontalScrollIndicator = NO;
            webview3Land.scrollView.bounces = YES;
            webview3Land.scrollView.showsVerticalScrollIndicator = NO;
            webview3Land.scrollView.backgroundColor = [UIColor clearColor];
        }
        
        labelLand3.hidden = YES;
        
        NSString *htmlString6 = [NSString stringWithFormat:@"<html><head> <style> body {font-family: 'Helvetica', sans-serif; background-color: transparent; } </style></head><body><div style=\"width:120px; height:100px \"><span style=\"font-size:15px; font-weight:bold; color:#2E4467; width:120px; height:100px; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"font-size:13px; color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span></div> </body></html>", NSLocalizedStringFromTable(@"tutorialThirdSentenceBold", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"tutorialThirdSentence", @"BeintooLocalizable", nil)];
        [webview3Land loadHTMLString:htmlString6 baseURL:nil];
        [landView addSubview:webview3Land];
    
    }
    
    [goToDashboard setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[goToDashboard setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[goToDashboard setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [goToDashboard setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[goToDashboard setButtonTextSize:18];
    
    [goToDashboardLand setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[goToDashboardLand setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[goToDashboardLand setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [goToDashboardLand setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[goToDashboardLand setButtonTextSize:18];
    
   
    [goToDashboard setTitle:NSLocalizedStringFromTable(@"tutorialProceedButton", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    [goToDashboardLand setTitle:NSLocalizedStringFromTable(@"tutorialProceedButton", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    
    mainView.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    landView.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];

    BGradientView *footerView = [[BGradientView alloc] initWithGradientType:GRADIENT_FOOTER];
    
    if(![BeintooDevice isiPad] && (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) ){
        self.view = landView;
        footerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width - 4 , [UIScreen mainScreen].bounds.size.height, 4);
    }
    else {
        self.view = mainView;
        footerView.frame = CGRectMake(0, self.view.frame.size.height - 4, [UIScreen mainScreen].bounds.size.width, 4);
        
    }
    
    if ([BeintooDevice isiPad])
        footerView.frame = CGRectMake(0, self.view.frame.size.height + 4, [UIScreen mainScreen].bounds.size.width, 4);
    
   // [self.view addSubview:footerView];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [footerView release];
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    goToDashboardLand.frame = CGRectMake((self.view.frame.size.width - goToDashboardLand.frame.size.width)/2 , goToDashboardLand.frame.origin.y, goToDashboardLand.frame.size.width, goToDashboardLand.frame.size.height);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView beginAnimations:nil context:nil];
    webView.alpha = 1.0;
    [UIView commitAnimations];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

- (IBAction)goToDashboard:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];
    
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
- (void)dealloc{
    [webview1 release];
    [webview2 release];
    [webview3 release];
    
    [webview1Land release];
    [webview2Land release];
    [webview3Land release];
    
    [super dealloc];
}
#endif

@end
