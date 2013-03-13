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

#import "BeintooiPadController.h"
#import "Beintoo.h"

@implementation BeintooiPadController

#ifdef UI_USER_INTERFACE_IDIOM
    @synthesize popoverController,loginPopoverController,vgoodPopoverController, privateSignupPopoverController, privateNotificationsPopoverController, notificationsPopoverController, leaderboardPopoverController, achievementsPopoverController, myOffersPopoverController, adPopoverController;
#endif
@synthesize isLoginOngoing;

- (id)init
{
	if (self = [super init]){
		loginVC = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
		loginNavController = [[BNavigationController alloc] initWithRootViewController:loginVC];
        
        beintooPrivateNotificationController = [BNavigationController alloc];
        notificationVC = [[BeintooNotificationListVC alloc] init];
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark MainPopover-Show-Hide-FromCaller


#ifdef UI_USER_INTERFACE_IDIOM
- (void)showBeintooPopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getMainNavigationController];
    
	if (popoverController != nil) {

#ifdef BEINTOO_ARC_AVAILABLE
        
#else
       [popoverController release];
#endif
		
		popoverController = nil;
	}
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 568)];
	popoverController.delegate = self;
    
    [UIView beginAnimations:nil context:nil];
	self.view.alpha = 1;
    [UIView commitAnimations];

	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideBeintooPopover{

	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}

- (void)showLeaderboardPopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getMainNavigationController];
	if (popoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [popoverController release];
#endif
		
        popoverController = nil;
	}
    
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 568)];
	popoverController.delegate = self;
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideLeaderboardPopover{
    
    self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}

- (void)showAchievementsPopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getMainNavigationController];
	if (popoverController != nil) {

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [popoverController release];
#endif
		
        popoverController = nil;
	}
    
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 568)];
	popoverController.delegate = self;
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideAchievementsPopover
{    
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}

- (void)showMyOffersPopover
{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getMainNavigationController];
	if (popoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [popoverController release];
#endif
        
		popoverController = nil;
	}
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 568)];
	popoverController.delegate = self;
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideMyOffersPopover{
    
    self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}

- (void)showNotificationsPopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getMainNavigationController];
	if (notificationsPopoverController != nil) {

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [popoverController release];
#endif
        
		notificationsPopoverController = nil;
	}
	notificationsPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[notificationsPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	notificationsPopoverController.delegate = self;
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[notificationsPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideNotificationsPopover{
    
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}

- (void)showSignupPopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getSignupNavigationController];
	if (popoverController != nil) {
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [popoverController release];
#endif
        
		popoverController = nil;
	}
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 568)];
	popoverController.delegate = self;
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideSignupPopover{
    
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}

- (void)showBestorePopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooBestoreNavController = [Beintoo getMainNavigationController];
	if (popoverController != nil) {
		
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [popoverController release];
#endif
        
		popoverController = nil;
	}
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooBestoreNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 568)];
	popoverController.delegate = self;
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideBestorePopover{
    
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}
#endif


#pragma mark -
#pragma mark LoginPopover - show-hide-FromCaller

#ifdef UI_USER_INTERFACE_IDIOM
- (void)showLoginPopover
{	
	if (loginPopoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [loginPopoverController release];
#endif
        
		loginPopoverController = nil;
	}
	[loginNavController popToRootViewControllerAnimated:NO];
	loginPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:loginNavController];
	[loginPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	loginPopoverController.delegate = self;
			
	[popoverController dismissPopoverAnimated:NO];
	[loginPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
	isLoginOngoing = YES;
}

- (void)hideLoginPopover
{
	[loginPopoverController dismissPopoverAnimated:NO];
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
	isLoginOngoing = NO;
}
#endif

#pragma mark -
#pragma mark Vgood-Show-Hide-FromCaller

#ifdef UI_USER_INTERFACE_IDIOM
- (void)showVgoodPopoverWithVGoodController:(BNavigationController *)_vgoodNavController
{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
		
	if (vgoodPopoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [vgoodPopoverController release];
#endif
        
		vgoodPopoverController = nil;
	}
	vgoodPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:_vgoodNavController];
	[vgoodPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	vgoodPopoverController.delegate = self;
	
	self.view.alpha = 1;
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadVgoodPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[vgoodPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	
	isVgoodPopoverVisible = YES;
}

- (void)hideVgoodPopover
{
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadVgoodPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isVgoodPopoverVisible= NO;
}

- (void)showAdPopoverWithVGoodController:(BNavigationController *)_vgoodNavController
{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
	if (adPopoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [adPopoverController release];
#endif
        
		adPopoverController = nil;
	}
	adPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:_vgoodNavController];
	[adPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	adPopoverController.delegate = self;
	
	self.view.alpha = 1;
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadAdPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[adPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	
	isVgoodPopoverVisible = YES;
}

- (void)hideAdPopover{
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadAdPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isVgoodPopoverVisible= NO;
}

- (void)showMissionVgoodPopoverWithVGoodController:(BNavigationController *)_vgoodNavController{
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
	if (vgoodPopoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [vgoodPopoverController release];
#endif
		
        vgoodPopoverController = nil;
	}
	vgoodPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:_vgoodNavController];
	[vgoodPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	vgoodPopoverController.delegate = self;
	
	self.view.alpha = 1;
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMissionVgoodPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[vgoodPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	
	isVgoodPopoverVisible = YES;

}
- (void)hideMissionVgoodPopover{
    self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMissionVgoodPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isVgoodPopoverVisible= NO;
}

- (void)showPrivateNotificationsPopover{
    
    if (beintooPrivateNotificationController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [beintooPrivateNotificationController release];
#endif
        
        beintooPrivateNotificationController = nil;
	}
    
    if (notificationVC != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [notificationVC release];
#endif
        
        notificationVC = nil;
    }
    
    beintooPrivateNotificationController = [BNavigationController alloc];
    notificationVC = [[BeintooNotificationListVC alloc] init];
    
	beintooPrivateNotificationController = [beintooPrivateNotificationController initWithRootViewController:notificationVC];
    
    if (privateNotificationsPopoverController != nil) {

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [privateNotificationsPopoverController release];
#endif
        
		privateNotificationsPopoverController = nil;
	}
    
    [beintooPrivateNotificationController popToRootViewControllerAnimated:NO];
	privateNotificationsPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooPrivateNotificationController];
	[privateNotificationsPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	privateNotificationsPopoverController.delegate = self;
    
	[popoverController dismissPopoverAnimated:NO];
    
	[privateNotificationsPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
}

- (void)hidePrivateNotificationsPopover
{
    [privateNotificationsPopoverController dismissPopoverAnimated:NO];
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
}

- (void)showPrivateSignupPopover
{    
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
    BeintooNavigationController *beintooSignupController = [Beintoo getPrivateSignupNavigationController];
    
	if (privateSignupPopoverController != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [privateSignupPopoverController release];
#endif
        
        privateSignupPopoverController = nil;
	}
    
    [beintooSignupController popToRootViewControllerAnimated:NO];
	privateSignupPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooSignupController];
	[privateSignupPopoverController setPopoverContentSize:CGSizeMake(320, 568)];
	privateSignupPopoverController.delegate = self;
    
	[popoverController dismissPopoverAnimated:NO];
    
	self.view.alpha = 1;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadPrivareSignup" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[privateSignupPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
}

- (void)hidePrivateSignupPopover
{    
	[privateSignupPopoverController dismissPopoverAnimated:NO];
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
}

#endif

#pragma mark -
#pragma mark animationFinish

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag{
	// --------------- Main Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadMainPopover"]) {
		[self.view removeFromSuperview];
        [Beintoo beintooDidDisappear];
        
    }
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadMainPopover"]) {
		[Beintoo beintooDidAppear];
	}
	// --------------- Vgood Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadVgoodPopover"]) {
		[self.view removeFromSuperview];
		[Beintoo prizeDidDisappear];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadVgoodPopover"]) {
		[Beintoo prizeDidAppear];
	}
    // --------------- Ad Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadAdPopover"]) {
		[self.view removeFromSuperview];
		[Beintoo adControllerDidDisappear];
        
        [Beintoo setLastGeneratedAd:nil];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadAdPopover"]) {
		[Beintoo adControllerDidAppear];
	}
    // --------------- Mission Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadMissionVgoodPopover"]) {
		[self.view removeFromSuperview];
		[Beintoo beintooDidDisappear];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadMissionVgoodPopover"]) {
	}
}

- (void)preparePopoverOrientation
{	
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		startingRect = CGRectMake(370, 510, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		startingRect = CGRectMake(370, 510, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		startingRect = CGRectMake(380, 450, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		startingRect = CGRectMake(380, 450, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
}

#pragma mark -
#pragma mark PopoverDelegate

#ifdef UI_USER_INTERFACE_IDIOM

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
	// Here we need to call the Beintoo dismiss, with respect to the actual popover. 
	// This will call the main or vgood "hide" method here to remove the iPadController from the window.
	
	/*if (isMainPopoverVisible) {  
		[Beintoo dismissBeintoo];
	}
	if (isVgoodPopoverVisible) {  
		[Beintoo dismissPrize];
	}
	return YES;*/
    
    return NO;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
}

#endif

#pragma mark -

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[loginVC release];
	[loginNavController release];
    [super dealloc];
#endif
    
}

@end
