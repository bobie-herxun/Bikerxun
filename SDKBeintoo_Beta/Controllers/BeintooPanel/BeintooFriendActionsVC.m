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

#import "BeintooFriendActionsVC.h"
#import "Beintoo.h"

@implementation BeintooFriendActionsVC

@synthesize elementsTable, elementsArrayList, selectedElement, startingOptions;

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
	
	self.title		= NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"Select A Friend");
	
	[friendsActionView setTopHeight:20];
	[friendsActionView setBodyHeight:417];
	
	elementsArrayList = [[NSMutableArray alloc] init];
	_player				= [[BeintooPlayer alloc] init];
	friendsVC			= [BeintooFriendsListVC alloc];
	findFriendsVC		= [BeintooFindFriendsVC alloc];
	friendRequestsVC	= [BeintooFriendRequestsVC alloc];
	recommendToAFriendVC = [[BeintooWebViewVC alloc] initWithNibName:@"BeintooWebViewVC" bundle:[NSBundle mainBundle] urlToOpen:@"http://sdk-mobile.beintoo.com/rtaf/"];
		
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
		
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 85.0;	
	
	self.elementsArrayList = [NSArray arrayWithObjects:@"yourFriends",@"findFriends",@"friendRequests",@"recommendToAFriend",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];

	//[self.elementsTable reloadData];
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
	
	NSString *choicheCode			= [self.elementsArrayList objectAtIndex:indexPath.row];
	NSString *choicheDesc			= [NSString stringWithFormat:@"%@Desc",choicheCode];
	cell.textLabel.text				= NSLocalizedStringFromTable(choicheCode,@"BeintooLocalizable",@"Select A Friend");;
	cell.textLabel.font				= [UIFont systemFontOfSize:16];
	cell.detailTextLabel.text		= NSLocalizedStringFromTable(choicheDesc,@"BeintooLocalizable",@"");;
	cell.detailTextLabel.font		= [UIFont systemFontOfSize:14];

	cell.imageView.image	= [UIImage imageNamed:[NSString stringWithFormat:@"beintoo_%@.png",choicheCode]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//self.selectedFriend = [self.friendsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
		NSDictionary *friendsListOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"profile",@"caller",nil,@"callerVC",nil];
		friendsVC = [friendsVC initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle] andOptions:friendsListOptions];
		[self.navigationController pushViewController:friendsVC animated:YES];
	}
	else if (indexPath.row == 1) {
		NSDictionary *findFriendsOptions = nil;
		findFriendsVC = [findFriendsVC initWithNibName:@"BeintooFindFriendsVC" bundle:[NSBundle mainBundle] andOptions:findFriendsOptions];
		[self.navigationController pushViewController:findFriendsVC animated:YES];		
	}
	else if	(indexPath.row == 2){
		NSDictionary *friendRequestsOptions = nil;
		friendRequestsVC = [friendRequestsVC initWithNibName:@"BeintooFriendRequestsVC" bundle:[NSBundle mainBundle] andOptions:friendRequestsOptions];
		[self.navigationController pushViewController:friendRequestsVC animated:YES];		
	}
	else if (indexPath.row == 3){
		[self.navigationController pushViewController:recommendToAFriendVC animated:YES];
	}
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

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

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[_player release];
	[friendsVC release];
	[findFriendsVC release];
	[friendRequestsVC release];
	[recommendToAFriendVC release];
	[elementsArrayList release];
    [super dealloc];
}
#endif

@end
