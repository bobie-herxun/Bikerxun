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


#import "BeintooLeaderboardVC.h"
#import "Beintoo.h"

@implementation BeintooLeaderboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedStringFromTable(@"leaderboard",@"BeintooLocalizable",@"pickContest");
	//leaderboardLabel.text = NSLocalizedStringFromTable(@"pickacontest",@"BeintooLocalizable",@"pickContest");
	
	[leaderboardView setTopHeight:40];
	[leaderboardView setBodyHeight:387];
    
    [segControl setTitle:NSLocalizedStringFromTable(@"people",@"BeintooLocalizable", nil) forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedStringFromTable(@"alliances",@"BeintooLocalizable",@"Friends") forSegmentAtIndex:1];

    segControl.tintColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];

#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
    
	leaderboardsTable.delegate = self;
	leaderboardsTable.rowHeight = 55;
    
    leaderboardContestVC = [[BeintooLeaderboardContestVC alloc]initWithNibName:@"BeintooLeaderboardContestVC" bundle:[NSBundle mainBundle]];
    allianceLeaderboardVC = [[BeintooAlliancesLeaderboardVC alloc]initWithNibName:@"BeintooAlliancesLeaderboardVC" bundle:[NSBundle mainBundle]];
	
	contestListToShow	= [[NSMutableArray alloc] init];	
	allContests			= [[NSArray alloc] init];
	contestCodeID		= [[NSMutableArray alloc] init];
	player				= [[BeintooPlayer alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    player.delegate		= self;
	
    [leaderboardsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    if (segControl.selectedSegmentIndex == 0) {
        isAllianceLeaderboard = NO;
    }else if(segControl.selectedSegmentIndex == 1){
        isAllianceLeaderboard = YES;
    }
    
    [leaderboardsTable deselectRowAtIndexPath:[leaderboardsTable indexPathForSelectedRow] animated:animated];
	
    if ([contestListToShow count] <= 0) {
        [BLoadingView startActivity:self.view];
        [player showContestList];
    }
}

#pragma mark AppDelegate
- (void)appDidGetContestsForApp:(NSArray *)result
{
	allContests = result;
	
	NSString *defaultName = [[NSString alloc] init];
	[contestListToShow removeAllObjects];
    
	for (int i = 0; i < [allContests count]; i++) {
		@try {
			if ([[[allContests objectAtIndex:i] objectForKey:@"isPublic"] boolValue] == 1) {
				defaultName = [[allContests objectAtIndex:i] objectForKey:@"name"];
				[contestListToShow addObject:defaultName];
				[contestCodeID addObject:[[allContests objectAtIndex:i] objectForKey:@"codeID"]];
			}
		}
		@catch (NSException * e) {
			//[player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
		}
	}
	[BLoadingView stopActivity];
	[leaderboardsTable reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [contestListToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }

	NSString *contestName = [contestListToShow objectAtIndex:indexPath.row];
	if ([contestName isEqualToString:@"default"]) {
		contestName = @"General"; 
	}
	cell.textLabel.text  = [NSString stringWithFormat:@"%@", contestName];
	cell.textLabel.font  = [UIFont systemFontOfSize:17];
	cell.imageView.image = [UIImage imageNamed:@"beintoo_cup.png"];
    NSString *typeOf;
    
    if (segControl.selectedSegmentIndex == 0) {
        typeOf = NSLocalizedStringFromTable(@"people",@"BeintooLocalizable", nil);
    }
    else{
        typeOf = NSLocalizedStringFromTable(@"alliances",@"BeintooLocalizable",@"Friends");
    }
    cell.detailTextLabel.text = typeOf;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[NSUserDefaults standardUserDefaults] setObject:[contestCodeID objectAtIndex:indexPath.row] forKey:@"selectedContest"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"back",@"BeintooLocalizable",@"Backbutton") style: UIBarButtonItemStyleBordered target:nil action:nil];
	[[self navigationItem] setBackBarButtonItem: backButton];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [backButton release];
#endif
	
    if (isAllianceLeaderboard) {
        NSString *contestName = [contestListToShow objectAtIndex:indexPath.row];
        if ([contestName isEqualToString:@"default"]) {
            contestName = @"General"; 
        }
        allianceLeaderboardVC.title = contestName;
        
        [self.navigationController pushViewController:allianceLeaderboardVC animated:YES];
    }
    else{
        [self.navigationController pushViewController:leaderboardContestVC animated:YES];
    }
}

- (IBAction) segmentedControlIndexChanged
{
	switch (segControl.selectedSegmentIndex) {
		case 0:{
            isAllianceLeaderboard = NO;
            [leaderboardsTable reloadData];
		}
			break;
		case 1:{
            isAllianceLeaderboard = YES;
            [leaderboardsTable reloadData];
		}
			break;
			
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    player.delegate    = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[contestListToShow release];
    //[leaderboardContestVC release];
    [allianceLeaderboardVC release];
	//[allContests release];
	[contestCodeID release];
	[player release];
    [super dealloc];
}
#endif

@end
