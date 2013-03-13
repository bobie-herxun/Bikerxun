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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BeintooDevice.h"

#define PRIZE_GOOD					1
#define PRIZE_RECOMMENDATION		2
#define PRIZE_RECOMMENDATION_HTML	3

#define ALERT_HEIGHT_RECOMMENDATION_HTML	70
#define ALERT_HEIGHT_RECOMMENDATION         50
#define ALERT_HEIGHT_VGOOD                  69
#define RECOMMENDATION_TEXTHEIGHT           25   

#define REWARD  100
#define AD      101

@class BButton,BVirtualGood;

@protocol BeintooPrizeDelegate;

@interface BPrize : UIView <UIWebViewDelegate>{
	
	UIImageView		*prizeThumb;
	UILabel			*textLabel;
	UILabel			*detailedTextLabel;
	UIButton		*closeBtn;
	BOOL			firstTouch;
	
	NSString		*transitionEnterSubtype;
	NSString		*transitionExitSubtype;
	BOOL            isVisible;
	int				prizeType;
	
	id <BeintooPrizeDelegate> delegate;
    id <BeintooPrizeDelegate> globalDelegate;
    
    CGSize windowSizeRect;
    
    UIWebView *recommWebView;
    
}

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooPrizeDelegate> delegate;
@property(nonatomic, retain) id <BeintooPrizeDelegate> globalDelegate;
#else
@property(nonatomic, assign) id <BeintooPrizeDelegate> delegate;
@property(nonatomic, assign) id <BeintooPrizeDelegate> globalDelegate;
#endif

@property(nonatomic,retain) UIImageView *beintooLogo;
@property(nonatomic,retain) UIImageView *prizeThumb;
@property(nonatomic,retain) UIImageView *prizeImg;
@property(nonatomic,retain) UILabel *textLabel;
@property(nonatomic,retain) UILabel *detailedTextLabel;
@property(nonatomic) int prizeType;
@property(nonatomic, assign) BOOL isVisible;
@property(nonatomic) int type;

- (void)setThumbnail:(NSData *)imgData;
- (void)removeViews;
- (void)show;
- (void)showWithAlphaAnimation;
- (void)drawPrize;
- (void)showHtmlWithAlphaAnimation;
- (void)setPrizeContentWithWindowSize:(CGSize)windowSize;
- (void)preparePrizeAlertOrientation:(CGRect)startingFrame;

- (void)userClickedOnWebView;
- (void)userDidFailToClickOnWebView;


@end

@protocol BeintooPrizeDelegate <NSObject>

@optional

- (void)userDidTapOnThePrize;
- (void)userDidTapOnClosePrize;

- (void)userDidTapOnTheAd;
- (void)userDidTapOnCloseAd;

- (void)beintooPrizeWillAppear;
- (void)beintooPrizeDidAppear;    
- (void)beintooPrizeDidDisappear;
- (void)beintooPrizeWillDisappear;

- (void)beintooPrizeAlertWillAppear;
- (void)beintooPrizeAlertDidAppear;    
- (void)beintooPrizeAlertDidDisappear;
- (void)beintooPrizeAlertWillDisappear;

- (void)beintooAdWillAppear;
- (void)beintooAdDidAppear;
- (void)beintooAdDidDisappear;
- (void)beintooAdWillDisappear;

- (void)beintooAdControllerWillAppear;
- (void)beintooAdControllerDidAppear;
- (void)beintooAdControllerDidDisappear;
- (void)beintooAdControllerWillDisappear;

@end

