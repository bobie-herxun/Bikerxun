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

#import "BeintooFriendsListVC.h"
#import "Beintoo.h"
#import "BPickerView.h"

@implementation BeintooFriendsListVC

@synthesize friendsTable, friendsArrayList, friendsImages, selectedFriend, vGood, startingOptions, backFromWebView, caller, isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions = options;
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
	self.title			 	= NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"Friends");
	noFriendsLabel.text		= NSLocalizedStringFromTable(@"nofriendslabel",@"BeintooLocalizable",@"");
	
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"profile"]) 
		selectFriendLabel.text  = NSLocalizedStringFromTable(@"hereAreYourFriends",@"BeintooLocalizable",@"Select A Friend");
	else
		selectFriendLabel.text  = NSLocalizedStringFromTable(@"selectFriend",@"BeintooLocalizable",@"Select A Friend");

	[friendsView setTopHeight:45];
	[friendsView setBodyHeight:382];
	
	self.friendsTable.delegate	= self;
	self.friendsTable.rowHeight	= 60.0;	
	
	friendsArrayList = [[NSMutableArray alloc] init];
	friendsImages    = [[NSMutableArray alloc] init];
	
	user			= [[BeintooUser alloc] init];
	_player			= [[BeintooPlayer alloc] init];
	profileVC		= [BeintooProfileVC alloc];	
	
	vGood = [[BeintooVgood alloc] init];
	vGood.delegate = self;
    
    [noFriendsLabel setHidden:YES];
	
	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		[user getFriendsByExtid];
		[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	}
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFriendsList) 
                                                 name:BeintooNotificationReloadFriendsList
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closePicker)
                                                 name:BeintooNotificationCloseBPickerView
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    user.delegate	= self;

}

- (void)reloadFriendsList
{    
    if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		[user getFriendsByExtid];	
		[friendsTable deselectRowAtIndexPath:[friendsTable indexPathForSelectedRow] animated:YES];
	}
}

- (void)closePicker
{
    [bPickerView removeFromSuperview];
}

- (void)didGetFriendsByExtid:(NSMutableArray *)result
{
	[friendsArrayList removeAllObjects];
	[friendsImages removeAllObjects];

	[noFriendsLabel setHidden:YES];

	if ([result count] <= 0) {
		[noFriendsLabel setHidden:NO];
	}
	if ([result isKindOfClass:[NSArray class]]) {
		for (int i = 0; i < [result count]; i++) {
			@try {
				NSMutableDictionary *friendsEntry = [[NSMutableDictionary alloc]init];
				NSString *nickname	 = [[result objectAtIndex:i] objectForKey:@"nickname"];
				NSString *userExt	 = [[result objectAtIndex:i] objectForKey:@"id"];
				NSString *userImgUrl = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
#ifdef BEINTOO_ARC_AVAILABLE
                BImageDownload *download = [[BImageDownload alloc] init];
#else
                BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
				
				download.delegate = self;
				download.urlString = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
				[friendsEntry setObject:nickname forKey:@"nickname"];
				[friendsEntry setObject:userExt forKey:@"userExt"];
				[friendsEntry setObject:userImgUrl forKey:@"userImgUrl"];
				[friendsArrayList addObject:friendsEntry];
				[friendsImages addObject:download];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [friendsEntry release];
#endif
				
			}
			@catch (NSException * e) {
				BeintooLOG(@"BeintooException - FriendList: %@ \n for object: %@",e,[result objectAtIndex:i]);
			}
		}
	}

	[BLoadingView stopActivity];
    for (UIView *subview in self.view.subviews){
        if ([subview isKindOfClass:[BLoadingView class]]){
            [subview removeFromSuperview];
        }
    }
	[friendsTable reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [friendsArrayList count];
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
	
	cell.textLabel.text  = [[self.friendsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
	cell.textLabel.font	 = [UIFont systemFontOfSize:16];
	
	BImageDownload *download = [self.friendsImages objectAtIndex:indexPath.row];
	UIImage *cellImage  = download.image;
	cell.imageView.image = cellImage;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedFriend = [self.friendsArrayList objectAtIndex:indexPath.row];
	
	// Act as "Send as a gift"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"sendAsAGift"]) 
		[self openSelectedFriendToSendAGift];
	
    // Act as "New message"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"newMessage"]) 
		[self pickAFriendToSendMessage];
	
	// Act as "Friend list"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"profile"]) 
		[self pickaFriendToShowProfile];
    
    // Act as "Challenges"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"challenges"]) 
		[self pickaFriendToSendChallenge];
}

- (void)openSelectedFriendToSendAGift
{
	[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"doYouFriend",@"BeintooLocalizable",@"") delegate:self 
											  cancelButtonTitle:@"No" 
										 destructiveButtonTitle:nil
											  otherButtonTitles:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@""),nil]; 
    if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"MarketplaceSendAsAGift"])
        popup.tag = 111;
    else 
        popup.tag = 222;
    
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [popup release];
#endif
	
}

- (void)pickaFriendToShowProfile
{
	[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	
	@try {
		NSDictionary *profileOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"friendsProfile",@"caller",
																			[self.selectedFriend objectForKey:@"userExt"],@"friendUserID",
																			[self.selectedFriend objectForKey:@"nickname"],@"friendNickname",nil];
		profileVC = [profileVC initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle] andOptions:profileOptions];
		[self.navigationController pushViewController:profileVC animated:YES];
	}
	@catch (NSException * e) {
	}
}

- (void)pickAFriendToSendMessage
{
	[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	
	@try {
		if ([[self.startingOptions objectForKey:@"callerVC"] isKindOfClass:[BeintooNewMessageVC class]]){
			BeintooNewMessageVC *callingViewController = [self.startingOptions objectForKey:@"callerVC"];
			[callingViewController setSelectedFriend:self.selectedFriend];
			
            [self.navigationController popViewControllerAnimated:YES];
		}
	}
	@catch (NSException * e) {
		
	}
}

- (void)pickaFriendToSendChallenge 
{	
	[friendsTable deselectRowAtIndexPath:[friendsTable indexPathForSelectedRow] animated:YES];
	
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [self.selectedFriend objectForKey:@"userExt"], @"friendUserID",
                             [self.selectedFriend objectForKey:@"nickname"],@"friendNickname",
                             nil];
    
    bPickerView = [[BPickerView alloc] initWithFrame:self.view.frame andOptions:options];
    [self.view addSubview:bPickerView];
    
    [bPickerView startPickerFilling];
}

- (void)removeBPickerViewFromSuperView:(NSNotification *)note
{
    [bPickerView removeFromSuperview];
}

#pragma mark -
#pragma mark actionSheet sendAsAGift

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) { // YES
		if (actionSheet.tag == 222){
            // Send as a gift call
            [BLoadingView startActivity:self.view];
            [vGood sendGoodWithID:[self.startingOptions objectForKey:@"vGoodID"] asGiftToUser:[self.selectedFriend objectForKey:@"userExt"]];
        }
        else {
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [startingOptions release];
#endif
            
            [self.navigationController popViewControllerAnimated:NO];
        }
	}
    else if (buttonIndex == 1) { // NO
		
	}
}

- (void)didSendVGoodAsGift:(BOOL)result
{
	[BLoadingView stopActivity];
	
	if (result) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"giftSent",@"BeintooLocalizable",@"Friends")
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]; 
		alert.tag = 1;
		[alert show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [alert release];
#endif
		
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil	message:NSLocalizedStringFromTable(@"giftNotSent",@"BeintooLocalizable",@"Friends")
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]; 
		alert.tag = 2;
		[alert show];

#ifdef BEINTOO_ARC_AVAILABLE
#else
        [alert release];
#endif
    
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0){
		if ([[self.startingOptions objectForKey:@"callerVC"] isKindOfClass:[BeintooWalletVC class]]){
			[self.navigationController popViewControllerAnimated:YES];
        }
		else {
			if (alertView.tag == 1) { // the vgood was correctly sent as a gift 
				[Beintoo dismissPrize];
			}
		}
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [self.friendsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [friendsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [path release];
#endif
    
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error
{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    user.delegate	= nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[user release];
	[vGood release];
    [profileVC release];
	[friendsArrayList release];
	[friendsImages release];
	[_player release];
    [super dealloc];
}
#endif

@end
