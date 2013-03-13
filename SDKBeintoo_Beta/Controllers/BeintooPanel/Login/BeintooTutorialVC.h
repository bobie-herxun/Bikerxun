/*******************************************************************************
 * Copyright 2011 Beintoo - author gpiazzese@beintoo.com
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
#import "BButton.h"
#import "BView.h"

@interface BeintooTutorialVC : UIViewController <UIWebViewDelegate> {
    
    
    IBOutlet BButton *goToDashboard;
    IBOutlet BButton *goToDashboardLand;
    IBOutlet UIView   *mainView;
    IBOutlet UIView   *landView;
    
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;

    IBOutlet UILabel *labelLand1;
    IBOutlet UILabel *labelLand2;
    IBOutlet UILabel *labelLand3;
    
    UIWebView *webview1;
    UIWebView *webview2;
    UIWebView *webview3;
    
    UIWebView *webview1Land;
    UIWebView *webview2Land;
    UIWebView *webview3Land;

}

@property (nonatomic, assign) BOOL   isFromDirectLaunch;

@end
