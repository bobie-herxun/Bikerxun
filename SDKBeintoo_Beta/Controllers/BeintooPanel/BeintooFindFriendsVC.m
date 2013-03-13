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

#import "BeintooFindFriendsVC.h"
#import "Beintoo.h"
#import "BeintooDevice.h"

@implementation BeintooFindFriendsVC

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
	
	self.title		= NSLocalizedStringFromTable(@"findFriends",@"BeintooLocalizable",@"Select A Friend");
	
	[findFriendsView setTopHeight:85];
	[findFriendsView setBodyHeight:332];
	
	_user					= [[BeintooUser alloc] init];
	_player					= [[BeintooPlayer alloc] init];
	
	elementsArrayList = [[NSMutableArray alloc] init];
	elementsImages    = [[NSMutableArray alloc] init];
	
	self.elementsTable.delegate		= self;
	self.elementsTable.dataSource	= self;
	self.elementsTable.rowHeight	= 75.0;
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];	
#endif
	
	friendTextField.delegate	= self;
	friendTextField.textColor	= [UIColor colorWithWhite:0 alpha:0.7]; 
	friendTextField.font		= [UIFont systemFontOfSize:12];
	
	friendTextField.text		= NSLocalizedStringFromTable(@"searchForTitle",@"BeintooLocalizable",@"");
	noResultLabel.text			= NSLocalizedStringFromTable(@"noResult",@"BeintooLocalizable",@"");
	[noResultLabel setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    _user.delegate			= self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	textField.font = [UIFont systemFontOfSize:16];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	@try {
		if ([textField.text length]>0) {
			[BLoadingView startActivity:self.view];
			NSString *encodedString = [textField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
			[_user getUsersByQuery:encodedString andSkipFriends:YES];	
		}
		else {
			friendTextField.font	= [UIFont systemFontOfSize:12];
			friendTextField.text	= NSLocalizedStringFromTable(@"searchForTitle",@"BeintooLocalizable",@"");
		}
	}
	@catch (NSException * e) {
		
	}
	return YES;
}


#pragma mark -
#pragma mark Delegates
- (void)didGetUserByQuery:(NSMutableArray *)result
{
	[self.elementsArrayList removeAllObjects];
	[self.elementsImages removeAllObjects];
	
	[noResultLabel setHidden:YES];
	
	if ([result count] <= 0) {
		[noResultLabel setHidden:NO];
	}
	
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
			[self.elementsArrayList addObject:friendsEntry];
			[self.elementsImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [friendsEntry release];
#endif
			
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException - FriendList: %@ \n for object: %@",e,[result objectAtIndex:i]);
        }
	}
	[BLoadingView stopActivity];
	[self.elementsTable reloadData];
}

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
	
	cell.textLabel.text = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
	cell.textLabel.font	= [UIFont systemFontOfSize:16];
	
	BImageDownload *download = [self.elementsImages objectAtIndex:indexPath.row];
	UIImage *cellImage  = download.image;
	cell.imageView.image = cellImage;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedElement = [self.elementsArrayList objectAtIndex:indexPath.row];
	
	NSString *selectedNick = [self.selectedElement objectForKey:@"nickname"];
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"addFriend",@"BeintooLocalizable",@""),selectedNick]
													delegate:self 
										   cancelButtonTitle:NSLocalizedStringFromTable(@"cancel",@"BeintooLocalizable",@"")
									  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"addAsFriend",@"BeintooLocalizable",@""),nil];
	as.actionSheetStyle = UIActionSheetStyleDefault;
	[as showInView:self.view];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [as release];
#endif
    
}

#pragma mark -
#pragma mark actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if(buttonIndex == 0){ // Add friend
		[BLoadingView startActivity:self.view];
		[_user sendFriendshipRequestTo:[self.selectedElement objectForKey:@"userExt"]];
	}
	if(buttonIndex == 1){ // Cancel
	}
	[self.elementsTable deselectRowAtIndexPath:[self.elementsTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [self.elementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [self.elementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
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
    
    _user.delegate			= self;
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
    [super dealloc];
}
#endif

@end
