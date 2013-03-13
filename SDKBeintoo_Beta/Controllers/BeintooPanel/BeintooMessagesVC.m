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

#import "BeintooMessagesVC.h"
#import "Beintoo.h"

@implementation BeintooMessagesVC

@synthesize elementsTable, elementsArrayList, elementsImages, selectedMessage, startingOptions, isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
		cellsToLoad				= 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title			 	= NSLocalizedStringFromTable(@"inbox",@"BeintooLocalizable",@"Select A Friend");
	titleLabel.text			= NSLocalizedStringFromTable(@"yourMessages",@"BeintooLocalizable",@"Select A Friend");
	noMessagesLabel.text	= NSLocalizedStringFromTable(@"noMessages",@"BeintooLocalizable",@"Select A Friend");
	
	[messagesView setTopHeight:0];
	[messagesView setBodyHeight:417];
	
	_message				= [[BeintooMessage alloc] init];
	_player					= [[BeintooPlayer alloc] init];
	_user					= [[BeintooUser alloc] init];
	
	beintooMessageShowVC	= [BeintooMessagesShowVC alloc];
	newMessageVC			= [BeintooNewMessageVC alloc];
	
	self.elementsTable.delegate	= self;
	self.elementsTable.rowHeight	= 68.0;	
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];	
#endif
	
	self.elementsArrayList = [[NSMutableArray alloc] init];
	self.elementsImages    = [[NSMutableArray alloc] init];
    
    [toolBar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
	
	[newMessageButton setTitle:NSLocalizedStringFromTable(@"newMessage", @"BeintooLocalizable", nil)];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [noMessagesLabel setHidden:YES];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
	[self.elementsTable deselectRowAtIndexPath:[self.elementsTable indexPathForSelectedRow] animated:YES];
	
    _message.delegate		= self;
	_player.delegate	    = self;
	_user.delegate			= self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		NSString *guid = [Beintoo getPlayerID];
		[_player getPlayerByGUID:guid];
	}
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result
{
	if (result != nil) {
		[BeintooMessage setTotalMessages:[[result objectForKey:@"user"] objectForKey:@"messages"]];
		[BeintooMessage setUnreadMessages:[[result objectForKey:@"user"]objectForKey:@"unreadMessages"]];
	}
	
	[noMessagesLabel setHidden:YES];
	loadMoreCount = 0;
	
	[self.elementsArrayList removeAllObjects];
	[self.elementsImages removeAllObjects];
	
	[BLoadingView startActivity:self.view];
	[_message showMessagesFrom:MSGFORPAGE*loadMoreCount andRows:MSGFORPAGE];
}

#pragma mark -
#pragma mark IBActions

- (void)loadmoreMessages
{
	loadMoreCount = loadMoreCount + 1;
	[BLoadingView startActivity:self.view];
	[_message showMessagesFrom:MSGFORPAGE * loadMoreCount andRows:MSGFORPAGE];
}

- (IBAction)newMessage
{
	newMessageVC = [newMessageVC initWithNibName:@"BeintooNewMessageVC" bundle:[NSBundle mainBundle] andOptions:nil];
    if (isFromNotification)
        newMessageVC.isFromNotification = YES;
	[self.navigationController pushViewController:newMessageVC animated:YES];
}

#pragma mark -
#pragma mark MessageDelegate

- (void)didFinishToLoadMessagesWithResult:(NSArray *)result
{
	@try {
		if ([result count] <= 0) {
			[noMessagesLabel setHidden:NO];
		}
		if ([result isKindOfClass:[NSDictionary class]]) {
			BeintooLOG(@"error in messages:");
			[noMessagesLabel setHidden:NO];
			[BLoadingView stopActivity];
			[elementsTable reloadData];
			return;
		}
	}
	@catch (NSException * e) {
	}

	for (int i = 0; i < [result count]; i++) {	
		@try {
			NSMutableDictionary *messageEntry = [[NSMutableDictionary alloc]init];
			NSString *from			= [[[result objectAtIndex:i] objectForKey:@"userFrom"] objectForKey:@"nickname"];
			NSString *fromUserID	= [[[result objectAtIndex:i] objectForKey:@"userFrom"] objectForKey:@"id"];
			NSString *creationdate	= [[result objectAtIndex:i] objectForKey:@"creationdate"]; 
			NSString *text			= [[result objectAtIndex:i] objectForKey:@"text"];
			NSString *status		= [[result objectAtIndex:i] objectForKey:@"status"];
			NSString *messageID		= [[result objectAtIndex:i] objectForKey:@"id"];
			NSString *fromImgURL	= [[[result objectAtIndex:i] objectForKey:@"userFrom"] objectForKey:@"userimg"];
			
            
#ifdef BEINTOO_ARC_AVAILABLE
            BImageDownload *download = [[BImageDownload alloc] init];
#else
            BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
			
            download.delegate = self;
			download.urlString = [[[result objectAtIndex:i] objectForKey:@"userFrom"] objectForKey:@"usersmallimg"]; 
						
			[messageEntry setObject:messageID forKey:@"id"];
			[messageEntry setObject:fromUserID forKey:@"fromUserID"];
			[messageEntry setObject:fromImgURL forKey:@"fromImgURL"];
			[messageEntry setObject:from forKey:@"from"];
			[messageEntry setObject:creationdate forKey:@"creationdate"];
			[messageEntry setObject:text forKey:@"text"];
			[messageEntry setObject:status forKey:@"status"];
			[self.elementsArrayList addObject:messageEntry];
			[self.elementsImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [messageEntry release];
#endif
			
		}
		@catch (NSException * e) {
			BeintooLOG(@"exception %@",e);
		}
	}
	if ([self.elementsArrayList count] >= [BeintooMessage totalMessagesCount]) 
		cellsToLoad = [self.elementsArrayList count];
	else 
		cellsToLoad = [self.elementsArrayList count]+1;
	
	[self.elementsTable reloadData];
	[BLoadingView stopActivity];	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return cellsToLoad;
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
		if (indexPath.row == [self.elementsArrayList count]) {
			
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(5, 15, 310, 35);
			[button addTarget:self action:@selector(loadmoreMessages) forControlEvents:UIControlEventTouchUpInside];
			button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			button.backgroundColor = [UIColor clearColor];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitleColor:[UIColor colorWithRed:84.0/255 green:88.0/255 blue:89.0/255 alpha:1.0] forState:UIControlStateHighlighted];
			[button setTitle:NSLocalizedStringFromTable(@"loadmoreButton",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
			[cell addSubview:button];
		}
		else {
			NSString *creationDate = [BeintooNetwork convertToCurrentDate:[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"creationdate"]];
			BOOL isUnread = FALSE;
			if ([[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"UNREAD"]) {
				isUnread = YES;
                
                UIView *unreadView = [[BGradientView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 27.5, 27.5, 10, 10)];
                
                CAGradientLayer * gradient = [CAGradientLayer layer];
                [gradient setFrame:[unreadView bounds]];
                UIColor *lightBlue = [UIColor colorWithRed:134.0/255 green:177.0/255 blue:246.0/255 alpha:1.0];
                UIColor *blue = [UIColor colorWithRed:25.0/255 green:63.0/255 blue:163.0/255 alpha:1.0];
                
                [gradient setColors:[NSArray arrayWithObjects:(id)[lightBlue CGColor], (id)[blue CGColor], nil]];
                
                CALayer * roundRect = [CALayer layer];
                [roundRect setFrame:[unreadView bounds]];
                [roundRect setCornerRadius:5.0f];
                [roundRect setMasksToBounds:YES];
                [roundRect addSublayer:gradient];
                
                [[unreadView layer] insertSublayer:roundRect atIndex:0];
                
                [[unreadView layer] setShadowColor:[[UIColor blackColor] CGColor]];
                [[unreadView layer] setShadowOffset:CGSizeMake(0, 6)];
                [[unreadView layer] setShadowOpacity:1.0];
                [[unreadView layer] setShadowRadius:10.0];
                [[unreadView layer] setMasksToBounds:YES];
                
                [unreadView setClipsToBounds:YES];
                [[unreadView layer] setCornerRadius:5.0f];
                
                [cell addSubview:unreadView];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [unreadView release];
#endif
                
			}
			
			/* --- FROM --- */
			UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 230, 20)];
			NSString *fromText = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"from",@"BeintooLocalizable",@""),[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"from"]];
			fromLabel.text = fromText;
			if (isUnread) 
				fromLabel.font = [UIFont boldSystemFontOfSize:14];
			else 
				fromLabel.font = [UIFont systemFontOfSize:14];
			fromLabel.textColor = [UIColor colorWithRed:84.0/255 green:88.0/255 blue:89.0/255 alpha:1.0];
			fromLabel.backgroundColor = [UIColor clearColor];
			
			/* --- CREATION --- */		
			UILabel *creationDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 230, 20)];
			creationDateLabel.text = creationDate;
			if (isUnread) 
				creationDateLabel.font = [UIFont boldSystemFontOfSize:14];
			else 
				creationDateLabel.font = [UIFont systemFontOfSize:14];
			creationDateLabel.textColor = [UIColor colorWithRed:84.0/255 green:88.0/255 blue:89.0/255 alpha:1.0];
			creationDateLabel.backgroundColor = [UIColor clearColor];
			
			/* --- TEXT --- */
			UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 39, 230, 20)];
			textLabel.text = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"text"];
			if (isUnread){
				textLabel.font = [UIFont boldSystemFontOfSize:12];
				textLabel.textColor = [UIColor blackColor];
			}
			else{ 
				textLabel.font = [UIFont systemFontOfSize:12];
				textLabel.textColor = [UIColor colorWithRed:84.0/255 green:88.0/255 blue:89.0/255 alpha:1.0];
			}
			textLabel.backgroundColor = [UIColor clearColor];
			textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			BImageDownload *download = [self.elementsImages objectAtIndex:indexPath.row];
			UIImage *cellImage  = download.image;
			
			UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 50, 50)];
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.backgroundColor = [UIColor clearColor];
			[imageView setImage:cellImage];
			
			[cell addSubview:fromLabel];
			[cell addSubview:creationDateLabel];
			[cell addSubview:textLabel];
			[cell addSubview:imageView];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [fromLabel release];
			[creationDateLabel release];
			[textLabel release];
			[imageView release];
#endif
			
		}
	}
	@catch (NSException * e) {
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	@try {
		self.selectedMessage = [self.elementsArrayList objectAtIndex:indexPath.row];
		beintooMessageShowVC = [beintooMessageShowVC initWithNibName:@"BeintooMessagesShowVC" bundle:[NSBundle mainBundle] andOptions:self.selectedMessage];
        if (isFromNotification)
            beintooMessageShowVC.isFromNotification = YES;
		[self.navigationController pushViewController:beintooMessageShowVC animated:YES];
	}
	@catch (NSException * e) {
	}
}

#pragma mark TableViewLoadEndedDelegate

- (void)didEndLoadingTableData
{
	@try {
		NSIndexPath *indPath = [NSIndexPath indexPathForRow:(MSGFORPAGE * loadMoreCount) inSection:0];
		[self.elementsTable scrollToRowAtIndexPath:indPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	@catch (NSException * e) {
	}
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
    
    _message.delegate		= nil;
	_player.delegate	    = nil;
	_user.delegate			= nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc
{
    _user.delegate = nil;
    _message.delegate = nil;
    _player.delegate = nil;
    
    [_user release];
	[_message release];
	[_player release];
	[self.elementsArrayList release];
	[self.elementsImages release];
	[beintooMessageShowVC release];
	[newMessageVC release];
    [super dealloc];
}
#endif

@end
