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

#import "BeintooGraphic.h"

@implementation BeintooGraphic

-(id)init
{
	if (self = [super init])
	{
	}
    return self;
}

+ (float)getPixelsForString:(NSString *)aString andFontSize:(NSInteger)fontSize
{
	float conversionVal = 7.0/fontSize;
	return ([aString length]/conversionVal)*PIXELS_FOR_CHAR;
}

+ (NSString *)getHtmlCodeForString:(NSString *)_text withHexColor:(NSString *)_hexColor size:(int)_fontSize andFontName:(NSString *)_fontName
{
    NSString *htmlCodedString = [NSString stringWithFormat:@"<font face=\"%@\" size=\"%d\" color=#%@>%@</font>", _fontName, _fontSize,_hexColor,_text];
    return htmlCodedString;
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
