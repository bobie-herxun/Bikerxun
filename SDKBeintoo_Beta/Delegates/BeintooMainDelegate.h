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

@class BVirtualGood;

@protocol BeintooMainDelegate <NSObject>

@optional

- (void)beintooWillAppear;

- (void)beintooDidAppear;

- (void)beintooWillDisappear;

- (void)beintooDidDisappear;

- (void)didBeintooGenerateAVirtualGood:(BVirtualGood *)theVgood __attribute__((deprecated("use 'didBeintooGenerateAReward:' instead")));

- (void)didBeintooFailToGenerateAVirtualGoodWithError:(NSDictionary *)error __attribute__((deprecated("use 'didBeintooFailToGenerateARewardWithError:' instead")));

- (void)didBeintooGenerateAReward:(BVirtualGood *)theReward;

- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error;

/* ---------------------------------------------------------------------
 * Prize
 * --------------------------------------------------------------------- */

- (void)beintooPrizeAlertWillAppear;

- (void)beintooPrizeAlertDidAppear;

- (void)beintooPrizeAlertWillDisappear;

- (void)beintooPrizeAlertDidDisappear;

- (void)beintooPrizeWillAppear;

- (void)beintooPrizeDidAppear;

- (void)beintooPrizeWillDisappear;

- (void)beintooPrizeDidDisappear;

- (void)didBeintooGenerateAnAd:(BVirtualGood *)theAd;

- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error;

/* ---------------------------------------------------------------------
 * Ad
 * --------------------------------------------------------------------- */

- (void)beintooAdWillAppear;

- (void)beintooAdDidAppear;

- (void)beintooAdWillDisappear;

- (void)beintooAdDidDisappear;

- (void)beintooAdControllerWillAppear;

- (void)beintooAdControllerDidAppear;

- (void)beintooAdControllerWillDisappear;

- (void)beintooAdControllerDidDisappear;

/* ---------------------------------------------------------------------
 * User Login/Singup Delegates
 * --------------------------------------------------------------------- */

- (void)beintooUserDidLogin;

- (void)beintooUserDidSignup;

- (void)userDidLogin;

- (void)userDidSignup;

/* ---------------------------------------------------------------------
 * Give Bedollars
 * --------------------------------------------------------------------- */

- (void)beintooGiveBedollarsWillAppear;

- (void)beintooGiveBedollarsDidAppear;

- (void)beintooGiveBedollarsWillDisappear;

- (void)beintooGiveBedollarsDidDisappear;

- (void)beintooGiveBedollarsControllerWillAppear;

- (void)beintooGiveBedollarsControllerDidAppear;

- (void)beintooGiveBedollarsControllerWillDisappear;

- (void)beintooGiveBedollarsControllerDidDisappear;

@end
