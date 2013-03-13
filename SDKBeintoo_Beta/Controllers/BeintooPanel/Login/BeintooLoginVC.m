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

#import "BeintooLoginVC.h"
#import "Beintoo.h"

@implementation BeintooLoginVC

@synthesize retrievedUsers, userImages, callerIstance, caller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		
    if (self) {
		registrationFBVC = [[BeintooSigninFacebookVC alloc] initWithNibName:@"BeintooSigninFacebookVC" bundle:[NSBundle mainBundle]];
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Accounts";
	
	[loginView setTopHeight:53.0];
	[loginView setBodyHeight:375.0];
	
	_player             = [[BeintooPlayer alloc] init];
	_player.delegate    = self;
	
	retrievedUsers      = [[NSArray alloc] init];
    userImages          = [[NSMutableArray alloc] init];
	
    useAnotherBtnLabel.text = NSLocalizedStringFromTable(@"useAnotherAccount",@"BeintooLocalizable",@"Use another account");
	titleLabel1.text        = NSLocalizedStringFromTable(@"wehavefound",@"BeintooLocalizable",@"We have found multiple Beintoo players");
	titleLabel2.text        = NSLocalizedStringFromTable(@"selectwhich",@"BeintooLocalizable",@"Select which one to use,");
	
	[anotherPlayerButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[anotherPlayerButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[anotherPlayerButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [anotherPlayerButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[anotherPlayerButton setTitle:NSLocalizedStringFromTable(@"useAnotherAccount",@"BeintooLocalizable",@"Use another account") forState:UIControlStateNormal];
	[anotherPlayerButton setButtonTextSize:20];
    anotherPlayerButton.hidden = YES;
    
	self.navigationController.navigationBarHidden = NO;
		
	// Retrieved Players Initial Settings
	retrievedPlayersTable.delegate  = self;
	retrievedPlayersTable.rowHeight = 50.0f; 
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
    buttonItem.title = NSLocalizedStringFromTable(@"useAnotherAccount",@"BeintooLocalizable",@"Use another account");
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y + 12, toolBar.frame.size.width, 32);
        retrievedPlayersTable.frame = CGRectMake(retrievedPlayersTable.frame.origin.x, retrievedPlayersTable.frame.origin.y, retrievedPlayersTable.frame.size.width, retrievedPlayersTable.frame.size.height + 12);
    }
    else {
        toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y, toolBar.frame.size.width, 44);
    }
    
    [toolBar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    retrievedUsers = [Beintoo getLastLoggedPlayers];
#else
    retrievedUsers = [[Beintoo getLastLoggedPlayers] retain];
#endif
	
	if ([retrievedUsers count] < 1) { // -- no already logged users found. Proceeding to registration.
        registrationVC	 = [[BeintooSigninVC alloc] initWithNibName:@"BeintooSigninVC" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:registrationVC animated:NO];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [registrationVC release];
#endif
        
	}
    else{
		[userImages removeAllObjects];
		for (int i = 0; i < [self.retrievedUsers count]; i++) {
			@try {
                if ([retrievedUsers isKindOfClass:[NSDictionary class]]) {
                    BeintooLOG(@"Beintoo ERROR: %@",[(NSDictionary *)self.retrievedUsers objectForKey:@"message"]);
                    return;
                }
				NSDictionary *user = [retrievedUsers objectAtIndex:i];
                
#ifdef BEINTOO_ARC_AVAILABLE
                BImageDownload *download = [[BImageDownload alloc] init];
#else
                BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
				
                download.delegate = self;
				download.urlString = [user objectForKey:@"usersmallimg"];
				[userImages addObject:download];
			}
			@catch (NSException * e) {
				BeintooLOG(@"BeintooException: %@ \n for object: %@", e, [retrievedUsers objectAtIndex:i]);
			}
		}
		[retrievedPlayersTable reloadData];		
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
    return [retrievedUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
    if ([retrievedUsers isKindOfClass:[NSDictionary class]]) {
        return cell;
    }
	NSDictionary *user = [retrievedUsers objectAtIndex:indexPath.row];

	@try {
		BImageDownload *download = [userImages objectAtIndex:indexPath.row];
		UIImage *cellImage  = download.image;

		cell.textLabel.text				= [user objectForKey:@"nickname"];
		cell.textLabel.font				= [UIFont systemFontOfSize:16];
		cell.detailTextLabel.text		= [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"level",@"BeintooLocalizable",@""),[self translateLevel:[user objectForKey:@"level"]]];
		cell.imageView.image			= cellImage;
	}
	@catch (NSException * e){
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{		
	NSDictionary *user	= [retrievedUsers objectAtIndex:indexPath.row];	
	NSString *userID	= [user objectForKey:@"id"];
	
	[BLoadingView startActivity:self.view];
	[_player login:userID];
}

#pragma mark -
#pragma mark GeneratePlayer

- (void)generatePlayerIfNotExists
{
	if ([Beintoo getPlayerID] == nil) {
		NSDictionary *anonymPlayer = [_player blockingLogin:@""];
        
		if ([anonymPlayer objectForKey:@"guid"] == nil) {			
			[BeintooNetwork showNoConnectionAlert];
			return;
		}
		else {
			[Beintoo setBeintooPlayer:anonymPlayer];
		}
	}
}

#pragma mark -
#pragma mark Delegates

- (void)playerDidLogin:(BeintooPlayer *)player
{
	[BLoadingView stopActivity];
    
    if ([player loginError] == LOGIN_NO_ERROR) {
		[retrievedPlayersTable deselectRowAtIndexPath:[retrievedPlayersTable indexPathForSelectedRow] animated:YES];
        
        [Beintoo postNotificationBeintooUserDidLogin];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];

        if ([BeintooDevice isiPad]){
            [Beintoo dismissIpadLogin];
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
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [userImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
	[retrievedPlayersTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [path release];
#endif
    
    download.delegate = nil;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error
{
    BeintooLOG(@"imagedownloadingerror: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark CommonMethods

- (IBAction)otherPlayer
{
    registrationVC	 = [[BeintooSigninVC alloc] initWithNibName:@"BeintooSigninVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:registrationVC animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [registrationVC release];
#endif
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationSignupClosed object:self];
    
    if ([BeintooDevice isiPad]){
        [Beintoo dismissIpadLogin];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    _player.delegate = self;
    
	[registrationFBVC release];
	//[registrationVC release];
	[userImages release];
	[_player release];
	[retrievedUsers release];
    [super dealloc];
}
#endif

@end
