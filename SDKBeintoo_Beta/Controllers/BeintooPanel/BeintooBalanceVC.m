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

#import "BeintooBalanceVC.h"
#import "Beintoo.h"

@implementation BeintooBalanceVC

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
	
	self.title		= NSLocalizedStringFromTable(@"balance",@"BeintooLocalizable",@"");
	titleLabel.text = NSLocalizedStringFromTable(@"balanceTitle",@"BeintooLocalizable",@"");
	noBalanceLabel.text		= NSLocalizedStringFromTable(@"nobalancelabel",@"BeintooLocalizable",@"Select A Friend");
	
	[balanceView setTopHeight:40];
	[balanceView setBodyHeight:377];
	
	_user					= [[BeintooUser alloc] init];
	_player					= [[BeintooPlayer alloc] init];
	
	self.elementsArrayList = [[NSMutableArray alloc] init];
	self.elementsImages    = [[NSMutableArray alloc] init];	
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 75.0;	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
	[noBalanceLabel setHidden:YES];
    
    _user.delegate			= self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		[_user getBalanceFrom:0 andRowns:20];
	}
}

#pragma mark -
#pragma mark Delegates

- (void)didGetBalance:(NSMutableArray *)result
{
	[self.elementsArrayList removeAllObjects];
	[self.elementsImages removeAllObjects];
	
	if ([result count] <= 0) {
		[noBalanceLabel setHidden:NO];
	}
	
	for (int i = 0; i < [result count]; i++) {
		@try {
			NSMutableDictionary *balanceEntry = [[NSMutableDictionary alloc]init];
			NSString *appName	 = [[[result objectAtIndex:i] objectForKey:@"app"] objectForKey:@"name"];
			NSString *movReason	 = [[result objectAtIndex:i] objectForKey:@"reason"];
			NSString *movValue	 = [[result objectAtIndex:i] objectForKey:@"value"];
			NSString *movDate	 = [[result objectAtIndex:i] objectForKey:@"creationdate"];
			
#ifdef BEINTOO_ARC_AVAILABLE
            BImageDownload *download = [[BImageDownload alloc] init];
#else
            BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
			
			download.delegate = self;
			download.urlString = [[[result objectAtIndex:i] objectForKey:@"app"] objectForKey:@"imageSmallUrl"];
			
			[balanceEntry setObject:appName forKey:@"appName"];
			[balanceEntry setObject:movReason forKey:@"movReason"];
			[balanceEntry setObject:movValue forKey:@"movValue"];
			[balanceEntry setObject:movDate forKey:@"movDate"];
			[self.elementsArrayList addObject:balanceEntry];
			[self.elementsImages addObject:download];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [balanceEntry release];
#endif
			
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException: %@ \n for object: %@",e,[result objectAtIndex:i]);
		}
	}
	[BLoadingView stopActivity];
	[self.elementsTable reloadData];
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
	
	UILabel *textLabel			= [[UILabel alloc] initWithFrame:CGRectMake(77, 8, 230, 20)];
	textLabel.text				= [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"appName"];
	textLabel.font				= [UIFont systemFontOfSize:15];
	textLabel.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	textLabel.backgroundColor	= [UIColor clearColor];
	textLabel.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	
	UILabel *detailTextLabel			= [[UILabel alloc] initWithFrame:CGRectMake(77, 30, 230, 20)];
	detailTextLabel.text				= [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"movDate"];
	detailTextLabel.font				= [UIFont systemFontOfSize:12];
	detailTextLabel.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	detailTextLabel.backgroundColor		= [UIColor clearColor];
	detailTextLabel.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	
	UILabel *detailTextLabel2			= [[UILabel alloc] initWithFrame:CGRectMake(77, 46, 230, 20)];
	NSString *movReason					= NSLocalizedStringFromTable([[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"movReason"],@"BeintooLocalizable",@"Select A Friend");
	detailTextLabel2.text				= movReason;
	detailTextLabel2.font				= [UIFont systemFontOfSize:12];
	detailTextLabel2.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	detailTextLabel2.backgroundColor	= [UIColor clearColor];
	detailTextLabel2.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	
	UILabel *movValue			= [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 70, 50)];
	NSString *value				= [NSString stringWithFormat:@"%@",[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"movValue"]];
	if ([value rangeOfString:@"-"].length <= 0) {
		value = [NSString stringWithFormat:@"+%@",value];
	}
	movValue.text				= value;
	movValue.font				= [UIFont systemFontOfSize:21];
	movValue.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	movValue.backgroundColor	= [UIColor clearColor];
	movValue.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    movValue.textAlignment = NSTextAlignmentRight;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        movValue.textAlignment = NSTextAlignmentRight;
    else
        movValue.textAlignment = UITextAlignmentRight;
#else
    movValue.textAlignment = UITextAlignmentRight;
#endif
    
    movValue.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
	
	BImageDownload *download	= [self.elementsImages objectAtIndex:indexPath.row];
	UIImage *cellImage			= download.image;
	
	UIImageView *imageView		= [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 50, 50)];
	imageView.contentMode		= UIViewContentModeScaleAspectFit;
	imageView.backgroundColor	= [UIColor clearColor];
	[imageView setImage:cellImage];
	
	[cell addSubview:textLabel];
	[cell addSubview:detailTextLabel];
	[cell addSubview:detailTextLabel2];
	[cell addSubview:movValue];
	[cell addSubview:imageView];
	
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [textLabel release];
	[detailTextLabel release];
	[imageView release];
	[detailTextLabel2 release];
	[movValue release];
#endif
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    _user.delegate      = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE

#else
- (void)dealloc {
	[_user release];
	[_player release];
	[self.elementsArrayList release];
	[self.elementsImages release];
    [super dealloc];
}
#endif

@end
