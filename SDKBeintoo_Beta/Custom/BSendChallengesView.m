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

#import "BSendChallengesView.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"
#import "BSendChallengeDetailsView.h"


@implementation BSendChallengesView

@synthesize challengeSender, challengeReceiver, selectedContest;

- (id)init
{
	if (self = [super init]){        
		
	}
    return self;
}

- (void)drawSendChallengeView{
    
    elementsArrayList = [[NSMutableArray alloc] init];
    
    [self initTableArrayElements];
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:self.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.6];
    
    sendChallengeView1 = [BSendChallengeDetailsView alloc];
    sendChallengeView2 = [BSendChallengeDetailsView alloc];
    sendChallengeView3 = [BSendChallengeDetailsView alloc];
        
    UITableView *elementsTable          = [[BTableView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 15) style:UITableViewStylePlain];
    
    if ([BeintooDevice isiPad] || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)
         elementsTable.frame          = CGRectMake(5, (self.frame.size.height - (35 + 122 * 3))/2, self.frame.size.width - 10, 35 + 122 * 3);
    else 
        elementsTable.frame          = CGRectMake(5, 10, self.frame.size.width - 10, self.frame.size.height - 20);
            
    elementsTable.separatorColor        = [UIColor clearColor];
    elementsTable.backgroundColor       = [UIColor clearColor];
    elementsTable.separatorStyle        = UITableViewCellSeparatorStyleNone;
	elementsTable.delegate              = self;
	elementsTable.dataSource            = self;
	elementsTable.rowHeight             = 122.0;
    elementsTable.bounces               = NO;
    
    elementsTable.layer.borderColor     = [UIColor lightGrayColor].CGColor;
    elementsTable.layer.cornerRadius    = 3.0;
    elementsTable.layer.borderWidth     = 1.0;
    elementsTable.userInteractionEnabled = YES;
    
    [shadowView addSubview:elementsTable];
    
    [self addSubview:shadowView];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [elementsTable release];
    [shadowView release];
#endif
    
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [elementsArrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = GRADIENT_CELL_GRAY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
	
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 190, 20)];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.font             = [UIFont boldSystemFontOfSize:15];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.textColor        = [UIColor colorWithWhite:0 alpha:1];
    titleLabel.text             = [[elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"title"];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [cell addSubview:titleLabel];
    
    UILabel *descr1Label         = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, 190, 50)];
    descr1Label.backgroundColor  = [UIColor clearColor];
    descr1Label.font             = [UIFont systemFontOfSize:13];
    descr1Label.numberOfLines    = 3;
    descr1Label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    descr1Label.textColor        = [UIColor colorWithWhite:0 alpha:1];
    descr1Label.text             = [[elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"desc1"];
    descr1Label.adjustsFontSizeToFitWidth = YES;
    
    [cell addSubview:descr1Label];
    
    UIImageView *cellImage       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-130, 15, 110, 93)];
    cellImage.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin;
    cellImage.image              = [UIImage imageNamed:[[elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"cellImage"]];
    cellImage.contentMode           = UIViewContentModeScaleAspectFit;
    
    [cell addSubview:cellImage];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [titleLabel release];
    [descr1Label release];
    [cellImage release];
#endif
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{ // BET -> actor = utente selezionato dalla leaderboard

            sendChallengeView1 = [sendChallengeView1 initWithFrame:self.frame];
            sendChallengeView1.challengeReceiver     = challengeReceiver;
            sendChallengeView1.challengeSender       = challengeSender;
            sendChallengeView1.challengeType         = SENDCHALLENGE_TYPE_BET_OTHER;
            
            [sendChallengeView1 drawSendChallengeView];
            sendChallengeView1.tag = BSENDCHALLENGEDETAILS_VIEW_TAG;
            sendChallengeView1.alpha = 0;
            [self addSubview:sendChallengeView1];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            sendChallengeView1.alpha = 1;
            [UIView commitAnimations];
            
        }
            break;

        case 1:{ // BET -> actor = utente corrente
            sendChallengeView2 = [sendChallengeView2 initWithFrame:self.frame];
            sendChallengeView2.challengeReceiver     = self.challengeReceiver;
            sendChallengeView2.challengeSender       = self.challengeSender;
            sendChallengeView2.challengeType         = SENDCHALLENGE_TYPE_BET_ME;
            
            [sendChallengeView2 drawSendChallengeView];
            sendChallengeView2.tag = BSENDCHALLENGEDETAILS_VIEW_TAG;
            sendChallengeView2.alpha = 0;
            [self addSubview:sendChallengeView2];
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            sendChallengeView2.alpha = 1;
            [UIView commitAnimations];
            
            break;
        }
        case 2:{ // CHALLENGE -> actor = nil
            
            sendChallengeView3 = [sendChallengeView3 initWithFrame:self.frame];
            
            sendChallengeView3.challengeReceiver     = self.challengeReceiver;
            sendChallengeView3.challengeSender       = self.challengeSender;
            sendChallengeView3.challengeType         = SENDCHALLENGE_TYPE_TIME;
            
            [sendChallengeView3 drawSendChallengeView];
            sendChallengeView3.tag = BSENDCHALLENGEDETAILS_VIEW_TAG;
            sendChallengeView3.alpha = 0;
            [self addSubview:sendChallengeView3];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            sendChallengeView3.alpha = 1;
            [UIView commitAnimations];
            
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 35.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

#ifdef BEINTOO_ARC_AVAILABLE
    BGradientView *gradientView = [[BGradientView alloc] initWithGradientType:GRADIENT_HEADER];
#else
    BGradientView *gradientView = [[[BGradientView alloc] initWithGradientType:GRADIENT_HEADER]autorelease];
#endif
	
    gradientView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 30);
    
    UILabel *contestNameLbl			= [[UILabel alloc]initWithFrame:CGRectMake(10,7,300,20)];
	contestNameLbl.backgroundColor	= [UIColor clearColor];
	contestNameLbl.textColor		= [UIColor blackColor];
	contestNameLbl.font				= [UIFont boldSystemFontOfSize:15];
    contestNameLbl.text             = NSLocalizedStringFromTable(@"leadSendChall", @"BeintooLocalizable", @"");
	
    [gradientView addSubview:contestNameLbl];
	
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [contestNameLbl release];
#endif
    
    /* ----------- CLOSE BUTTON OVER HEADER SECTION ------------- */
    
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(gradientView.frame.size.width - closeBtnOffset, 3, 30, 30)];
	
    [closeBtn addTarget:self action:@selector(closeMainView) forControlEvents:UIControlEventTouchUpInside];
    [gradientView addSubview: closeBtn];
    [gradientView bringSubviewToFront:closeBtn];
    /* ----------------------------------------------------------- */
	return gradientView;
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
                             [[self viewWithTag:BSENDCHALLENGEDETAILS_VIEW_TAG] removeFromSuperview];
                             [self removeFromSuperview];
                         }
         ];
    }
    else {
        self.alpha = 0;
        [[self viewWithTag:BSENDCHALLENGEDETAILS_VIEW_TAG] removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)removeViews
{
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [elementsArrayList release];
    [sendChallengeView1 release];
    [sendChallengeView2 release];
    [sendChallengeView3 release];
    
    [super dealloc];
}
#endif

@end

