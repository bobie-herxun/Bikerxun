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
#import <QuartzCore/QuartzCore.h>
#import "BeintooTutorialVC.h"

@implementation BeintooSigninVC

@synthesize nickname, caller, isFromDirectLaunch;

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
	
	registrationFBVC = [BeintooSignupVC alloc];
	
    nickname = [[NSString alloc] init];
	
    [beintooView setTopHeight:0];
	[beintooView setBodyHeight:545];
	[beintooView setIsScrollView:YES];
    
    [beintooViewLand setTopHeight:0];
	[beintooViewLand setBodyHeight:370];
	[beintooViewLand setIsScrollView:YES];
    
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 440);
	scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
			
	self.navigationItem.hidesBackButton = NO;
	if ([[Beintoo getLastLoggedPlayers] count] < 1) {
		self.navigationItem.hidesBackButton = YES;
	}
	
	user			= [[BeintooUser alloc] init];
	user.delegate	= self;
	_player			= [[BeintooPlayer alloc]init];
	_player.delegate = self;
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	emailTF.delegate = self;
	nickTF.delegate = self;
    
    emailTF.text = @"";
	emailTF.placeholder = @"email";
	emailTF.hidden = NO;
	title1.text = NSLocalizedStringFromTable(@"enteremail", @"BeintooLocalizable", @"");
	title1.numberOfLines = 2;
    
	[newUserButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [newUserButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[newUserButton setButtonTextSize:20];
    
    [disclaimer setScrollEnabled:YES];
    [disclaimerLand setScrollEnabled:YES];
	
	emailTFLand.delegate = self;
	nickTFLand.delegate = self;
    
    emailTFLand.text = @"";
	emailTFLand.placeholder = NSLocalizedStringFromTable(@"signupTextFieldPlaceholder",@"BeintooLocalizable", nil);
	emailTFLand.hidden = NO;
	title1Land.text = NSLocalizedStringFromTable(@"signupMainSentence",@"BeintooLocalizable",@"");
	title1Land.numberOfLines = 2;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    title1.textAlignment = NSTextAlignmentCenter;
    title1Land.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        title1.textAlignment = NSTextAlignmentCenter;
        title1Land.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        title1.textAlignment = UITextAlignmentCenter;
        title1Land.textAlignment = UITextAlignmentCenter;
    }
#else
    title1.textAlignment = UITextAlignmentCenter;
    title1Land.textAlignment = UITextAlignmentCenter;
#endif
   
    [newUserButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [newUserButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[newUserButton setButtonTextSize:20];
    
    [newUserButtonLand setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[newUserButtonLand setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[newUserButtonLand setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [newUserButtonLand setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[newUserButtonLand setButtonTextSize:20];
    
    fbButton = [[BButton alloc] initWithFrame:facebookButton.frame];
    [fbButton setHighColor:[UIColor colorWithRed:96.0/255 green:130.0/255 blue:178.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
	[fbButton setMediumHighColor:[UIColor colorWithRed:80.0/255 green:106.0/255 blue:148.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
	[fbButton setMediumLowColor:[UIColor colorWithRed:74.0/255 green:100.0/255 blue:140.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
    [fbButton setLowColor:[UIColor colorWithRed:38.0/255 green:60.0/255 blue:86.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
	[fbButton setButtonTextSize:20];
    [fbButton addTarget:self action:@selector(loginFB) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageFb = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 36, 34)];
    imageFb.image = [UIImage imageNamed:@"fb.png"];
    imageFb.backgroundColor = [UIColor clearColor];
    [fbButton addSubview:imageFb];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [imageFb release];
#endif
    
    UILabel *labelFb = [[UILabel alloc] initWithFrame:CGRectMake(65, 4, 245, 34)];
    labelFb.backgroundColor = [UIColor clearColor];
    labelFb.textColor = [UIColor whiteColor];
    labelFb.text = NSLocalizedStringFromTable(@"connectWithFacebook", @"BeintooLocalizable", nil);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    labelFb.minimumScaleFactor = 2.0;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        labelFb.minimumScaleFactor = 2.0;
    else
        labelFb.minimumFontSize = 8.0;
#else
    labelFb.minimumFontSize = 8.0;
#endif
    
    labelFb.font = [UIFont systemFontOfSize:19];
    labelFb.shadowOffset = CGSizeMake(0, -1);
    labelFb.shadowColor = [UIColor colorWithRed:38.0/255.0 green:60.0/255.0 blue:86.0/255.0 alpha:0.8];
    [fbButton addSubview:labelFb];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [labelFb release];
#endif
    
    [beintooView addSubview:fbButton];
    facebookButton.hidden = YES;
    
    fbButtonLand = [[BButton alloc] initWithFrame:facebookButtonLand.frame];
    fbButtonLand.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [fbButtonLand setHighColor:[UIColor colorWithRed:96.0/255 green:130.0/255 blue:178.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
	[fbButtonLand setMediumHighColor:[UIColor colorWithRed:80.0/255 green:106.0/255 blue:148.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
	[fbButtonLand setMediumLowColor:[UIColor colorWithRed:74.0/255 green:100.0/255 blue:140.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
    [fbButtonLand setLowColor:[UIColor colorWithRed:38.0/255 green:60.0/255 blue:86.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(56, 2)/pow(255,2) green:pow(79, 2)/pow(255,2) blue:pow(112, 2)/pow(255,2) alpha:1]];
	[fbButtonLand setButtonTextSize:20];
    [fbButtonLand addTarget:self action:@selector(loginFB) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageFbLand = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 36, 34)];
    imageFbLand.image = [UIImage imageNamed:@"fb.png"];
    imageFbLand.backgroundColor = [UIColor clearColor];
    [fbButtonLand addSubview:imageFbLand];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [imageFbLand release];
#endif
    
    UILabel *labelFbLand = [[UILabel alloc] initWithFrame:CGRectMake(65, 4, 235, 34)];
    labelFbLand.backgroundColor = [UIColor clearColor];
    labelFbLand.textColor = [UIColor whiteColor];
    labelFbLand.text = NSLocalizedStringFromTable(@"connectWithFacebook", @"BeintooLocalizable", nil);
    labelFbLand.font = [UIFont systemFontOfSize:18];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    labelFbLand.minimumScaleFactor = 2.0;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        labelFbLand.minimumScaleFactor = 2.0;
    else
        labelFbLand.minimumFontSize = 8.0;
#else
    labelFbLand.minimumFontSize = 8.0;
#endif

    labelFbLand.shadowOffset = CGSizeMake(0, -1);
    labelFbLand.shadowColor = [UIColor colorWithRed:38.0/255.0 green:60.0/255.0 blue:86.0/255.0 alpha:0.8];
    [fbButtonLand addSubview:labelFbLand];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [labelFbLand release];
#endif
    
    [beintooViewLand addSubview:fbButtonLand];
    facebookButtonLand.hidden = YES;
    
    // Keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification  object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification  object:self.view.window];
    
    // keyboardIsShown = NO;
    
    if (keyboardToolbar == nil) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];
		keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
		UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
        
#ifdef BEINTOO_ARC_AVAILABLE
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraSpace,doneButton,nil]];
#else
        [keyboardToolbar setItems:[[[NSArray alloc] initWithObjects:extraSpace,doneButton,nil] autorelease]];
		
		[doneButton release];
		[extraSpace release];
#endif
		
	}
    
    @try {
		if ([emailTF respondsToSelector:@selector(setInputAccessoryView:)])
			[emailTF setInputAccessoryView:keyboardToolbar];
		else
			isAccessoryInputViewNotSupported = YES;
	}
	@catch (NSException * e) {
		isAccessoryInputViewNotSupported = YES;
	}
    
    @try {
		if ([emailTFLand respondsToSelector:@selector(setInputAccessoryView:)])
			[emailTFLand setInputAccessoryView:keyboardToolbar];
		else
			isAccessoryInputViewNotSupported = YES;
	}
	@catch (NSException * e) {
		isAccessoryInputViewNotSupported = YES;
	}
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [keyboardToolbar release];
#endif
    
    if ( ![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        [beintooViewLand removeFromSuperview];
        [beintooView removeFromSuperview];
        [scrollView addSubview:beintooViewLand];
    }
    else{
        [beintooViewLand removeFromSuperview];
        [beintooView removeFromSuperview];
        [scrollView addSubview:beintooView];
    }
    
    webview = [[UIWebView alloc] initWithFrame:title1.frame];
    webview.alpha = 0.0;
    webview.delegate = self;
    webview.backgroundColor = [UIColor clearColor];
    [webview setOpaque:NO];
    webview.backgroundColor = [UIColor clearColor];
    webview.userInteractionEnabled = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
        for (UIView *subview in webview.subviews){
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
        webview.scrollView.showsHorizontalScrollIndicator = NO;
        webview.scrollView.bounces = YES;
        webview.scrollView.showsVerticalScrollIndicator = NO;
        webview.scrollView.backgroundColor = [UIColor clearColor];
    }
    
    title1.hidden = YES;
    
    NSString *htmlString1 = [NSString stringWithFormat:@"<html><head> <style> body {margin: 0; padding: 0px; font-family: 'Helvetica', sans-serif; background-color: transparent; line-height:17px; font-weight:bold; font-size:15px;} </style></head><body><div><span style=\"color:#2E4467; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\" color:#2E4467; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\" color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span>   <span style=\"color:#2E4467; text-shadow: 0px 1px 0px #FFF;\">%@</span>  <span style=\" color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span> </div> </body></html>", NSLocalizedStringFromTable(@"signupMainSentence1", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence2", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence3", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence4", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence5", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence6", @"BeintooLocalizable", nil)];
    
    [webview loadHTMLString:htmlString1 baseURL:nil];
    [beintooView addSubview:webview];
    
    webviewLand = [[UIWebView alloc] initWithFrame:title1Land.frame];
    webviewLand.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    webviewLand.alpha = 0.0;
    webviewLand.delegate = self;
    webviewLand.backgroundColor = [UIColor clearColor];
    [webviewLand setOpaque:NO];
    webviewLand.userInteractionEnabled = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
        for (UIView *subview in webviewLand.subviews){
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
        webviewLand.scrollView.showsHorizontalScrollIndicator = NO;
        webviewLand.scrollView.bounces = YES;
        webviewLand.scrollView.showsVerticalScrollIndicator = NO;
        webviewLand.scrollView.backgroundColor = [UIColor clearColor];
    }
    
    title1Land.hidden = YES;
    
    NSString *htmlString2 = [NSString stringWithFormat:@"<html><head> <style> body { margin: 0; padding: 0px; font-family: 'Helvetica', sans-serif; background-color: transparent; line-height:17px; font-weight:bold; font-size:15px;} </style></head><body><div><span style=\"color:#2E4467; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\"color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\" color:#2E4467; text-shadow: 0px 1px 0px #FFF;\">%@</span> <span style=\" color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span>   <span style=\"color:#2E4467; text-shadow: 0px 1px 0px #FFF;\">%@</span>  <span style=\" color:#586985; text-shadow: 0px 1px 0px #FFF;\">%@</span> </div> </body></html>", NSLocalizedStringFromTable(@"signupMainSentence1", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence2", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence3", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence4", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence5", @"BeintooLocalizable", nil), NSLocalizedStringFromTable(@"signupMainSentence6", @"BeintooLocalizable", nil)];
    
    [webviewLand loadHTMLString:htmlString2 baseURL:nil];
    [beintooViewLand addSubview:webviewLand];
    
    orLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    loginWithDifferent.titleLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    orLabelLand.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    loginWithDifferentLand.titleLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    
    disclaimer.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    disclaimerLand.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    
    emailTF.frame = CGRectMake(emailTF.frame.origin.x, emailTF.frame.origin.y, emailTF.frame.size.width, 44);
    emailTFLand.frame = CGRectMake(emailTFLand.frame.origin.x, emailTFLand.frame.origin.y, emailTFLand.frame.size.width, 44);
    
    registrazioneComplete = [[UILabel alloc] initWithFrame:CGRectMake(10, webview.frame.origin.y + webview.frame.size.height + 20, 300, 15)];
    registrazioneComplete.text = NSLocalizedStringFromTable(@"registrationComplete",@"BeintooLocalizable",@"");
    registrazioneComplete.font = [UIFont boldSystemFontOfSize:14.0];
    registrazioneComplete.numberOfLines = 1;
    registrazioneComplete.alpha = 0.0;
    registrazioneComplete.backgroundColor = [UIColor clearColor];
    registrazioneComplete.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    [beintooView addSubview:registrazioneComplete];
    
    confirmNickname = [[UILabel alloc] initWithFrame:CGRectMake(10, registrazioneComplete.frame.origin.y + registrazioneComplete.frame.size.height + 2, 300, 15)];
    confirmNickname.text = NSLocalizedStringFromTable(@"confirmNickname",@"BeintooLocalizable",@"");
    confirmNickname.font = [UIFont boldSystemFontOfSize:14.0];
    confirmNickname.numberOfLines = 1;
    confirmNickname.alpha = 0.0;
    confirmNickname.backgroundColor = [UIColor clearColor];
    confirmNickname.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    [beintooView addSubview:confirmNickname];
    
    registrazioneCompleteLand = [[UILabel alloc] initWithFrame:CGRectMake(webviewLand.frame.origin.x, webviewLand.frame.origin.y + webviewLand.frame.size.height + 15, webviewLand.frame.size.width, 20)];
    registrazioneCompleteLand.text = NSLocalizedStringFromTable(@"registrationComplete",@"BeintooLocalizable",@"");
    registrazioneCompleteLand.backgroundColor = [UIColor clearColor];
    registrazioneCompleteLand.font = [UIFont boldSystemFontOfSize:14.0];
    registrazioneCompleteLand.numberOfLines = 0;
    registrazioneCompleteLand.alpha = 0.0;
    registrazioneCompleteLand.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    [beintooViewLand addSubview:registrazioneCompleteLand];
    
    confirmNicknameLand = [[UILabel alloc] initWithFrame:CGRectMake(webviewLand.frame.origin.x, registrazioneCompleteLand.frame.origin.y + registrazioneCompleteLand.frame.size.height + 2, 300, 15)];
    confirmNicknameLand.text = NSLocalizedStringFromTable(@"confirmNickname",@"BeintooLocalizable",@"");
    confirmNicknameLand.font = [UIFont boldSystemFontOfSize:14.0];
    confirmNicknameLand.numberOfLines = 1;
    confirmNicknameLand.alpha = 0.0;
    confirmNicknameLand.backgroundColor = [UIColor clearColor];
    confirmNicknameLand.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    [beintooViewLand addSubview:confirmNicknameLand];
    
    scrollView.clipsToBounds = NO;
    
    disclaimer.text = NSLocalizedStringFromTable(@"registrationDisclaim",@"BeintooLocalizable",@"Login");
    disclaimerLand.text = NSLocalizedStringFromTable(@"registrationDisclaim",@"BeintooLocalizable",@"Login");
	
	[newUserButton setTitle:NSLocalizedStringFromTable(@"startBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[newUserButton removeTarget:self action:@selector(confirmNickname) forControlEvents:UIControlEventTouchUpInside];
	[newUserButton addTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
	
	[loginWithDifferent setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[loginWithDifferent setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateHighlighted];
	[loginWithDifferent setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateSelected];
    
    [newUserButtonLand setTitle:NSLocalizedStringFromTable(@"startBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[newUserButtonLand removeTarget:self action:@selector(confirmNickname) forControlEvents:UIControlEventTouchUpInside];
	[newUserButtonLand addTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
	
	[loginWithDifferentLand setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[loginWithDifferentLand setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateHighlighted];
	[loginWithDifferentLand setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateSelected];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    registrazioneComplete.textAlignment = NSTextAlignmentLeft;
    registrazioneCompleteLand.textAlignment = NSTextAlignmentLeft;
    confirmNickname.textAlignment = NSTextAlignmentLeft;
    confirmNicknameLand.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        registrazioneComplete.textAlignment = NSTextAlignmentLeft;
        registrazioneCompleteLand.textAlignment = NSTextAlignmentLeft;
        confirmNickname.textAlignment = NSTextAlignmentLeft;
        confirmNicknameLand.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        registrazioneComplete.textAlignment = UITextAlignmentLeft;
        registrazioneCompleteLand.textAlignment = UITextAlignmentLeft;
        confirmNickname.textAlignment = UITextAlignmentLeft;
        confirmNicknameLand.textAlignment = UITextAlignmentLeft;
    }
#else
    registrazioneComplete.textAlignment = UITextAlignmentLeft;
    registrazioneCompleteLand.textAlignment = UITextAlignmentLeft;
    confirmNickname.textAlignment = UITextAlignmentLeft;
    confirmNicknameLand.textAlignment = UITextAlignmentLeft;
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    emailTF.text = @"";
    emailTFLand.text = @"";
    
   if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        beintooViewLand.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 320);
    }
    else{
        beintooView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    }

    int appOrientation = [Beintoo appOrientation];
    if(!([BeintooDevice isiPad]) && 
       (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) )
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 365);
    
    else 
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 545);

    scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    
    emailTF.hidden = NO;
    emailTF.placeholder = NSLocalizedStringFromTable(@"signupTextFieldPlaceholder",@"BeintooLocalizable", nil);
	emailTFLand.hidden = NO;
	title1Land.text = NSLocalizedStringFromTable(@"signupMainSentence",@"BeintooLocalizable",@"");
	
    self.navigationItem.hidesBackButton = NO;
    newUserButton.alpha = 1.0;
    newUserButton.userInteractionEnabled = YES;
    
    orLabel.text = NSLocalizedStringFromTable(@"signupOrLabel", @"BeintooLocalizable", nil);
    orLabelLand.text = NSLocalizedStringFromTable(@"signupOrLabel", @"BeintooLocalizable", nil);
    
    emailTF.tag = 10;
    emailTFLand.tag = 10;
    
	nickTF.text = @"";
	nickTF.hidden = YES;
    
    nickTFLand.text = @"";
	nickTFLand.hidden = YES;
	
	loginWithDifferent.hidden = NO;
    loginWithDifferent.userInteractionEnabled = YES;
    [beintooView bringSubviewToFront:loginWithDifferent];
    
    [loginWithDifferent setNeedsLayout];
    
	facebookButton.hidden = NO;
    fbButton.hidden = NO;
    orLabel.hidden = NO;
    
    loginWithDifferentLand.hidden = NO;
	facebookButtonLand.hidden = NO;
    fbButtonLand.hidden = NO;
    orLabelLand.hidden = NO;
    
    scrollView.canCancelContentTouches = YES;
    
    self.navigationItem.hidesBackButton = NO;
	if ([[Beintoo getLastLoggedPlayers] count] < 1 || confirmNickname.alpha == 1.0 || confirmNicknameLand.alpha == 1.0) {
		self.navigationItem.hidesBackButton = YES;
        
        if( !([BeintooDevice isiPad]) && 
           ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
            emailTFLand.alpha = 1.0;
            title1Land.alpha = 1.0;
            orLabelLand.alpha = 1.0;
            registrazioneCompleteLand.alpha = 0.0;
            confirmNicknameLand.alpha = 0.0;
            fbButtonLand.alpha = 1.0;
        }
        else {
            emailTF.alpha = 1.0;
            title1.alpha = 1.0;
            orLabel.alpha = 1.0;
            fbButton.alpha = 1.0;
            registrazioneComplete.alpha = 0.0;
            confirmNickname.alpha = 0.0;
        }
	}
    
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - UIWebView methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView beginAnimations:nil context:nil];
    webView.alpha = 1.0;
    [UIView commitAnimations];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
        if ([emailTFLand tag] == 10)
            [self newUser];
        else if ([emailTFLand tag] == 11)
            [self confirmNickname]; 
    }
    else {
        if ([emailTF tag] == 10)
            [self newUser];
        else if ([emailTF tag] == 11)
            [self confirmNickname];        
    }
    [textField resignFirstResponder];
	return YES;
}

#pragma mark - Keyboard delegate methods

- (void)keyboardWillShow:(NSNotification *)aNotification
{    
    if ([emailTF isFirstResponder] || [emailTFLand isFirstResponder]){
		if (![BeintooDevice isiPad]) {
            [UIView beginAnimations:nil context:nil];
            
            if( !([BeintooDevice isiPad]) && 
               ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
                
                self.view.frame = CGRectMake(self.view.frame.origin.x, - 140, self.view.frame.size.width, self.view.frame.size.height);
            }
            else {
                self.view.frame = CGRectMake(self.view.frame.origin.x, - 210, self.view.frame.size.width, self.view.frame.size.height);
            }
            
            [UIView commitAnimations];
       }
	}
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self moveTextViewForKeyboard:aNotification up:YES];
    
    [UIView commitAnimations];
}

- (void)keyboardDidHide:(NSNotification *)aNotification
{	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [self moveTextViewForKeyboard:aNotification up:NO];
    
    [UIView commitAnimations];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
{
	NSDictionary* userInfo = [aNotification userInfo];
	
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	
    if ([BeintooDevice isiPad] && !(([Beintoo appOrientation] == UIInterfaceOrientationPortrait || 
                                     [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown))){
        
        if (up == YES)
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - self.view.frame.size.height);
        else 
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)dismissKeyboard
{
	if ([emailTF isFirstResponder])
		[emailTF resignFirstResponder];
    else if ([emailTFLand isFirstResponder])
        [emailTFLand resignFirstResponder];
}

- (IBAction)loginWithDifferent
{
	//[self.navigationController pushViewController:alreadyRegisteredSigninVC animated:YES];
    
    BeintooSigninAlreadyVC *alreadyRegisteredSigninVC = [[BeintooSigninAlreadyVC alloc] initWithNibName:@"BeintooSigninAlreadyVC" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:alreadyRegisteredSigninVC animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [alreadyRegisteredSigninVC release];
#endif
    
}

#pragma mark -
#pragma mark newUser Process

- (IBAction)newUser
{	
    if ([emailTFLand isFirstResponder])
        [emailTFLand resignFirstResponder];
    if ([emailTF isFirstResponder])
        [emailTF resignFirstResponder];
    
    if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
	
	NSString *userEmail;
    
    if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) )
        userEmail = emailTFLand.text;
    else 
        userEmail = emailTF.text;
    
	if (![self NSStringIsValidEmail:userEmail]) {
		
		UIAlertView *errorAV = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"loginError",@"BeintooLocalizable",@"") 
														  message:NSLocalizedStringFromTable(@"regEmailErrorMessage",@"BeintooLocalizable",@"") 
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		[errorAV show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [errorAV release];
#endif
		
		return;
	}
    
    if ([Beintoo isUserLogged]){
        [Beintoo playerLogout];
    }
	
    [self generatePlayerIfNotExists];
    
	NSRange range	= [userEmail rangeOfString:@"@"];
	self.nickname	= [userEmail substringToIndex:range.location];
	
    [UIView beginAnimations:nil context:nil];
    if( !([BeintooDevice isiPad]) && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
        newUserButtonLand.alpha = 0.5f;
        newUserButtonLand.userInteractionEnabled = NO;
        fbButtonLand.userInteractionEnabled = NO;
    }
    else {
        newUserButton.alpha = 0.5f;
        newUserButton.userInteractionEnabled = NO;
        fbButton.userInteractionEnabled = NO;
    }
    
    [UIView commitAnimations];
    
    
	[BLoadingView startActivity:self.view];
	[user registerUserToGuid:[Beintoo getPlayerID] withEmail:userEmail nickname:self.nickname password:nil name:nil country:nil address:nil gender:nil sendGreetingsEmail:YES];
}

#pragma mark -
#pragma mark Player-User Delegates

- (void)didCompleteRegistration:(NSDictionary *)result
{    
    if ([result objectForKey:@"message"] != nil) {
        
        [UIView beginAnimations:nil context:nil];
        
        if( !([BeintooDevice isiPad]) && 
           ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
            newUserButtonLand.alpha = 1.0f;
            newUserButtonLand.userInteractionEnabled = YES;
            fbButtonLand.userInteractionEnabled = YES;
        }
        else {
            newUserButton.alpha = 1.0f;
            newUserButton.userInteractionEnabled = YES;
            fbButton.userInteractionEnabled = YES;
        }
        
        [UIView commitAnimations];
        
        [BLoadingView stopActivity];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"useralreadyregistered",@"BeintooLocalizable",@"")  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
    }
    else{
        [self dismissKeyboard];
        NSString *newUserID = [result objectForKey:@"id"];
        
        if (newUserID != nil) {
            [_player login:newUserID];
        }
    }
}

- (void)playerDidLogin:(BeintooPlayer *)player
{	
    [UIView beginAnimations:nil context:nil];
    if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
        newUserButtonLand.alpha = 1.0f;
        newUserButtonLand.userInteractionEnabled = YES;
        fbButtonLand.userInteractionEnabled = YES;
    }
    else {
        newUserButton.alpha = 1.0f;
        newUserButton.userInteractionEnabled = YES;
        fbButton.userInteractionEnabled = YES;
    }
    
    [UIView commitAnimations];
    
	if ([Beintoo getUserID] != nil) {
		[BLoadingView stopActivity];
		[self startNickAnimation];
	}
    else
    {
        [BLoadingView stopActivity];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"useralreadyregistered",@"BeintooLocalizable",@"")  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
    }
}

- (void)confirmNickname
{
    NSString *newNickname;
    if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight)){
        newNickname = [emailTFLand.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [emailTFLand resignFirstResponder];
    }
    else {
        newNickname = [emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [emailTF resignFirstResponder];
    }
	
	[BLoadingView startActivity:self.view];
	[user updateUser:[Beintoo getUserID] withNickname:newNickname];
}

- (void)didCompleteUserNickUpdate:(NSDictionary *)result
{    
    BeintooTutorialVC *beintooTutorialVC = [[BeintooTutorialVC alloc] initWithNibName:@"BeintooTutorialVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:beintooTutorialVC animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [beintooTutorialVC release];
#endif
    
    [Beintoo postNotificationBeintooUserDidSignup];
}

#pragma mark -
#pragma mark emailValidation

- (BOOL)NSStringIsValidEmail:(NSString *)email
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL isValid = [emailTest evaluateWithObject:email];
	
	return isValid;	
}

#pragma mark -
#pragma mark nicknameAnimation

- (void)startNickAnimation
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];

    if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
        [emailTFLand resignFirstResponder];
        emailTFLand.tag = 11;
    }
    else {
        [emailTF resignFirstResponder];
        emailTF.tag = 11;
    }
    
	self.navigationItem.hidesBackButton = YES;
    
	CATransition *signFormAnimation = [CATransition animation];
	[signFormAnimation setDuration:0.3f];
	[signFormAnimation setValue:@"formAnimationStart" forKey:@"name"];
	signFormAnimation.removedOnCompletion = YES;
	[signFormAnimation setType:kCATransitionPush];
	signFormAnimation.subtype = kCATransitionFromRight;
	signFormAnimation.delegate = self;
	[signFormAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
        
        emailTFLand.alpha = 0;
        title1Land.alpha = 0;
        orLabelLand.alpha = 0;
        registrazioneCompleteLand.alpha = 0.0;
        confirmNicknameLand.alpha = 0.0;
        fbButtonLand.alpha = 0.0;
        facebookButtonLand.alpha = 0.0;
        [[emailTF layer] addAnimation:signFormAnimation forKey:nil];
        [[title1 layer] addAnimation:signFormAnimation forKey:nil];
        [[orLabel layer] addAnimation:signFormAnimation forKey:nil];
    }
    else {
        emailTF.alpha = 0;
        title1.alpha = 0;
        orLabel.alpha = 0;
        fbButton.alpha = 0.0;
        registrazioneComplete.alpha = 0.0;
        confirmNickname.alpha = 0.0;
        facebookButton.alpha = 0.0;
        [[emailTF layer] addAnimation:signFormAnimation forKey:nil];
        [[title1 layer] addAnimation:signFormAnimation forKey:nil];
        [[orLabel layer] addAnimation:signFormAnimation forKey:nil];
    }
}

- (void)closeNickAnimation
{    
    CATransition *signFormAnimation = [CATransition animation];
	[signFormAnimation setDuration:0.3f];
	[signFormAnimation setValue:@"formAnimationDisappear" forKey:@"name"];
	signFormAnimation.removedOnCompletion = YES;
	[signFormAnimation setType:kCATransitionPush];
	signFormAnimation.subtype = kCATransitionFromRight;
	signFormAnimation.delegate = self;
	[signFormAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    if( !([BeintooDevice isiPad]) && 
       ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
        
        emailTFLand.alpha = 1;
        title1Land.alpha = 1;
        orLabelLand.alpha = 0;
        [[emailTFLand layer] addAnimation:signFormAnimation forKey:@"Show"];
        [[title1Land layer] addAnimation:signFormAnimation forKey:nil];
        [[orLabelLand layer] addAnimation:signFormAnimation forKey:nil];
        
        emailTFLand.text = self.nickname;
        registrazioneCompleteLand.alpha = 1.0;
        confirmNicknameLand.alpha = 1.0;
        [newUserButtonLand setTitle:NSLocalizedStringFromTable(@"confirmNickBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [newUserButtonLand removeTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
        [newUserButtonLand addTarget:self action:@selector(confirmNickname) forControlEvents:UIControlEventTouchUpInside];
        
        loginWithDifferentLand.alpha = 0;
        facebookButtonLand.alpha = 0;
        fbButtonLand.alpha = 0;
    }
    else {
        emailTF.alpha = 1;
        title1.alpha = 1;
        orLabel.alpha = 0;
        registrazioneComplete.alpha = 1.0;
        confirmNickname.alpha = 1.0;
        [[emailTF layer] addAnimation:signFormAnimation forKey:@"Show"];
        [[title1 layer] addAnimation:signFormAnimation forKey:nil];
        [[orLabel layer] addAnimation:signFormAnimation forKey:nil];
        
        emailTF.text = self.nickname;
        
        [newUserButton setTitle:NSLocalizedStringFromTable(@"confirmNickBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
        [newUserButton removeTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
        [newUserButton addTarget:self action:@selector(confirmNickname) forControlEvents:UIControlEventTouchUpInside];
        
        loginWithDifferent.alpha = 0;
        facebookButton.alpha = 0;
        fbButton.alpha = 0;
    }
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
	if ([[animation valueForKey:@"name"] isEqualToString:@"formAnimationStart"]) {
		[self closeNickAnimation];
	}
}

#pragma mark -
#pragma mark LoginFacebook

- (IBAction)loginFB
{	
	if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
	
	[self generatePlayerIfNotExists];
	
	NSString *loginFBURL;

	if ([Beintoo isOnPrivateSandbox]) {
		loginFBURL = [NSString stringWithFormat:@"http://sandbox.beintoo.com/connect.html?signup=facebook&apikey=%@&guid=%@&display=touch&redirect_uri=http://sandbox.beintoo.com/m/landing_register_ok.html&logged_uri=http://sandbox.beintoo.com/m/landing_logged.html",
					  [Beintoo getApiKey],
					  [Beintoo getPlayerID]];
	}
	else {
		loginFBURL = [NSString stringWithFormat:@"https://www.beintoo.com/connect.html?signup=facebook&apikey=%@&guid=%@&display=touch&redirect_uri=https://www.beintoo.com/m/landing_register_ok.html&logged_uri=https://www.beintoo.com/m/landing_logged.html",
					  [Beintoo getApiKey],
					  [Beintoo getPlayerID]];
	}
	
	
	registrationFBVC = [registrationFBVC initWithNibName:@"BeintooSignupVC" bundle:[NSBundle mainBundle] urlToOpen:loginFBURL];
	[self.navigationController pushViewController:registrationFBVC animated:YES];
}

#pragma mark -
#pragma mark GeneratePlayer

- (void)generatePlayerIfNotExists
{
	if ([Beintoo getPlayerID] == nil) {
		NSDictionary *anonymPlayer = [_player blockingLogin:@""];
		if ([anonymPlayer objectForKey:@"guid"] == nil) {
			// This is a critical point, if the anonymPlayer is == nil, we're going to register an invalid user
			// We prevent this checking if we received a valid guid.
			
			[BeintooNetwork showNoConnectionAlert];
			return;
		}
		else 
			[Beintoo setBeintooPlayer:anonymPlayer];
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
    else
    {
        
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    @try {
        for (UIView *subview in [self.view subviews]){
            if ([subview isKindOfClass:[BLoadingView class]])
                [subview removeFromSuperview];
        }
	}
	@catch (NSException * e) {
	}

	if ([emailTF isFirstResponder]) {
		[emailTF resignFirstResponder];
	}
	
	if ([nickTF isFirstResponder]) {
		[nickTF resignFirstResponder];
	}
    
    if ([emailTFLand isFirstResponder]) {
		[emailTFLand resignFirstResponder];
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[user release];
	[_player release];
	[nickname release];
	//[alreadyRegisteredSigninVC release];
    [webviewLand release];
    [webview release];
    [super dealloc];
}
#endif

@end
