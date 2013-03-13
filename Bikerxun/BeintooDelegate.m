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

#import "BeintooDelegate.h"
#import "Beintoo.h"

@implementation BeintooDelegate

/* -----------------------------------------
 * BeintooPanel
 * ----------------------------------------- */

- (void)beintooWillAppear{
	BeintooLOG(@"Beintoo will appear!");
}

- (void)beintooDidAppear{
	BeintooLOG(@"Beintoo did appear!");
}

- (void)beintooWillDisappear{
	BeintooLOG(@"Beintoo will disappear!");
}

- (void)beintooDidDisappear{
	BeintooLOG(@"Beintoo did disappear!");
}

/* -----------------------------
 * Beintoo Reward
 * ----------------------------- */

- (void)didBeintooGenerateAReward:(BVirtualGood *)theReward
{
    BeintooLOG(@"Reward generated: %@", [theReward theGood]);
}

- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error
{
    BeintooLOG(@"Vgood generation error: %@", error);
}

/*
 * Reward Notifications
 */

- (void)beintooPrizeWillAppear{
	BeintooLOG(@"Prize will appear!");
}

- (void)beintooPrizeDidAppear{
	BeintooLOG(@"Prize did appear!");
}

- (void)beintooPrizeWillDisappear{
	BeintooLOG(@"Prize will disappear!");
}

- (void)beintooPrizeDidDisappear{
	BeintooLOG(@"Prize did disappear!");
}

- (void)beintooPrizeAlertWillAppear{
	BeintooLOG(@"alert will appear");
}

- (void)beintooPrizeAlertDidAppear{
	BeintooLOG(@"alert did appear");
}

- (void)beintooPrizeAlertWillDisappear{
	BeintooLOG(@"alert will disappear");

}
- (void)beintooPrizeAlertDidDisappear{
	BeintooLOG(@"alert did disappear");
}

/*
 * Ad Notifications
 */

- (void)beintooAdWillAppear{
	BeintooLOG(@"Ad will appear!");
}

- (void)beintooAdDidAppear{
	BeintooLOG(@"Ad did appear!");
}

- (void)beintooAdDidDisappear{
	BeintooLOG(@"Ad did disappear!");
}

- (void)beintooAdWillDisappear{
	BeintooLOG(@"Ad will disappear!");
}

- (void)beintooAdControllerWillAppear{
	BeintooLOG(@"Ad Controller will appear!");
}

- (void)beintooAdControllerDidAppear;{
	BeintooLOG(@"Ad Controller did appear!");
}

- (void)beintooAdControllerDidDisappear{
	BeintooLOG(@"Ad Controller did disappear!");
}

- (void)beintooAdControllerWillDisappear{
	BeintooLOG(@"Ad Controller will disappear!");
}

- (void)didBeintooGenerateAnAd:(BVirtualGood *)theAd{
    BeintooLOG(@"New Ad has been generated!");
}

- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error{
    BeintooLOG(@"Failed while generating a new Ad!");
}

/*
 * Give Bedollars Notifications
 */

- (void)beintooGiveBedollarsWillAppear{
	BeintooLOG(@"Give Bedollars will appear!");
}

- (void)beintooGiveBedollarsDidAppear{
	BeintooLOG(@"Give Bedollars did appear!");
}

- (void)beintooGiveBedollarsWillDisappear{
	BeintooLOG(@"Give Bedollars will disappear!");
}

- (void)beintooGiveBedollarsDidDisappear{
	BeintooLOG(@"Give Bedollars did disappear!");
}

- (void)beintooGiveBedollarsControllerWillAppear{
	BeintooLOG(@"Give Bedollars Controller will appear");
}

- (void)beintooGiveBedollarsControllerDidAppear{
	BeintooLOG(@"Give Bedollars Controller did appear");
}

- (void)beintooGiveBedollarsControllerWillDisappear{
	BeintooLOG(@"Give Bedollars Controller will disappear");
    
}
- (void)beintooGiveBedollarsControllerDidDisappear{
	BeintooLOG(@"Give Bedollars Controller did disappear");
}

/* ---------------------------
 * Beintoo Mission
 * --------------------------- */

- (void)didBeintooGetAMission:(NSDictionary *)theMission{
    BeintooLOG(@"Beintoo mission %@",theMission);
    
}
- (void)didBeintooFailToGetAMission:(NSDictionary *)error{
    BeintooLOG(@"Beintoo mission generation error %@",error);    
}

@end
