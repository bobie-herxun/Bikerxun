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

#import "BeintooLeaderboardContestVC.h"
#import "BeintooLoginVC.h"
#import "Beintoo.h"

@implementation BeintooLeaderboardContestVC

@synthesize segControl, players, leaderboardEntries, leaderboardImages, selectedPlayer, isFromNotification, isFromDirectLaunch;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"leaderboard",@"BeintooLocalizable",@"Leaderboard");

	[leaderboardContestView setTopHeight:40];
	[leaderboardContestView setBodyHeight:387];
	
    noScoresLabel.hidden = YES;
    noScoresLabel.text = NSLocalizedStringFromTable(@"errorMessage",@"BeintooLocalizable",@"All");

	[segControl setTitle:NSLocalizedStringFromTable(@"all",@"BeintooLocalizable",@"All") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"Friends") forSegmentAtIndex:1];
    [segControl setTitle:NSLocalizedStringFromTable(@"tobeat",@"BeintooLocalizable",@"Friends") forSegmentAtIndex:2];
   
    segControl.tintColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];

#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
	user					 = [[BeintooUser alloc] init];
	_player					 = [[BeintooPlayer alloc] init];

	leaderboardContestTable.delegate  = self;	
	leaderboardContestTable.rowHeight = 60;
	allScores				 = [[NSDictionary alloc]init];
	self.leaderboardEntries  = [[NSMutableArray alloc]init];
	self.leaderboardImages   = [[NSMutableArray alloc]init];
	
	currentUser				= [[NSDictionary alloc] init];
	players                 = [[NSMutableArray alloc]init];
    
    profileVC               = [BeintooProfileVC alloc];	
    loginVC                 = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    
    UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	loginNavController      = [[BNavigationController alloc] initWithRootViewController:loginVC];
	[[loginNavController navigationBar] setTintColor:barColor];	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    user.delegate			 = self;
	_player.delegate		 = self;

    noScoresLabel.hidden = YES;
    
    isAlreadyLogging = NO;
    
    if (signupViewForPlayers != nil) {
        signupViewForPlayers = nil;
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [signupViewForPlayers release];
#endif
        
    }
    
    [[self.view viewWithTag:1111] removeFromSuperview];
    
#ifdef BEINTOO_ARC_AVAILABLE
    signupViewForPlayers = [BSignupLayouts getBeintooLeaderboardSignupViewWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 90) andButtonActionSelector:@selector(tryBeintoo) fromSender:self];
#else
    signupViewForPlayers = [[BSignupLayouts getBeintooLeaderboardSignupViewWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 90) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
#endif
    
    signupViewForPlayers.tag = 1111;
    [self.view addSubview:signupViewForPlayers];

	plusOneCell              = 0;
	startRows                = 0;
	[self.leaderboardEntries removeAllObjects];
	[self.leaderboardImages removeAllObjects];
    
    if ([Beintoo isUserLogged]) {
        [signupViewForPlayers setHidden:YES];
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:YES forSegmentAtIndex:1];
        [segControl setEnabled:YES forSegmentAtIndex:2];
        
        if(homeTablePlayerAnimationPerformed){
            CGRect currentFrame = leaderboardContestTable.frame;
            leaderboardContestTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y - 50, currentFrame.size.width, currentFrame.size.height + 50);
            homeTablePlayerAnimationPerformed = NO;
        }
    }
    else{
        [signupViewForPlayers setHidden:NO];
        if(!homeTablePlayerAnimationPerformed){
            CGRect currentFrame = leaderboardContestTable.frame;
            leaderboardContestTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + 50, currentFrame.size.width, currentFrame.size.height - 50);
            homeTablePlayerAnimationPerformed = YES;
        }
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:NO forSegmentAtIndex:1];
        [segControl setEnabled:NO forSegmentAtIndex:2];
    }

    [BLoadingView startActivity:self.view];
    if (self.segControl.selectedSegmentIndex == 0) {
        
        isLeaderboardCloseToUser = NO;
        [BLoadingView stopActivity];
        [BLoadingView startActivity:self.view];
        
        [_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:nil andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];		
    }
    else if (self.segControl.selectedSegmentIndex == 1) {
        
        isLeaderboardCloseToUser = NO;
        [BLoadingView stopActivity];
        [BLoadingView startActivity:self.view];
        
        [_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
    }
    else if (self.segControl.selectedSegmentIndex == 2){
        
        isLeaderboardCloseToUser = YES;
        [BLoadingView stopActivity];
        [BLoadingView startActivity:self.view];
        
        [_player topScoreFrom:0 andRows:20 closeToUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
    }
}

#pragma mark AppDelegates

- (void)appDidGetTopScoreswithResult:(NSDictionary *)result
{
    @try {
        NSDictionary *currentContest = [result objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
        currentUser					 = [currentContest objectForKey:@"currentUser"];
        self.players				 = [currentContest objectForKey:@"leaderboard"];
        if ([self.players count] > 0 && [self.players count] >= NUMBER_OF_ROWS && !isLeaderboardCloseToUser) {
            plusOneCell = 1;
        }
        else {
            plusOneCell = 0;
        }
            
        if ([self.leaderboardEntries count] <= 0 && currentUser != nil) {
             // --------- Here we set the first element of the leaderboard: the current player and its position
            NSMutableDictionary *leaderboardEntry = [[NSMutableDictionary alloc]init];
            
            NSString *position		= [currentUser objectForKey:@"pos"]; 	
            NSString *score			= [currentUser objectForKey:@"score"];
            NSDictionary *theUser	= [currentUser objectForKey:@"user"];
            
#ifdef BEINTOO_ARC_AVAILABLE
            BImageDownload *download = [[BImageDownload alloc] init];
#else
            BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
            
            download.delegate = self;
            download.urlString = [theUser objectForKey:@"usersmallimg"];
            
            [leaderboardEntry setObject:position forKey:@"position"];
            [leaderboardEntry setObject:score forKey:@"score"];
            [leaderboardEntry setObject:theUser forKey:@"user"];
            
            [self.leaderboardEntries addObject:leaderboardEntry];
            [self.leaderboardImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
             [leaderboardEntry release];
#endif
           
        }
            
        for (int i = 0; i < [self.players count]; i++) {
            NSMutableDictionary *leaderboardEntry = [[NSMutableDictionary alloc]init];
            
            NSString *position		= [[self.players objectAtIndex:i] objectForKey:@"pos"]; 	
            NSString *score			= [[self.players objectAtIndex:i] objectForKey:@"score"];
            NSDictionary *theUser	= [[self.players objectAtIndex:i] objectForKey:@"user"];
            
#ifdef BEINTOO_ARC_AVAILABLE
            BImageDownload *download = [[BImageDownload alloc] init];
#else
            BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
            
            download.delegate = self;
            download.urlString = [theUser objectForKey:@"usersmallimg"];
                        
            [leaderboardEntry setObject:position forKey:@"position"];
            [leaderboardEntry setObject:score forKey:@"score"];
            [leaderboardEntry setObject:theUser forKey:@"user"];
            
            [self.leaderboardEntries addObject:leaderboardEntry];
            [self.leaderboardImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [leaderboardEntry release];
#endif
        
        }
    }
	@catch (NSException * e) {
		BeintooLOG(@"BeintooException: %@",e);
        noScoresLabel.hidden = NO;
        noScoresLabel.text = NSLocalizedStringFromTable(@"errorMessage",@"BeintooLocalizable",@"All");
	}
    
    if ([self.leaderboardEntries count] <= 0 && !currentUser) {
        noScoresLabel.hidden = NO;
        noScoresLabel.text = NSLocalizedStringFromTable(@"noResult", @"BeintooLocalizable", nil);
    }

	[BLoadingView stopActivity];
    [leaderboardContestTable reloadData];
}

- (void)tryBeintoo
{    
    if (!isAlreadyLogging) {
        isAlreadyLogging = YES;
        @try {
            if ([BeintooNetwork connectedToNetwork]) {
                [BLoadingView startActivity:self.view];
                
            }
            [user getUserByUDID];
        }
        @catch (NSException * e) {
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.leaderboardEntries count] + plusOneCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	UIFont *positionFont = [UIFont systemFontOfSize:16];
	if (indexPath.row == 0 && currentUser != nil) {
		_gradientType = GRADIENT_CELL_SPECIAL;
		positionFont  = [UIFont boldSystemFontOfSize:15]; 
	}
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {

#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
    
    }
	
	if (indexPath.row == [leaderboardEntries count]) {
		
		UILabel *loadMoreLabel			= [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 110, 14)];
		loadMoreLabel.autoresizingMask	= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		loadMoreLabel.backgroundColor	= [UIColor clearColor];
		loadMoreLabel.font				= [UIFont systemFontOfSize:17];		
		loadMoreLabel.text				= NSLocalizedStringFromTable(@"loadmoreButton", @"BeintooLocalizable", nil);
		
		[cell addSubview:loadMoreLabel];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [loadMoreLabel release];
#endif
		
    }
	else
    {
        UIImage *cellImage;
        if ([leaderboardImages count] > 0){
            BImageDownload *download = [leaderboardImages objectAtIndex:indexPath.row];
            cellImage  = download.image;
            
            NSDictionary *userToShow = [[leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"user"];
            
            UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 25, 17)];
            positionLabel.backgroundColor = [UIColor clearColor];
            positionLabel.font = [UIFont boldSystemFontOfSize:12];
            positionLabel.adjustsFontSizeToFitWidth = YES;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
            positionLabel.textAlignment = NSTextAlignmentCenter;
            positionLabel.minimumScaleFactor = 2.0;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            {
                positionLabel.textAlignment = NSTextAlignmentCenter;
                positionLabel.minimumScaleFactor = 2.0;
            }
            else
            {
                positionLabel.textAlignment = UITextAlignmentCenter;
                positionLabel.minimumFontSize = 8.0;
            }
#else
            positionLabel.textAlignment = UITextAlignmentCenter;
            positionLabel.minimumFontSize = 8.0;
#endif
           
            positionLabel.text = [NSString stringWithFormat:@"%@",[[leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"position"]];
            
            [cell addSubview:positionLabel];
            
            UIImageView *imageViewPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 50, 50)];
            imageViewPhoto.image = cellImage;
            [cell addSubview:imageViewPhoto];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10 , self.view.frame.size.width - 90 - 30, 20)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = positionFont;
            nameLabel.adjustsFontSizeToFitWidth = YES;
            nameLabel.text = [NSString stringWithFormat:@"%@", [userToShow objectForKey:@"nickname"]];
            
            [cell addSubview:nameLabel];
            
            UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30 , self.view.frame.size.width - 90 - 30, 20)];
            descriptionLabel.backgroundColor = [UIColor clearColor];
            descriptionLabel.font = [UIFont systemFontOfSize:12];
            descriptionLabel.adjustsFontSizeToFitWidth = YES;
            descriptionLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"score", @"BeintooLocalizable", @"Score"),[[leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"score"]];
            
            [cell addSubview:descriptionLabel];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [positionLabel release];
            [imageViewPhoto release];
            [nameLabel release];
            [descriptionLabel release];
#endif
            
            if ([Beintoo isAFriendOfMine:[userToShow objectForKey:@"id"]]){
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"beintoo_yourfriends.png"]];
                cell.accessoryView = imageView;
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [imageView release];
#endif
                
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.row == [self.leaderboardEntries count]) {
		startRows = startRows + NUMBER_OF_ROWS;

		// Adding new elements to the tableview, depending on the segmentcontrol we use the userId or not to load only friends
		if (self.segControl.selectedSegmentIndex == 0) {
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:nil andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}else {
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
		[BLoadingView startActivity:self.view];
	}
	else if([Beintoo isUserLogged]) {  
        
        /* LEADERBOARD FOR USER */
        // here we have to choose among:
        // -- 1. Send a challenge
        // -- 2. View profile
        // -- 3. Add as friend
        
		/*self.selectedPlayer = [self.leaderboardEntries objectAtIndex:indexPath.row];
		NSString *myUserID = [Beintoo getUserID];
		if (![[[self.selectedPlayer objectForKey:@"user"] objectForKey:@"id"] isEqualToString:myUserID]) {
			[self openSelectedPlayer];
		}else {
			[leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
		}*/
        
        selectedPlayer = [leaderboardEntries objectAtIndex:indexPath.row];
		
        
        NSString *myUserID = [Beintoo getUserID];
		if (![[[selectedPlayer objectForKey:@"user"] objectForKey:@"id"] isEqualToString:myUserID]) {
			//[self openSelectedPlayer];
            NSDictionary *profileOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"friendsProfile",@"caller",
                                            [[self.selectedPlayer objectForKey:@"user"] objectForKey:@"id"],@"friendUserID",
                                            [[self.selectedPlayer objectForKey:@"user"] objectForKey:@"nickname"],@"friendNickname",nil];
            profileVC = [[BeintooProfileVC alloc] initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle] andOptions:profileOptions];
            if (isFromDirectLaunch)
                profileVC.isFromDirectLaunch = YES;
            
            [self.navigationController pushViewController:profileVC animated:YES];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [profileVC release];
#endif
            
		}
        else {
			[leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
		}
	}
    else{  /* LEADERBOARD FOR PLAYER */
        [leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [self.leaderboardImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [leaderboardContestTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [path release];
#endif
    
    download.delegate = nil;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error
{
    BeintooLOG(@"BeintooImageError: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark ActionSheetCall

- (void)openSelectedPlayer
{
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                                    destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedStringFromTable(@"leadSendChall",@"BeintooLocalizable",@""),
                                                    NSLocalizedStringFromTable(@"leadViewProfile",@"BeintooLocalizable",@""),
                                                    NSLocalizedStringFromTable(@"leadAddFriend",@"BeintooLocalizable",@""), nil ];
    
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [popup release];
#endif
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
	if (buttonIndex == 0) { 
        // ---------- Send challenge
        //[user challengeRequestfrom:myUserExt to:toUserExt withAction:@"INVITE" forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
        
        BSendChallengesView *sendChallengeView  = [[BSendChallengesView alloc] initWithFrame:self.view.frame];
        sendChallengeView.challengeReceiver     = [self.selectedPlayer objectForKey:@"user"];
        sendChallengeView.challengeSender       = [Beintoo getUserIfLogged];
        
        [sendChallengeView drawSendChallengeView];
        sendChallengeView.tag = BSENDCHALLENGE_VIEW_TAG;
        sendChallengeView.alpha = 0;
        [self.view addSubview:sendChallengeView];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [sendChallengeView release];
#endif
        
        [UIView beginAnimations:@"sendChallengeOpen" context:nil];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDuration:0.45];
        sendChallengeView.alpha = 1;
        [UIView commitAnimations];	
    }
    else if (buttonIndex == 1) {
		// ---------- View profile
        NSDictionary *profileOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"friendsProfile",@"caller",
                                        [[self.selectedPlayer objectForKey:@"user"] objectForKey:@"id"],@"friendUserID",
                                        [[self.selectedPlayer objectForKey:@"user"] objectForKey:@"nickname"],@"friendNickname",nil];
		profileVC = [profileVC initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle] andOptions:profileOptions];
		[self.navigationController pushViewController:profileVC animated:YES];

	}
    else if (buttonIndex == 2){
        // ---------- Add as a friend
        [user sendFriendshipRequestTo:[[self.selectedPlayer objectForKey:@"user"]objectForKey:@"id"]];

    }
    [leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark Friend request response

- (void)didGetFriendRequestResponse:(NSDictionary *)result
{
	[BLoadingView stopActivity];
	
	NSString *alertMessage;
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) 
		alertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");
	else{
		int messageID = (int)[[result objectForKey:@"messageID"] doubleValue];
		if (messageID == -23) 
			alertMessage = NSLocalizedStringFromTable(@"pendingFriendRequest",@"BeintooLocalizable",@"");
		else
			alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	}
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [av release];
#endif
	
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
            BeintooLoginVC *signinVC            = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
            UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
            BNavigationController *signinNavController = [[BNavigationController alloc] initWithRootViewController:signinVC];
            [[signinNavController navigationBar] setTintColor:barColor];
            
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_5_0)
            [self presentViewController:signinNavController
                               animated:YES
                             completion:^(void){
                                 [leaderboardContestTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                             }
             ];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_5_0)
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [self presentViewController:signinNavController
                                   animated:YES
                                   completion:^(void){
                                    [leaderboardContestTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                                   }
                 ];
            else    {
                [self presentModalViewController:signinNavController animated:YES];
                [leaderboardContestTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            }
#else
            [self presentModalViewController:signinNavController animated:YES];
            [leaderboardContestTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
            [signinVC release];
            [signinNavController release];
#endif
            
        }
    }	
}

- (IBAction)segmentedControlIndexChanged
{
    noScoresLabel.hidden = YES;
    
	switch (self.segControl.selectedSegmentIndex) {
		case 0:{
			
			// Resetting all the leaderboards array
			plusOneCell              = 0;
			startRows                = 0;
            isLeaderboardCloseToUser = NO;
			[self.leaderboardEntries removeAllObjects];
			[self.leaderboardImages removeAllObjects];
			
			
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:nil andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
			break;
		case 1:{
			// Resetting all the leaderboards array
            plusOneCell              = 0;
			startRows                = 0;
            isLeaderboardCloseToUser = NO;
            [self.leaderboardEntries removeAllObjects];
			[self.leaderboardImages removeAllObjects];
			
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
			break;
        
        case 2:{
			// Resetting all the leaderboards array
			plusOneCell              = 0;
			startRows                = 0;
            isLeaderboardCloseToUser = YES;
			[self.leaderboardEntries removeAllObjects];
			[self.leaderboardImages removeAllObjects];
			
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			
			[_player topScoreFrom:0 andRows:20 closeToUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
			break;
			
		default:
			break;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    user.delegate       = nil;
    _player.delegate    = nil;
    
    @try {
		[BLoadingView stopActivity];
        for (UIView *view in [self.view subviews]) {
            if([view isKindOfClass:[BLoadingView class]]){	
                [view removeFromSuperview];
            }
        }
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    @try {
        UIView *sendChallenge  = [self.view viewWithTag:BSENDCHALLENGE_VIEW_TAG];
        [sendChallenge removeFromSuperview];
    }
	@catch (NSException * e) {
        BeintooLOG(@"Exception on view removing");
    }
    
    @try {
        UIView *signupView  = [self.view viewWithTag:1111];
        [signupView removeFromSuperview];
        [self.leaderboardEntries removeAllObjects];
        [self.leaderboardImages removeAllObjects];
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
    [Beintoo dismissBeintoo];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[currentUser release];
	[players release];
    [profileVC release];
	[allScores release];
	[self.leaderboardEntries release];
	[self.leaderboardImages release];
	[user release];
    [loginVC release];
	[_player release];
    [signupViewForPlayers release];
    [super dealloc];
}
#endif

@end
