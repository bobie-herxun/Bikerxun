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

#import <UIKit/UIKit.h>
#import "BeintooPlayer.h"
#import "BeintooDevice.h"

#define GIVE_BEDOLLARS      102

extern NSString *clickProtocolOpenBestore;
extern NSString *clickProtocolOpenInternalUrl;
extern NSString *clickProtocolOpenExternUrl;
extern NSString *clickProtocolReloadSelf;
extern NSString *signinProtocol;

@protocol BTemplateGiveBedollarsDelegate;

@class BButton, BVirtualGood;

@interface BTemplateGiveBedollars : UIView <UIWebViewDelegate, BeintooPlayerDelegate>
{
	UIImageView		*prizeThumb;
	UILabel			*textLabel;
	UILabel			*detailedTextLabel;
	UIButton		*closeBtn;
	BOOL			firstTouch;
	
	NSString		*transitionEnterSubtype;
	NSString		*transitionExitSubtype;
	BOOL            isVisible;
	int				prizeType;
	
	id <BTemplateGiveBedollarsDelegate> delegate;
    id <BTemplateGiveBedollarsDelegate> globalDelegate;
    
    CGSize windowSizeRect;
    
    UIWebView *recommWebView;
    
    BOOL isUpForKeyboard;
    
    BeintooPlayer   *beintooPlayer;
}

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BTemplateGiveBedollarsDelegate> delegate;
@property(nonatomic, retain) id <BTemplateGiveBedollarsDelegate> globalDelegate;
#else
@property(nonatomic, assign) id <BTemplateGiveBedollarsDelegate> delegate;
@property(nonatomic, assign) id <BTemplateGiveBedollarsDelegate> globalDelegate;
#endif

@property(nonatomic) int prizeType;
@property(nonatomic, assign) BOOL isVisible;
@property(nonatomic) int type;
@property(nonatomic, retain) BVirtualGood *contentHTML;
@property(nonatomic, assign) int notificationPosition;

- (void)removeViews;
- (void)show;
- (void)showWithAlphaAnimation;
- (void)drawPrize;
- (void)showHtmlWithAlphaAnimation;
- (void)setPrizeContentWithWindowSize:(CGSize)windowSize;
- (void)preparePrizeAlertOrientation:(CGRect)startingFrame;

@end

@protocol BTemplateGiveBedollarsDelegate <NSObject>

@optional

- (void)dismissGiveBedollars;

- (void)beintooGiveBedollarsWillAppear;
- (void)beintooGiveBedollarsDidAppear;
- (void)beintooGiveBedollarsDidDisappear;
- (void)beintooGiveBedollarsWillDisappear;

- (void)beintooGiveBedollarsControllerWillAppear;
- (void)beintooGiveBedollarsControllerDidAppear;
- (void)beintooGiveBedollarsControllerDidDisappear;
- (void)beintooGiveBedollarsControllerWillDisappear;

- (void)launchGiveBedollarsController;

@end

