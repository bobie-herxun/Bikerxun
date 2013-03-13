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

#import "BScore.h"

@implementation BScore

@synthesize bestScore,lastScore,balance,contestName;

- (id)initWithScore:(NSDictionary *)_resultScore andContest:(NSString *)_contestName{
	if (self = [super init]) {
		self.bestScore		= [_resultScore objectForKey:@"bestscore"];
		self.lastScore		= [_resultScore objectForKey:@"lastscore"];
		self.balance		= [_resultScore objectForKey:@"balance"];
		self.contestName	= _contestName;
	}
	return self;
}

- (int)balanceInteger{
	return [self.balance intValue];
}
- (int)lastScoreInteger{
	return [self.lastScore intValue];
}
- (int)bestScoreInteger{
	return [self.bestScore intValue];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
