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

#import "BeintooChallengesVC.h"
#import "Beintoo.h"

@implementation BeintooChallengesVC

@synthesize challengesArrayList,selectedChallenge,segControl,titleLabel,showChallengeVC,myImage,challengeImages, isFromNotification;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"challenges",@"BeintooLocalizable",@"Challenges");

	challengesTable.delegate	= self;
	challengesTable.rowHeight	= 60.0;
	
	[challengesView setTopHeight:40.0];
	[challengesView setBodyHeight:385.0];
	
	[segControl setTitle:NSLocalizedStringFromTable(@"pending",@"BeintooLocalizable",@"Pending") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedStringFromTable(@"ongoing",@"BeintooLocalizable",@"Ongoing") forSegmentAtIndex:1];
	[segControl setTitle:NSLocalizedStringFromTable(@"ended",@"BeintooLocalizable",@"Ended") forSegmentAtIndex:2];

    segControl.tintColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    [toolBar setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
	
	titleLabel.text = NSLocalizedStringFromTable(@"nochallenges",@"BeintooLocalizable",@"You don't have any challenge in this state");
	titleLabel1.text = NSLocalizedStringFromTable(@"hereare",@"BeintooLocalizable",@"Here are your challenges");
	titleLabel2.text = NSLocalizedStringFromTable(@"itstimeto",@"BeintooLocalizable",@"It's time to win!");
    
    sendNewChallengeButton.title = NSLocalizedStringFromTable(@"leadSendChall",@"BeintooLocalizable",nil);
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
			
	[self.titleLabel setHidden:YES];
	self.challengesArrayList    = [[NSMutableArray alloc] init];
    self.challengeImages        = [[NSMutableArray alloc] init];
	self.showChallengeVC        = [BeintooShowChallengeVC alloc];
    
    challengesPlayerFromImagesArray     = [[NSMutableArray alloc] init];
    challengesPlayerToImagesArray      = [[NSMutableArray alloc] init];

	user = [[BeintooUser alloc] init];
	_player = [[BeintooPlayer alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
	[self.titleLabel setHidden:YES];	
    
    user.delegate = self;
    
    [challengesTable reloadData];
	
	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		
		if (self.segControl.selectedSegmentIndex==0) 
			[user showChallengesbyStatus:CHALLENGES_TO_BE_ACCEPTED];	
		else if (self.segControl.selectedSegmentIndex==1) 
			[user showChallengesbyStatus:CHALLENGES_STARTED];
		else if (self.segControl.selectedSegmentIndex==2) 
			[user showChallengesbyStatus:CHALLENGES_ENDED];
	}
}

#pragma mark -
#pragma mark Delegates

- (void)didShowChallengesByStatus:(NSArray *)result
{    
    [self.challengesArrayList removeAllObjects];
    [self.challengeImages removeAllObjects];
    
    [challengesPlayerFromImagesArray removeAllObjects];
    [challengesPlayerToImagesArray removeAllObjects];
		
	if ([result count] == 0) {
		[titleLabel setHidden:NO];
	}else {
		[titleLabel setHidden:YES];
	}
    
    if (segControl.selectedSegmentIndex == 0 || segControl.selectedSegmentIndex == 1){
        titleLabel.text = NSLocalizedStringFromTable(@"nochallenges", @"BeintooLocalizable", nil);
    }
    else {
        titleLabel.text = NSLocalizedStringFromTable(@"noChallengesCompleted", @"BeintooLocalizable", nil);
    }

	if([result isKindOfClass:[NSDictionary class]]){
		NSDictionary *errorRes = (NSDictionary *)result;
		if ([errorRes objectForKey:@"kind"]!=nil) {
			[BLoadingView stopActivity];
			[self.titleLabel setHidden:NO];
			return;
		}
	}
	
	for (int i=0; i<[result count]; i++) {
		/*@try {
			NSMutableDictionary *challengeEntry = [[NSMutableDictionary alloc]init];
			
            NSString *imgUrlFrom = [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"usersmallimg"];
			NSString *imgUrlTo = [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"usersmallimg"];
			NSString *imgUrl;
            
			NSString *status		= [[result objectAtIndex:i] objectForKey:@"status"];
			NSString *playerFromScore;
			NSString *playerToScore;
			NSString *startDate;
			NSString *endDate;
			NSString *winner;
						
			if (![status isEqualToString:@"TO_BE_ACCEPTED"]) {
				playerFromScore	= [[result objectAtIndex:i] objectForKey:@"playerFromScore"];
				playerToScore	= [[result objectAtIndex:i] objectForKey:@"playerToScore"];
				startDate		= [[result objectAtIndex:i] objectForKey:@"startdate"];
				endDate         = [[result objectAtIndex:i] objectForKey:@"enddate"];
			}
			if ([status isEqualToString:@"ENDED"]) {
				winner			= [[[result objectAtIndex:i] objectForKey:@"winner"] objectForKey:@"user"];
			}
            
			NSString *playerFrom	= [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"nickname"];
			NSString *playerTo		= [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"nickname"];
			NSString *userExtFrom	= [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"id"];
			NSString *userExtTo		= [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"id"];
			NSString *contestName	= [[[result objectAtIndex:i] objectForKey:@"contest"] objectForKey:@"name"];
			NSString *contestCodeID = [[[result objectAtIndex:i] objectForKey:@"contest"] objectForKey:@"codeID"];
            
            NSString *actorId = [[[[result objectAtIndex:i] objectForKey:@"userActor"] objectForKey:@"user"] objectForKey:@"id"];
            NSString *type = [[result objectAtIndex:i] objectForKey:@"type"];

			if ([playerFrom isEqualToString:[[Beintoo getUserIfLogged] objectForKey:@"nickname"]]) {
				imgUrl = imgUrlTo;
			}else{ imgUrl = imgUrlFrom;}
                    
            BImageDownload *download         = [[[BImageDownload alloc] init] autorelease];
			download.delegate                = self;
			download.urlString               = imgUrl;

			NSString *price			= [[result objectAtIndex:i] objectForKey:@"price"];
			NSString *prize			= [[result objectAtIndex:i] objectForKey:@"prize"];
            NSString *targetScore   = [[result objectAtIndex:i] objectForKey:@"targetScore"];

			[challengeEntry setObject:playerFrom forKey:@"playerFrom"];
			[challengeEntry setObject:playerTo forKey:@"playerTo"];
			if (![status isEqualToString:@"TO_BE_ACCEPTED"]) {
				[challengeEntry setObject:playerFromScore forKey:@"playerFromScore"];
				[challengeEntry setObject:playerToScore forKey:@"playerToScore"];
				[challengeEntry setObject:startDate forKey:@"startDate"];
				[challengeEntry setObject:endDate forKey:@"endDate"];
			}
			if ([status isEqualToString:@"ENDED"]) {
				if (winner!=nil) {
					[challengeEntry setObject:winner forKey:@"winner"];
				}
			}
			[challengeEntry setObject:userExtFrom forKey:@"userExtFrom"];
			[challengeEntry setObject:userExtTo forKey:@"userExtTo"];
			[challengeEntry setObject:contestName forKey:@"contestName"];
			[challengeEntry setObject:contestCodeID forKey:@"contestCodeID"];
			[challengeEntry setObject:status forKey:@"status"];
            [challengeEntry setObject:price	forKey:@"price"];
			[challengeEntry setObject:prize forKey:@"prize"];
            
            [challengeEntry setObject:imgUrlFrom forKey:@"imgUrlFrom"];	
            [challengeEntry setObject:imgUrlTo forKey:@"imgUrlTo"];			
            
            if ( [[result objectAtIndex:i] objectForKey:@"targetScore"] != nil){
                [challengeEntry setObject:targetScore forKey:@"targetScore"];
            }
			
			[challengeEntry setObject:actorId forKey:@"actorId"];
            [challengeEntry setObject:type forKey:@"type"];
			
            [self.challengeImages addObject:download];
			[self.challengesArrayList addObject:challengeEntry];
			[challengeEntry release];
			
		}
		@catch (NSException * e) {
			//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			BeintooLOG(@"BeintooException: %@ \n for object: %@",e,[result objectAtIndex:i]);
		}
	}
	[BLoadingView stopActivity];
	[challengesTable reloadData];*/
        
        
        BImageDownload *downloadPlayerFrom = [[BImageDownload alloc] init];
        BImageDownload *downloadPlayerTo = [[BImageDownload alloc] init];
        
        NSMutableDictionary *challengeEntry = [[NSMutableDictionary alloc] init];
        
		@try {
			
			
			NSString *imgUrlFrom = [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"usersmallimg"];
			NSString *imgUrlTo = [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"usersmallimg"];
			
			NSString *status		= [[result objectAtIndex:i] objectForKey:@"status"];
			NSString *playerFromScore;
			NSString *playerToScore;
			NSString *startDate;
			NSString *endDate;
			NSString *winner;
			
			if (![status isEqualToString:@"TO_BE_ACCEPTED"]) {
				playerFromScore	= [[result objectAtIndex:i] objectForKey:@"playerFromScore"];
				playerToScore	= [[result objectAtIndex:i] objectForKey:@"playerToScore"];
				startDate		= [[result objectAtIndex:i] objectForKey:@"startdate"];
				endDate		= [[result objectAtIndex:i] objectForKey:@"enddate"];
			}
			if ([status isEqualToString:@"ENDED"]) {
				winner			= [[[result objectAtIndex:i] objectForKey:@"winner"] objectForKey:@"user"];
			}
			NSString *playerFrom	= [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"nickname"];
			NSString *playerTo		= [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"nickname"];
			NSString *userExtFrom	= [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"id"];
			NSString *userExtTo		= [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"id"];
			NSString *contestName	= [[[result objectAtIndex:i] objectForKey:@"contest"] objectForKey:@"name"];
			NSString *contestCodeID = [[[result objectAtIndex:i] objectForKey:@"contest"] objectForKey:@"codeID"];
			
            downloadPlayerFrom.urlString = imgUrlFrom;
            downloadPlayerFrom.delegate = self;
            downloadPlayerFrom.tag = 1;
            
            downloadPlayerTo.urlString = imgUrlTo;
            downloadPlayerTo.delegate = self;
            downloadPlayerTo.tag = 2;
            
            [challengeEntry setObject:playerFrom forKey:@"playerFrom"];
			[challengeEntry setObject:playerTo forKey:@"playerTo"];
            
			if (![status isEqualToString:@"TO_BE_ACCEPTED"]) {
				[challengeEntry setObject:playerFromScore forKey:@"playerFromScore"];
				[challengeEntry setObject:playerToScore forKey:@"playerToScore"];
				[challengeEntry setObject:startDate forKey:@"startDate"];
				[challengeEntry setObject:endDate forKey:@"endDate"];
			}
			if ([status isEqualToString:@"ENDED"]) {
				if (winner!=nil) {
					[challengeEntry setObject:winner forKey:@"winner"];
				}
			}
			[challengeEntry setObject:userExtFrom forKey:@"userExtFrom"];
			[challengeEntry setObject:userExtTo forKey:@"userExtTo"];
			[challengeEntry setObject:contestName forKey:@"contestName"];
			[challengeEntry setObject:contestCodeID forKey:@"contestCodeID"];
			[challengeEntry setObject:status forKey:@"status"];
			[challengeEntry setObject:downloadPlayerFrom forKey:@"imgPlayerFrom"];
            [challengeEntry setObject:downloadPlayerTo forKey:@"imgPlayerTo"];
            
            if ( [[result objectAtIndex:i] objectForKey:@"price"] )
                [challengeEntry setObject:[[result objectAtIndex:i] objectForKey:@"price"]	forKey:@"price"];
            
            if ( [[result objectAtIndex:i] objectForKey:@"prize"] )
                [challengeEntry setObject:[[result objectAtIndex:i] objectForKey:@"prize"] forKey:@"prize"];
            
			if ( [[result objectAtIndex:i] objectForKey:@"targetScore"] ){
                [challengeEntry setObject:[[result objectAtIndex:i] objectForKey:@"targetScore"] forKey:@"targetScore"];
            }
			
            if ( [[result objectAtIndex:i] objectForKey:@"userActor"] ){
                if ( [[[result objectAtIndex:i] objectForKey:@"userActor"] objectForKey:@"user"]){
                      if ( [[[[result objectAtIndex:i] objectForKey:@"userActor"] objectForKey:@"user"] objectForKey:@"id"] )
                        [challengeEntry setObject:[[[[result objectAtIndex:i] objectForKey:@"userActor"] objectForKey:@"user"] objectForKey:@"id"] forKey:@"actorId"];
                }
            }
            
            if ( [[result objectAtIndex:i] objectForKey:@"type"] )
                [challengeEntry setObject:[[result objectAtIndex:i] objectForKey:@"type"] forKey:@"type"];
            
            [challengesPlayerFromImagesArray addObject:downloadPlayerFrom];
            [challengesPlayerToImagesArray addObject:downloadPlayerTo];
			
			[challengesArrayList addObject:challengeEntry];            
            
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException: %@ \n for object: %@", e, [result objectAtIndex:i]);
		}
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [downloadPlayerFrom release];
        [downloadPlayerTo release];
        [challengeEntry release];
#endif
        
	}
    
    [challengesTable reloadData];
	[BLoadingView stopActivity];	
}

- (IBAction)sendNewChallenge
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"challenges", @"caller", nil];
    
    BeintooFriendsListVC *friendsListVC = [[BeintooFriendsListVC alloc] initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle] andOptions:options];
    
    [self.navigationController pushViewController:friendsListVC animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [friendsListVC release];
#endif
    
}

- (IBAction) segmentedControlIndexChanged
{
	switch (self.segControl.selectedSegmentIndex) {
		case 0:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[user showChallengesbyStatus:CHALLENGES_TO_BE_ACCEPTED];	
		}
			break;
		case 1:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[user showChallengesbyStatus:CHALLENGES_STARTED];	
		}
			break;
			
		case 2:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[user showChallengesbyStatus:CHALLENGES_ENDED];	
		}
			break;
			
		default:
			break;
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
	return [self.challengesArrayList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
    
   /* UILabel *textLabel              = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 230, 24)];
    textLabel.text                  = [NSString stringWithFormat:@"%@",[[self.challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"contestName"]];
    textLabel.font                  = [UIFont systemFontOfSize:18];
    textLabel.autoresizingMask      = UIViewAutoresizingFlexibleWidth;
    textLabel.backgroundColor       = [UIColor clearColor];
    
    NSString *detailString          = [NSString stringWithFormat:@"%@ %@ %@ %@",NSLocalizedStringFromTable(@"from",@"BeintooLocalizable",@""),[[self.challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"playerFrom"],NSLocalizedStringFromTable(@"to",@"BeintooLocalizable",@""),[[self.challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"playerTo"]];
    
    UILabel *detailTextLabel        = [[UILabel alloc] initWithFrame:CGRectMake(75, 34, 230, 20)];
    detailTextLabel.text            = detailString;
    detailTextLabel.textColor       = [UIColor grayColor];
    detailTextLabel.font            = [UIFont systemFontOfSize:13];
    detailTextLabel.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    detailTextLabel.backgroundColor = [UIColor clearColor];
    
    BImageDownload *download        = [self.challengeImages objectAtIndex:indexPath.row];

    UIImage *challengeImage         = download.image;
    UIImageView *imageView          = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 50, 50)];
    imageView.backgroundColor       = [UIColor clearColor];    
    imageView.image                 = challengeImage;

    [cell addSubview:imageView];
    [cell addSubview:textLabel];
    [cell addSubview:detailTextLabel];
    
    [imageView release];
    [textLabel release];
    [detailTextLabel release];*/
    
    UILabel *contestLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, self.view.frame.size.width - 120, 20)];
    contestLabel.backgroundColor = [UIColor clearColor];
    contestLabel.font = [UIFont systemFontOfSize:15];
    contestLabel.adjustsFontSizeToFitWidth = YES;
	contestLabel.text =  [NSString stringWithFormat:@"%@ %@ %@", [[challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"playerFrom"],
                          NSLocalizedStringFromTable(@"to",@"BeintooLocalizable",@""),
                          [[challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"playerTo"]];
    [cell addSubview:contestLabel];
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, self.view.frame.size.width - 120, 20)];
    detailsLabel.backgroundColor = [UIColor clearColor];
    detailsLabel.font = [UIFont systemFontOfSize:12];
    detailsLabel.adjustsFontSizeToFitWidth = YES;
	detailsLabel.text = [NSString stringWithFormat:@"%@",[[challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"contestName"]];
    
    [cell addSubview:detailsLabel];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    contestLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        contestLabel.textAlignment = NSTextAlignmentCenter;
        detailsLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        contestLabel.textAlignment = UITextAlignmentCenter;
        detailsLabel.textAlignment = UITextAlignmentCenter;
    }
#else
    contestLabel.textAlignment = UITextAlignmentCenter;
    detailsLabel.textAlignment = UITextAlignmentCenter;
#endif
    
    UIImageView *imageViewFrom = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    imageViewFrom.contentMode = UIViewContentModeScaleAspectFit;
    BImageDownload  *downloadPlayerFrom = [challengesPlayerFromImagesArray objectAtIndex:indexPath.row];
    downloadPlayerFrom.tag = 1;
	imageViewFrom.image = downloadPlayerFrom.image;
    [cell addSubview:imageViewFrom];
        
    UIImageView *imageViewTo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55, 5, 50, 50)];
    imageViewTo.contentMode = UIViewContentModeScaleAspectFit;
    BImageDownload  *downloadPlayerTo = [challengesPlayerToImagesArray objectAtIndex:indexPath.row];
    downloadPlayerFrom.tag = 2;
	imageViewTo.image = downloadPlayerTo.image;
    [cell addSubview:imageViewTo];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [contestLabel release];
    [detailsLabel release];
    [imageViewFrom release];
    [imageViewTo release];
#endif
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedChallenge = [self.challengesArrayList objectAtIndex:indexPath.row];
    
    self.showChallengeVC = [self.showChallengeVC initWithNibName:@"BeintooShowChallengeVC" bundle:[NSBundle mainBundle] andChallengeStatus:self.selectedChallenge];
	//NSString *devicePlayer = [[Beintoo getUserIfLogged] objectForKey:@"nickname"];
	/*if ([[self.selectedChallenge objectForKey:@"status"]isEqualToString:@"TO_BE_ACCEPTED"]) {
		if (![[self.selectedChallenge objectForKey:@"playerFrom"] isEqualToString:devicePlayer]){
			[self.navigationController pushViewController:self.showChallengeVC animated:YES];
		}
	}
	else 
	*/	
    
    [self.navigationController pushViewController:self.showChallengeVC animated:YES];

	[challengesTable deselectRowAtIndexPath:[challengesTable indexPathForSelectedRow] animated:YES];
}

#pragma mark - ImageDownload Delegate

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index;
    if (download.tag == 1)
        index = [challengesPlayerFromImagesArray indexOfObject:download]; 
    else if (download.tag == 2)
        index = [challengesPlayerToImagesArray indexOfObject:download]; 
    
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [challengesTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
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

#pragma mark - UIViewController end methods

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    user.delegate = nil;
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [challengesPlayerFromImagesArray     release];
    [challengesPlayerToImagesArray      release];
	[user release];
    [self.challengesArrayList release];
    [self.challengeImages release];
	[self.showChallengeVC release];
	[_player release];
    [super dealloc];
}
#endif

@end
