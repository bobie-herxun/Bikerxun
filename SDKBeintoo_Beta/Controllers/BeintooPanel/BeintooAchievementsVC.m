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


#import "BeintooAchievementsVC.h"
#import "Beintoo.h"

@implementation BeintooAchievementsVC

@synthesize achievementsArrayList, achievementsImages, isFromNotification, popup;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"achievements",@"BeintooLocalizable",@"Wallet");
	
	[walletView setTopHeight:20];
	[walletView setBodyHeight:460];

	achievementsTable.delegate	= self;
	achievementsTable.rowHeight	= 70.0;
	walletLabel.text		= NSLocalizedStringFromTable(@"hereiswallet",@"BeintooLocalizable",@"");
	

	_achievements               = [[BeintooAchievements alloc] init];
	_player                     = [[BeintooPlayer alloc] init];
    archiveAchievements         = [[NSMutableArray alloc] init];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	self.achievementsArrayList = [[NSMutableArray alloc] init];
	self.achievementsImages    = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    _achievements.delegate	 = self;

    noAchievementsLabel.text		= NSLocalizedStringFromTable(@"noAchievementsLabel",@"BeintooLocalizable",@"");
    
    [self.achievementsArrayList removeAllObjects];
    [self.achievementsImages removeAllObjects];
    [achievementsTable reloadData];
    [noAchievementsLabel setHidden:YES];
    [achievementsTable deselectRowAtIndexPath:[achievementsTable indexPathForSelectedRow] animated:YES];
    [BLoadingView startActivity:self.view];
    [_achievements getAchievementsForCurrentUser];
}

#pragma mark -
#pragma mark Delegates

- (void)didGetAllUserAchievementsWithResult:(NSArray *)result
{    
	[self.achievementsArrayList removeAllObjects];
	[self.achievementsImages removeAllObjects];
	[noAchievementsLabel setHidden:YES];
	if ([result count] <= 0) {
		[noAchievementsLabel setHidden:NO];
	}
	if ([result isKindOfClass:[NSDictionary class]]) {
		[noAchievementsLabel setHidden:NO];
		[BLoadingView stopActivity];
		[achievementsTable reloadData];
		return;
	}
	
	for (int i = 0; i < [result count]; i++) {
        NSMutableDictionary *achievementEntry = [[NSMutableDictionary alloc] init];
        BImageDownload *download = [[BImageDownload alloc] init];
		
        @try {
			
			NSDictionary *currentAchievement = [[result objectAtIndex:i] objectForKey:@"achievement"];
            
			NSString *name          = [currentAchievement objectForKey:@"name"]; 
			NSString *description   = [currentAchievement objectForKey:@"description"]; 
			NSString *bedollarsVal	= [NSString stringWithFormat:@"%.0f", [[currentAchievement objectForKey:@"bedollars"] floatValue]];
			NSString *imageURL		= [currentAchievement objectForKey:@"imageURL"];
            
			NSString *blockedBy		= [currentAchievement objectForKey:@"blockedBy"];
			BOOL isBlockedByOthers = FALSE;
			if (blockedBy != nil) {
				isBlockedByOthers = TRUE;
			}
            
			download.delegate = self;
            
            if ([imageURL length] > 0) 
                download.urlString = [imageURL copy];
			
            if ([name length] > 0) 
                [achievementEntry setObject:name forKey:@"name"];
            
            if ([description length] > 0) 
                [achievementEntry setObject:description	forKey:@"description"];
            
            if ([bedollarsVal length] > 0) 
                [achievementEntry setObject:bedollarsVal forKey:@"bedollarsValue"];
            
            if ([imageURL length] > 0) 
                [achievementEntry setObject:imageURL forKey:@"imageURL"];
            
			if (isBlockedByOthers) {
				[achievementEntry setObject:blockedBy forKey:@"blockedBy"];
			}
            
			[achievementsArrayList addObject:achievementEntry];
			[achievementsImages addObject:download];
            
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException: %@ \n for object: %@", e, [result objectAtIndex:i]);
		}
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [download release];
        [achievementEntry release];
#endif
        
	}
    
    archiveAchievements = [result mutableCopy];
    
	[achievementsTable reloadData];
	[BLoadingView stopActivity];
    
    [self performSelector:@selector(updateProgress) withObject:nil afterDelay:0.2];
}

- (void)updateProgress
{
    for (int i = 0; i < [archiveAchievements count]; i++){
        if ([[archiveAchievements objectAtIndex:i] objectForKey:@"percentage"]){
            NSString *percentage   = [[archiveAchievements objectAtIndex:i] objectForKey:@"percentage"];
            [[achievementsArrayList objectAtIndex:i] setObject:percentage forKey:@"percentage"];
            NSUInteger indices[] = {0, i};
            NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            UITableViewCell *cell = [achievementsTable cellForRowAtIndexPath:path];
            for (UIView *subview in cell.subviews){
                if ([subview isKindOfClass:[UIProgressView class]]){
                    UIProgressView *progessView = (UIProgressView *)subview;
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                        [progessView setProgress:[percentage floatValue]/100 animated:YES];
                    else
                        [progessView setProgress:[percentage floatValue]/100];
                }
            }
        
#ifdef BEINTOO_ARC_AVAILABLE
        
#else
        [path release];
#endif
        
        }
        else if ([[[archiveAchievements objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"UNLOCKED"]) {
            [[achievementsArrayList objectAtIndex:i] setObject:@"100" forKey:@"percentage"];
            NSUInteger indices[] = {0, i};
            NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            UITableViewCell *cell = [achievementsTable cellForRowAtIndexPath:path];
            for (UIView *subview in cell.subviews){
                if ([subview isKindOfClass:[UIProgressView class]]){
                    UIProgressView *progessView = (UIProgressView *)subview;
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)   
                        [progessView setProgress:1.0 animated:YES];
                    else
                        [progessView setProgress:1.0];
                }
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
            
#else
            [path release];
#endif
            
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
	return [self.achievementsArrayList count];
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

		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 180, 18)];
		textLabel.text = [[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
		textLabel.font = [UIFont systemFontOfSize:13];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 180, 18)];
		detailTextLabel.text = [[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"description"];
		detailTextLabel.font = [UIFont systemFontOfSize:12];
		detailTextLabel.numberOfLines = 1;
		detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
		detailTextLabel.backgroundColor = [UIColor clearColor];
		detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UILabel *bedollars = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 70, 20)];
		bedollars.text = @"Bedollars";
		bedollars.font = [UIFont systemFontOfSize:11];
		bedollars.textColor = [UIColor colorWithWhite:0 alpha:0.6];
		bedollars.backgroundColor = [UIColor clearColor];
		bedollars.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
		bedollars.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
		
		NSString *value = [NSString stringWithFormat:@"%@", [[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"bedollarsValue"]]; 
		UILabel *bedollarsValue = [[UILabel alloc] initWithFrame:CGRectMake(240, 18, 70, 50)];
		bedollarsValue.text = [NSString stringWithFormat:@"+%@", value]; 
		bedollarsValue.font = [UIFont systemFontOfSize:20];
		bedollarsValue.textColor = [UIColor colorWithWhite:0 alpha:0.6];
		bedollarsValue.backgroundColor = [UIColor clearColor];
        bedollarsValue.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
		bedollarsValue.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
        bedollars.textAlignment = NSTextAlignmentRight;
        bedollarsValue.textAlignment = NSTextAlignmentRight;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            bedollars.textAlignment = NSTextAlignmentRight;
            bedollarsValue.textAlignment = NSTextAlignmentRight;
        }
        else
        {
            bedollars.textAlignment = UITextAlignmentRight;
            bedollarsValue.textAlignment = UITextAlignmentRight;
        }
#else
        bedollars.textAlignment = UITextAlignmentRight;
        bedollarsValue.textAlignment = UITextAlignmentRight;
#endif
        
		if ([value intValue] > 0) {
			[cell addSubview:bedollars];
			[cell addSubview:bedollarsValue];
		}
        
        UIProgressView *progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(70, 50, self.view.frame.size.width - 70 - 70, 40)];
        progressBar.progressViewStyle = UIProgressViewStyleBar;
        progressBar.opaque = YES;
        progressBar.progress = 0.0;
        
        if ([[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"percentage"]){
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [progressBar setProgress:([[[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"percentage"] floatValue] / 100) animated:NO];
            else
                [progressBar setProgress:([[[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"percentage"] floatValue] / 100)];
        }
        else if ([[[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"UNLOCKED"]){
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                [progressBar setProgress:1.0 animated:NO];
            else
                [progressBar setProgress:1.0];
        }
        
        [cell addSubview: progressBar];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [progressBar release];
#endif
        
		BImageDownload *download = [achievementsImages objectAtIndex:indexPath.row];
		UIImage *cellImage  = download.image;
        
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 55, 55)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.backgroundColor = [UIColor clearColor];
		[imageView setImage:cellImage];
		
		[cell addSubview:textLabel];
		[cell addSubview:detailTextLabel];
		[cell addSubview:imageView];
        
#ifdef BEINTOO_ARC_AVAILABLE    
#else
        [textLabel release];
		[detailTextLabel release];
		[imageView release];
		[bedollars release];
		[bedollarsValue release];
#endif
		
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[achievementsTable deselectRowAtIndexPath:[achievementsTable indexPathForSelectedRow] animated:NO];
    
    popup = [[BPopup alloc] initWithSuperview:self.view andAchievement:[achievementsArrayList objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [self.achievementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [achievementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _achievements.delegate   = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc
{

#ifdef BEINTOO_ARC_AVAILABLE
#else
    
    if ([popup retainCount] > 0)
        [popup release];
    
	[self.achievementsArrayList release];
	[self.achievementsImages	release];
	[_player release];
	[_achievements release];
    [archiveAchievements release];
    [super dealloc];
#endif
    
}

@end
