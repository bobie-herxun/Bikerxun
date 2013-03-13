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
#import "BeintooMainDelegate.h"

@interface BeintooDelegate : NSObject <BeintooMainDelegate>
{
}

- (void)beintooWillAppear;
- (void)beintooDidAppear;
- (void)beintooWillDisappear;
- (void)beintooDidDisappear;


/* -------------------
 * PRIZE
 * -------------------*/

- (void)beintooPrizeWillAppear;
- (void)beintooPrizeDidAppear;
- (void)beintooPrizeWillDisappear;
- (void)beintooPrizeDidDisappear;

- (void)beintooPrizeAlertWillAppear;
- (void)beintooPrizeAlertDidAppear;
- (void)beintooPrizeAlertWillDisappear;
- (void)beintooPrizeAlertDidDisappear;

- (void)didBeintooGenerateAReward:(BVirtualGood *)theReward;
- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error;

/* -------------------
 * AD
 * -------------------*/

- (void)beintooAdControllerWillAppear;
- (void)beintooAdControllerDidAppear;
- (void)beintooAdControllerWillDisappear;
- (void)beintooAdControllerDidDisappear;

- (void)beintooAdWillAppear;
- (void)beintooAdDidAppear;
- (void)beintooAdWillDisappear;
- (void)beintooAdDidDisappear;

- (void)didBeintooGenerateAnAd:(BVirtualGood *)theAd;
- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error;


@end
