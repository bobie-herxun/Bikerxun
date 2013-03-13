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

#import "BeintooSigninAlreadyVC.h"
#import "Beintoo.h"
#import <QuartzCore/QuartzCore.h>
#import "BeintooTutorialVC.h"

@implementation BeintooSigninAlreadyVC
@synthesize caller, isFromDirectLaunch;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"login", @"BeintooLocalizable", @"Login");
	
	scrollView.backgroundColor = [UIColor clearColor];
	scrollView.exclusiveTouch = NO;
    
	[beintooView setTopHeight:0];
	[beintooView setBodyHeight:[UIScreen mainScreen].bounds.size.height];
	[beintooView setIsScrollView:YES];
    beintooView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [beintooView addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 440);
	
    mainLabel.text = NSLocalizedStringFromTable(@"new_login_title",@"BeintooLocalizable",@"");
    mainLabelLand.text = NSLocalizedStringFromTable(@"new_login_title",@"BeintooLocalizable",@"");
	
	user			= [[BeintooUser alloc] init];
	user.delegate	= self;
	_player			= [[BeintooPlayer alloc]init];
	_player.delegate = self;
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	eTF.delegate = self;
	pTF.delegate = self;
    
    eTFLand.delegate = self;
	pTFLand.delegate = self;
	
    eTF.placeholder =  NSLocalizedStringFromTable(@"loginEmailPlaceholder",@"BeintooLocalizable", nil);
	pTF.placeholder =  NSLocalizedStringFromTable(@"loginPasswordPlaceholder",@"BeintooLocalizable", nil);
    
    eTFLand.placeholder =  NSLocalizedStringFromTable(@"loginEmailPlaceholder",@"BeintooLocalizable", nil);
	pTFLand.placeholder =  NSLocalizedStringFromTable(@"loginPasswordPlaceholder",@"BeintooLocalizable", nil);
    
    mainLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    mainLabelLand.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    
	[loginButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[loginButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[loginButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [loginButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[loginButton setTitle:NSLocalizedStringFromTable(@"loginOn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[loginButton setButtonTextSize:20];
    
    [loginButtonLand setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[loginButtonLand setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[loginButtonLand setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [loginButtonLand setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[loginButtonLand setTitle:NSLocalizedStringFromTable(@"loginOn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[loginButtonLand setButtonTextSize:20];
    
    // Keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification  object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) 
												 name:UIKeyboardDidShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification  object:self.view.window];
    
    // keyboardIsShown = NO;
    
    if (keyboardToolbar == nil) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];
		keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)];
        
		UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
		
#ifdef BEINTOO_ARC_AVAILABLE
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:previousButton, nextButton,  extraSpace, doneButton, nil]];
#else
        [keyboardToolbar setItems:[[[NSArray alloc] initWithObjects:previousButton, nextButton,  extraSpace, doneButton, nil] autorelease]];
        
        [previousButton release];
        [nextButton release];
		[doneButton release];
		[extraSpace release];
#endif        
        
	}
    
    if (keyboardToolbarForgot == nil) {
		keyboardToolbarForgot = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];
		keyboardToolbarForgot.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
        
#ifdef BEINTOO_ARC_AVAILABLE
        [keyboardToolbarForgot setItems:[[NSArray alloc] initWithObjects:extraSpace, doneButton, nil]];
#else
        [keyboardToolbarForgot setItems:[[[NSArray alloc] initWithObjects:extraSpace, doneButton, nil] autorelease]];
		
        [doneButton release];
		[extraSpace release];
#endif
		
	}
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        [scrollView addSubview:landscapeView];
    }
    else {
        [scrollView addSubview:portraitView];
    }
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        
        @try {
            if ([eTFLand respondsToSelector:@selector(setInputAccessoryView:)]){
                [eTFLand setInputAccessoryView:keyboardToolbar];
                [pTFLand setInputAccessoryView:keyboardToolbar];
                
                [forgotPasswordTextField setInputAccessoryView:keyboardToolbarForgot];
            }
            else
                isAccessoryInputViewNotSupported = YES;
        }
        @catch (NSException * e) {
            isAccessoryInputViewNotSupported = YES;
        }
    }
    else{
        
        @try {
            if ([eTF respondsToSelector:@selector(setInputAccessoryView:)]){
                [eTF setInputAccessoryView:keyboardToolbar];
                [pTF setInputAccessoryView:keyboardToolbar];
                
                [forgotPasswordTextField setInputAccessoryView:keyboardToolbarForgot];
            }
            else
                isAccessoryInputViewNotSupported = YES;
        }
        @catch (NSException * e) {
            isAccessoryInputViewNotSupported = YES;
        }
    }
    
    eTF.frame = CGRectMake(eTF.frame.origin.x, eTF.frame.origin.y, eTF.frame.size.width, 44);
    eTFLand.frame = CGRectMake(eTFLand.frame.origin.x, eTFLand.frame.origin.y, eTFLand.frame.size.width, 44);
    
    pTF.frame = CGRectMake(pTF.frame.origin.x, pTF.frame.origin.y, pTF.frame.size.width, 44);
    pTFLand.frame = CGRectMake(pTFLand.frame.origin.x, pTFLand.frame.origin.y, pTFLand.frame.size.width, 44);
    
    forgotPasswordTextField.frame = CGRectMake(forgotPasswordTextField.frame.origin.x, forgotPasswordTextField.frame.origin.y, forgotPasswordTextField.frame.size.width, 44);
    
    forgotPassword.titleLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];
    forgotPasswordLand.titleLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:68.0/255.0 blue:103.0/255.0 alpha:1.0];

    [forgotPassword setTitle:NSLocalizedStringFromTable(@"forgotPasswordButton", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    [forgotPassword setTitle:NSLocalizedStringFromTable(@"forgotPasswordButton", @"BeintooLocalizable", nil) forState:UIControlStateHighlighted];
    [forgotPassword setTitle:NSLocalizedStringFromTable(@"forgotPasswordButton", @"BeintooLocalizable", nil) forState:UIControlStateSelected];
    
    [forgotPasswordLand setTitle:NSLocalizedStringFromTable(@"forgotPasswordButton", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    [forgotPasswordLand setTitle:NSLocalizedStringFromTable(@"forgotPasswordButton", @"BeintooLocalizable", nil) forState:UIControlStateHighlighted];
    [forgotPasswordLand setTitle:NSLocalizedStringFromTable(@"forgotPasswordButton", @"BeintooLocalizable", nil) forState:UIControlStateSelected];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= BEINTOO_IOS_6_0
    forgotPassword.titleLabel.textAlignment     = NSTextAlignmentLeft;
    forgotPasswordLand.titleLabel.textAlignment = NSTextAlignmentLeft;
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        forgotPassword.titleLabel.textAlignment     = NSTextAlignmentLeft;
        forgotPasswordLand.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        forgotPassword.titleLabel.textAlignment = UITextAlignmentLeft;
        forgotPasswordLand.titleLabel.textAlignment = UITextAlignmentLeft;
    }
#else
    forgotPassword.titleLabel.textAlignment = UITextAlignmentLeft;
    forgotPasswordLand.titleLabel.textAlignment = UITextAlignmentLeft;
#endif

    forgotPasswordBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    forgotPasswordBase.alpha = 0.0;
    forgotPasswordBase.userInteractionEnabled = NO;
    [self.view addSubview:forgotPasswordBase];
    
    [forgotPasswordBase addSubview:forgotPasswordView];
    [forgotPasswordView addSubview:forgotPasswordTextField];
}

- (void)nextTextField
{
    if ([eTF isFirstResponder]){
        [pTF becomeFirstResponder];
    }
    else if ([eTFLand isFirstResponder]){
        [pTFLand becomeFirstResponder];
    }
}

- (void)previousTextField
{
    if ([pTF isFirstResponder]){
        [eTF becomeFirstResponder];
    }
    else if ([pTFLand isFirstResponder]){
        [eTFLand becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    eTF.text = @"";
	pTF.text = @"";
    
    eTFLand.text = @"";
	pTFLand.text = @"";
    
    if (([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight ||
         [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) && ![BeintooDevice isiPad]) {
        
        beintooView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
    
    if (textField.tag == 99){
        if (![BeintooDevice isiPad])
            forgotPasswordBase.frame = CGRectMake(forgotPasswordBase.frame.origin.x, forgotPasswordBase.frame.origin.y - 80, forgotPasswordBase.frame.size.width, forgotPasswordBase.frame.size.height);
    }
    else {
    
        if (([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
             [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) && ![BeintooDevice isiPad]) {
            if (textField.tag == 21)
                self.view.frame = CGRectMake(self.view.frame.origin.x, - 85, self.view.frame.size.width, self.view.frame.size.height);
            else if (textField.tag == 31)
                self.view.frame = CGRectMake(self.view.frame.origin.x, - 105, self.view.frame.size.width, self.view.frame.size.height);
            else 
                self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
        else {
            if ([BeintooDevice isiPad] && !(([Beintoo appOrientation] == UIInterfaceOrientationPortrait || 
                                             [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown))){
                
            }
            else if (![BeintooDevice isiPad]){
                if (textField.tag == 21)
                    self.view.frame = CGRectMake(self.view.frame.origin.x, - 175, self.view.frame.size.width, self.view.frame.size.height);
                else if (textField.tag == 31)
                    self.view.frame = CGRectMake(self.view.frame.origin.x, - 215, self.view.frame.size.width, self.view.frame.size.height);
                else 
                    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
        }
    }
    
	[UIView commitAnimations];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]){
        UITextField *_textfield = (UITextField *)[self.view viewWithTag:(textField.tag + 10)];
        if (_textfield){
            [_textfield becomeFirstResponder];
        }
        else{
            if (textField.tag != 99)
                [self login];
            else  {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                
                if (![BeintooDevice isiPad]){
                    forgotPasswordBase.frame = CGRectMake(forgotPasswordBase.frame.origin.x, forgotPasswordBase.frame.origin.y + 80, forgotPasswordBase.frame.size.width, forgotPasswordBase.frame.size.height);
                }
                [forgotPasswordTextField resignFirstResponder];
                
                [UIView commitAnimations];
                
                [self forgotPassword:nil];
            }
            [textField resignFirstResponder];
        }
    }
    return YES;
}


- (IBAction)login
{	
	if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
    
    NSString *email;
    NSString *password;
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        email = [eTFLand.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        password = [pTFLand.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    else {
        email = [eTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        password = [pTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];    
    } 
    
    if ([email length] <= 0 || [password length] <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedStringFromTable(@"loginErrorMsg", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [alert release];
#endif
        
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        loginButtonLand.userInteractionEnabled = NO;
        loginButtonLand.alpha = 0.5;
    }
    else {
        loginButton.userInteractionEnabled = NO;
        loginButton.alpha = 0.5;
    }
    [UIView commitAnimations];
    
	[user getUserByM:email andP:password];
    
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        if ([pTFLand isFirstResponder]){
            [pTFLand resignFirstResponder];
        }
        else if ([eTFLand isFirstResponder]) {
            [eTFLand resignFirstResponder];
        }
    }
    else {
        if ([pTF isFirstResponder]){
            [pTF resignFirstResponder];
        }
        else if ([eTF isFirstResponder]) {
            [eTF resignFirstResponder];
        }
    }
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
        [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
	}
	[UIView commitAnimations];
    
    
    [BLoadingView startActivity:self.view];
}

- (void)loginOK
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationReloadDashboard object:self];
    
    [Beintoo postNotificationBeintooUserDidLogin];
    
    if ([BeintooDevice isiPad]){
        [Beintoo dismissIpadLogin];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationSignupClosed object:self];
    
    if ([BeintooDevice isiPad]){
        [Beintoo dismissIpadLogin];
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

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];

    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    if (![forgotPasswordTextField isFirstResponder])
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardDidHide:(NSNotification *)aNotification
{
  [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
{
	NSDictionary* userInfo = [aNotification userInfo];
	
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	 
    if ([BeintooDevice isiPad] && !(([Beintoo appOrientation] == UIInterfaceOrientationPortrait || 
                                     [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown))){
        if (up == YES){
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 220);
            scrollView.contentSize = CGSizeMake(scrollView.contentOffset.x, 650);
            forgotPasswordBase.frame = self.view.frame;
            forgotPasswordView.frame = CGRectMake((forgotPasswordBase.frame.size.width - forgotPasswordView.frame.size.width)/2, (forgotPasswordBase.frame.size.height - forgotPasswordView.frame.size.height)/2, forgotPasswordView.frame.size.width, forgotPasswordView.frame.size.height);
            
        }
        else {
            scrollView.contentSize = CGSizeMake(scrollView.contentOffset.x, 550);
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            [self closeForgotView:nil];
        }
    }
}

- (void)dismissKeyboard
{
    if ([forgotPasswordTextField isFirstResponder]){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if (![BeintooDevice isiPad]){
            forgotPasswordBase.frame = CGRectMake(forgotPasswordBase.frame.origin.x, forgotPasswordBase.frame.origin.y + 80, forgotPasswordBase.frame.size.width, forgotPasswordBase.frame.size.height);
        }
        [forgotPasswordTextField resignFirstResponder];
        
        [UIView commitAnimations];
    }
    else {
        if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                        [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
            if ([eTFLand isFirstResponder])
                [eTFLand resignFirstResponder];
            else if ([pTFLand isFirstResponder])
                [pTFLand resignFirstResponder];
        }
        else {
            if ([eTF isFirstResponder])
                [eTF resignFirstResponder];
            else if ([pTF isFirstResponder])
                [pTF resignFirstResponder];
        }
    }
}

- (IBAction)openForgotView:(id)sender
{
    [self dismissKeyboard];
    
    forgotPasswordBase.frame = self.view.frame;
    forgotPasswordBase.alpha = 0.0;
    forgotPasswordBase.userInteractionEnabled = YES;
    forgotPasswordBase.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    forgotPasswordView.frame = CGRectMake((forgotPasswordBase.frame.size.width - forgotPasswordView.frame.size.width)/2, (forgotPasswordBase.frame.size.height - forgotPasswordView.frame.size.height)/2, forgotPasswordView.frame.size.width, forgotPasswordView.frame.size.height);
    forgotPasswordView.backgroundColor = [UIColor whiteColor];
    [forgotPasswordView.layer setCornerRadius:6.0];
   
    forgotPasswordLabel.text = NSLocalizedStringFromTable(@"forgotPasswordTitle", @"BeintooLocalizable", nil);
    
    forgotPasswordTextField.delegate = self;
    forgotPasswordTextField.placeholder = NSLocalizedStringFromTable(@"loginEmailPlaceholder",@"BeintooLocalizable", nil);
    forgotPasswordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    forgotPasswordTextField.text = @"";
   
    if ([[eTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0){
        forgotPasswordTextField.text = [eTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    [forgotPasswordButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[forgotPasswordButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[forgotPasswordButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [forgotPasswordButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[forgotPasswordButton setTitle:NSLocalizedStringFromTable(@"forgotPasswordSendEmail",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[forgotPasswordButton setButtonTextSize:18];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        [UIView animateWithDuration:0.5
                         animations:^(void) {
                            forgotPasswordBase.alpha = 1.0;
                         } 
                         completion:^(BOOL finished) {
                            forgotPasswordBase.frame = self.view.frame;
                            forgotPasswordView.frame = CGRectMake((forgotPasswordBase.frame.size.width - forgotPasswordView.frame.size.width)/2, (forgotPasswordBase.frame.size.height - forgotPasswordView.frame.size.height)/2, forgotPasswordView.frame.size.width, forgotPasswordView.frame.size.height);
                         }];
    }
    else {
        [UIView beginAnimations:nil context:nil];
        forgotPasswordBase.alpha = 1.0;
        forgotPasswordBase.frame = self.view.frame;
        forgotPasswordView.frame = CGRectMake((forgotPasswordBase.frame.size.width - forgotPasswordView.frame.size.width)/2, (forgotPasswordBase.frame.size.height - forgotPasswordView.frame.size.height)/2, forgotPasswordView.frame.size.width, forgotPasswordView.frame.size.height);
        [UIView commitAnimations];    
    }
}

- (IBAction)closeForgotView:(id)sender
{
    if ([forgotPasswordTextField isFirstResponder])
        [forgotPasswordTextField resignFirstResponder];
        
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        [UIView animateWithDuration:0.5
                         animations:^(void) {
                             forgotPasswordBase.alpha = 0.0;
                         } 
                         completion:^(BOOL finished) {
                            forgotPasswordBase.frame = self.view.frame;
                            forgotPasswordView.frame = CGRectMake((forgotPasswordBase.frame.size.width - forgotPasswordView.frame.size.width)/2, (forgotPasswordBase.frame.size.height - forgotPasswordView.frame.size.height)/2, forgotPasswordView.frame.size.width, forgotPasswordView.frame.size.height);
                         }];
    }
    else {
        [UIView beginAnimations:nil context:nil];
        forgotPasswordBase.alpha = 0.0;
        forgotPasswordBase.frame = self.view.frame;
        forgotPasswordView.frame = CGRectMake((forgotPasswordBase.frame.size.width - forgotPasswordView.frame.size.width)/2, (forgotPasswordBase.frame.size.height - forgotPasswordView.frame.size.height)/2, forgotPasswordView.frame.size.width, forgotPasswordView.frame.size.height);
        [UIView commitAnimations]; 
    }
}

- (IBAction)forgotPassword:(id)sender
{    
    if (![BeintooNetwork connectedToNetwork]){
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
    if ([[forgotPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0){
        [BLoadingView startActivity:forgotPasswordBase];
        [user forgotPassword:[forgotPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"regEmailErrorMessage", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"BeintooLocalizable", nil) otherButtonTitles: nil];
        alert.tag = 555;
        
        [alert show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [alert release];
#endif

    }
}

- (void)didCompleteForgotPassword:(NSDictionary *)result
{
    [BLoadingView stopActivity];
    
    NSString *alertMessage;
    NSString *alertTitle;
    int alertTag;
    if ([[result objectForKey:@"message"] isEqualToString:@"OK"]){
        alertTitle = NSLocalizedStringFromTable(@"forgotPasswordAlertTitle", @"BeintooLocalizable", nil); //@"Email Sent";
        alertMessage = [NSString stringWithFormat:/*@"An email has been sent to %@, check it and retry logging in!"*/ NSLocalizedStringFromTable(@"forgotPasswordAlertSuccess", @"BeintooLocalizable", nil), [forgotPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        alertTag = 100;
    }
    else {
        alertTitle = @"Error";
        alertMessage = [NSString stringWithFormat:@"Check your email: maybe it doesn't exist!"];
        alertTag = 101;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = alertTag;
    [alert show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [alert release];
#endif
    
}

#pragma mark -
#pragma mark UserDelegate

- (void)didGetUserByMail:(NSDictionary *)result
{    
    [UIView beginAnimations:nil context:nil];
    if (![BeintooDevice isiPad] && ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
                                    [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)) {
        loginButtonLand.userInteractionEnabled = YES;
        loginButtonLand.alpha = 1.0;
    }
    else {
        loginButton.userInteractionEnabled = YES;
        loginButton.alpha = 1.0;
    }
    [UIView commitAnimations];
    
    [BLoadingView stopActivity];
    
    if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
        
        
		return;
	}
    
	if ([result objectForKey:@"id"] == nil) {
        UIAlertView *errorAV = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"loginError",@"BeintooLocalizable",@"") 
														  message:NSLocalizedStringFromTable(@"loginErrorMsg",@"BeintooLocalizable",@"") 
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		[errorAV show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [errorAV release];
#endif
		
	}
	if ([result objectForKey:@"id"] != nil) {
		UIAlertView *successAV = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"loginSuccess",@"BeintooLocalizable",@"") 
                                                            message:NSLocalizedStringFromTable(@"loginSuccessMsg",@"BeintooLocalizable",@"") 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
		successAV.tag = 321;
		[successAV show];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [successAV release];
#endif
		
        [_player login:[result objectForKey:@"id"]];
	}
}

#pragma mark -
#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100){
        [self closeForgotView:nil];
    }
    else  if (alertView.tag == 101){
        
    }
	else if (buttonIndex == 0) { 
		if (alertView.tag == 321) {
			[self loginOK];
		}
		[alertView dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void)playerDidLogin:(BeintooPlayer *)player
{
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[user release];
	[_player release];
    [keyboardToolbar release];
    [keyboardToolbarForgot release];
    [forgotPasswordBase release];
    
	[super dealloc];
}
#endif

@end
