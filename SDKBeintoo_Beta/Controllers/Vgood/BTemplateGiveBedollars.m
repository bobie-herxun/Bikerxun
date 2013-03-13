/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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

#import "BTemplateGiveBedollars.h"
#import "Beintoo.h"

NSString *clickProtocolOpenBestore      = @"#ios-openbestore";
NSString *clickProtocolOpenInternalUrl  = @"#ios-openinternalurl";
NSString *clickProtocolOpenExternUrl    = @"#ios-openexternalurl";
NSString *clickProtocolReloadSelf       = @"#ios-reload";
NSString *signinProtocol                = @"/m/set_app_and_redirect.html";

@implementation BTemplateGiveBedollars

@synthesize delegate, prizeType, isVisible, globalDelegate, type, contentHTML, notificationPosition;

- (id)init
{
	if (self = [super init]){
        recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        // Keyboard notifications
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification object:self.window];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification object:self.window];
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification  object:self.window];
	}
    return self;
}

- (void)setPrizeContentWithWindowSize:(CGSize)windowSize
{
	firstTouch  = YES;
    isVisible   = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 2;
	self.layer.borderColor  = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
	self.layer.borderWidth  = 0;
	self.alpha = 0;
    
    self.frame = CGRectZero;
	
    windowSizeRect = windowSize;
    
	CGRect vgoodFrame = CGRectMake(0, 0, windowSize.width, windowSize.height);
    
    prizeType = PRIZE_RECOMMENDATION_HTML;
	
    beintooPlayer = [[BeintooPlayer alloc] init];
    beintooPlayer.delegate = self;
    
	[self setFrame:vgoodFrame];
    [self preparePrizeAlertOrientation:vgoodFrame];
}

- (void)show
{
	self.alpha = 1;
    
    CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.4f];
	[applicationLoadViewIn setValue:@"load" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionMoveIn];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
}

- (void)hide
{	
    CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.4f];
	[applicationLoadViewIn setValue:@"unload" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionMoveIn];
	applicationLoadViewIn.subtype = transitionExitSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self layer] addAnimation:applicationLoadViewIn forKey:@"Hide"];
}

- (void)showWithAlphaAnimation
{    
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.4f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = kCATransitionFade;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];

    self.alpha = 1;
}

- (void)showHtmlWithAlphaAnimation
{    
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.4f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = kCATransitionFade;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];

    self.alpha = 1;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    
}

- (void)drawPrize
{    
	BVirtualGood *lastVgood;
    
    lastVgood = [Beintoo getLastGeneratedGiveBedollars];
    
    [self removeViews];
	
    recommWebView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight)
        recommWebView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
    
    NSString *vgoodUrl = [[lastVgood theGood] objectForKey:@"content"];
    NSString *content = [NSString stringWithFormat:@"%@", vgoodUrl];
    
    recommWebView.delegate = self;
    recommWebView.scalesPageToFit = NO;
    recommWebView.opaque = NO;
    recommWebView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        recommWebView.scrollView.scrollEnabled = NO;
    else {
        for (UIView *subview in [recommWebView subviews]){
            if ([subview isKindOfClass:[UIScrollView class]]){
                UIScrollView *_scrollSubView = (UIScrollView *)subview;
                _scrollSubView.scrollEnabled = NO;
            }
        }
    }
    
    for(UIView *wview in [[[recommWebView subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]])
            wview.hidden = YES;
    }
    
    [self addSubview:recommWebView];
    [self sendSubviewToBack:recommWebView];
    
    [recommWebView loadHTMLString:content baseURL:nil];
}

- (void)orientationChanged
{    
    BVirtualGood *lastVgood;
    
    lastVgood = [Beintoo getLastGeneratedGiveBedollars];
    
    NSString *vgoodUrl = [[lastVgood theGood] objectForKey:@"content"];
    NSString *content = [NSString stringWithFormat:@"%@", vgoodUrl];
    
    [recommWebView loadHTMLString:content baseURL:nil];
}

- (void)removeViews
{
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)closeBanner
{
	self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    if ([[self delegate] respondsToSelector:@selector(dismissGiveBedollars)])
        [[self delegate] dismissGiveBedollars];
}

- (void)preparePrizeAlertOrientation:(CGRect)startingFrame
{    
    self.alpha = 0;
    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
	}
    else if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
	}
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		self.frame = startingFrame;
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    
    [self drawPrize];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [BLoadingView startActivity:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    if (self.alpha == 0){
        [self setViewSize];
        [self show];
    }
    else
        [self updateView];
    
    [BLoadingView stopActivity];
}

- (void)setViewSize
{
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    else if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    else if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    else if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    
    CGRect frame = recommWebView.frame;
    frame.size.height = 1;
    recommWebView.frame = frame;
    CGSize fittingSize = [recommWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    recommWebView.frame = CGRectMake(0, 0,  frame.size.width, frame.size.height);
    
    float offset = 0;
    float height = 0;
    float width = 0;
    
    int appOrientation = [Beintoo appOrientation];
    
    if (appOrientation == UIInterfaceOrientationPortrait || appOrientation == UIInterfaceOrientationPortraitUpsideDown){
        if (frame.size.height < windowSizeRect.height)
            height = frame.size.height;
        else
            height = windowSizeRect.height;
        
        if (frame.size.width < windowSizeRect.width)
            width = frame.size.width;
        else
            width = windowSizeRect.width;
        
        if (notificationPosition == BeintooNotificationPositionBottom)
            offset = windowSizeRect.height - height;
    }
    else {
        if (frame.size.width < windowSizeRect.width)
            height = frame.size.width;
        else
            height = windowSizeRect.width;
        
        if (frame.size.height < windowSizeRect.height)
            width = frame.size.height;
        else
            width = windowSizeRect.height;
        
        if (notificationPosition == BeintooNotificationPositionBottom)
            offset = windowSizeRect.width - width;
    }
    
    int statusBarOffest = 0;
    if ([Beintoo isStatusBarHiddenOnApp] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO)
        statusBarOffest = 20;
    
    if (appOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
        
        self.frame = CGRectMake(0, 0, fittingSize.height, fittingSize.width);
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowSizeRect.width - width/2, windowSizeRect.height/2) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.center = CGPointMake(width/2, windowSizeRect.height/2);
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
    }
    else if (appOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
        
        self.frame = CGRectMake(0, 0, fittingSize.height, fittingSize.width);
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(width/2, windowSizeRect.height/2);
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowSizeRect.width - width/2, windowSizeRect.height/2);
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
    }
    else if (appOrientation == UIInterfaceOrientationPortrait) {
        
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.frame = CGRectMake(0, windowSizeRect.height - height, width, height);
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.frame = CGRectMake(0, 0, width, height);
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
    }
    else if (appOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.frame = CGRectMake(0, 0, width, height);
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.frame = CGRectMake(0, windowSizeRect.height - height, width, height);
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
    }
}

- (void)updateView
{
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    else if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    else if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    else if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    
    CGRect frame = recommWebView.frame;
    frame.size.height = 1;
    recommWebView.frame = frame;
    CGSize fittingSize = [recommWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    recommWebView.frame = CGRectMake(0, 0,  frame.size.width, frame.size.height);
    
    float offset = 0;
    float height = 0;
    float width = 0;
    
    int appOrientation = [Beintoo appOrientation];
    
    if (appOrientation == UIInterfaceOrientationPortrait || appOrientation == UIInterfaceOrientationPortraitUpsideDown){
        if (frame.size.height < windowSizeRect.height)
            height = frame.size.height;
        else
            height = windowSizeRect.height;
        
        if (frame.size.width < windowSizeRect.width)
            width = frame.size.width;
        else
            width = windowSizeRect.width;
        
        if (notificationPosition == BeintooNotificationPositionBottom)
            offset = windowSizeRect.height - height;
    }
    else {
        if (frame.size.width < windowSizeRect.width)
            height = frame.size.width;
        else
            height = windowSizeRect.width;
        
        if (frame.size.height < windowSizeRect.height)
            width = frame.size.height;
        else
            width = windowSizeRect.height;
        
        if (notificationPosition == BeintooNotificationPositionBottom)
            offset = windowSizeRect.width - width;
    }
    
    int statusBarOffest = 0;
    if ([Beintoo isStatusBarHiddenOnApp] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO)
        statusBarOffest = 20;
    
    if (appOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.frame = CGRectMake(0, 0, fittingSize.height, fittingSize.width);
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowSizeRect.width - width/2, windowSizeRect.height/2) ;
            
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.center = CGPointMake(width/2, windowSizeRect.height/2);
            
        }
    }
    else if (appOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.frame = CGRectMake(0, 0, fittingSize.height, fittingSize.width);
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(width/2, windowSizeRect.height/2);
            
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowSizeRect.width - width/2, windowSizeRect.height/2);
           
        }
    }
    else if (appOrientation == UIInterfaceOrientationPortrait) {
        
         if (notificationPosition == BeintooNotificationPositionBottom) {
            self.frame = CGRectMake(0, windowSizeRect.height - height, width, height);
            
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.frame = CGRectMake(0, 0, width, height);
           
        }
    }
    else if (appOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        if (notificationPosition == BeintooNotificationPositionBottom) {
            self.frame = CGRectMake(0, 0, width, height);
                      
        }
        else if(notificationPosition == BeintooNotificationPositionTop){
            self.frame = CGRectMake(0, windowSizeRect.height - height, width, height);
           
        }
    }
    
    self.clipsToBounds = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    NSMutableURLRequest *req    = (NSMutableURLRequest *)request;
    NSString *urlString         = [req.URL absoluteString];
    
    if ([urlString rangeOfString:@"#ios-close"].location != NSNotFound){
        
        [self closeTemplate];
        
        if ([[self delegate] respondsToSelector:@selector(dismissGiveBedollars)])
            [[self delegate] dismissGiveBedollars];
        
        return NO;
    }
    
    if ([urlString rangeOfString:clickProtocolOpenBestore].location != NSNotFound){
        
        [self closeTemplate];
        
        [Beintoo launchBestore];
        
        return NO;
    }
    
    if ([urlString rangeOfString:clickProtocolOpenExternUrl].location != NSNotFound){
        
        [self closeTemplate];
        
        if ([[self delegate] respondsToSelector:@selector(dismissGiveBedollars)])
            [[self delegate] dismissGiveBedollars];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
        return NO;
    }
    
    if ([urlString rangeOfString:clickProtocolOpenInternalUrl].location != NSNotFound){
        
        [self closeTemplate];
        
        [Beintoo getLastGeneratedGiveBedollars].getItRealURL = urlString;
        
        if ([[self delegate] respondsToSelector:@selector(launchGiveBedollarsController)])
            [[self delegate] launchGiveBedollarsController];
        
        return NO;
    }
    
    if ([urlString rangeOfString:clickProtocolReloadSelf].location != NSNotFound){
        [self updateView];
        
        return YES;
    }
    
    if ([urlString rangeOfString:signinProtocol].location != NSNotFound) {
        
        BeintooUrlParser *urlParser = [[BeintooUrlParser alloc] initWithURLString:urlString];
        
        if ([urlParser valueForVariable:@"guid"])
            [beintooPlayer getPlayerByGUID:[urlParser valueForVariable:@"guid"]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [urlParser release];
#endif
        
        return  NO;
    }
    
    return YES;
}

- (void)closeTemplate
{    
    [recommWebView stopLoading];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        [UIView animateWithDuration:0.7
                         animations:^(void){
                             self.alpha  = 0;
                            // [self hide];
                         }
                         completion:^(BOOL finished){
                             self.isVisible = NO;
                             
                             [self removeViews];
                             [self removeFromSuperview];
                             
                             [Beintoo setLastGeneratedGiveBedollars:nil];
                         }
         ];
    }
    else {
        self.alpha  = 0;
        self.isVisible = NO;
        
        [self removeViews];
        [self removeFromSuperview];
        
        [Beintoo setLastGeneratedGiveBedollars:nil];
    }
}

#pragma mark - Keyboard delegates

- (void)keyboardWillShow:(NSNotification *)notification;
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (self.notificationPosition == BeintooNotificationPositionBottom && !isUpForKeyboard)
    {
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
            
            int offset = kbSize.width;
            
            if ([BeintooDevice isiPad] == NO)
            {
                //float portraitHeight    = [Beintoo getAppWindow].frame.size.height - self.frame.size.height;
                float portraitWidth     = [Beintoo getAppWindow].frame.size.width - self.frame.size.width;
                offset = portraitWidth;
            }
            
            if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)
                offset = - offset;
            else
                offset = + offset;
            
            [UIView animateWithDuration:0.25
                             animations:^(void){
                                self.frame = CGRectMake(self.frame.origin.x + offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 isUpForKeyboard = YES;
                             }
             ];
        }
        else {
            
            int offset = 0;
            
            if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait)
                offset = + kbSize.height;
            else
                offset = - kbSize.height;
            
            [UIView animateWithDuration:0.25
                             animations:^(void){
                                 self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - offset, self.frame.size.width, self.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                  isUpForKeyboard = YES;
                             }
             ];
            
        }
    }
}

- (void)keyboardDidShow:(NSNotification *)notification;
{
}

- (void)keyboardWillHide:(NSNotification *)notification;
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (self.notificationPosition == BeintooNotificationPositionBottom && isUpForKeyboard)
    {
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
            
            int offset = kbSize.width;
            
            if ([BeintooDevice isiPad] == NO)
            {
                //float portraitHeight    = [Beintoo getAppWindow].frame.size.height - self.frame.size.height;
                float portraitWidth     = [Beintoo getAppWindow].frame.size.width - self.frame.size.width;
                offset = portraitWidth;
            }
            
            if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)
                offset = - offset;
            else
                offset = + offset;
                 
            [UIView animateWithDuration:0.25
                             animations:^(void){
                                 self.frame = CGRectMake(self.frame.origin.x - offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 isUpForKeyboard = NO;
                             }
             ];
        }
        else {
            
            int offset = 0;
            
            if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait)
                offset = + kbSize.height;
            else
                offset = - kbSize.height;
            
            [UIView animateWithDuration:0.25
                             animations:^(void){
                                 self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + offset, self.frame.size.width, self.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 isUpForKeyboard = NO;
                             }
             ];
        }
    }
}

#pragma mark - Beintoo Player

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

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [beintooPlayer release];
    
    [super dealloc];
#endif
    
}

@end