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

#import "BPrize.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"

@implementation BPrize

@synthesize beintooLogo, prizeImg, prizeThumb, textLabel, detailedTextLabel, delegate, prizeType, isVisible, globalDelegate, type;

- (id)init
{
	if (self = [super init]){
        recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
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
	
	[self setFrame:vgoodFrame];
    [self preparePrizeAlertOrientation:vgoodFrame];
}

- (void)show
{    
	if (type == REWARD){
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.7f];
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
        applicationLoadViewIn.removedOnCompletion = YES;
        [applicationLoadViewIn setType:kCATransitionMoveIn];
        applicationLoadViewIn.subtype = transitionEnterSubtype;
        applicationLoadViewIn.delegate = self;
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	}
	self.alpha = 1;
}

- (void)showWithAlphaAnimation
{   
    if (type == REWARD){
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.8f];
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
        applicationLoadViewIn.removedOnCompletion = YES;
        [applicationLoadViewIn setType:kCATransitionMoveIn];
        applicationLoadViewIn.subtype = kCATransitionFade;
        applicationLoadViewIn.delegate = self;
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    }
    
    self.alpha = 1;
}

- (void)showHtmlWithAlphaAnimation
{    
    if (type == REWARD){
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.7f];
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
        applicationLoadViewIn.removedOnCompletion = YES;
        [applicationLoadViewIn setType:kCATransitionMoveIn];
        applicationLoadViewIn.subtype = kCATransitionFade;
        applicationLoadViewIn.delegate = self;
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    }
    
    self.alpha = 1;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
	}
}

- (void)drawPrize
{    
	BVirtualGood *lastVgood;
    
    if (type == REWARD)
        lastVgood = [Beintoo getLastGeneratedVGood];
    else if (type == AD)
        lastVgood = [Beintoo getLastGeneratedAd];
    
    
    [self removeViews];
	
    recommWebView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight)
        recommWebView.frame = CGRectMake(0, 0, windowSizeRect.height, windowSizeRect.width);
    
    NSString *vgoodUrl = [[lastVgood theGood] objectForKey:@"content"];
    NSString *content = [NSString stringWithFormat:@"%@", vgoodUrl];
    
    recommWebView.delegate = self;
    recommWebView.scalesPageToFit = NO;
    recommWebView.opaque = NO;
    recommWebView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
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
    
    [self addSubview:recommWebView];
    [self sendSubviewToBack:recommWebView];
    
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
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnClosePrize)])
        [[self delegate] userDidTapOnClosePrize];
    
}

- (void)setThumbnail:(NSData *)imgData
{    
    BVirtualGood *lastVgood;
    
    if (type == REWARD)
        lastVgood = [Beintoo getLastGeneratedVGood];
    else if (type == AD)
         lastVgood = [Beintoo getLastGeneratedAd];
    
	if (prizeType == PRIZE_GOOD) {
		self.prizeThumb = [[UIImageView alloc] initWithFrame:CGRectMake(8, ([self bounds].size.height/2 - 54/2), 54, 54)];
		[self.prizeThumb setImage:[UIImage imageWithData:imgData]];
		[self addSubview:self.prizeThumb];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [self.prizeThumb release];	
#endif
		
	}
	if (prizeType == PRIZE_RECOMMENDATION) {
		prizeThumb.alpha = 1;
		self.prizeThumb = [[UIImageView alloc] initWithFrame:CGRectMake(10, ([self bounds].size.height/2 - 50/2), 
                                                                        [self bounds].size.width-20, 
                                                                        50)];
		[self.prizeThumb setImage:[UIImage imageWithData:imgData]];
		[self addSubview:self.prizeThumb];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
      [self.prizeThumb release];
#endif
        
        NSString *rewardText;
        if ([lastVgood.theGood objectForKey:@"rewardText"] != nil) {
            rewardText = [lastVgood.theGood objectForKey:@"rewardText"];
        }
        else{
            rewardText = NSLocalizedStringFromTable(@"vgoodMessageAd", @"BeintooLocalizable",@"Pending");
        }
        UILabel *recommendationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.textLabel.frame.origin.y, self.bounds.size.width-1, RECOMMENDATION_TEXTHEIGHT)];
        recommendationLabel.text            = rewardText;
        recommendationLabel.font            = [UIFont systemFontOfSize:14];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        recommendationLabel.textAlignment   = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            recommendationLabel.textAlignment   = NSTextAlignmentCenter;
        else
            recommendationLabel.textAlignment   = UITextAlignmentCenter;
#else
        recommendationLabel.textAlignment   = UITextAlignmentCenter;
#endif
            
        recommendationLabel.backgroundColor = [UIColor clearColor];
        recommendationLabel.textColor       = [UIColor whiteColor];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [recommendationLabel release];
#endif
        
	}
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

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [self showHtmlWithAlphaAnimation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    NSMutableURLRequest *req    = (NSMutableURLRequest *)request;
    NSString *urlString         = [req.URL absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked  && ([urlString rangeOfString:@"#ios-close"].location != NSNotFound)){
        
        if (type == REWARD){
            if ([[self delegate] respondsToSelector:@selector(userDidTapOnClosePrize)])
                [[self delegate] userDidTapOnClosePrize];
        }
        else if (type == AD){
            if ([[self delegate] respondsToSelector:@selector(userDidTapOnCloseAd)])
                [[self delegate] userDidTapOnCloseAd];
        }
        
        [self userDidFailToClickOnWebView];
        
        return NO;
        
    }
    
    if(navigationType == UIWebViewNavigationTypeOther && ([urlString rangeOfString:@"about:blank"].location != NSNotFound)){
        return YES;
    }
    
    if(type == REWARD && (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)){
        
        [Beintoo getLastGeneratedVGood].getItRealURL = urlString;
            
        [self userClickedOnWebView];
        
        return NO;
    }
    
    if(type == AD && (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)){
        
        [Beintoo getLastGeneratedAd].getItRealURL = urlString;
        [self userClickedOnWebView];
       
        return NO;
    }
    
    return YES;
}

- (void)userClickedOnWebView
{
    [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
    
    if (type == REWARD){
        if ([[self delegate] respondsToSelector:@selector(userDidTapOnThePrize)])
            [[self delegate] userDidTapOnThePrize];
    }
    else if (type == AD){
        if ([[self delegate] respondsToSelector:@selector(userDidTapOnTheAd)])
            [[self delegate] userDidTapOnTheAd];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        [UIView animateWithDuration:0.4
                         animations:^(void){
                             self.alpha  = 0;
                         }
                         completion:^(BOOL finished){
                             firstTouch = YES;
                             self.isVisible = NO;
                             
                             [self removeViews];
                             [self removeFromSuperview];
                             
                             [Beintoo setLastGeneratedAd:nil];
                         }
        ];
    }
    else {
        firstTouch = YES;
        self.isVisible = NO;
        
        [self removeViews];
        [self removeFromSuperview];
        
        [Beintoo setLastGeneratedAd:nil];
    }
}

- (void)userDidFailToClickOnWebView
{
    [recommWebView stopLoading];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        [UIView animateWithDuration:0.4
                         animations:^(void){
                             self.alpha  = 0;
                         }
                         completion:^(BOOL finished){
                             self.isVisible = NO;
                             
                             [self removeViews];
                             [self removeFromSuperview];
                             
                             [Beintoo setLastGeneratedAd:nil];
                         }
         ];
    }
    else {
        self.alpha  = 0;
        self.isVisible = NO;
        
        [self removeViews];
        [self removeFromSuperview];
        
        [Beintoo setLastGeneratedAd:nil];
    }
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
