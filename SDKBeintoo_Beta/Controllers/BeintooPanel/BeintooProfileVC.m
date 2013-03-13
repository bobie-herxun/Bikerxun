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


#import "BeintooProfileVC.h"
#import "Beintoo.h"
#import "BSignupLayouts.h"

@implementation BeintooProfileVC

@synthesize sectionScores, allScores, allContests, allScoresForContest, arrayWithScoresForAllContests, startingOptions, isFromNotification, isFromDirectLaunch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeBPickerViewFromSuperView:)
                                                     name:BeintooNotificationCloseBPickerView
                                                   object:nil];
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isAFriendProfile = NO;
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"friendsProfile"]) {
		isAFriendProfile = YES;
	}		 
		
	self.title = NSLocalizedStringFromTable(@"profile", @"BeintooLocalizable", @"Profile");
	
    loginVC                 = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    
    UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	loginNavController      = [[BNavigationController alloc] initWithRootViewController:loginVC];
	[[loginNavController navigationBar] setTintColor:barColor];	

	levelTitle.text		= NSLocalizedStringFromTable(@"level",@"BeintooLocalizable",@"UserLevel");
	noScoreLabel.text	= NSLocalizedStringFromTable(@"noscoreLabel",@"BeintooLocalizable",@"You don't have any points on this app.");
	
	friendsToolbarLabel.text	= NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"");
	messagesToolbarLabel.text	= NSLocalizedStringFromTable(@"messages",@"BeintooLocalizable",@"");
	balanceToolbarLabel.text	= NSLocalizedStringFromTable(@"balance",@"BeintooLocalizable",@"");
    alliancesLabel.text         = NSLocalizedStringFromTable(@"alliances",@"BeintooLocalizable",@"");
    alliancekey.text            = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTable(@"alliance",@"BeintooLocalizable",@"")];
    allianceValue.text          = NSLocalizedStringFromTable(@"noAlliances", @"BeintooLocalizable", nil);

    if ([BeintooAlliance userHasAlliance])
        if ([BeintooAlliance userAllianceName] != nil)
            allianceValue.text = [BeintooAlliance userAllianceName];
    
	[profileView setTopHeight:108.0];
	[profileView setBodyHeight:[UIScreen mainScreen].bounds.size.height];
	[profileView setIsScrollView:YES];

	scrollView.contentSize          = CGSizeMake(self.view.bounds.size.width, 450);
	scrollView.backgroundColor      = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];

	scoresTable.delegate		= self;
	scoresTable.rowHeight		= 25.0;
	
    [toolBar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
    
	messagesVC          = [BeintooMessagesVC alloc];
	newMessageVC        = [BeintooNewMessageVC alloc];
	balanceVC           = [BeintooBalanceVC alloc];
	friendActionsVC     = [[BeintooFriendActionsVC alloc] initWithNibName:@"BeintooFriendActionsVC" bundle:[NSBundle mainBundle] andOptions:nil];
    alliancesActionVC   = [[BeintooAllianceActionsVC alloc] initWithNibName:@"BeintooAllianceActionsVC" bundle:[NSBundle mainBundle] andOptions:nil];
	
	listOfContests				= [[NSMutableArray alloc] init];
	self.allScores				= [[NSDictionary alloc] init];
	self.allContests			= [[NSMutableArray alloc] init];
	self.allScoresForContest	= [[NSMutableArray alloc] init];
	feedNameLists				= [[NSMutableArray alloc] init];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];

#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
	self.sectionScores	 = [[NSMutableArray alloc] init];
	
	_player				= [[BeintooPlayer alloc] init];
	_user				= [[BeintooUser alloc] init];
    _alliance           = [[BeintooAlliance alloc] init];
	
	// Toolbar
	[toolbarView setGradientType:GRADIENT_TOOLBAR];
    
    settingsLabel.text = NSLocalizedStringFromTable(@"settingsLabel", @"BeintooLocalizable", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    _player.delegate	= self;
	_user.delegate		= self;

    unreadMessagesLabel.frame = CGRectMake(messagesToolbarLabel.frame.origin.x + messagesToolbarLabel.frame.size.width - 15, unreadMessagesLabel.frame.origin.y, unreadMessagesLabel.frame.size.width, unreadMessagesLabel.frame.size.height);
    
    profileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        profileView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 450);
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.height, 320 - 32);
        
    }
    else{
        profileView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, [UIScreen mainScreen].bounds.size.height);
        
    }
    profileView.clipsToBounds = YES;  
    
    userImg.contentMode = UIViewContentModeScaleAspectFit;
    userImg.image       = nil;
    isAlreadyLogging    = NO;
    
    unreadMessagesLabel.text	= [NSString stringWithFormat:@"%d", [BeintooMessage unreadMessagesCount]];
    [unreadMessagesLabel setHidden:YES];
    
    [noScoreLabel setHidden:YES];
    
    if(![Beintoo isUserLogged]){
        
        noScoreLabel.text	= NSLocalizedStringFromTable(@"noscoreLabel",@"BeintooLocalizable",@"You don't have any points on this app.");
        
        [toolbarView setHidden:NO];
        toolBar.hidden = YES;
        
        [nickname setHidden:YES];
        [level setHidden:YES];
        [beDollars setHidden:YES];
        [levelTitle setHidden:YES];
        [bedollarsTitle setHidden:YES];
        [alliancekey setHidden:YES];
        [allianceValue setHidden:YES];
                        
        if (signupViewForPlayers != nil) {
            signupViewForPlayers = nil;
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [signupViewForPlayers release];
#endif
            
        }
        [[self.view viewWithTag:1111] removeFromSuperview];
        
#ifdef BEINTOO_ARC_AVAILABLE
        signupViewForPlayers = [BSignupLayouts getBeintooSignupViewForProfileWithFrame:CGRectMake(100, 10 , 220, 90) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
        signupViewForPlayers = [[BSignupLayouts getBeintooSignupViewForProfileWithFrame:CGRectMake(100, 10 , 220, 90) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
         signupViewForPlayers.tag = 1111;
        [self.view addSubview:signupViewForPlayers];
        
        [BLoadingView startActivity:self.view];
        [_player getAllScores];

    }
    else if (isAFriendProfile) {
        
        noScoreLabel.text	= NSLocalizedStringFromTable(@"noscoreLabelOtherUser",@"BeintooLocalizable",@"You don't have any points on this app.");
        
        toolBar.hidden = NO;
        [toolbarView setHidden:YES];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 0;
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        /* 
         ** can be unfriend or addAsAFrined
         */
        
        UIBarButtonItem *friendTypeRequest;
        
        if ([Beintoo isAFriendOfMine:[self.startingOptions objectForKey:@"friendUserID"]]){
            friendTypeRequest = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_friend.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(sendUnfriendRequest)];
        }
        else {
            friendTypeRequest = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_friend.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(sendFriendRequest)];
        }
        
        UIBarButtonItem *addToAllianceButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_alliance.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(addToAlliance)];
        
        UIBarButtonItem *sendMessageButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(sendMessage)];
        
        UIBarButtonItem *sendChallenge = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"challenge.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(sendNewChallenge)];
        
        BOOL addChallenges = FALSE;
        NSArray *features = [Beintoo getFeatureList];
        for (NSString *feature in features){
            if ([feature isEqualToString:BFEATURE_CHALLENGES]){
                addChallenges = TRUE;
                break;
            }
        }
        
        if ([BeintooAlliance userIsAllianceAdmin]){
            if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown){
                
                int total_width = 280;
                int single_width = 0;
                if (addChallenges == TRUE)
                    single_width  = total_width / 4;
                else
                    single_width  = total_width / 3;
                    
                friendTypeRequest.width = single_width;
                addToAllianceButtonItem.width = single_width;
                sendMessageButtonItem.width = single_width;
                sendChallenge.width = single_width;
            }
            else {
                
                int total_width = 440;
                int single_width = 0;
                if (addChallenges == TRUE)
                    single_width  = total_width / 4;
                else
                    single_width  = total_width / 3;
                
                friendTypeRequest.width = single_width;
                addToAllianceButtonItem.width = single_width;
                sendMessageButtonItem.width = single_width;
                sendChallenge.width = single_width;
            }
            
            if (addChallenges == TRUE)
                [toolBar setItems:[NSArray arrayWithObjects: fixedSpace, sendMessageButtonItem, flexibleSpace, sendChallenge, flexibleSpace, addToAllianceButtonItem, flexibleSpace, friendTypeRequest,  fixedSpace, nil]];
            else
                [toolBar setItems:[NSArray arrayWithObjects: fixedSpace, sendMessageButtonItem, flexibleSpace, addToAllianceButtonItem, flexibleSpace, friendTypeRequest,  fixedSpace, nil]];
        }
        else {
            if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown){
                
                int total_width = 280;
                int single_width = 0;
                if (addChallenges == TRUE)
                    single_width  = total_width / 3;
                else
                    single_width  = total_width / 2;
                
                friendTypeRequest.width = single_width;
                addToAllianceButtonItem.width = single_width;
                sendMessageButtonItem.width = single_width;
                sendChallenge.width = single_width;
            }
            else {
                
                int total_width = 440;
                int single_width = 0;
                if (addChallenges == TRUE)
                    single_width  = total_width / 3;
                else
                    single_width  = total_width / 2;
                
                friendTypeRequest.width = single_width;
                addToAllianceButtonItem.width = single_width;
                sendMessageButtonItem.width = single_width;
                sendChallenge.width = single_width;
            }
            
            if (addChallenges == TRUE)
                [toolBar setItems:[NSArray arrayWithObjects: fixedSpace, sendMessageButtonItem, flexibleSpace, sendChallenge, flexibleSpace, friendTypeRequest, fixedSpace, nil]];
            else
                [toolBar setItems:[NSArray arrayWithObjects: fixedSpace, sendMessageButtonItem, flexibleSpace, friendTypeRequest, fixedSpace, nil]];
        }
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [addToAllianceButtonItem release];
        [friendTypeRequest release];
        [sendMessageButtonItem release];
        [sendChallenge release];
        [flexibleSpace release];
        [fixedSpace release];
#endif
        
        [alliancekey setHidden:YES];
        [allianceValue setHidden:YES];
        [nickname setHidden:NO];
        [level setHidden:NO];
        [beDollars setHidden:NO];
        [levelTitle setHidden:NO];
        [bedollarsTitle setHidden:NO];
        
        scoresTable.center = CGPointMake(scoresTable.center.x, scoresTable.center.y - 56);
        scoresTable.frame = CGRectMake(scoresTable.frame.origin.x, scoresTable.frame.origin.y, scoresTable.frame.size.width, scoresTable.frame.size.height + 56);
        
        [BLoadingView startActivity:profileView];
        [_player getPlayerByUserID:[self.startingOptions objectForKey:@"friendUserID"]];
    }
    else { // user profile
        
        noScoreLabel.text	= NSLocalizedStringFromTable(@"noscoreLabel",@"BeintooLocalizable",@"You don't have any points on this app.");
        
        toolBar.hidden = NO;
        [toolbarView setHidden:NO];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 0;
        
        UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"logoutBtn", @"BeintooLocalizable",@"") style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
        
        if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)
            logoutButtonItem.width = 145;
        else 
            logoutButtonItem.width = 222.5;
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *removeButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"detach",@"BeintooLocalizable",@"Detach from device") style:UIBarButtonItemStyleBordered target:self action:@selector(detachUserFromDevice)];
        
        if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)
            removeButtonItem.width = 145;
        else 
            removeButtonItem.width = 222.5;
        
        [toolBar setItems:[NSArray arrayWithObjects:fixedSpace, logoutButtonItem, flexibleSpace, removeButtonItem, fixedSpace, nil]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [logoutButtonItem release];
        [removeButtonItem release];
        [fixedSpace release];
        [flexibleSpace release];
#endif
        
        [alliancekey setHidden:NO];
        [allianceValue setHidden:NO];
        [nickname setHidden:NO];
        [level setHidden:NO];
        [beDollars setHidden:NO];
        [levelTitle setHidden:NO];
        [bedollarsTitle setHidden:NO];
        
        [BLoadingView startActivity:profileView];
        [_player getAllScores];
        
        if ([BeintooMessage unreadMessagesCount] > 0) {
            [unreadMessagesLabel setHidden:NO];
        }
    }
}

#pragma mark - SendChalllenge methods

- (IBAction)sendNewChallenge
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [self.startingOptions objectForKey:@"friendUserID"], @"friendUserID",
                             [self.startingOptions objectForKey:@"friendNickname"], @"friendNickname",
                             nil];
    
    bPickerView = [[BPickerView alloc] initWithFrame:self.view.frame andOptions:options];
    [self.view addSubview:bPickerView];
    
    [bPickerView startPickerFilling];
}

- (void)removeBPickerViewFromSuperView:(NSNotification *)note
{
    [bPickerView removeFromSuperview];
}
										
#pragma mark - Beintoo Delegates

- (void)player:(BeintooPlayer *)player didGetAllScores:(NSDictionary *)result
{	
    self.allScores = result;
    
	if (self.allScores == nil) {
		[noScoreLabel setHidden:NO];
	}
	
	@try {
		NSDictionary *currentUser = [Beintoo getUserIfLogged];
        
#ifdef BEINTOO_ARC_AVAILABLE
        BImageDownload *download = [[BImageDownload alloc] init];
#else
        BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
    
        download.delegate = self;
        if (!currentUser) {
            
            download.urlString = @"beintoo_profile.png";
            /*userImg.contentMode = UIViewContentModeCenter;
            userImg.image       = [UIImage imageNamed:@"beintoo_profile.png"];*/
        }
        else{
            /*NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUser objectForKey:@"userimg"]]];
            [userImg setImage:[UIImage imageWithData:imgData]];*/
            
            download.urlString = [currentUser objectForKey:@"userimg"];
        }
        
        userImg.image = download.image;
        
		nickname.text  = [currentUser objectForKey:@"nickname"];
		level.text	   = [self translateLevel:[currentUser objectForKey:@"level"]];
		beDollars.text = [NSString stringWithFormat:@"%.2f", [[currentUser objectForKey:@"bedollars"]floatValue]];
		
		[self.allContests removeAllObjects];
		[self.allScoresForContest removeAllObjects];
		
		for (id theKey in allScores)
        {
			NSDictionary *contestValues = [[allScores objectForKey:theKey]objectForKey:@"contest"];
			if ( ([[contestValues objectForKey:@"isPublic"] intValue] == 1) || ([[contestValues objectForKey:@"codeID"] isEqualToString:@"default"]) ) {
				[self.allContests addObject:theKey];
			}
		}
	}
	@catch (NSException * e) {
	}
	
	for (int i = 0; i < [self.allContests count]; i++) {
		@try {
			NSMutableArray *scores = [[NSMutableArray alloc]init];
			NSString *totalScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"balance"];
			NSString *bestScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"bestscore"];
			NSString *lastScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"lastscore"];
			
			[scores addObject:totalScore];
			[scores addObject:bestScore];
			[scores addObject:lastScore];
			
            [self.allScoresForContest addObject:scores];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [scores release];
#endif
			
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException: %@ \n for object: %@",e,[self.allContests objectAtIndex:i]);
		}
	}
    
	[scoresTable reloadData];
	[BLoadingView stopActivity];
}

- (void)didgetPlayerByUser:(NSDictionary *)result
{
	@try {
		
		self.allScores = [result objectForKey:@"playerScore"];
		
		if (self.allScores == nil) {
			[noScoreLabel setHidden:NO];
		}
		
		NSDictionary *currentUser = [result objectForKey:@"user"];	
		/*NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUser objectForKey:@"userimg"]]];
		[userImg setImage:[UIImage imageWithData:imgData]];*/
        
#ifdef BEINTOO_ARC_AVAILABLE
        BImageDownload *download = [[BImageDownload alloc] init];
#else
        BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
        
        download.delegate = self;
        download.urlString = [currentUser objectForKey:@"userimg"];
        userImg.image = download.image;

		nickname.text  = [currentUser objectForKey:@"nickname"];
		level.text	   = [self translateLevel:[currentUser objectForKey:@"level"]];
		beDollars.text = [NSString stringWithFormat:@"%.2f",[[currentUser objectForKey:@"bedollars"]floatValue]];
		
		[self.allContests removeAllObjects];
		[self.allScoresForContest removeAllObjects];
		
		for (id theKey in allScores) {
			NSDictionary *contestValues = [[allScores objectForKey:theKey]objectForKey:@"contest"];
			if ( ([[contestValues objectForKey:@"isPublic"] intValue]==1) || ([[contestValues objectForKey:@"codeID"] isEqualToString:@"default"]) ) {
				[self.allContests addObject:theKey];
			}
		}
	}
	@catch (NSException * e) {
		BeintooLOG(@"BeintooException - Profile: %@",e);
	}
	
	for (int i = 0; i < [self.allContests count]; i++) {
		@try {
			NSMutableArray *scores = [[NSMutableArray alloc]init];
			NSString *totalScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"balance"];
			NSString *bestScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"bestscore"];
			NSString *lastScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"lastscore"];
			
			[scores addObject:totalScore];
			[scores addObject:bestScore];
			[scores addObject:lastScore];
			
			[self.allScoresForContest addObject:scores];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [scores release];
#endif
        
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException - Profile: %@ \n for object: %@",e,[self.allContests objectAtIndex:i]);
		}
	}
	
    [scoresTable reloadData];
	[BLoadingView stopActivity];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)logout
{
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"logout",@"BeintooLocalizable",@"Are you sure?") 
													   delegate:self 
											  cancelButtonTitle:nil 
										 destructiveButtonTitle:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@"")
											  otherButtonTitles:@"No", nil ];
	
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
	popup.tag = POPUP_LOGOUT;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [popup release];
#endif
	
}

- (IBAction)detachUserFromDevice
{
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"detachFromDevice",@"BeintooLocalizable",@"Are you sure?") 
													   delegate:self 
											  cancelButtonTitle:nil 
										 destructiveButtonTitle:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@"")
											  otherButtonTitles:@"No", nil ];
	
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
	popup.tag = POPUP_DETACH;

#ifdef BEINTOO_ARC_AVAILABLE
#else
    [popup release];
#endif

}

- (IBAction)openBalance
{
    if ([Beintoo isUserLogged]){
        balanceVC = [balanceVC initWithNibName:@"BeintooBalanceVC" bundle:[NSBundle mainBundle] andOptions:nil];
        
        [self.navigationController pushViewController:balanceVC animated:YES];
    }
    else {
        
#ifdef BEINTOO_ARC_AVAILABLE
        UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif

        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [featureView release];
#endif

    }
}	 

- (IBAction)openMessages
{
    if([Beintoo isUserLogged]){
        messagesVC = [messagesVC initWithNibName:@"BeintooMessagesVC" bundle:[NSBundle mainBundle] andOptions:nil];
        
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
    else
    {
        
#ifdef BEINTOO_ARC_AVAILABLE
        UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
        
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];
       
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [featureView release];
#endif
        
    }
}

- (IBAction)openFriends{	
    if ([Beintoo isUserLogged]){
        
        [self.navigationController pushViewController:friendActionsVC animated:YES];
    }
    else {
        
#ifdef BEINTOO_ARC_AVAILABLE
        UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
        
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [featureView release];
#endif
    
    }
}

- (IBAction)openAlliances{	
    if ([Beintoo isUserLogged]){
        
        [self.navigationController pushViewController:alliancesActionVC animated:YES];
    }
    else {
        
#ifdef BEINTOO_ARC_AVAILABLE
        UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
        
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [featureView release];
#endif
    
    }
}

- (IBAction)openSettings
{
    if ([Beintoo isUserLogged]){
        NSString *url;
        if (![Beintoo isOnPrivateSandbox])
            url = [NSString stringWithFormat:@"https://www.beintoo.com/nativeapp/settings.html?apikey=%@&guid=%@&extId=%@", [Beintoo getApiKey], [Beintoo getPlayerID], [Beintoo getUserID]];
        else
            url = [NSString stringWithFormat:@"https://sandbox.beintoo.com/nativeapp/settings.html?apikey=%@&guid=%@&extId=%@", [Beintoo getApiKey], [Beintoo getPlayerID], [Beintoo getUserID]];
        
        webview = [[BeintooWebViewVC alloc] initWithNibName:@"BeintooWebViewVC" bundle:[NSBundle mainBundle] urlToOpen:url];
        
        [self.navigationController pushViewController:webview animated:YES];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [webview release];
#endif
        
    }
    else {

#ifdef BEINTOO_ARC_AVAILABLE
        UIView *featureView = [BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
        
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [featureView release];
#endif
    
    }
}

- (void)dismissFeatureSignupView
{
    UIView *featureView = [self.view viewWithTag:3333];
    [featureView removeFromSuperview];
}

// Friend profile
- (IBAction)sendMessage
{
	NSDictionary *replyOptions	= [NSDictionary dictionaryWithObjectsAndKeys:[self.startingOptions objectForKey:@"friendNickname"],@"from",
										[self.startingOptions objectForKey:@"friendUserID"],@"fromUserID",nil];
	NSDictionary *newMsgOptions	= [NSDictionary dictionaryWithObjectsAndKeys:replyOptions,@"replyOptions",nil];
	newMessageVC = [newMessageVC initWithNibName:@"BeintooNewMessageVC" bundle:[NSBundle mainBundle] andOptions:newMsgOptions];
    if (isFromNotification)
        newMessageVC.isFromNotification = YES;
	[self.navigationController pushViewController:newMessageVC animated:YES];
}

- (void)didGetUnfriendRequestResponse:(NSDictionary *)result
{
    UIAlertView *alert = [UIAlertView alloc];
    NSString *message;
    
    if ([[result objectForKey:@"message"] isEqualToString:@"OK"]){
        message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"successfullyUnfrined", @"BeintooLocalizable", nil), [self.startingOptions objectForKey:@"friendNickname"]];
        alert.tag = 1;
    }
    else 
        message = NSLocalizedStringFromTable(@"errorMessage", @"BeintooLocalizable", nil); 
    
    [BLoadingView stopActivity];
    alert = [alert initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [alert release];
#endif
    
}

- (void)didInviteFriendsToAllianceWithResult:(NSDictionary *)result
{
    [BLoadingView stopActivity];
    
    NSString *alertMessage;
    UIAlertView *av = [UIAlertView alloc];
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) {
		alertMessage = NSLocalizedStringFromTable(@"requestSent", @"BeintooLocalizable",@"");
        av.tag = 321;
    }
	else
		alertMessage = NSLocalizedStringFromTable(@"requestNotSent", @"BeintooLocalizable",@"");
	av = [av initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [av release];
#endif
    
}

- (void)didGetFriendRequestResponse:(NSDictionary *)result
{
    UIAlertView *alert = [UIAlertView alloc];
    NSString *message;
    
    if ([[result objectForKey:@"message"] isEqualToString:@"OK"]){
        message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"friendshipRequestSent", @"BeintooLocalizable", nil), [self.startingOptions objectForKey:@"friendNickname"]];
        alert.tag = 2;
    }
    else 
        message = NSLocalizedStringFromTable(@"errorMessage", @"BeintooLocalizable", nil); 
    
    [BLoadingView stopActivity];
    alert = [alert initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [alert release];
#endif

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadFriendsList object:nil];
    }
}

- (void)addToAlliance
{
    NSArray *friends = [NSArray arrayWithObject:[self.startingOptions objectForKey:@"friendUserID"]];
    
    [_alliance allianceAdminInviteFriends:friends onAlliance:[BeintooAlliance userAllianceID]];
    [BLoadingView startActivity:profileView];
}

- (void)sendUnfriendRequest
{
    [BLoadingView startActivity:profileView];
    [_user sendUnfriendshipRequestTo:[self.startingOptions objectForKey:@"friendUserID"]];
}

- (void)sendFriendRequest
{
    [BLoadingView startActivity:profileView];
    [_user sendFriendshipRequestTo:[self.startingOptions objectForKey:@"friendUserID"]];
} 

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if (actionSheet.tag == POPUP_DETACH){
		if(buttonIndex == 0){
			[_user removeUDIDConnectionFromUserID:[[Beintoo getUserIfLogged] objectForKey:@"id"]];
			[self logoutUser];
		}
	}
	
	if (actionSheet.tag == POPUP_LOGOUT){
		if(buttonIndex == 0)
			[self logoutUser];
	}
}
						   
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allContests count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSArray *scores = [allScores objectForKey:[self.allContests objectAtIndex:section]];
	//return [scores count]-1;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
#endif
    
    }
	
	@try {
		NSArray *scoresForThisSection = [self.allScoresForContest objectAtIndex:indexPath.section];
				
		
		UILabel *totLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 95, 20)];
		UILabel *bestLabel              = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 2, 95, 20)];
		UILabel *lastLabel              = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.68, 2, 95, 20)];
        
        UIColor *labelBGColor           = [UIColor clearColor];
		totLabel.backgroundColor		= labelBGColor;
		bestLabel.backgroundColor		= labelBGColor;
		lastLabel.backgroundColor		= labelBGColor;
		
        UIFont *labelFont               = [UIFont systemFontOfSize:13];
        UIColor *labelTextColor         = [UIColor colorWithWhite:0 alpha:0.7];
        
		totLabel.font                   = labelFont;
		totLabel.textColor              = labelTextColor;
		bestLabel.font                  = labelFont;
		bestLabel.textColor             = labelTextColor;
		lastLabel.font                  = labelFont;
		lastLabel.textColor             = labelTextColor;
		
		totLabel.text                   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"totalScore", @"BeintooLocalizable", nil), [scoresForThisSection objectAtIndex:0]];
		bestLabel.text                  = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"bestScore", @"BeintooLocalizable", nil), [scoresForThisSection objectAtIndex:1]];
		lastLabel.text                  = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"lastScore", @"BeintooLocalizable", nil),[scoresForThisSection objectAtIndex:2]];
        
        totLabel.adjustsFontSizeToFitWidth  = YES;
        bestLabel.adjustsFontSizeToFitWidth = YES;
        lastLabel.adjustsFontSizeToFitWidth = YES;
        
		[cell addSubview:totLabel];
		[cell addSubview:bestLabel];
		[cell addSubview:lastLabel];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [totLabel release];
		[bestLabel release];
		[lastLabel release];
#endif
		
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
#ifdef BEINTOO_ARC_AVAILABLE
    BGradientView *gradientView = [[BGradientView alloc] initWithGradientType:GRADIENT_HEADER];
#else
    BGradientView *gradientView = [[[BGradientView alloc] initWithGradientType:GRADIENT_HEADER]autorelease];
#endif
    
	gradientView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40);

	UILabel *contestNameLbl			= [[UILabel alloc] initWithFrame:CGRectMake(10,2,300,20)];
	contestNameLbl.backgroundColor	= [UIColor clearColor];
	contestNameLbl.textColor		= [UIColor blackColor];
	contestNameLbl.font				= [UIFont boldSystemFontOfSize:14];
	
	UILabel *feedNameLbl		= [[UILabel alloc] initWithFrame:CGRectMake(10,2,300,50)];
	feedNameLbl.backgroundColor = [UIColor clearColor];
	feedNameLbl.textColor	    = [UIColor blackColor];
	feedNameLbl.font		    = [UIFont systemFontOfSize:12];
	
	NSDictionary *contest = [[self.allScores objectForKey:[self.allContests objectAtIndex:section]] objectForKey:@"contest"];
	NSString *feedName = [contest objectForKey:@"feed"];
	
	/*if ([[self.allContests objectAtIndex:section] isEqualToString:@"default"]) {
		tempLabel.text = NSLocalizedStringFromTable(@"pointsOnThisApp",@"BeintooLocalizable",@"Points on this app");
	}
	else
		tempLabel.text = [NSString stringWithFormat:@"%@ %@:",NSLocalizedStringFromTable(@"pointsOn",@"BeintooLocalizable",@"Points on"),[self.allContests objectAtIndex:section]];
	*/
	
	contestNameLbl.text = [contest objectForKey:@"name"];
	feedNameLbl.text	= feedName;
	[gradientView addSubview:contestNameLbl];
	[gradientView addSubview:feedNameLbl];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [contestNameLbl release];
	[feedNameLbl release];
#endif
    
	return gradientView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (NSString *)translateLevel:(NSNumber *)levelNumber
{
	if (levelNumber.intValue==1) {return NSLocalizedStringFromTable(@"novice",@"BeintooLocalizable",@"Novice");}
	else if(levelNumber.intValue==2){return NSLocalizedStringFromTable(@"learner",@"BeintooLocalizable",@"Learner");}
	else if(levelNumber.intValue==3){return NSLocalizedStringFromTable(@"passionate",@"BeintooLocalizable",@"Passionate");}
	else if(levelNumber.intValue==4){return NSLocalizedStringFromTable(@"winner",@"BeintooLocalizable",@"Winner");}
	else if(levelNumber.intValue==5){return NSLocalizedStringFromTable(@"master",@"BeintooLocalizable",@"Master");}
	else
		return @"";
}

- (void)logoutUser
{
	[Beintoo setUserLogged:NO];
	[Beintoo dismissBeintoo];
}

- (void)tryBeintoo
{
    if (!isAlreadyLogging) {
        isAlreadyLogging = YES;
        @try {
            if ([BeintooNetwork connectedToNetwork]) {
                [BLoadingView startActivity:self.view];
                [loginNavController popToRootViewControllerAnimated:NO];                
            }
            [_user getUserByUDID];
        }
        @catch (NSException * e) {
        }
    }
}

- (void)didGetUserByUDID:(NSMutableArray *)result
{
    @synchronized(self){
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo setLastLoggedPlayers:(NSArray *)result];
#else
        [Beintoo setLastLoggedPlayers:[(NSArray *)result retain]];
#endif
        
        [BLoadingView stopActivity]; 
        
        if ([BeintooDevice isiPad]){
            [Beintoo launchIpadLogin];
        }
        else {
            BeintooLoginVC *signinVC        = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
            UIColor *barColor               = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
            BNavigationController *signinNavController = [[BNavigationController alloc] initWithRootViewController:signinVC];
            [[signinNavController navigationBar] setTintColor:barColor];
            
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
            [self presentViewController:signinNavController animated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [self presentViewController:signinNavController animated:YES completion:nil];
            else 
                [self presentModalViewController:signinNavController animated:YES];
#else
            [self presentModalViewController:signinNavController animated:YES];
#endif
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [signinVC release];
            [signinNavController release];
#endif
            
        }
    }	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _player.delegate  = nil;
    _user.delegate    = nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
	if (isAFriendProfile) {
		scoresTable.center = CGPointMake(scoresTable.center.x, scoresTable.center.y+56);
        scoresTable.frame = CGRectMake(scoresTable.frame.origin.x, scoresTable.frame.origin.y, scoresTable.frame.size.width, scoresTable.frame.size.height - 56);
	}
    
    @try {        
        UIView *featureView = [self.view viewWithTag:3333];
        UIView *signupView  = [self.view viewWithTag:1111];
        [featureView removeFromSuperview];
        [signupView removeFromSuperview];
	}
	@catch (NSException * e) {
    }
}

- (UIView *)closeButton
{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo
{
    if (isFromNotification){
        if ([BeintooDevice isiPad]){
            [Beintoo dismissIpadNotifications];
        }
        else {
            
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
            [self dismissViewControllerAnimated:YES completion:nil];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [self dismissViewControllerAnimated:YES completion:nil];
            else
                [self dismissModalViewControllerAnimated:YES];
#else
            [self dismissModalViewControllerAnimated:YES];
#endif
            
        }
    }
    else
        [Beintoo dismissBeintoo];
}

#pragma mark - ImageDownload delegate 

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    userImg.image = download.image;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error
{

}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[listOfContests release];
	[self.allScores release];
	[self.sectionScores release];
	[self.allContests release];
	[self.allScoresForContest release];
	[feedNameLists release];
	[_player release];
	[_user release];
	[messagesVC release];
	[newMessageVC release];
	[friendActionsVC release];
    [signupViewForPlayers release];
    [loginVC release];
    [_alliance release];
    [super dealloc];
}
#endif

@end
