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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
	EGOOPullRefreshUpToDate,
} EGOPullRefreshState;

@interface BRefreshTableHeaderView : UIView
{	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
	
	EGOPullRefreshState _state;
	UIColor *bottomBorderColor;
	CGFloat bottomBorderThickness;
}

@property(nonatomic,assign) EGOPullRefreshState state;
@property(nonatomic,retain) UIColor *bottomBorderColor;
@property(nonatomic,assign) CGFloat bottomBorderThickness;

- (id)initWithFrameRelativeToFrame:(CGRect)originalFrame;
- (void)setLastRefreshDate:(NSDate*)date;
- (void)setCurrentDate;
- (void)setState:(EGOPullRefreshState)aState;

@end
