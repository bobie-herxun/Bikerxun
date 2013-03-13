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

#import "BSendChallengeDetailsView.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"


@implementation BSendChallengeDetailsView

@synthesize challengeSender, challengeReceiver, challengeType, selectedContest;

-(id)init
{
	if (self = [super init]){        
		
	}
    return self;
}

- (void)drawSendChallengeView
{    
    elementsArrayList           = [[NSMutableArray alloc] init];
    imagesArray                 = [[NSMutableArray alloc] init];
    
    challengeSenderDef          = [[NSDictionary alloc] init];
    challengeReceiverDef        = [[NSDictionary alloc] init];
    challengeContest            = [[NSDictionary alloc] init];
    
    _user                       = [[BeintooUser alloc] init];
    _user.delegate              = self;
    
    [self initTableArrayElements];
    
    
    // Keyboard notifications
	/*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:self.window];
	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification object:self.window];*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification  object:self.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification  object:self.window];
   
    
    shadowView                 = [[UIView alloc] initWithFrame:self.bounds];
    shadowView.userInteractionEnabled   = YES;
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.6];
    
    /* ----------- CLOSE BUTTON OVER FIRST CELL ------------- */
    int closeBtnOffset      = 35;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 1.0;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(closeMainView) forControlEvents:UIControlEventTouchUpInside];
    [shadowView addSubview: closeBtn];
    /* ----------------------------------------------------------- */
    
    if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)
        elementsTable = [[BTableView alloc] initWithFrame:CGRectMake(15, (self.frame.size.height - 115 - 220 - 71)/2, self.frame.size.width-30,
                                                                115 + 220 + 71) style:UITableViewStylePlain];
    else
        elementsTable = [[BTableView alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width - 30,
                                                                     self.frame.size.height - 20) style:UITableViewStylePlain];
    
    [closeBtn setFrame:CGRectMake(self.frame.size.width - closeBtnOffset, elementsTable.frame.origin.y - 8 ,
                                  closeBtnImg.size.width+5, closeBtnImg.size.height+5)];
    
    elementsTable.userInteractionEnabled= YES;
    elementsTable.separatorColor        = [UIColor clearColor];
    elementsTable.backgroundColor       = [UIColor clearColor];
    elementsTable.separatorStyle        = UITableViewCellSeparatorStyleNone;
	elementsTable.delegate              = self;
	elementsTable.dataSource            = self;
	elementsTable.rowHeight             = 122.0;
    elementsTable.bounces               = NO;
    
    //SETUP TABLE TO RECEIVE TAPS
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    if ([BeintooDevice isiPad])
        singleTapGestureRecognizer.enabled = NO;

    [elementsTable addGestureRecognizer:singleTapGestureRecognizer];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [singleTapGestureRecognizer release];
#endif
    
    elementsTable.layer.borderColor     = [UIColor lightGrayColor].CGColor;
    elementsTable.layer.cornerRadius    = 3.0;
    elementsTable.layer.borderWidth     = 1.0;
    
    imageToDownload1                    = [[BImageDownload alloc] init];
    imageToDownload1.tag                = 11;
    imageToDownload1.urlString          = [challengeSender objectForKey:@"usersmallimg"];
    imageToDownload1.delegate           = self;

    imageToDownload2                    = [[BImageDownload alloc] init];
    imageToDownload1.tag                = 12;
    //imageToDownload2.urlString          = [challengeReceiver objectForKey:@"usersmallimg"];
    imageToDownload2.delegate           = self;
    
    [imagesArray addObject:imageToDownload1];
    [imagesArray addObject:imageToDownload2];

    [shadowView addSubview:elementsTable];
    [shadowView bringSubviewToFront:closeBtn];
    
    [self addSubview:shadowView];
    
    activityForSenderImage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityForSenderImage hidesWhenStopped];
    [activityForSenderImage startAnimating];
    
    activityForReceiverImage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityForReceiverImage startAnimating];
    [activityForReceiverImage hidesWhenStopped];
    
    [BLoadingView startActivity:self];
    
    [_user getChallangePrereequisitesFromUser:[challengeSender objectForKey:@"id"] toUser:challengeReceiver forContest:selectedContest];
    
}

#pragma mark - User Delegate

- (void)didGetChallangePrerequisites:(NSDictionary *)result
{
    challengeSenderDef      = [[[result objectForKey:@"playerFrom"] objectForKey:@"user"] copy];
    challengeReceiverDef    = [[[result objectForKey:@"playerTo"] objectForKey:@"user"] copy];
    challengeContest        = [[result objectForKey:@"contest"] copy];
    
    imageToDownload2.urlString          = [challengeReceiverDef objectForKey:@"usersmallimg"];
   
    
    [elementsTable reloadData];
    
    [BLoadingView stopActivity];
}

- (void)challengeRequestFinishedWithResult:(NSDictionary *)result
{    
    [BLoadingView stopActivity];
    
	if ([result objectForKey:@"messageID"] != nil) {
		
		if ([[result objectForKey:@"messageID"] intValue] == -15) { // CHALLENGE ONGOING
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeOngoing",@"BeintooLocalizable",@"")
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[av show];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [av release];
#endif
			
			return;
		}
        if([[result objectForKey:@"messageID"] intValue] == -12){ // NOT ENOUGH BEDOLLARS
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"noBedollarsForChall",@"BeintooLocalizable",@"")
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[av show];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [av release];
#endif
            
			return;
        }
        
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"errorMessage",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
		return;
		
	}
	if ([[result objectForKey:@"status"] isEqualToString:@"STARTED"]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeAccepted",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
    else if ([[result objectForKey:@"status"] isEqualToString:@"TO_BE_ACCEPTED"]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeSent",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
    else{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeRefused",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    
    switch (indexPath.row) {
        case 0:
            cellHeight = 115;
            break;

        case 1:{
            if( ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) || ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) ){
                cellHeight = 220;
            }else{
                cellHeight = 220;
            }
        }
            break;
        
        case 2:
            cellHeight = 71;
            break;
            
        default:
            cellHeight = 0;
            break;
    }
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = GRADIENT_CELL_GRAY;
    if (indexPath.row == 1) {
        _gradientType = GRADIENT_CELL_HEAD;
    }
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
	
    @try {
        
    switch (indexPath.row) {
            case 0:{
                
                UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 200, 20)];
                titleLabel.backgroundColor  = [UIColor clearColor];
                titleLabel.font             = [UIFont boldSystemFontOfSize:15];
                titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                titleLabel.textColor        = [UIColor colorWithWhite:0 alpha:1];
                if ([[elementsArrayList objectAtIndex:challengeType-1] objectForKey:@"title"])
                    titleLabel.text         = [[elementsArrayList objectAtIndex:challengeType-1] objectForKey:@"title"];
                else 
                    titleLabel.text         = @"";
                
                titleLabel.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:titleLabel];
                
                UILabel *descr1Label         = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, 200, 50)];
                descr1Label.backgroundColor  = [UIColor clearColor];
                descr1Label.font             = [UIFont systemFontOfSize:13];
                descr1Label.numberOfLines    = 3;
                descr1Label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                descr1Label.textColor        = [UIColor colorWithWhite:0 alpha:1];
                if ([[elementsArrayList objectAtIndex:challengeType-1] objectForKey:@"title"])
                    descr1Label.text         = [[elementsArrayList objectAtIndex:challengeType-1] objectForKey:@"desc1"];
                else 
                    descr1Label.text         = @"";

                descr1Label.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:descr1Label];
                
                UIImageView *cellImage       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-135, 20, 90, 80)];
                cellImage.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin;
                cellImage.image              = [UIImage imageNamed:[[elementsArrayList objectAtIndex:challengeType-1] objectForKey:@"cellImage"]];
                cellImage.contentMode           = UIViewContentModeScaleAspectFit;
                
                [cell addSubview:cellImage];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [titleLabel release];
                [descr1Label release];
                [cellImage release];
#endif
                
            }
                break;
                
            case 1:{
                
                // ----------- Sender Nick ----------------
                UILabel *senderNick         = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 200, 20)];
                senderNick.backgroundColor  = [UIColor clearColor];
                senderNick.font             = [UIFont boldSystemFontOfSize:14];
                senderNick.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                senderNick.textColor        = [UIColor colorWithWhite:0 alpha:1];
                if ([challengeSenderDef count] > 0)
                    senderNick.text             = [challengeSenderDef objectForKey:@"nickname"];
                else 
                    senderNick.text             = @"";
                
                senderNick.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:senderNick];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [senderNick release];
#endif
                
                // ----------- MaxAmount Sender -------------
                UILabel *maxAmoutSender         = [[UILabel alloc] initWithFrame:CGRectMake(12, 26, 280, 20)];
                maxAmoutSender.backgroundColor  = [UIColor clearColor];
                maxAmoutSender.font             = [UIFont systemFontOfSize:12];
                maxAmoutSender.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                maxAmoutSender.textColor        = [UIColor colorWithWhite:0 alpha:0.9];
                if ([challengeSenderDef count] > 0)
                    maxAmoutSender.text             = [NSString stringWithFormat:@"Bedollars: %@",
                                                       [challengeSenderDef objectForKey:@"bedollars"]];
                else 
                    maxAmoutSender.text             = @"";
                
                maxAmoutSender.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:maxAmoutSender];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [maxAmoutSender release];
#endif
                
                // ----------- VersusImage -------------
                UIImage     *vsImage            = [UIImage imageNamed:@"beintoo_challenges_vert.png"];
                UIImageView *versusImageView    = [[UIImageView alloc]initWithFrame:CGRectMake(7, 62 ,vsImage.size.width, vsImage.size.height)];
                versusImageView.contentMode     = UIViewContentModeScaleAspectFit;
                versusImageView.backgroundColor = [UIColor clearColor];
                [versusImageView setImage:vsImage];
                
                UILabel     *vsLabel            = [[UILabel alloc] initWithFrame:CGRectMake(8, 37 ,28, 25)];
                vsLabel.backgroundColor         = [UIColor clearColor];
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                vsLabel.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    vsLabel.textAlignment = NSTextAlignmentCenter;
                else
                vsLabel.textAlignment = UITextAlignmentCenter;
#else
                vsLabel.textAlignment = UITextAlignmentCenter;
#endif
                
                vsLabel.font                    = [UIFont systemFontOfSize:16];
                vsLabel.textColor               = [UIColor whiteColor];
                vsLabel.text                    = @"VS";
                
                [versusImageView addSubview:vsLabel];
                
                [cell addSubview:versusImageView];
              
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [vsLabel release];
                [versusImageView release];
#endif
                
                // ----------- HowMuchBedollars  -------------
                UILabel *howMuchBedollars         = [[UILabel alloc] initWithFrame:CGRectMake(60, 56, 245, 18)];
                howMuchBedollars.backgroundColor  = [UIColor clearColor];
                howMuchBedollars.font             = [UIFont systemFontOfSize:14];
                howMuchBedollars.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                howMuchBedollars.textColor        = [UIColor colorWithWhite:0 alpha:0.8];
                howMuchBedollars.text             = NSLocalizedStringFromTable(@"challhowmuchbet",@"BeintooLocalizable",@"");
                howMuchBedollars.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:howMuchBedollars];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [howMuchBedollars release];
#endif
                
                bedollarsTextField                      = [[UITextField alloc] initWithFrame:CGRectMake(60, 76, 100, 28)];
                bedollarsTextField.tag                  = 1;
                bedollarsTextField.delegate             = self;
                bedollarsTextField.keyboardType         = UIKeyboardTypeNumberPad;
                bedollarsTextField.placeholder          = NSLocalizedStringFromTable(@"clickhere",@"BeintooLocalizable",@"");
                bedollarsTextField.font                 = [UIFont systemFontOfSize:14];
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                bedollarsTextField.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    bedollarsTextField.textAlignment = NSTextAlignmentLeft;
                else
                    bedollarsTextField.textAlignment = UITextAlignmentLeft;
#else
                bedollarsTextField.textAlignment = UITextAlignmentLeft;
#endif
                
                bedollarsTextField.adjustsFontSizeToFitWidth = YES;
                bedollarsTextField.textColor            = [UIColor blackColor];
                bedollarsTextField.backgroundColor      = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
                bedollarsTextField.clearsOnBeginEditing = YES;
                bedollarsTextField.borderStyle          = UITextBorderStyleBezel;
                
                [cell addSubview:bedollarsTextField];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [bedollarsTextField release];
#endif
                
                UILabel *bedollarsLabel         = [[UILabel alloc] initWithFrame:CGRectMake(170, 80, 100, 18)];
                bedollarsLabel.backgroundColor  = [UIColor clearColor];
                bedollarsLabel.font             = [UIFont systemFontOfSize:13];
                bedollarsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                bedollarsLabel.textColor        = [UIColor colorWithWhite:0 alpha:0.8];
                bedollarsLabel.text             = [NSString stringWithFormat:@"Bedollars"];
                bedollarsLabel.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:bedollarsLabel];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [bedollarsLabel release];
#endif

                if (challengeType == SENDCHALLENGE_TYPE_BET_ME || challengeType == SENDCHALLENGE_TYPE_BET_OTHER ) {
                    // ----------- HowManyPoints  -------------
                    UILabel *howMuchPoints          = [[UILabel alloc] initWithFrame:CGRectMake(60, 112, 245, 18)];
                    howMuchPoints.backgroundColor   = [UIColor clearColor];
                    howMuchPoints.font              = [UIFont systemFontOfSize:14];
                    howMuchPoints.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
                    howMuchPoints.textColor         = [UIColor colorWithWhite:0 alpha:0.8];
                    
                    if (challengeType == SENDCHALLENGE_TYPE_BET_OTHER){
                        if ([challengeReceiverDef count] > 0)
                            howMuchPoints.text             = [NSString stringWithFormat:NSLocalizedStringFromTable(@"challhowmanypointyou",@"BeintooLocalizable",@""),[challengeReceiverDef objectForKey:@"nickname"]];
                        else 
                            howMuchPoints.text = @"";
                    }
                    else if (challengeType == SENDCHALLENGE_TYPE_BET_ME){
                        if ([challengeReceiverDef count] > 0)
                            howMuchPoints.text             = [NSString stringWithFormat:NSLocalizedStringFromTable(@"challhowmanypoint",@"BeintooLocalizable",@""),[challengeReceiverDef objectForKey:@"nickname"]];
                        else 
                            howMuchPoints.text = @"";
                    }
                    
                
                    howMuchPoints.adjustsFontSizeToFitWidth = YES;
                    
                    [cell addSubview:howMuchPoints];
                    
#ifdef BEINTOO_ARC_AVAILABLE
#else
                    [howMuchPoints release];
#endif
                   
                    pointsTextField                      = [[UITextField alloc] initWithFrame:CGRectMake(60, 132, 100, 28)];
                    pointsTextField.tag                  = 2;
                    pointsTextField.keyboardType         = UIKeyboardTypeNumberPad;
                    pointsTextField.delegate             = self;
                    pointsTextField.placeholder          = NSLocalizedStringFromTable(@"clickhere",@"BeintooLocalizable",@"");
                    pointsTextField.font                 = [UIFont systemFontOfSize:14];
                    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                    pointsTextField.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                        pointsTextField.textAlignment = NSTextAlignmentLeft;
                    else
                        pointsTextField.textAlignment = UITextAlignmentLeft;
#else
                    pointsTextField.textAlignment = UITextAlignmentLeft;
#endif
                    
                    pointsTextField.adjustsFontSizeToFitWidth = YES;
                    pointsTextField.textColor            = [UIColor blackColor];
                    pointsTextField.backgroundColor      = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
                    pointsTextField.clearsOnBeginEditing = YES;
                    pointsTextField.borderStyle          = UITextBorderStyleBezel;
                    
                    [cell addSubview:pointsTextField];
                    
                    UILabel *pointsLabel            = [[UILabel alloc] initWithFrame:CGRectMake(170, 136, 120, 18)];
                    pointsLabel.backgroundColor     = [UIColor clearColor];
                    pointsLabel.font                = [UIFont systemFontOfSize:13];
                    pointsLabel.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
                    pointsLabel.textColor           = [UIColor colorWithWhite:0 alpha:0.8];
                    
                    if ([challengeContest count] > 0)
                        pointsLabel.text                = [challengeContest objectForKey:@"feed"];
                    else 
                        pointsLabel.text                = @"";
                    
                    pointsLabel.adjustsFontSizeToFitWidth = YES;
                    
                    [cell addSubview:pointsLabel];
                    
#ifdef BEINTOO_ARC_AVAILABLE
#else
                    [pointsTextField release];
                    [pointsLabel release];
#endif
                    
                }
                
                // ----------- Receiver Nick ----------------
                UILabel *receiverNick         = [[UILabel alloc] initWithFrame:CGRectMake(12, 174, 200, 20)];
                receiverNick.backgroundColor  = [UIColor clearColor];
                receiverNick.font             = [UIFont boldSystemFontOfSize:14];
                receiverNick.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                receiverNick.textColor        = [UIColor colorWithWhite:0 alpha:1];
                if ([challengeReceiverDef count] > 0)
                    receiverNick.text             = [challengeReceiverDef objectForKey:@"nickname"];
                else 
                    receiverNick.text             = @"";

                receiverNick.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:receiverNick];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [receiverNick release];
#endif
                
                // ----------- MaxAmount Sender -------------
                UILabel *maxAmoutReceiver         = [[UILabel alloc] initWithFrame:CGRectMake(12, 192, 280, 20)];
                maxAmoutReceiver.backgroundColor  = [UIColor clearColor];
                maxAmoutReceiver.font             = [UIFont systemFontOfSize:12];
                maxAmoutReceiver.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                maxAmoutReceiver.textColor        = [UIColor colorWithWhite:0 alpha:0.9];
                if ([challengeReceiverDef count] > 0)
                    maxAmoutReceiver.text             = [NSString stringWithFormat:@"Bedollars: %@",
                                                         [challengeReceiverDef objectForKey:@"bedollars"]];
                else 
                    maxAmoutReceiver.text             = @"";
                
                maxAmoutReceiver.adjustsFontSizeToFitWidth = YES;
                
                [cell addSubview:maxAmoutReceiver];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [maxAmoutReceiver release];
#endif
                
            }
                break;
                
            case 2:{
                
                // Introducing an offset used on landscape mode to create space among elements
                int offset = 0;
                if( (([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) || ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight)) && ![BeintooDevice isiPad] ){
                    offset = 10;
                }

                UIImageView *imageViewSender        = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 45, 45)];
                
                BImageDownload *image1              = [imagesArray objectAtIndex:0];
                image1.tag                          = 11;
                imageViewSender.image               = image1.image;
                
                if (image1.image == nil){
                    
                    [cell addSubview:activityForSenderImage];
                    activityForSenderImage.center = CGPointMake(imageViewSender.frame.size.width/2, imageViewSender.frame.size.height/2);
                }
                else {
                    [activityForSenderImage stopAnimating];
                }
                
                imageViewSender.contentMode         = UIViewContentModeScaleAspectFit;
                imageViewSender.backgroundColor     = [UIColor clearColor];
                [cell addSubview:imageViewSender];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [imageViewSender release];
#endif
                
                // ----------- Versus -------------
                UIImage     *vsImage            = [UIImage imageNamed:@"beintoo_challenges_horiz.png"];
                UIImageView *versusImageView    = [[UIImageView alloc]initWithFrame:CGRectMake(54+offset, 15,vsImage.size.width, vsImage.size.height)];
                versusImageView.contentMode     = UIViewContentModeScaleAspectFit;
                versusImageView.backgroundColor = [UIColor clearColor];
                [versusImageView setImage:vsImage];
                
                UILabel     *vsLabel            = [[UILabel alloc] initWithFrame:CGRectMake(14, 6 ,28, 25)];
                vsLabel.backgroundColor         = [UIColor clearColor];
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                vsLabel.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    vsLabel.textAlignment = NSTextAlignmentCenter;
                else
                    vsLabel.textAlignment = UITextAlignmentCenter;
#else
                vsLabel.textAlignment = UITextAlignmentCenter;
#endif
                
                vsLabel.font                    = [UIFont systemFontOfSize:16];
                vsLabel.textColor               = [UIColor whiteColor];
                vsLabel.text                    = @"VS";
                
                [versusImageView addSubview:vsLabel];
                
                [cell addSubview:versusImageView];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [vsLabel release];
                [versusImageView release];
#endif
                
                // ----------- Image Receiver -------------
                UIImageView *imageViewReceiver      = [[UIImageView alloc]initWithFrame:CGRectMake(111+(offset*2), 12, 45, 45)];
                
                BImageDownload *image2              = [imagesArray objectAtIndex:1];
                image2.tag                          = 12;
                imageViewReceiver.image             = image2.image;
                if (image2.image == nil){
                    [cell addSubview:activityForReceiverImage];
                    activityForReceiverImage.center = CGPointMake(imageViewReceiver.frame.size.width/2, imageViewReceiver.frame.size.height/2);
                }
                else {
                    [activityForReceiverImage stopAnimating];
                }
                
                imageViewReceiver.contentMode       = UIViewContentModeScaleAspectFit;
                imageViewReceiver.backgroundColor   = [UIColor clearColor];
                [cell addSubview:imageViewReceiver];
                
                // ----------- Equal sign -------------
                UILabel     *equalLabel             = [[UILabel alloc] initWithFrame:CGRectMake(160+(offset*3), 20, 25, 25)];
                equalLabel.backgroundColor          = [UIColor clearColor];
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
                equalLabel.textAlignment = NSTextAlignmentCenter;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    equalLabel.textAlignment = NSTextAlignmentCenter;
                else
                    equalLabel.textAlignment = UITextAlignmentCenter;
#else
                equalLabel.textAlignment = UITextAlignmentCenter;
#endif
                
                equalLabel.font                     = [UIFont boldSystemFontOfSize:27];
                equalLabel.textColor                = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
                equalLabel.text                     = @"=";
                [cell addSubview:equalLabel];
                
                // ---------------- Button -----------------
                BButton *sentBtn = [[BButton alloc] initWithFrame:CGRectMake(190+(offset*4), 18, 86, 35)];
                [sentBtn setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
                [sentBtn setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
                [sentBtn setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
                [sentBtn setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
                [sentBtn setTitle:NSLocalizedStringFromTable(@"sendButton",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
                [sentBtn addTarget:self action:@selector(handleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [sentBtn setButtonTextSize:13];
                
                [cell addSubview:sentBtn];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [imageViewReceiver release];
                [equalLabel release];
                [sentBtn release];
#endif
                
            }
                break;
                
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on table view %@", exception);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)initTableArrayElements
{
    [elementsArrayList removeAllObjects];
    
    NSDictionary *meVsYouDict       = [NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedStringFromTable(@"challmevsyoutitle",@"BeintooLocalizable",@""),@"title",
                                       NSLocalizedStringFromTable(@"challmevsyou",@"BeintooLocalizable",@""), @"desc1",
                                       @"0",@"cellTag",
                                       @"beintoo_challenges_vs.png",@"cellImage",nil];
    
    NSDictionary *friendsChallDict  = [NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedStringFromTable(@"challFriendstitle",@"BeintooLocalizable",@""),@"title",
                                       NSLocalizedStringFromTable(@"challFriends",@"BeintooLocalizable",@""), @"desc1",
                                       @"1",@"cellTag",
                                       @"beintoo_challenges_on.png",@"cellImage",nil];
    
    NSDictionary *challenge24Dict   = [NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedStringFromTable(@"chall48title",@"BeintooLocalizable",@""),@"title",
                                       NSLocalizedStringFromTable(@"chall48",@"BeintooLocalizable",@""), @"desc1",
                                       @"2",@"cellTag",
                                       @"beintoo_challenges_24.png",@"cellImage",nil];
    
	
    [elementsArrayList addObject:meVsYouDict];
    [elementsArrayList addObject:friendsChallDict];
    [elementsArrayList addObject:challenge24Dict];

}

#pragma mark - ViewActions
- (void)closeMainView
{    
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        [UIView animateWithDuration:0.5
                         animations:^(void) {
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }
         ];
     }
     else {
         [UIView beginAnimations:nil context:nil];
         self.alpha = 0;
         [self removeFromSuperview];
         [UIView commitAnimations];
     }
}

// Called when the user touch the send-challenge button
- (void)handleButtonPressed:(UITapGestureRecognizer *)sender
{    
    switch (challengeType) {
        case 1:{
            if ([pointsTextField.text intValue]>0 && [bedollarsTextField.text intValue]>0) {
                [_user challengeRequestfrom:[challengeSenderDef objectForKey:@"id"] to:[challengeReceiverDef objectForKey:@"id"]                                                                        
                                 withAction:@"INVITE" 
                                 forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"] 
                         withBedollarsToBet:bedollarsTextField.text andScoreToReach:pointsTextField.text 
                         forKindOfChallenge:@"BET" andActor:[challengeReceiverDef objectForKey:@"id"]];        
                [BLoadingView startActivity:self];
            }
            else{

                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challerror",@"BeintooLocalizable",@"")
                                                            delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [av setTag:10]; // To recognise this one and do close the view
                [av show];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [av release];
#endif
                
            }
        }
            break;
        case 2:{
            if ([pointsTextField.text intValue]>0 && [bedollarsTextField.text intValue]>0) {
                [BLoadingView startActivity:self];

                [_user challengeRequestfrom:[challengeSenderDef objectForKey:@"id"] to:[challengeReceiverDef objectForKey:@"id"]                                                                        
                                 withAction:@"INVITE" 
                                 forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"] 
                         withBedollarsToBet:bedollarsTextField.text andScoreToReach:pointsTextField.text 
                         forKindOfChallenge:@"BET" andActor:[challengeSender objectForKey:@"id"]];            
            }
            else{
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challerror",@"BeintooLocalizable",@"")
                                                            delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [av setTag:10]; // To recognise this one and do close the view
                [av show];
               
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [av release];
#endif
                
            }
        }
            break;
        
        case 3:{
            if ([bedollarsTextField.text intValue]>0) {
                [BLoadingView startActivity:self];

                [_user challengeRequestfrom:[challengeSenderDef objectForKey:@"id"] to:[challengeReceiverDef objectForKey:@"id"]                                                                        
                                 withAction:@"INVITE" 
                                 forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"] 
                         withBedollarsToBet:bedollarsTextField.text andScoreToReach:nil 
                         forKindOfChallenge:@"CHALLENGE" andActor:nil];            
            }
            else{
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challerror",@"BeintooLocalizable",@"")
                                                            delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [av setTag:10]; // To recognise this one and do close the view
                [av show];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [av release];
#endif
                
            }

        }
            break;
            
        default:
            break;
    }    
}

- (void)sendChallengeAction
{
    // Nothing to do here
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // AlertView.tag == 10 if there was an error and we do not want to close the view
    if (alertView.tag != 10) {
        BSendChallengesView *parentView = (BSendChallengesView *)self.superview ;
        [parentView closeMainView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationChallengeSent object:nil];
    }
}

#pragma mark - UITextFieldDelegate and methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{    
    if (!([BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown))){
        [UIView beginAnimations:@"keyboardUp" context:nil];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDuration:0.2];
        if (!textFieldAnimationPerformed) {
            self.center = CGPointMake(self.center.x, self.center.y - 100);
            textFieldAnimationPerformed = YES;
        }

        [UIView commitAnimations];
    }
    
	return YES;
}

// This won't work on simulator, it will not be directly called, use the keyboardDidHide: delegate to call it

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
   // if ( !([Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)){
        [UIView beginAnimations:@"keyboardDown" context:nil];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDuration:0.2];
        if (textFieldAnimationPerformed) {
            self.center = CGPointMake(self.center.x, self.center.y + 100);
            textFieldAnimationPerformed = NO;
        }
        [UIView commitAnimations];    
  //  }
    
	[textField resignFirstResponder];
    [self checkTextFieldInputs];
        
	return YES;
}

- (void)keyboardDidHide:(NSNotification *)aNotification
{
    [UIView beginAnimations:@"keyboardDown" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:0.2];
    if (textFieldAnimationPerformed) {
        self.center = CGPointMake(self.center.x, self.center.y + 100);
        textFieldAnimationPerformed = NO;
    }
    [UIView commitAnimations];
    
    
    if ([bedollarsTextField isFirstResponder]) {
        [bedollarsTextField resignFirstResponder];
    }else if([pointsTextField isFirstResponder]) {
        [pointsTextField resignFirstResponder];
    }
    
    [self checkTextFieldInputs];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{    
    if (![BeintooDevice isiPad])
    {
        [UIView beginAnimations:@"keyboardDown" context:nil];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDuration:0.2];
        if (textFieldAnimationPerformed) {
            self.center = CGPointMake(self.center.x, self.center.y + 100);
            textFieldAnimationPerformed = NO;
        }
        [UIView commitAnimations];
        
        
        if ([bedollarsTextField isFirstResponder]) {
            [bedollarsTextField resignFirstResponder];
        }else if([pointsTextField isFirstResponder]) {
            [pointsTextField resignFirstResponder];
        }
        
        [self checkTextFieldInputs];
    }
}

- (void)checkTextFieldInputs
{
    NSString *bedollarsBet  = bedollarsTextField.text;
    NSString *pointsBet     = pointsTextField.text;
    
    int      bedollarsValue = [bedollarsBet intValue];
    int      pointsValue    = [pointsBet intValue];
        
    if (bedollarsValue <= 0) {
        bedollarsTextField.text = @"0";
    }
    if (pointsValue <= 0) {
        pointsTextField.text = @"0";
    }
    else{
        pointsTextField.text = [NSString stringWithFormat:@"%d",pointsValue];
    }
    
    int max;
    if ([[challengeSenderDef objectForKey:@"bedollars"] intValue] <= [[challengeReceiverDef objectForKey:@"bedollars"] intValue]){
        max = [[challengeSenderDef objectForKey:@"bedollars"] intValue];
    }
    else {
        max = [[challengeReceiverDef objectForKey:@"bedollars"] intValue];
    }
    
    if (bedollarsValue > max ) {
        bedollarsTextField.text = [NSString stringWithFormat:@"%i", max];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView beginAnimations:@"keyboardDown" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:0.2];
    if (textFieldAnimationPerformed) {
        self.center = CGPointMake(self.center.x, self.center.y + 100);
        textFieldAnimationPerformed = NO;
    }
    [UIView commitAnimations];    
    
    if ([bedollarsTextField isFirstResponder]) {
        [bedollarsTextField resignFirstResponder];
    }else if([pointsTextField isFirstResponder]) {
        [pointsTextField resignFirstResponder];
    }
    [self checkTextFieldInputs];
}

//********** VIEW TAPPED **********
- (void) handleSingleTap:(UITapGestureRecognizer *)sender
{
    [UIView beginAnimations:@"keyboardDown" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:0.2];
    if (textFieldAnimationPerformed) {
        self.center = CGPointMake(self.center.x, self.center.y + 100);
        textFieldAnimationPerformed = NO;
    }
    [UIView commitAnimations];    
    
    if ([bedollarsTextField isFirstResponder]) {
        [bedollarsTextField resignFirstResponder];
    }else if([pointsTextField isFirstResponder]) {
        [pointsTextField resignFirstResponder];
    }
    [self checkTextFieldInputs];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods
 
- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSIndexPath *rowToReload    = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *rowsToReload       = [NSArray arrayWithObjects:rowToReload, nil];  
    
    [elementsTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    download.delegate = nil;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error
{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}


- (void)removeViews
{
    _user.delegate = nil;
    
    imageToDownload1.delegate = nil;
    imageToDownload2.delegate = nil;
    
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}   

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    imageToDownload1.delegate = nil;
    imageToDownload2.delegate = nil;
    
    if (_user != nil) {
        [_user release];
    }
    
    [elementsArrayList release];
    [imagesArray release];
    [activityForReceiverImage release];
    [activityForSenderImage release];
    [challengeSender release];
    [challengeReceiverDef release];
    [challengeContest release];
    
    [super dealloc];
}
#endif

@end

