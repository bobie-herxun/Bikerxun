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


#import "BRefreshTableHeaderView.h"
#import "Beintoo.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:160.0/255.0 green:173.0/255.0 blue:182.0/255.0 alpha:1.0]


@implementation BRefreshTableHeaderView

@synthesize state=_state;
@synthesize bottomBorderThickness;
@synthesize bottomBorderColor;

static NSDateFormatter *refreshFormatter;


+ (void)initialize
{
  /* Formatter for last refresh date */
  refreshFormatter = [[NSDateFormatter alloc] init];
  [refreshFormatter setDateStyle:NSDateFormatterShortStyle];
  [refreshFormatter setTimeStyle:NSDateFormatterShortStyle];
}


// Sets up the frame following the recipe in the samples except it doesn't *overlap* the partner view,
// ensuring that if you choose to draw a bottom border (by setting bottomBorderThickness > 0.0) then
// you'll get a proper border, not a partially obscured one.
- (id)initWithFrameRelativeToFrame:(CGRect)originalFrame
{
	CGRect relativeFrame = CGRectMake(0.0f, 0.0f - originalFrame.size.height, originalFrame.size.width, originalFrame.size.height);
	[self setBottomBorderThickness:1.0f];
	return [self initWithFrame:relativeFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        else
            lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
#else
        lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
#endif
        
        [self addSubview:lastUpdatedLabel];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [lastUpdatedLabel release];
#endif


//		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"]) {
//			lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
//		} else {
//			[self setCurrentDate];
//		}
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        statusLabel.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            statusLabel.textAlignment = NSTextAlignmentCenter;
        else
            statusLabel.textAlignment = UITextAlignmentCenter;
#else
        statusLabel.textAlignment = UITextAlignmentCenter;
#endif
        
        [self setState:EGOOPullRefreshNormal];
		[self addSubview:statusLabel];
        
		arrowImage = [[CALayer alloc] init];
		arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		arrowImage.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		[[self layer] addSublayer:arrowImage];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [arrowImage release];
        [activityView release];
        [statusLabel release];
#endif
		
    }
    return self;
}

// Will only draw a bottom border if you've set bottomBorderThickness to be > 0.0
// and makes sure that the stroke is correctly centered so you get a border as thick
// as you've asked for.
- (void)drawRect:(CGRect)rect
{
	if ([self bottomBorderThickness] == 0.0f) return;
	CGFloat strokeOffset = [self bottomBorderThickness] / 2.0f;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context,  kCGPathFillStroke);
	UIColor *strokeColor = ([self bottomBorderColor]) ? [self bottomBorderColor] : BORDER_COLOR;
	[strokeColor setStroke];
	CGContextSetLineWidth(context, [self bottomBorderThickness]);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - strokeOffset);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - strokeOffset);
	CGContextStrokePath(context);
}

- (void)setLastRefreshDate:(NSDate*)date
{
  if (!date) {
    [lastUpdatedLabel setText:NSLocalizedStringFromTable(@"neverUpdated", @"BeintooLocalizable", nil)];
    return;
  }
  
	lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"lastUpdate", @"BeintooLocalizable", nil), [refreshFormatter stringFromDate:date]];
}

- (void)setCurrentDate
{
	lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"lastUpdate", @"BeintooLocalizable", nil), [refreshFormatter stringFromDate:[NSDate date]]];
//	[[NSUserDefaults standardUserDefaults] setObject:lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setState:(EGOPullRefreshState)aState
{	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			statusLabel.text = NSLocalizedStringFromTable(@"releaseToRefresh", @"BeintooLocalizable", nil); 
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:.18];
				arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			statusLabel.text =  NSLocalizedStringFromTable(@"pullDownToRefresh", @"BeintooLocalizable", nil); 
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = NO;
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshLoading:
			
			statusLabel.text = NSLocalizedStringFromTable(@"loading", @"BeintooLocalizable", nil); 
			[activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshUpToDate:
        
			statusLabel.text = NSLocalizedStringFromTable(@"upToDate", @"BeintooLocalizable", nil); 
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc
{
	[bottomBorderColor release], bottomBorderColor = nil;
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
    [super dealloc];
}
#endif

@end
