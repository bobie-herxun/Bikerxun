//
//  AppDelegate.h
//  Bikerxun
//
//  Created by Bobie on 3/13/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeintooDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow                *window;
    BeintooDelegate         *sampleDelegate;
}

@property (strong, nonatomic) UIWindow *window;

@end
