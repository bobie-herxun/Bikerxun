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


#import "BeintooVGoodVC.h"
#import "Beintoo.h"

@implementation BeintooVGoodVC

@synthesize homeSender,generatedVGood, theVirtualGood,startingOptions;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		theVirtualGood		= [[BVirtualGood alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Beintoo";
	
	registrationVC  = [BeintooVGoodShowVC alloc];
	[registrationVC setIsFromWallet:NO];
	friendsListVC   = [BeintooFriendsListVC alloc];
	beintooPlayer   = [[BeintooPlayer alloc] init];
	
	scrollView.contentSize	   = CGSizeMake(self.view.bounds.size.width, 400);
	scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
	
	endLabelTitle.text			= NSLocalizedStringFromTable(@"endDate",@"BeintooLocalizable",@"EndDate");
	whoAlsoConvertedTitle.text	= NSLocalizedStringFromTable(@"whoAlsoConverted",@"BeintooLocalizable",@"WhoAlso");
	titleLabel1.text			= NSLocalizedStringFromTable(@"congratulations",@"BeintooLocalizable",@"Congratulations!");
	
	[vgoodView setTopHeight:40];
	[vgoodView setBodyHeight:440];
	[vgoodView setIsScrollView:YES];
	[descView setGradientType:GRADIENT_HEADER];
	
	[whoAlsoConvertedTitle setHidden:YES];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	vgoodTable.delegate		  = self;
	vgoodTable.rowHeight	  = 45;
	
	[getCouponButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[getCouponButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[getCouponButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [getCouponButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[getCouponButton setTitle:NSLocalizedStringFromTable(@"getCoupon",@"BeintooLocalizable",@"Accept Coupon") forState:UIControlStateNormal];
	[getCouponButton setButtonTextSize:17];

	[sendAsAGiftButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[sendAsAGiftButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[sendAsAGiftButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [sendAsAGiftButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[sendAsAGiftButton setTitle:NSLocalizedStringFromTable(@"sendAsGift",@"BeintooLocalizable",@"Send as a gift") forState:UIControlStateNormal];
	[sendAsAGiftButton setButtonTextSize:17];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
	vgoodNameText.text		= self.theVirtualGood.vGoodName;
	vgoodEndDateLbl.text	= self.theVirtualGood.vGoodEndDate;
	vgoodDescrTextView.text	= self.theVirtualGood.vGoodDescription;
	[vgoodImageView setImage:[UIImage imageWithData:self.theVirtualGood.vGoodImageData]];
	
	if ([self.theVirtualGood.whoAlsoConverted count] > 0) {
		[whoAlsoConvertedTitle setHidden:NO];
	}
	
	/*
	 *  Check if the vgood is pushed from a multipleVgoodVC, if yes hides back button.
	 *
	NSArray *VCArray = self.navigationController.viewControllers;
	for (int i=0; i<[VCArray count]; i++) {
		if ([[VCArray objectAtIndex:i] isKindOfClass:[BeintooMultipleVgoodVC class]]) {
			[self.navigationItem setHidesBackButton:YES];
		}
	} */ // not needed anymore (at least now....)
	
	if (isThisVgoodConverted) {
		[self.navigationItem setHidesBackButton:YES];
	}
	
}

- (IBAction)getItReal
{
	isThisVgoodConverted = YES;
	
	NSString *getRealURLWithLocation = self.theVirtualGood.getItRealURL;
	NSString *locationParams = [Beintoo getUserLocationForURL];
	if (locationParams != nil) {
		getRealURLWithLocation = [self.theVirtualGood.getItRealURL stringByAppendingString:locationParams];
	}
	registrationVC = [registrationVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:getRealURLWithLocation];

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
	[[self navigationItem] setBackBarButtonItem: backButton];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [backButton release];
#endif
	
	[self.navigationController pushViewController:registrationVC animated:YES];	
}

- (IBAction)sendAsAGift
{
	if ([Beintoo getUserID] != nil){
		NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:self.theVirtualGood.vGoodID, @"vGoodID",@"sendAsAGift",@"caller",nil];
		friendsListVC = [friendsListVC  initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle] andOptions:options];
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"back",@"BeintooLocalizable",@"") style: UIBarButtonItemStyleBordered target:nil action:nil];
		[[self navigationItem] setBackBarButtonItem: backButton];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [backButton release];
#endif
				
		[self.navigationController pushViewController:friendsListVC animated:YES];
	}else {
		UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"unableToSendAsAGift",@"BeintooLocalizable",@"Send as a gift") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
		
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
	return [self.theVirtualGood.whoAlsoConverted count];
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
	
	cell.textLabel.text =  [[self.theVirtualGood.whoAlsoConverted objectAtIndex:indexPath.row] objectForKey:@"nickname"];
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	NSString *imgString = [[self.theVirtualGood.whoAlsoConverted objectAtIndex:indexPath.row] objectForKey:@"usersmallimg"];
	cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgString]]];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
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
	[Beintoo dismissPrize];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[theVirtualGood release];
	[registrationVC release];
	[friendsListVC release];
	[beintooPlayer release];
	[prizeBanner release];
	[generatedVGood release];
    [super dealloc];
}
#endif

@end
