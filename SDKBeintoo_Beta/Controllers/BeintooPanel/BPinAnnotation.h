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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface BPinAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D  coordinate;
    NSString                *mTitle;
    NSString                *mSubTitle;
    int                     tag;
}

@property (nonatomic, assign) CLLocationCoordinate2D    coordinate;
@property (nonatomic, retain) NSString                  *mTitle;
@property (nonatomic, retain) NSString                  *mSubTitle;
@property (nonatomic, assign) int                       tag;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c andTitle:(NSString *)_title andSubTitle:(NSString*)_subTitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

- (NSString *)subtitle;
- (NSString *)title;

@end
