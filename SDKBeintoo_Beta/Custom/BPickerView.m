//
//  BPickerView.m
//  SampleBeintoo
//
//  Created by Giuseppe Piazzese on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BPickerView.h"
#import "Beintoo.h"
#import "BSendChallengesView.h"

@implementation BPickerView

@synthesize options;

- (id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)_options
{
	if (self = [super init])
	{
        self.frame = frame;
        self.options = _options;
        player  = [[BeintooPlayer alloc] init];
        user    = [[BeintooUser alloc] init];
        player.delegate = self;
        user.delegate = self;
        
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height + 40, self.frame.size.width, 216)];
        pickerView.delegate     = self;
        pickerView.dataSource   = self;
        pickerView.showsSelectionIndicator = YES;
        [self addSubview:pickerView];
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 40)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hide)];
        UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendChallenge)];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexibleSpace, sendButton, nil]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [cancelButton release];
        [flexibleSpace release];
        [sendButton release];
#endif
        
        [self addSubview:toolbar];
        
        self.alpha = 1.0;
        self.backgroundColor = [UIColor clearColor];
        
        contestsDictionary          = [[NSMutableArray alloc] init];
        contestsCodeIDDictionary    = [[NSMutableArray alloc] init];
        selectedContest             = [[NSString alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:BeintooNotificationChallengeSent object:nil];
    }
    return self;
}

- (void)startPickerFilling
{
    [BLoadingView startActivity:self];
    [player showContestList];
}

- (void)sendChallenge
{
    BSendChallengesView *sendChallengeView  = [[BSendChallengesView alloc] initWithFrame:self.frame];
    sendChallengeView.challengeReceiver     = [options objectForKey:@"friendUserID"];
    sendChallengeView.challengeSender       = [Beintoo getUserIfLogged];
    sendChallengeView.selectedContest       = selectedContest;
    
    [sendChallengeView drawSendChallengeView];
    sendChallengeView.tag = BSENDCHALLENGE_VIEW_TAG;
    sendChallengeView.alpha = 0;
    [self addSubview:sendChallengeView];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [sendChallengeView release];
#endif
    
    [UIView beginAnimations:@"sendChallengeOpen" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:0.45];
    sendChallengeView.alpha = 1;
    [UIView commitAnimations];
    /*[user challengeRequestfrom:[Beintoo getUserID] to:[options objectForKey:@"friendUserID"] withAction:@"INVITE" forContest:selectedContest];
    [BLoadingView startActivity:self];*/
}

- (void)show
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDidStopSelector:nil];
    
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    toolbar.frame = CGRectMake(0, self.frame.size.height - 216 - 40, self.frame.size.width, 40);
    pickerView.frame = CGRectMake(0, self.frame.size.height - 216, self.frame.size.width, 216);
    
    [UIView commitAnimations];
}

- (void)hide
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationChallengeSent object:nil];
    
    [UIView beginAnimations:@"disappear_animation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.backgroundColor = [UIColor clearColor];
    toolbar.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 40);
    pickerView.frame = CGRectMake(0, self.frame.size.height + 40, self.frame.size.width, 216);
    
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    if ([animationID isEqualToString:@"disappear_animation"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationCloseBPickerView object:self];
    }
}

#pragma mark AppDelegate

- (void)appDidGetContestsForApp:(NSArray *)result
{	
    NSArray *contests = result;
	
	NSString *defaultName = [[NSString alloc] init];
	
    for (int i = 0; i < [contests count]; i++) {
		@try {
			if ([[[contests objectAtIndex:i] objectForKey:@"isPublic"] boolValue] == 1) {
				defaultName = [[contests objectAtIndex:i] objectForKey:@"name"];
				[contestsDictionary addObject:defaultName];
				[contestsCodeIDDictionary addObject:[[contests objectAtIndex:i] objectForKey:@"codeID"]];
			}
		}
		@catch (NSException * e) {
			BeintooLOG(@"Exception in BCustomPickerView: %@", e);
		}
	}
    
	[BLoadingView stopActivity];
	[pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    [self show];
}

- (void)challengeRequestFinishedWithResult:(NSDictionary *)result
{    
    [BLoadingView stopActivity];
    
    if ([result objectForKey:@"messageID"] != nil) {
		
		if ([[result objectForKey:@"messageID"] intValue] == -15) { // CHALLENGE ONGOING
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeOngoing",@"BeintooLocalizable",@"")
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[av show];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [av release];
#endif
            
			return;
		}
        if([[result objectForKey:@"messageID"] intValue] == -12){ // NOT ENOUGH BEDOLLARS
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"noBedollarsForChall",@"BeintooLocalizable",@"")
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[av show];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [av release];
#endif
            
			return;
        }
        
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"errorMessage",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
		return;
		
	}
	if ([[result objectForKey:@"status"] isEqualToString:@"STARTED"]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeAccepted",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
    else if ([[result objectForKey:@"status"] isEqualToString:@"TO_BE_ACCEPTED"]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeSent",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
		
	}
    else{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeRefused",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self hide];
}

#pragma mark - UIPickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [contestsDictionary count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [contestsDictionary objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedContest = [contestsCodeIDDictionary objectAtIndex:row];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc{
    [user release];
    [player release];
    [contestsDictionary release];
    [contestsCodeIDDictionary release];
    [selectedContest release];
    [pickerView release];
    [toolbar release];
    
    [super dealloc];
}
#endif

@end
