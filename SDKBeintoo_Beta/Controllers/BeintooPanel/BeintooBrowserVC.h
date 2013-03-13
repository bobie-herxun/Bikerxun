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

#import <UIKit/UIKit.h>


@interface BeintooBrowserVC : UIViewController <UIWebViewDelegate,UINavigationBarDelegate>{

	IBOutlet UIWebView		*_webView;
	UIActivityIndicatorView *loadingIndicator;
	NSString				*urlToOpen;
    BOOL                    allowCloseWebViewAndDismissBeintoo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL;
- (void)setUrlToOpen:(NSString *)_url;
- (void)setAllowCloseWebView:(BOOL)_value;
- (UIButton *)closeButton;

- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)refresh:(id)sender;

@property(nonatomic,retain) NSString *urlToOpen;
@property(nonatomic,assign) BOOL            isFromNotification;

@end
