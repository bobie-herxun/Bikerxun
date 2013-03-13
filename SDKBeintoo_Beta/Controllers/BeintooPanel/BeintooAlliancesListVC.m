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

#import "BeintooAlliancesListVC.h"
#import "Beintoo.h"

@implementation BeintooAlliancesListVC

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
	
	self.title		= NSLocalizedStringFromTable(@"alliancemainlist",@"BeintooLocalizable",@"Select A Friend");
	
	[findFriendsView setTopHeight:80];
	[findFriendsView setBodyHeight:332];
	
	_player					= [[BeintooPlayer alloc] init];
    _alliance               = [[BeintooAlliance alloc] init];
	
	elementsArrayList       = [[NSMutableArray alloc] init];
	elementsImages          = [[NSMutableArray alloc] init];
	
	self.elementsTable.delegate		= self;
	self.elementsTable.dataSource	= self;
	self.elementsTable.rowHeight	= 41.0;
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	friendTextField.delegate           = self;
	friendTextField.textColor          = [UIColor colorWithWhite:0 alpha:0.7]; 
	friendTextField.font               = [UIFont systemFontOfSize:14];
    friendTextField.layer.cornerRadius = 3;
	
	friendTextField.text		= NSLocalizedStringFromTable(@"allianceSearchFor",@"BeintooLocalizable",@"");
	noResultLabel.text			= NSLocalizedStringFromTable(@"noResult",@"BeintooLocalizable",@"");
	[noResultLabel setHidden:YES];
    
    viewAllianceVC              = [BeintooViewAllianceVC alloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }

    _alliance.delegate      = self;

	if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [BLoadingView startActivity:self.view];
        [_alliance getAllianceListWithQueryText:nil];
    }
}

#pragma mark - 
#pragma mark Alliance delegate

- (void)didGetAlliancesList:(NSArray *)result
{
    [BLoadingView stopActivity];
    noResultLabel.hidden = YES;    
    
    [self.elementsArrayList removeAllObjects];   
    
    if ([result isKindOfClass:[NSArray class]]) {
        self.elementsArrayList =  (NSMutableArray *)result;
    }
    [self.elementsTable reloadData];
    
    if ([result count] <= 0) {
        noResultLabel.hidden = NO;
    }
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
        if ([textField.text length]==0) {
            [BLoadingView startActivity:self.view];
			[_alliance getAllianceListWithQueryText:nil];	
        }
		if ([textField.text length]>0) {
			[BLoadingView startActivity:self.view];
			NSString *encodedString = [textField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
			[_alliance getAllianceListWithQueryText:encodedString];	
		}
		else {
			friendTextField.font	= [UIFont systemFontOfSize:12];
			friendTextField.text	= NSLocalizedStringFromTable(@"searchForTitle",@"BeintooLocalizable",@"");
		}
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
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
	
	cell.textLabel.text     = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.textLabel.font     = [UIFont systemFontOfSize:13];
    cell.imageView.image    = [UIImage imageNamed:@"beintoo_alliance_iconsmall.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *currentElem       = [self.elementsArrayList objectAtIndex:indexPath.row];
    NSString *selectedAllianceID    = [currentElem objectForKey:@"id"];
    NSString *selectedAllianceAdmin = [currentElem objectForKey:@"admin"];
    
    NSDictionary *optionsToSeeAlliance = [NSDictionary dictionaryWithObjectsAndKeys:selectedAllianceID,@"allianceID",selectedAllianceAdmin,@"allianceAdmin", nil];
    viewAllianceVC = [viewAllianceVC initWithNibName:@"BeintooViewAllianceVC" bundle:[NSBundle mainBundle] andOptions:optionsToSeeAlliance];
    
    [self.navigationController pushViewController:viewAllianceVC animated:YES];

}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    
    _player.delegate        = nil;
    _alliance.delegate      = nil;
    
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
    [_player release];
    [_alliance release];
    
    [super dealloc];
}
#endif

@end
