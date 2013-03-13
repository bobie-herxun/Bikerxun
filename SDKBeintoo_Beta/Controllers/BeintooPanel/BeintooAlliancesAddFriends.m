//
//  BeintooAlliancesAddFriends.m
//  SampleBeintoo
//
//  Created by Giuseppe Piazzese on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeintooAlliancesAddFriends.h"
#import "Beintoo.h"

@implementation BeintooAlliancesAddFriends
@synthesize startingOptions, isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSMutableArray *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([BeintooDevice isiPad]) {
       [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    noResultLabel.text	= NSLocalizedStringFromTable(@"noFriendsAlliance", @"BeintooLocalizable", nil);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    noResultLabel.minimumScaleFactor = 2.0;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        noResultLabel.minimumScaleFactor = 2.0;
    else
        noResultLabel.minimumFontSize = 8.0;
#else
    noResultLabel.minimumFontSize = 8.0;
#endif
    
    noResultLabel.numberOfLines   = 0;
    
	barButton.title     = NSLocalizedStringFromTable(@"done", @"BeintooLocalizable", nil);
    
	[friendsActionView setTopHeight:30];
	[friendsActionView setBodyHeight:397];
	
	_alliance				= [[BeintooAlliance	alloc] init];
    _user                   = [[BeintooUser	alloc] init];
	
    elementsArray           = [[NSMutableArray alloc] init];
    imagesArray             = [[NSMutableArray alloc] init];
    selectedFriends         = [[NSMutableArray alloc] init];
    
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
	elementsTable.delegate		= self;
	elementsTable.dataSource    = self;
	elementsTable.rowHeight     = 40.0;	
    
    _alliance.delegate          = self;
    _user.delegate              = self;
    
    [toolBar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
        [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y + 12, toolBar.frame.size.width, 32);
        elementsTable.frame = CGRectMake(elementsTable.frame.origin.x, elementsTable.frame.origin.y, elementsTable.frame.size.width, elementsTable.frame.size.height + 12);
    }
    else {
        toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y, toolBar.frame.size.width, 44);
        elementsTable.frame = CGRectMake(elementsTable.frame.origin.x, elementsTable.frame.origin.y, elementsTable.frame.size.width, elementsTable.frame.size.height);
    }
    
    if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [BLoadingView startActivity:self.view];
        [_user getFriendsByExtid];
    }
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc{
    [elementsArray release];
    [imagesArray release];
    [selectedFriends release];
    [_alliance release];
    [_user release];
    
    if ([startingOptions retainCount] > 0)
        [startingOptions release];
    
    [super dealloc];
}
#endif

#pragma mark - 
#pragma mark User Callbacks

- (void)didGetFriendsByExtid:(NSMutableArray *)result
{    
    [BLoadingView stopActivity];
    noResultLabel.hidden = YES;    
    
    [elementsArray removeAllObjects];  
    
    [Beintoo setBeintooUserFriends:(NSArray *)result];
    
    for (int i = 0; i < [result count]; i++){
        
        BImageDownload *download = [[BImageDownload alloc] init];
        download.urlString = [[result objectAtIndex:i] objectForKey:@"userimg"];
        [imagesArray addObject:download];
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [download release];
#endif
        
        [elementsArray addObject:[result objectAtIndex:i]];
    }
    
    [elementsTable reloadData];
    
    if ([result count] <= 0) {
        noResultLabel.hidden = NO;
    }
}

- (IBAction)addToAlliance
{    
    if ( [selectedFriends count] > 0 ){
        [BLoadingView startActivity:self.view];
        [_alliance allianceAdminInviteFriends:selectedFriends onAlliance:[BeintooAlliance userAllianceID]];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 321)
        [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [elementsArray count];
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
    
	@try {
        NSDictionary *currentElem = [elementsArray objectAtIndex:indexPath.row];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(45, 9, 250, 20)];
        labelName.text         = [[elementsArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        labelName.font         = [UIFont systemFontOfSize:13];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        labelName.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            labelName.textAlignment = NSTextAlignmentLeft;
        else
            labelName.textAlignment = UITextAlignmentLeft;
#else
        labelName.textAlignment = UITextAlignmentLeft;
#endif
        
        labelName.backgroundColor = [UIColor clearColor];
        [cell addSubview:labelName];
        
        BImageDownload *download    = [imagesArray objectAtIndex:indexPath.row];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 2, 33, 33)];
        imageView.image        = download.image;
        [cell addSubview:imageView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        for (int y = 0; y < [startingOptions count]; y++){
            if ([[[startingOptions objectAtIndex:y] objectForKey:@"id"] isEqualToString:[[elementsArray objectAtIndex:indexPath.row] objectForKey:@"id"]]){
                labelName.alpha = 0.4;   
                imageView.alpha = 0.4;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            }
        }
        
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
        [labelName release];
        [imageView release];
#endif
        
        if ([selectedFriends containsObject:[currentElem objectForKey:@"id"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception %@", exception);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *selectedUserID = [[elementsArray objectAtIndex:indexPath.row] objectForKey:@"id"]; 
    
    BOOL isAlreadyInTheAlliance = NO;
    
    for (int y = 0; y < [startingOptions count]; y++){
        if ([[[startingOptions objectAtIndex:y] objectForKey:@"id"] isEqualToString:[[elementsArray objectAtIndex:indexPath.row] objectForKey:@"id"]]){
            isAlreadyInTheAlliance = YES;
            break;
        }
    }
    
    if (isAlreadyInTheAlliance == NO){
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) {  // Selecting friend
            thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
            if (![selectedFriends containsObject:selectedUserID]) {
                [selectedFriends addObject:selectedUserID];
            }
        }
        else{                                                          // Deselecting friend
            thisCell.accessoryType = UITableViewCellAccessoryNone;
            if ([selectedFriends containsObject:selectedUserID]) {
                [selectedFriends removeObject:selectedUserID];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [imagesArray indexOfObject:download]; 
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

@end
