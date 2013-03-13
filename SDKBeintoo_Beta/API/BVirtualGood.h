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

#import <Foundation/Foundation.h>

#define VGOOD_STATIC_IMAGE_URL_SMALL @"http://static.beintoo.com.s3.amazonaws.com/images/defaults/vgood_small.jpg"
#define VGOOD_STATIC_IMAGE_URL  @"http://static.beintoo.com.s3.amazonaws.com/images/defaults/vgood.jpg"

@interface BVirtualGood : NSObject {
	
	NSDictionary *theGood;
	NSArray		 *theGoodsList;
	
	NSString			 *vGoodDescription;
	NSString			 *getItRealURL;
	NSData				 *vGoodImageData;
	NSString			 *vGoodName;
	NSString			 *vGoodEndDate;
	NSString			 *vGoodID;
	NSMutableArray		 *whoAlsoConverted;
	
    BOOL                 isRecommendation;
	BOOL				 isHTML;
	BOOL				 isGenerated;
	BOOL				 isMultipleVgood;
}

- (BOOL)isMultiple;
- (void)setIsMultiple:(BOOL)_isMultiple;
- (BOOL)isRecommendation;
- (BOOL)isHTMLRecommendation;
- (void)setVgoodContent:(NSDictionary *)_vgood;
- (id)init;

@property(nonatomic,retain) NSDictionary    *theGood;
@property(nonatomic,retain) NSArray         *theGoodsList;
@property(nonatomic,retain) NSString        *vGoodDescription;
@property(nonatomic,retain) NSString        *getItRealURL;
@property(nonatomic,retain) NSString        *vGoodName;
@property(nonatomic,retain) NSString        *vGoodEndDate;
@property(nonatomic,retain) NSString        *vGoodID;
@property(nonatomic,retain)	NSData          *vGoodImageData;
@property(nonatomic,retain) NSMutableArray  *whoAlsoConverted;
@property(nonatomic, assign) BOOL openInBrowser;
	
@end
