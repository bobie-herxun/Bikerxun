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

#import "BLoadingView.h"
#import "Beintoo.h"

@implementation BLoadingView

static BLoadingView *loading;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        self.opaque = NO;
	
		hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
		hudView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:0.7];
		hudView.clipsToBounds = YES;
		hudView.layer.cornerRadius = 10.0;
        hudView.autoresizesSubviews = NO;
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.frame = CGRectMake(11, 11, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
		[hudView addSubview:activityIndicatorView];
		[activityIndicatorView startAnimating];
		[self addSubview:hudView];
    }
    return self;
}

+ (void)startActivity:(UIView *)callingView
{	
	loading = [[BLoadingView alloc] initWithFrame:CGRectMake((callingView.frame.size.width/2)-30, (callingView.frame.size.height/2)-30, 100, 100)];
	loading.alpha = 0.0;
    loading.autoresizesSubviews = NO;
	[callingView addSubview:loading];
	
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:0.0];
    loading.alpha = 1.0;
	[UIView commitAnimations];

    
    /*[UIView animateWithDuration:0.5
						  delay: 0.0
						options: UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 loading.alpha = 1.0;
					 }
					 completion:nil];
     */
}

- (id)initWithFrame:(CGRect)frame andCallingView:(UIView *)_view
{
    if (self = [super initWithFrame:frame]) 
    {
        self.opaque = NO;
        
		UIView *hudFullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height)];
		//hudFullView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:0.5];
        hudFullView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
		hudFullView.clipsToBounds = YES;
		hudFullView.layer.cornerRadius = 0.0;
		
		hudView = [[UIView alloc] initWithFrame:CGRectMake((hudFullView.frame.size.width/2) - 30 , (hudFullView.frame.size.height/2) - 30, 60, 60)];
		hudView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:0.7];
		hudView.clipsToBounds = YES;
		hudView.layer.cornerRadius = 10.0;
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.frame = CGRectMake(11, 11, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
		[hudView addSubview:activityIndicatorView];
		[activityIndicatorView startAnimating];
        [hudFullView addSubview:hudView];
		[self addSubview:hudFullView];
        
    }
    return self;
}

- (id)initWithHiddenFrame:(CGRect)frame andCallingView:(UIView *)_view
{
    if (self = [super initWithFrame:frame]) 
    {
        self.opaque = NO;
        
		UIView *hudFullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height)];
		//hudFullView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:0.3];
        hudFullView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
		hudFullView.clipsToBounds = YES;
		hudFullView.layer.cornerRadius = 0.0;
		
		[self addSubview:hudFullView];
        
    }
    return self;
}

+ (void)startFullScreenActivity:(UIView *)callingView
{	
	loading = [[BLoadingView alloc] initWithFrame:CGRectMake(callingView.frame.origin.x, callingView.frame.origin.y, callingView.frame.size.width, callingView.frame.size.height) andCallingView:callingView];
    
	loading.alpha = 0.0;
	[callingView addSubview:loading];
	
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:0.0];
    loading.alpha = 1.0;
	[UIView commitAnimations];
}

+ (void)startFullScreenHiddenActivity:(UIView *)callingView
{	
    loading = [[BLoadingView alloc] initWithHiddenFrame:CGRectMake(callingView.frame.origin.x, callingView.frame.origin.y, callingView.frame.size.width, callingView.frame.size.height) andCallingView:callingView];
    loading.layer.cornerRadius = 0.0;
    [callingView addSubview:loading];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:0.0];
    loading.alpha = 1.0;
	[UIView commitAnimations];
    
}

+ (void)stopActivity{
	if (loading!=nil) {
		[loading setHidden:YES];
        [loading removeFromSuperview];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [loading release];
#endif
		
		loading = nil;
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[hudView release];
	[activityIndicatorView release];
    
	[super dealloc];
}
#endif

@end
