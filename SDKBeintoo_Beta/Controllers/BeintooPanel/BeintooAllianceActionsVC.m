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

#import "BeintooAllianceActionsVC.h"
#import "Beintoo.h"

@implementation BeintooAllianceActionsVC

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
	
	self.title		= NSLocalizedStringFromTable(@"alliances",@"BeintooLocalizable",@"");
	
	[alliancesActionView setTopHeight:20];
	[alliancesActionView setBodyHeight:457];
	
	elementsArrayList   = [[NSMutableArray alloc] init];
	_player				= [[BeintooPlayer alloc] init];
		
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [barCloseBtn release];
#endif
		
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 85.0;	
    
    UILabel *allianceTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 70)];
    allianceTipsLabel.text              = NSLocalizedStringFromTable(@"alliancemaintextfooter",@"BeintooLocalizable",@"");
    allianceTipsLabel.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    allianceTipsLabel.textAlignment = NSTextAlignmentCenter;   
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        allianceTipsLabel.textAlignment = NSTextAlignmentCenter;
    else
        allianceTipsLabel.textAlignment = UITextAlignmentCenter;
#else
    allianceTipsLabel.textAlignment = UITextAlignmentCenter;
#endif
    
    allianceTipsLabel.textColor         = [UIColor colorWithWhite:0 alpha:0.7];
    allianceTipsLabel.font              = [UIFont systemFontOfSize:13];
    allianceTipsLabel.backgroundColor   = [UIColor clearColor];
    allianceTipsLabel.numberOfLines     = 3;
    
    [self.view addSubview:allianceTipsLabel];
    [self.view sendSubviewToBack:allianceTipsLabel];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [allianceTipsLabel release];
#endif
    
    viewAllianceVC      = [[BeintooViewAllianceVC alloc] initWithNibName:@"BeintooViewAllianceVC" bundle:[NSBundle mainBundle] andOptions:nil];
    allianceListVC      = [[BeintooAlliancesListVC alloc] initWithNibName:@"BeintooAlliancesListVC" bundle:[NSBundle mainBundle] andOptions:nil];
    allianceCreateVC    = [[BeintooCreateAllianceVC alloc] initWithNibName:@"BeintooCreateAllianceVC" bundle:[NSBundle mainBundle] andOptions:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }

    _player.delegate    = self;

	if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [_player getPlayerByGUID:[Beintoo getPlayerID]];
    }
    
    [elementsArrayList removeAllObjects];
    [elementsArrayList addObject:@"alliance_create"];
    [elementsArrayList addObject:@"alliance_list"];
    
    if([BeintooAlliance userHasAlliance]){
        [elementsArrayList removeAllObjects];
        [elementsArrayList addObject:@"alliance_your"];
        [elementsArrayList addObject:@"alliance_list"];
    }
    
    [elementsTable reloadData];
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result
{    
    if ([result objectForKey:@"user"] != nil){
        [Beintoo setBeintooPlayer:result];
    }
    
    // Alliance check
    if ([result objectForKey:@"alliance"] != nil) {
        [BeintooAlliance setUserWithAlliance:YES];
    }
    else{
        [BeintooAlliance setUserWithAlliance:NO];
    }
    
    [elementsArrayList removeAllObjects];
    [elementsArrayList addObject:@"alliance_create"];
    [elementsArrayList addObject:@"alliance_list"];
    
    if([BeintooAlliance userHasAlliance]){
        [elementsArrayList removeAllObjects];
        [elementsArrayList addObject:@"alliance_your"];
        [elementsArrayList addObject:@"alliance_list"];
    }
    
    [BLoadingView stopActivity];
    [elementsTable reloadData];

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
	NSString *choicheDesc			= [NSString stringWithFormat:@"%@Desc", choicheCode];
	cell.textLabel.text				= NSLocalizedStringFromTable(choicheCode, @"BeintooLocalizable", nil);
	cell.textLabel.font				= [UIFont systemFontOfSize:16];
	cell.detailTextLabel.text		= NSLocalizedStringFromTable(choicheDesc,@"BeintooLocalizable",@"");;
	cell.detailTextLabel.font		= [UIFont systemFontOfSize:14];

	cell.imageView.image	= [UIImage imageNamed:[NSString stringWithFormat:@"beintoo_%@.png", choicheCode]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *selectedElem = [self.elementsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
        if ([selectedElem isEqualToString:@"alliance_your"]) {
            viewAllianceVC.isMineAlliance = YES;
            [self.navigationController pushViewController:viewAllianceVC animated:YES];
        }
        if ([selectedElem isEqualToString:@"alliance_create"]) {
            [self.navigationController pushViewController:allianceCreateVC animated:YES];
        }
	}
	else if (indexPath.row == 1) {
        [self.navigationController pushViewController:allianceListVC animated:YES];

    }
	else if	(indexPath.row == 2){
	
    }
	else if (indexPath.row == 3){
	
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

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

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _player.delegate    = nil;
    
    @try {
        [BLoadingView stopActivity];
    }
    @catch (NSException * e) {
    }  
}

#ifdef BEINTOO_ARC_AVAILABLE

#else
- (void)dealloc {
	[_player release];
	[elementsArrayList release];
    [viewAllianceVC release];
    [super dealloc];
}
#endif

@end
