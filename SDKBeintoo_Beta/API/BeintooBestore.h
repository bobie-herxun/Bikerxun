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

#define KIND_FEATURED           @"FEATURED"
#define KIND_NATIONAL           @"NATIONAL"
#define KIND_NATIONAL_TOPSOLD   @"NATIONAL_TOPSOLD"
#define CATEGORY_KIND           @"CATEGORY"
#define SUB_CATEGORY_KIND       @"SUB_CATEGORY"
#define KIND_AROUND_ME          @"AROUNDME"

#define SORT_DISTANCE           @"DISTANCE"
#define SORT_PRICE              @"PRICE" // <---- PRICE_DESC
#define SORT_PRICE_ASC          @"PRICE_ASC"

#import <Foundation/Foundation.h>
#import "Parser.h"

@protocol BeintooBestoreDelegate;

@interface BeintooBestore : NSObject <BeintooParserDelegate> {

    id <BeintooBestoreDelegate> delegate;
	Parser *parser;
	
	NSString *rest_resource;
    NSString *rest_resource_vgood;
}

- (NSString *)restResource;

- (void)getContentForKind:(NSString *)_kind andStart:(int)_start andNumberOfRows:(int)_rows andSorting:(NSString *)_sorting;
- (void)getContentForKind:(NSString *)_kind andCategory:(NSString *)_category andStart:(int)_start andNumberOfRows:(int)_rows andSorting:(NSString *)_sorting;
- (void)getCategories;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooBestoreDelegate> delegate;
#else
@property(nonatomic, assign) id <BeintooBestoreDelegate> delegate;
#endif

@property(nonatomic,retain) Parser *parser;
    
@end

@protocol BeintooBestoreDelegate <NSObject>

@optional
- (void)didBestoreGotContent:(NSMutableArray *)result;
- (void)didBestoreGotCategories:(NSMutableArray *)result;
- (void)didBestoreGotCategoryContent:(NSMutableArray *)result;

- (void)didNotBestoreGotCategoryContent;
- (void)didNotBestoreGotCategories;
- (void)didNotBestoreGotContent;


@end
