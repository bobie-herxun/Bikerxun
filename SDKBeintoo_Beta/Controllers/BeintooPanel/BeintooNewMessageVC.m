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

#import "BeintooNewMessageVC.h"
#import "Beintoo.h"

@implementation BeintooNewMessageVC

@synthesize startingOptions, keyboardToolbar, selectedFriend, isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
		if ([self.startingOptions objectForKey:@"replyOptions"]!=nil) {
			NSDictionary *friendToReply = [NSDictionary dictionaryWithObjectsAndKeys:[[options objectForKey:@"replyOptions"] objectForKey:@"from"],@"nickname",
										   [[options objectForKey:@"replyOptions"] objectForKey:@"fromUserID"],@"userExt",
										   [[options objectForKey:@"replyOptions"] objectForKey:@"fromImgURL"],@"userImgUrl",nil];
			self.selectedFriend = friendToReply;
		}
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[sendMessageView setTopHeight:40.0];
	[sendMessageView setBodyHeight:379.0];
	
	_message		  = [[BeintooMessage alloc] init];
	_player			  =	[[BeintooPlayer alloc] init];
	friendsListVC	  = [BeintooFriendsListVC alloc];	
	
	self.title			= NSLocalizedStringFromTable(@"sendMessageTitle",@"BeintooLocalizable",@"");
	titleLabel.text		= NSLocalizedStringFromTable(@"sendmessage",@"BeintooLocalizable",@"");
	toLabel.text		= NSLocalizedStringFromTable(@"to:",@"BeintooLocalizable",@"");
	textLabel.text		= NSLocalizedStringFromTable(@"message:",@"BeintooLocalizable",@"");
	
	receiverTextField.backgroundColor = [UIColor whiteColor];
	messageTextView.backgroundColor	  = [UIColor whiteColor];
	receiverTextField.delegate		  = self;
	messageTextView.delegate		  = self;
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];	
#endif
	
	[messageTextView.layer setCornerRadius:0];
	[messageTextView.layer setMasksToBounds:YES];
	[messageTextView.layer setBorderWidth:1.0f];
	[messageTextView.layer setBorderColor:[UIColor colorWithWhite:0 alpha:0.9].CGColor];
	
	// Keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification  object:self.view.window];
    keyboardIsShown = NO;
	
	if (keyboardToolbar == nil) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];
		keyboardToolbar.barStyle = UIBarStyleBlackOpaque;
							
		UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
		
#ifdef BEINTOO_ARC_AVAILABLE
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraSpace,doneButton,nil]];
#else
        [keyboardToolbar setItems:[[[NSArray alloc] initWithObjects:extraSpace,doneButton,nil] autorelease]];
        [doneButton release];
		[extraSpace release];
#endif
		
	}
	
	@try {
		if ([messageTextView respondsToSelector:@selector(setInputAccessoryView:)])
			[messageTextView setInputAccessoryView:keyboardToolbar];
		else
			isAccessoryInputViewNotSupported = YES;
	}
	@catch (NSException * e) {
		isAccessoryInputViewNotSupported = YES;
	}
	
	[sendButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[sendButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[sendButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [sendButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[sendButton setTitle:NSLocalizedStringFromTable(@"sendButton",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[sendButton setButtonTextSize:16];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    _message.delegate = self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		@try {
			if (self.selectedFriend != nil) {
				toNickLabel.text = [self.selectedFriend objectForKey:@"nickname"];
				toNickLabel.textColor = [UIColor colorWithWhite:0 alpha:0.9];
				toNickLabel.font = [UIFont boldSystemFontOfSize:15];
				receiverTextField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
			}
			else {
				toNickLabel.text = NSLocalizedStringFromTable(@"addressee",@"BeintooLocalizable",@"");
				toNickLabel.textColor = [UIColor colorWithWhite:0 alpha:0.65];
				toNickLabel.font = [UIFont systemFontOfSize:15];
				receiverTextField.backgroundColor = [UIColor whiteColor];
			}
		}
		@catch (NSException * e) {
			//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
		}
	}
}

#pragma mark -
#pragma mark MessageDelegate

- (void)didSendMessageWithResult:(BOOL)messageSent
{
	[BLoadingView stopActivity];
	if (messageSent) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"messageSent",@"BeintooLocalizable",@"") 
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		av.tag = 123;
		[av show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
		
	}
	else {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"messageNotSent",@"BeintooLocalizable",@"") 
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
}

#pragma mark AlertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0 && alertView.tag == 123)
		[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)sendMessage
{
	NSString *textToSend = messageTextView.text;
	
	if (self.selectedFriend != nil) { // A friend is selected
		if (([textToSend length]<2) || [[textToSend stringByReplacingOccurrencesOfString:@" " withString:@""] length]<2) {
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"shortMessageError",@"BeintooLocalizable",@"") 
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[av show];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [av release];
#endif
			
		}
		else {
			[_message sendMessageTo:[self.selectedFriend objectForKey:@"userExt"] withText:textToSend];
			[BLoadingView startActivity:self.view];
		}
	}
	else {  // Friend not selected
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"noFriendSelected",@"BeintooLocalizable",@"") 
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [av release];
#endif
        
	}
}

- (IBAction)pickAFriend
{
	NSDictionary *friendsListOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"newMessage",@"caller",self,@"callerVC",nil];
	friendsListVC = [friendsListVC initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle] andOptions:friendsListOptions];
	[self.navigationController pushViewController:friendsListVC animated:YES];
}

#pragma mark -
#pragma mark Animations For Keyboard

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    @try {
		if ([messageTextView respondsToSelector:@selector(setInputAccessoryView:)])
			[messageTextView setInputAccessoryView:keyboardToolbar];
		else
			isAccessoryInputViewNotSupported = YES;
	}
	@catch (NSException * e) {
		isAccessoryInputViewNotSupported = YES;
	}    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView
{
    if ([aTextView isFirstResponder])
        [aTextView resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	if ([messageTextView isFirstResponder]){
		
		//if (![BeintooDevice isiPad]) {
            [self moveTextViewForKeyboard:aNotification up:YES];
        //}
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
	if ([messageTextView isFirstResponder]) {
		
        //if (![BeintooDevice isiPad]) {
            [self moveTextViewForKeyboard:aNotification up:NO];        
        //}
	}
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
{
	NSDictionary* userInfo = [aNotification userInfo];
	
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
		
	CGPoint center          = self.view.center;
	CGRect keyboardFrame    = [self.view convertRect:keyboardEndFrame toView:nil];
	
	float shiftValue = 2.5;
	if (self.view.bounds.size.height > 330) {
		shiftValue = 1.8;
	}
	
	center.y			     -= (keyboardFrame.size.height/shiftValue) * (up? 1 : -1);	
	
    if (!([Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown)){
        if (up == YES)
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 120, self.view.frame.size.width, self.view.frame.size.height);
        else
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
	}
	[UIView commitAnimations];
}

- (void) dismissKeyboard
{
	if ([messageTextView isFirstResponder])
		[messageTextView resignFirstResponder];
} 

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _message.delegate = nil;
    
	@try {
		[BLoadingView stopActivity];
		if ([messageTextView isFirstResponder])
			[messageTextView resignFirstResponder];
		
		// Reset the addressee and the message
		self.selectedFriend = nil;
		messageTextView.text = @"";
	}
	@catch (NSException * e) {
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[keyboardToolbar release];
	[friendsListVC release];
	[_player release];
	[_message release];
    [super dealloc];
#endif
    
}

@end
