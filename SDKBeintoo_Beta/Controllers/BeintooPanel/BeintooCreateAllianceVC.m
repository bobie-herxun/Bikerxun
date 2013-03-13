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

#import "BeintooCreateAllianceVC.h"
#import "Beintoo.h"

@implementation BeintooCreateAllianceVC

@synthesize elementsTable, elementsArrayList, elementsImages, selectedElement, startingOptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title		= NSLocalizedStringFromTable(@"alliancemaincreate",@"BeintooLocalizable",@"");
	
	[findFriendsView setTopHeight:105];
	[findFriendsView setBodyHeight:332];
	
	_player					= [[BeintooPlayer alloc] init];
    _alliance               = [[BeintooAlliance alloc] init];
    _user                   = [[BeintooUser alloc]init];
	
	elementsArrayList       = [[NSMutableArray alloc] init];
	elementsImages          = [[NSMutableArray alloc] init];
    selectedFriendsArray    = [[NSMutableArray alloc] init];
	
	self.elementsTable.delegate		= self;
	self.elementsTable.dataSource	= self;
	self.elementsTable.rowHeight	= 38.0;
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
		
	allianceTextField.delegate	= self;
	allianceTextField.textColor	= [UIColor colorWithWhite:0 alpha:0.7]; 
	allianceTextField.font		= [UIFont systemFontOfSize:12];
    allianceTextField.layer.cornerRadius = 3;
	allianceTextField.text = @"";
	allianceTextField.placeholder	= NSLocalizedStringFromTable(@"alliancecreateeditext",@"BeintooLocalizable",@"");
    titleLabel.text                 = NSLocalizedStringFromTable(@"allianceaddfriends",@"BeintooLocalizable",@"");
    titleLabel.textColor            = [UIColor colorWithWhite:0 alpha:0.6];
	noResultLabel.text              = @"You have no friends to invite";
	[noResultLabel setHidden:YES];
    
    [createAllianceButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[createAllianceButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[createAllianceButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [createAllianceButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[createAllianceButton setTitle:NSLocalizedStringFromTable(@"alliancemaincreate",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[createAllianceButton setButtonTextSize:15];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }

    _alliance.delegate      = self;
    _user.delegate          = self;
    
    [self.elementsArrayList removeAllObjects];

	if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [BLoadingView startActivity:self.view];
        [_user getFriendsByExtid];
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createAlliance
{
    NSString *allianceName = allianceTextField.text;
    
    if ([[allianceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] >= 3)
    {
        [BLoadingView startActivity:self.view];
        [_alliance createAllianceWithName:[allianceName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] andCreatorId:[Beintoo getUserID]];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"alliancenametooshort",@"BeintooLocalizable",@"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
    }
}

#pragma mark - 
#pragma mark Alliance delegate

- (void)didCreateAlliance:(NSDictionary *)result
{    
    NSString *justCreatedAllianceID = [result objectForKey:@"id"];
    if ( ([selectedFriendsArray count] > 0) && (justCreatedAllianceID != nil) ) {
        [_alliance allianceAdminInviteFriends:selectedFriendsArray onAlliance:justCreatedAllianceID];
    }
    else if (justCreatedAllianceID != nil){
        [BLoadingView stopActivity];
        
        NSString *alertMessage;
        UIAlertView *av = [UIAlertView alloc];
        
        alertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");
        av.tag = 321;
        av = [av initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
       
    }
    else {
        [BLoadingView stopActivity];
        NSString *alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
    }
}

- (void)didInviteFriendsToAllianceWithResult:(NSDictionary *)result
{
    [BLoadingView stopActivity];
    
    NSString *alertMessage;
    UIAlertView *av = [UIAlertView alloc];
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) {
		alertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");
        av.tag = 321;
    }
	else
		alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	av = [av initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
	
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [av release];
#endif
    
}

#pragma mark -
#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 321) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 
#pragma mark UserDelegate

- (void)didGetFriendsByExtid:(NSMutableArray *)result
{
    [BLoadingView stopActivity];
    noResultLabel.hidden = YES;  
    
    [Beintoo setBeintooUserFriends:(NSArray *)result];
    
    [self.elementsArrayList removeAllObjects];    
    self.elementsArrayList =  (NSMutableArray *)result;
    [self.elementsTable reloadData];
    
    if ([result count] <= 0) {
        noResultLabel.hidden = NO;
    }
}

#pragma mark -
#pragma mark UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	textField.font = [UIFont systemFontOfSize:14];
    textField.text = @"";
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];

	return YES;
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
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
	
    NSDictionary *currentElem = [self.elementsArrayList objectAtIndex:indexPath.row];
    
	cell.textLabel.text     = [currentElem objectForKey:@"nickname"];
	cell.textLabel.font     = [UIFont systemFontOfSize:13];
    cell.imageView.image    = [UIImage imageNamed:@"beintoo_user_icon.png"];
    
    if ([selectedFriendsArray containsObject:[currentElem objectForKey:@"id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *selectedUserID = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"id"]; 
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {  // Selecting friend
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (![selectedFriendsArray containsObject:selectedUserID]) {
            [selectedFriendsArray addObject:selectedUserID];
        }
    }
    else{                                                          // Deselecting friend
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        if ([selectedFriendsArray containsObject:selectedUserID]) {
            [selectedFriendsArray removeObject:selectedUserID];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
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
    [Beintoo dismissBeintoo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _alliance.delegate      = nil;
    _user.delegate          = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[elementsArrayList release];
	[elementsImages release];
    [selectedFriendsArray release];
    [_player release];
    [_alliance release];
    [super dealloc];
}
#endif

@end
