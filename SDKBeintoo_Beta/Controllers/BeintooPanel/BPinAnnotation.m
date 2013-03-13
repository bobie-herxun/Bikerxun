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

#import "BPinAnnotation.h"

@implementation BPinAnnotation
@synthesize coordinate, mTitle, mSubTitle, tag;

- (NSString *)subtitle{
    return  mSubTitle;
}

- (NSString *)title{
    return mTitle;
}

- (int)tag{
    return tag;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c andTitle:(NSString *)_title andSubTitle:(NSString*)_subTitle{
    self.coordinate = c;
    
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate = c;
    return self;

}

@end
