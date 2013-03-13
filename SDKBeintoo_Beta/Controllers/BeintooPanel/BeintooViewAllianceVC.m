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

#import "BeintooViewAllianceVC.h"
#import "Beintoo.h"

@implementation BeintooViewAllianceVC

@synthesize elementsTable, elementsArrayList, selectedElement, startingOptions, globalResult, isMineAlliance, isFromLeaderboard, needJoinAlliance, needLeaveAlliance, needPendingRequest, needAddToAlliance, isFromNotification, isFromDirectLaunch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (isMineAlliance)
        self.title		= NSLocalizedStringFromTable(@"alliance_your", @"BeintooLocalizable",@"");
	
	[alliancesActionView setTopHeight:82];
	[alliancesActionView setBodyHeight:[UIScreen mainScreen].bounds.size.height];
	
	//self.elementsArrayList   = [[NSMutableArray alloc] init];
    elementsArrayImages = [[NSMutableArray alloc] init];
    globalResult        = [[NSDictionary alloc] init];
	_player				= [[BeintooPlayer alloc] init];
    _user               = [[BeintooUser alloc] init];
    _alliance           = [[BeintooAlliance alloc] init];
    
    allianceAdminUserID = [[NSString alloc] init];    
    allianceId          = [[NSString alloc] init];    
    
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	    
	elementsTable.delegate		= self;
	elementsTable.rowHeight	= 30.0;	
    
    [alliancesActionView setIsScrollView:YES];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 320);
	scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    scrollView.scrollEnabled = NO;
    
    allianceNameLabel.font          = [UIFont systemFontOfSize:14];
    allianceMembersLabel.font       = [UIFont systemFontOfSize:14];
    allianceMembersLabel.textColor  = [UIColor colorWithWhite:0 alpha:0.7];
    allianceAdminLabel.font         = [UIFont systemFontOfSize:14];
    allianceAdminLabel.textColor    = [UIColor colorWithWhite:0 alpha:0.7];
    
    allianceImageView.image         = [UIImage imageNamed:@"beintoo_alliance_your.png"];
    allianceImageView.contentMode   = UIViewContentModeCenter;
    
    [toolbar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
        [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        toolbar.frame = CGRectMake(toolbar.frame.origin.x, toolbar.frame.origin.y + 12, toolbar.frame.size.width, 32);
        elementsTable.frame = CGRectMake(elementsTable.frame.origin.x, elementsTable.frame.origin.y, elementsTable.frame.size.width, elementsTable.frame.size.height + 12);
    }
    else {
        toolbar.frame = CGRectMake(toolbar.frame.origin.x, toolbar.frame.origin.y, toolbar.frame.size.width, 44);
        elementsTable.frame = CGRectMake(elementsTable.frame.origin.x, elementsTable.frame.origin.y, elementsTable.frame.size.width, elementsTable.frame.size.height);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    toolbar.frame = CGRectMake(0, self.view.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height);
    
    _alliance.delegate  = self;
    _user.delegate      = self;
    
    elementsTable.hidden  = NO;
    
    needAddToAlliance   = NO;
    needJoinAlliance    = NO;
    needLeaveAlliance   = NO;
    needPendingRequest  = NO;
    
    
    if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        if (!self.startingOptions) { // No initial options, this is the case when the user wants to see his current alliance (and of course he has one)
            NSString *userAllianceID = [BeintooAlliance userAllianceID];
            if (userAllianceID) {
                [BLoadingView startActivity:self.view];
                
                if ([BeintooAlliance userHasAlliance]) 
                    [_alliance getAllianceWithAdminDetailsWithID:userAllianceID];
                else 
                    [_alliance getAllianceWithID:userAllianceID];
                
                needJoinAlliance = NO;
                needPendingRequest = NO;
            }
        }
        else {
            if (isFromLeaderboard) {                     
                // With options, FROM LEADERBOARDS
                NSString *userAllianceID = [[self.startingOptions objectForKey:@"user"] objectForKey:@"id"];
                if (userAllianceID) {
                    [BLoadingView startActivity:self.view];
                    
                    if ([[[[self.startingOptions objectForKey:@"user"] objectForKey:@"admin"] objectForKey:@"id"] isEqualToString:[Beintoo getUserID]])
                        [_alliance getAllianceWithAdminDetailsWithID:userAllianceID];
                    else 
                        [_alliance getAllianceWithID:userAllianceID];
                    
                    needLeaveAlliance = NO;
                    needPendingRequest = NO;
                    needJoinAlliance = YES;
                    
                    if ([BeintooAlliance userHasAlliance]) {
                        needJoinAlliance = NO;
                    }
                }
            }
            else{                       // With options, it means that an user wants to see an alliance from the global list...
                NSString *userAllianceID = [self.startingOptions objectForKey:@"allianceID"];
                if (userAllianceID) {
                    [BLoadingView startActivity:self.view];
                    [_alliance getAllianceWithID:userAllianceID];
                    
                    needLeaveAlliance = NO;
                    needPendingRequest = NO;
                    needJoinAlliance = YES;
                    
                    if ([BeintooAlliance userHasAlliance]) {
                        needJoinAlliance = NO;
                    }
                }
            }
        }
    }
}

#pragma mark -
#pragma mark Alliance Delegates

- (void)didGetAlliance:(NSDictionary *)result
{
    [BLoadingView stopActivity];
    
   /* allianceAdminUserID          = [[[result objectForKey:@"admin"]objectForKey:@"id"] retain];
    allianceId                   = [[result objectForKey:@"id"] retain];
    
    if ([[Beintoo getUserID] isEqualToString:allianceAdminUserID]) {
        pendingRequestsButton.hidden = NO;
    }
    
    allianceNameLabel.text       = [result objectForKey:@"name"];
    allianceMembersLabel.text    = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"allianceMembers",@"BeintooLocalizable",@""),[result objectForKey:@"members"]];
    allianceAdminLabel.text      = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"allianceAdmin",@"BeintooLocalizable",@""),[[result objectForKey:@"admin"]objectForKey:@"nickname"]];
    
    [self.elementsArrayList removeAllObjects];    
    if ([[result objectForKey:@"users"] isKindOfClass:[NSArray class]]) {
        self.elementsArrayList = [result objectForKey:@"users"];
    }
    
    [self.elementsTable reloadData];*/
    
    [BLoadingView stopActivity];
    
#ifdef BEINTOO_ARC_AVAILABLE
    allianceAdminUserID          = [[result objectForKey:@"admin"]objectForKey:@"id"];
    allianceId                   = [result objectForKey:@"id"];
#else
    allianceAdminUserID          = [[[result objectForKey:@"admin"]objectForKey:@"id"] retain];
    allianceId                   = [[result objectForKey:@"id"] retain];
#endif
    
    if ([[Beintoo getUserID] isEqualToString:allianceAdminUserID]) {
        [BeintooAlliance setUserWithAlliance:YES];
        needPendingRequest = YES;
        needAddToAlliance = YES;
    }
    else {
        [BeintooAlliance setUserAllianceAdmin:NO];
        needPendingRequest = NO;
        needAddToAlliance = NO;
    }
    
    allianceNameLabel.text       = [result objectForKey:@"name"];
    allianceMembersLabel.text    = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"alliancemembers",@"BeintooLocalizable",@""),[result objectForKey:@"members"]];
    allianceAdminLabel.text      = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"allianceadmin",@"BeintooLocalizable",@""),[[result objectForKey:@"admin"]objectForKey:@"nickname"]];
    
    [self.elementsArrayList removeAllObjects];
    [elementsArrayImages removeAllObjects];
    
    if ([[result objectForKey:@"users"] isKindOfClass:[NSArray class]]) {
        self.elementsArrayList = [result objectForKey:@"users"];
        for (int i = 0; i < [self.elementsArrayList count]; i++){
            BImageDownload *download = [[BImageDownload alloc] init];
            download.delegate  = self;
            download.urlString = [[self.elementsArrayList objectAtIndex:i] objectForKey:@"usersmallimg"];
            [elementsArrayImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [download release];
#endif
            
            if ([[Beintoo getUserID] isEqualToString:[[self.elementsArrayList objectAtIndex:i] objectForKey:@"id"]]) {
                needLeaveAlliance = YES;
            }
            else {
                needLeaveAlliance = NO;
            }
        }
    }
    
    [elementsTable reloadData];
    [self updateToolbar];
}

- (void)didGetAlliancesAdminList:(NSDictionary *)result
{    
    [BLoadingView stopActivity];
    
#ifdef BEINTOO_ARC_AVAILABLE
    allianceAdminUserID          = [[result objectForKey:@"admin"]objectForKey:@"id"];
    allianceId                   = [result objectForKey:@"id"];
#else
    allianceAdminUserID          = [[[result objectForKey:@"admin"]objectForKey:@"id"] retain];
    allianceId                   = [[result objectForKey:@"id"] retain];
#endif
    
    if ([[Beintoo getUserID] isEqualToString:allianceAdminUserID]) {
        
        [BeintooAlliance setUserWithAlliance:YES];
        needPendingRequest = YES;
        needAddToAlliance = YES;
        
        int pendingReq = [[result objectForKey:@"pendingRequest"] intValue];
        NSString *localizedString = NSLocalizedStringFromTable(@"allianceviewpending",@"BeintooLocalizable",@"");
        [pendingRequestsButton setTitle:[NSString stringWithFormat:@"%@ (%i)", localizedString, pendingReq] forState:UIControlStateNormal];
    }
    
    allianceNameLabel.text       = [result objectForKey:@"name"];
    allianceMembersLabel.text    = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"alliancemembers",@"BeintooLocalizable",@""),[result objectForKey:@"members"]];
    allianceAdminLabel.text      = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"allianceadmin",@"BeintooLocalizable",@""),[[result objectForKey:@"admin"]objectForKey:@"nickname"]];
    
    [self.elementsArrayList removeAllObjects];
    [elementsArrayImages removeAllObjects];
    
    if ([[result objectForKey:@"users"] isKindOfClass:[NSArray class]]) {
        self.elementsArrayList = [result objectForKey:@"users"];
        for (int i = 0; i < [self.elementsArrayList count]; i++){
            BImageDownload *download = [[BImageDownload alloc] init];
            download.delegate  = self;
            download.urlString = [[self.elementsArrayList objectAtIndex:i] objectForKey:@"usersmallimg"];
            [elementsArrayImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [download release];
#endif
            if ([[Beintoo getUserID] isEqualToString:[[self.elementsArrayList objectAtIndex:i] objectForKey:@"id"]]) {
                needLeaveAlliance = YES;
            }
        }
    }
    [elementsTable reloadData];
    [self updateToolbar];
    
}

- (void)didAllianceAdminPerformedRequest:(NSDictionary *)result
{    
    [BLoadingView stopActivity];
    
    globalResult = result;
    
	NSString *successAlertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");
    
	NSString *alertMessage;
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) 
		alertMessage = successAlertMessage;
	else
		alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [av release];
#endif
	
}

- (void)updateToolbar
{    
    UIBarButtonItem *joinButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"alliancesendreq", @"BeintooLocalizable", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(joinAlliance)];
    
    UIBarButtonItem *addToAllianceButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_alliance.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(addFriendsToAlliance)];
    
    UIBarButtonItem *pendingButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pending_request_alliance_admin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(getPendingRequests)];
    
    UIBarButtonItem *leaveButtonItem = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"cancel_alliance.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(leaveAlliance)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 0;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    if (needAddToAlliance && needLeaveAlliance && needPendingRequest){
        if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown){
            pendingButtonItem.width = 92.5;
            leaveButtonItem.width = 92.5;
            addToAllianceButtonItem.width = 92.5;
        }
        else { 
            pendingButtonItem.width = 152.5;
            leaveButtonItem.width = 152.5;
            addToAllianceButtonItem.width = 152.5;
        }
    }
    else if (needLeaveAlliance){
        if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown){
            
            leaveButtonItem.width = 300;
        }
        else { 
            leaveButtonItem.width = 460;
        }
    }
    else if (needJoinAlliance){
        if (![BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown){
            joinButtonItem.width = 300;
        }
        else { 
            joinButtonItem.width = 460;
        }
    }
    
    if (needPendingRequest != NO){
        
        [buttonsArray addObject:pendingButtonItem];
    }
    
    if (needAddToAlliance  != NO){
        
        if ([buttonsArray count] > 0)
            [buttonsArray addObject:flexibleSpace];
        
        [buttonsArray addObject:addToAllianceButtonItem];
    }
    
    if (needJoinAlliance  != NO){
        
        if ([buttonsArray count] > 0)
            [buttonsArray addObject:flexibleSpace];
        
        [buttonsArray addObject:joinButtonItem];
        
    }
    
    if (needLeaveAlliance  != NO){
        if ([buttonsArray count] > 0)
            [buttonsArray addObject:flexibleSpace];
        
        [buttonsArray addObject:leaveButtonItem];
    }
    
    [buttonsArray insertObject:flexibleSpace atIndex:0];
    
    [buttonsArray addObject:flexibleSpace];
    
    [toolbar setItems:buttonsArray];
    
    if ([buttonsArray count] >= 3){
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - toolbar.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height);
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        toolbar.frame = CGRectMake(0, self.view.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height);
        [UIView commitAnimations];        
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [pendingButtonItem release];
    [addToAllianceButtonItem release];
    [joinButtonItem release];
    [leaveButtonItem release];
    [fixedSpace release];
    [flexibleSpace release];
    [buttonsArray release];
#endif
    
}

#pragma mark -
#pragma mark AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1){
        [BeintooAlliance setUserWithAlliance:NO];
        [BeintooAlliance setUserAllianceAdmin:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 
#pragma mark IBActions

- (IBAction)leaveAlliance
{    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"allianceleaveareyousure",@"BeintooLocalizable",@"") delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    as.actionSheetStyle = UIActionSheetStyleDefault;
    as.tag = 1;
    [as showInView:[self.view superview]];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [as release];
#endif
    
}

- (IBAction)joinAlliance{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"alliancerequestdialog",@"BeintooLocalizable",@"") delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@""),nil];
    as.actionSheetStyle = UIActionSheetStyleDefault;
    as.tag = 2;
    [as showInView:[self.view superview]];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [as release];
#endif
    
}

- (IBAction)getPendingRequests
{    
    NSDictionary *pendingOptions = [NSDictionary dictionaryWithObjectsAndKeys:allianceId,@"allianceID",allianceAdminUserID,@"allianceAdminID", nil];
    
    
    pendingRequestsVC = [[BeintooAlliancePendingVC alloc] initWithNibName:@"BeintooAlliancePendingVC" bundle:[NSBundle mainBundle] andOptions:pendingOptions];
    if (isFromNotification)
        pendingRequestsVC.isFromNotification = YES;
    [self.navigationController pushViewController:pendingRequestsVC animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [pendingRequestsVC release];
#endif
    
}

- (IBAction)addFriendsToAlliance
{    
    allianceAddFriends = [[BeintooAlliancesAddFriends alloc] initWithNibName:@"BeintooAlliancesAddFriends" bundle:[NSBundle mainBundle] andOptions:self.elementsArrayList];
    if (isFromNotification)
        allianceAddFriends.isFromNotification = YES;
    [self.navigationController pushViewController:allianceAddFriends animated:YES];

#ifdef BEINTOO_ARC_AVAILABLE
#else
    [pendingRequestsVC release];
#endif

}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if (actionSheet.tag == 1) {  // LEAVE
        if (buttonIndex == 0) { 
            requestType = ALLIANCE_REQUEST_LEAVE;
            [BLoadingView startActivity:self.view];
            [_alliance performActionOnAlliance:allianceId withAction:ALLIANCE_ACTION_REMOVE forUser:[Beintoo getUserID]];
        }
        if (buttonIndex == 1) {
            // do nothing, the user picked no -> not leaving alliance
        }
    }
    
    if (actionSheet.tag == 2) {  // ASK TO JOIN
        if (buttonIndex == 0) { 
            requestType = ALLIANCE_REQUEST_JOIN;
            [BLoadingView startActivity:self.view];
            [_alliance sendJoinRequestForUser:[Beintoo getUserID] toAlliance:allianceId];
        }
        if (buttonIndex == 1) {
            // do nothing, the user picked no
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
	return [self.elementsArrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
	
    /*cell.textLabel.text         = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    cell.textLabel.font         = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor    = [UIColor colorWithWhite:0 alpha:0.7];
    cell.imageView.image        = [UIImage imageNamed:@"beintoo_user_icon.png"];
    cell.imageView.alpha        = 0.4;*/
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.text         = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    cell.textLabel.font         = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor    = [UIColor colorWithWhite:0 alpha:0.7];
    cell.imageView.image        = [UIImage imageNamed:@"beintoo_user_icon.png"];
    cell.imageView.alpha        = 0.0;
    
    BImageDownload  *download   = [elementsArrayImages objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 0, 28, 28)];
    imageView.image        = download.image;
    
    [cell addSubview:imageView];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [imageView release];
#endif
    
    if ([Beintoo isAFriendOfMine:[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"id"]]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"beintoo_yourfriends.png"]];
        cell.accessoryView = imageView;
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [imageView release];
#endif
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"id"]){
        if (![[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"id"] isEqualToString:[Beintoo getUserID]]){
            
            /*UIActionSheet	*popup;
             
             if ([Beintoo isAFriendOfMine:[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"id"]]){
             
             popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
             cancelButtonTitle:@"Cancel" 
             destructiveButtonTitle:nil
             otherButtonTitles:
             NSLocalizedStringFromTable(@"leadViewProfile",@"BeintooLocalizable",@""), 
             NSLocalizedStringFromTable(@"sendMesage",@"BeintooLocalizable",@""), NSLocalizedStringFromTable(@"sendChallenge",@"BeintooLocalizable",@""), nil ];
             popup.tag = 3;
             }
             else {
             popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
             cancelButtonTitle:@"Cancel" 
             destructiveButtonTitle:nil
             otherButtonTitles:
             NSLocalizedStringFromTable(@"leadViewProfile",@"BeintooLocalizable",@""), 
             NSLocalizedStringFromTable(@"sendMesage",@"BeintooLocalizable",@""), NSLocalizedStringFromTable(@"sendChallenge",@"BeintooLocalizable",@""), NSLocalizedStringFromTable(@"addFriends",@"BeintooLocalizable",@""),  nil ];
             popup.tag = 4;
             }
             
             popup.actionSheetStyle = UIActionSheetStyleDefault;
             [popup showInView:[self.view superview]];
             [popup release];*/
            
            NSDictionary *profileOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"friendsProfile",@"caller",
                                            [[self.elementsArrayList objectAtIndex:[elementsTable indexPathForSelectedRow].row] objectForKey:@"id"],@"friendUserID",
                                            [[self.elementsArrayList objectAtIndex:[elementsTable indexPathForSelectedRow].row] objectForKey:@"nickname"],@"friendNickname",nil];
            profileVC = [[BeintooProfileVC alloc] initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle] andOptions:profileOptions];
            if (isFromNotification)
                profileVC.isFromNotification = YES;
            [self.navigationController pushViewController:profileVC animated:YES];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [profileVC release];
#endif
            
            return;
        }
    }
    
    [elementsTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
#ifdef BEINTOO_ARC_AVAILABLE
    BGradientView *gradientView = [[BGradientView alloc] initWithGradientType:GRADIENT_HEADER];
#else
    BGradientView *gradientView = [[[BGradientView alloc] initWithGradientType:GRADIENT_HEADER]autorelease];
#endif
	
    gradientView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 35);
    
	UILabel *allianceMembers        = [[UILabel alloc]initWithFrame:CGRectMake(45,7,300,20)];
	allianceMembers.backgroundColor	= [UIColor clearColor];
	allianceMembers.textColor		= [UIColor blackColor];
	allianceMembers.font			= [UIFont boldSystemFontOfSize:13];
	
	allianceMembers.text = NSLocalizedStringFromTable(@"allianceviewmembers",@"BeintooLocalizable",@"");
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 34, 27)];
    userImage.image = [UIImage imageNamed:@"beintoo_user_icon.png"];
    
    [gradientView addSubview:userImage];
	[gradientView addSubview:allianceMembers];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [userImage release];
    [allianceMembers release];
#endif
	
    return gradientView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 35.0;
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

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [elementsArrayImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [elementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _alliance.delegate  = nil;
    _user.delegate       = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[_player release];
    [_alliance release];
    [globalResult release];
	[elementsArrayList release];
    [allianceAdminUserID release];
    [allianceId release];
    [pendingRequestsVC release];
    [elementsArrayImages release];
    
    [super dealloc];
}
#endif

@end
