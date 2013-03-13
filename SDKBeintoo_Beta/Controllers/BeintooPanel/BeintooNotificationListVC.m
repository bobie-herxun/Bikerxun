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

#import "BeintooNotificationListVC.h"
#import "Beintoo.h"


@implementation BeintooNotificationListVC

@synthesize notificationTable, notificationArrayList, notificationImages, selectedNotification, startingOptions, isFromNotification;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title      = NSLocalizedStringFromTable(@"notifications", @"BeintooLocalizable", nil);
    
	mainView        = [[BView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [mainView setTopHeight:0];
	[mainView setBodyHeight:self.view.frame.size.height];
    
    self.view = mainView;
    mainView.autoresizesSubviews = YES;
    
    notificationTable = [[BTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, mainView.frame.size.height - 9)];
    notificationTable.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.notificationTable.delegate     = self;
    self.notificationTable.dataSource   = self;
	self.notificationTable.rowHeight	= 90.0;
    notificationTable.backgroundColor   = [UIColor clearColor];
	
    notificationArrayList = [[NSMutableArray alloc] init];
	notificationImages    = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];	
#endif
    
    _notification           = [[BeintooNotification alloc] init];
    _notification.delegate  = self;
    
    // ViewControllers initialization
    messagesVC              = [[BeintooMessagesVC alloc] initWithNibName:@"BeintooMessagesVC" bundle:[NSBundle mainBundle] andOptions:nil];
    friendRequestVC         = [[BeintooFriendRequestsVC alloc] initWithNibName:@"BeintooFriendRequestsVC" bundle:[NSBundle mainBundle] andOptions:nil];
    
    walletVC                = [[BeintooWalletVC alloc]initWithNibName:@"BeintooWalletVC" bundle:[NSBundle mainBundle]];
    challengesVC            = [[BeintooChallengesVC alloc]initWithNibName:@"BeintooChallengesVC" bundle:[NSBundle mainBundle]];
    achievementVC           = [[BeintooAchievementsVC alloc]initWithNibName:@"BeintooAchievementsVC" bundle:[NSBundle mainBundle]];
    pendigAllianceReqVC     = [BeintooAlliancePendingVC alloc];
    viewAllianceVC          = [[BeintooViewAllianceVC alloc] initWithNibName:@"BeintooViewAllianceVC" bundle:[NSBundle mainBundle] andOptions:nil];
    tipsAndForumVC          = [BeintooBrowserVC alloc];
	
    noNotificationLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 60)];
    noNotificationLabel.backgroundColor = [UIColor clearColor];
	noNotificationLabel.text            = [NSString stringWithFormat:NSLocalizedStringFromTable(@"noNotifications", @"BeintooLocalizable", @"")];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    noNotificationLabel.textAlignment = NSTextAlignmentCenter;
    noNotificationLabel.minimumScaleFactor = 2.0;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        noNotificationLabel.textAlignment = NSTextAlignmentCenter;
        noNotificationLabel.minimumScaleFactor = 2.0;
    }
    else
    {
        noNotificationLabel.textAlignment = UITextAlignmentCenter;
        noNotificationLabel.minimumFontSize = 8.0;
    }
#else
    noNotificationLabel.textAlignment = UITextAlignmentCenter;
    noNotificationLabel.minimumFontSize = 8.0;
#endif
    
    noNotificationLabel.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    noNotificationLabel.font            = [UIFont boldSystemFontOfSize:14];
    
    noNotificationLabel.numberOfLines   = 0;
    noNotificationLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.8];
        
    [mainView addSubview:notificationTable];
    [mainView addSubview:noNotificationLabel];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [notificationTable release];
    [noNotificationLabel release];
#endif

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [noNotificationLabel setHidden:YES];
    
    if ([BeintooDevice isiPad])
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    
    [BLoadingView startActivity:self.view];
    [_notification getNotificationListWithStart:0 andRows:50];
}

- (void)didGetNotificationListWithResult:(NSArray *)result
{
    [notificationArrayList removeAllObjects];
	[notificationImages removeAllObjects];

	[noNotificationLabel setHidden:YES];

	if ([result count] == 0) {
		[noNotificationLabel setHidden:NO];
	}
    
    if ([result isKindOfClass:[NSArray class]]) {
		for (int i = 0; i < [result count]; i++) {
            
            NSMutableDictionary *notificationEntry = [[NSMutableDictionary alloc] init];
            BImageDownload *download = [[BImageDownload alloc] init];
            
			@try {
                
				download.delegate = self;
                if ([[result objectAtIndex:i] objectForKey:@"image_url"])
                    download.urlString = [[result objectAtIndex:i] objectForKey:@"image_url"];
				
                if ([[result objectAtIndex:i] objectForKey:@"creationdate"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"creationdate"] forKey:@"creationDate"];
                
                if ([[result objectAtIndex:i] objectForKey:@"image_url"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"image_url"] forKey:@"image_url"];
				
                if ([[result objectAtIndex:i] objectForKey:@"localizedMessage"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"localizedMessage"] forKey:@"localizedMessage"];
                
                if ([[result objectAtIndex:i] objectForKey:@"status"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"status"] forKey:@"status"];
                
                if ([[result objectAtIndex:i] objectForKey:@"type"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"type"] forKey:@"type"];
                
                if ([[result objectAtIndex:i] objectForKey:@"id"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
                
                if ([[result objectAtIndex:i] objectForKey:@"url"])
                    [notificationEntry setObject:[[result objectAtIndex:i] objectForKey:@"url"] forKey:@"url"];
				
                [notificationArrayList addObject:notificationEntry];
				[notificationImages addObject:download];
                
            }
			@catch (NSException *e) {
				BeintooLOG(@"Beintoo Exception in Notifications: %@ \n for object: %@", e, [result objectAtIndex:i]);
			}
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [download release];
            [notificationEntry release];
#endif
            
		}
	}
    
    [notificationTable reloadData];
    
    if ([self.notificationArrayList count] > 0) {
        NSDictionary *lastNotification = [self.notificationArrayList objectAtIndex:0];
        if ([[lastNotification objectForKey:@"status"] isEqualToString:@"UNREAD"]) {
            NSString *notificationID = [lastNotification objectForKey:@"id"];
            [_notification setAllNotificationReadUpToNotification:notificationID];
        }
    }
    
    [BLoadingView stopActivity];
}

- (void)didSetNotificationReadWithResult:(NSArray *)result
{
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *textToMeasure = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"localizedMessage"];
    
    CGSize maximumLabelSize;
    if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)
        maximumLabelSize = CGSizeMake(220, 9999);
    else 
        maximumLabelSize = CGSizeMake(220, 9999);
    
    CGSize expectedLabelSize;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    else
        expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap]; 
#else
    expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
#endif
    
    if (expectedLabelSize.height < 30) {
        expectedLabelSize.height = 32;
    }
    
    return expectedLabelSize.height + 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [notificationArrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    NSString *notificationStatus    = [[self.notificationArrayList objectAtIndex:indexPath.row]objectForKey:@"status"];
   	int _gradientType = ([notificationStatus isEqualToString:@"UNREAD"]) ? GRADIENT_NOTIF_UNDREAD_CELL : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {

#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
    
    }
    
    NSString *textToMeasure     = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"localizedMessage"];
    
    CGSize maximumLabelSize;
    if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)
        maximumLabelSize = CGSizeMake(220, 9999);
    else 
        maximumLabelSize = CGSizeMake(220, 9999);
    
    CGSize expectedLabelSize;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    else
        expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
#else
    expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
#endif
    
    UIImageView *imageView      = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 50, 50)];
	
	BImageDownload *download    = [self.notificationImages objectAtIndex:indexPath.row];
	UIImage *cellImage          = download.image;
	imageView.image             = cellImage;
    
    [cell addSubview:imageView];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [imageView release];
#endif
        
    UILabel *messageLabel           = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, expectedLabelSize.width, expectedLabelSize.height)];
	messageLabel.text               = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"localizedMessage"];
	messageLabel.font               = [UIFont systemFontOfSize:13];
    messageLabel.textColor          = [UIColor colorWithWhite:0 alpha:1.0];
    
    if ([[[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"UNREAD"]) {
        messageLabel.font           = [UIFont boldSystemFontOfSize:12];
        messageLabel.textColor      = [UIColor colorWithWhite:0 alpha:0.9];
        
        UIView *unreadView = [[BGradientView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 27.5, (expectedLabelSize.height + 42 - 10)/2, 10, 10)];
        
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
    
    messageLabel.numberOfLines      = 0;
    messageLabel.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
    messageLabel.backgroundColor    = [UIColor clearColor];
    
    [cell addSubview:messageLabel];
    
    UILabel *notificationDate           = [[UILabel alloc] initWithFrame:CGRectMake(70, expectedLabelSize.height+11, 200, 15)];
	notificationDate.text               = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"creationDate"];
	notificationDate.font               = [UIFont systemFontOfSize:11];
    notificationDate.backgroundColor    = [UIColor clearColor];
    notificationDate.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
    
    [cell addSubview:notificationDate];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [messageLabel release];
    [notificationDate release];
#endif

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedNotification = [self.notificationArrayList objectAtIndex:indexPath.row];
	[self.notificationTable deselectRowAtIndexPath:[self.notificationTable indexPathForSelectedRow] animated:YES];	
    
    NSString *notificationType  = [self.selectedNotification objectForKey:@"type"];
    
    if ([notificationType isEqualToString:@"FRIENDSHIP_GOT"]) {
        // Friendship request to be accepted
        friendRequestVC.isFromNotification = YES;
        [self.navigationController pushViewController:friendRequestVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"FRIENDSHIP_ACCEPTED"]) {
        // Friendship request has been accepted - do nothing
    }
    else if ([notificationType isEqualToString:@"MESSAGE_NEW"]) {
        // New message to read
        messagesVC.isFromNotification = YES;
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
    else if([notificationType isEqualToString:@"CHALLENGE_INVITED"] || [notificationType isEqualToString:@"CHALLENGE_ACCEPTED"] 
             || [notificationType isEqualToString:@"CHALLENGE_WON"] || [notificationType isEqualToString:@"CHALLENGE_LOST"]) {
        
        challengesVC.isFromNotification = YES;
        [self.navigationController pushViewController:challengesVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"MISSION_COMPLETED"]) {
        // Do Nothing
    }
    else if ([notificationType isEqualToString:@"ALLIANCE_ACCEPTED"]) {
        // User has been accepted on alliance
        viewAllianceVC.isFromNotification = YES;
        [self.navigationController pushViewController:viewAllianceVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"ALLIANCE_ADMIN_PENDING"]) {
        // User alliance has to confirm new members
        NSDictionary *pendingOptions = [NSDictionary dictionaryWithObjectsAndKeys:[BeintooAlliance userAllianceID],@"allianceID",[Beintoo getUserID],@"allianceAdminID", nil];
        
        pendigAllianceReqVC = [pendigAllianceReqVC initWithNibName:@"BeintooAlliancePendingVC" bundle:[NSBundle mainBundle] andOptions:pendingOptions];
        pendigAllianceReqVC.isFromNotification = YES;
        [self.navigationController pushViewController:pendigAllianceReqVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"VGOOD_ASSIGNED"] || [notificationType isEqualToString:@"VGOOD_GIFTED"])  {
        // Vgood received
        walletVC.isFromNotification = YES;
        [self.navigationController pushViewController:walletVC animated:YES];
    }
    
    else if ([notificationType isEqualToString:@"FORUM_REPLIED"]) {
        // --------------- forum&tips
        NSString *tipsUrl = [NSString stringWithFormat:@"http://appsforum.beintoo.com/?apikey=%@&userExt=%@#main",
                             [Beintoo getApiKey],[Beintoo getUserID]];
        tipsAndForumVC = [tipsAndForumVC initWithNibName:@"BeintooBrowserVC" bundle:[NSBundle mainBundle] urlToOpen:nil];
        [tipsAndForumVC setUrlToOpen:tipsUrl];
        tipsAndForumVC.isFromNotification = YES;
        
        [self.navigationController pushViewController:tipsAndForumVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"ACHIEVEMENT_UNLOCKED"]) {
        achievementVC.isFromNotification = YES;
        [self.navigationController pushViewController:achievementVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"PUSH_REQUEST_MARKETPLACE"]){
        BeintooBestoreVC *bestoreVC = [[BeintooBestoreVC alloc] initWithNibName:@"BeintooBestoreVC" bundle:[NSBundle mainBundle]];
        bestoreVC.isFromNotification = YES;
        [self.navigationController pushViewController:bestoreVC animated:YES];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [bestoreVC release];
#endif
        
    }
    else if ([notificationType isEqualToString:@"BEINTOO_PROMOTIONAL"] || [notificationType isEqualToString:@"RECOMMEND_APP"]){
        if([self.selectedNotification objectForKey:@"url"] != nil){
            NSString *theUrl = [self.selectedNotification objectForKey:@"url"];
            BeintooVGoodShowVC *showUrl = [[BeintooVGoodShowVC alloc] initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:theUrl];
            showUrl.isFromNotification = YES;
            [self.navigationController pushViewController:showUrl animated:YES];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [showUrl release];
#endif
           
        }
    }
    else{
        // If the notification is not one of the standard case, we open a webview with an url received on the notification (if received)
        if([self.selectedNotification objectForKey:@"url"] != nil){
            NSString *tipsUrl = [self.selectedNotification objectForKey:@"url"];
            
            BeintooWebViewVC *webView = [[BeintooWebViewVC alloc] initWithNibName:@"BeintooWebViewVC" bundle:[NSBundle mainBundle] urlToOpen:tipsUrl];
            webView.isFromNotification = YES;
            [self.navigationController pushViewController:webView animated:YES];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [webView release];
#endif
            
        }
    }

    // ----- We verify if the message is unread and if yes mark it as read (on the server)
    NSString *status            = [self.selectedNotification objectForKey:@"status"];
    if ([status isEqualToString:@"UNREAD"]){
        [[self.notificationArrayList objectAtIndex:indexPath.row] setObject:@"READ" forKey:@"status"];
        [notificationTable reloadData];
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [self.notificationImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [notificationTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
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

#pragma mark - Close Notification

- (void)closeBeintoo
{
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == [Beintoo appOrientation]);
}
#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [pendigAllianceReqVC release];
    [viewAllianceVC release];
    [messagesVC release];
    [friendRequestVC release];
    [walletVC release];
    [challengesVC release];
    [achievementVC release];
    [tipsAndForumVC release];
	[_notification release];
	[notificationArrayList release];
	[notificationImages release];
    [noNotificationLabel release];
	[super dealloc];
}
#endif

@end
