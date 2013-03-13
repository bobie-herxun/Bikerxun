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

#import "BGradientView.h"
#import "QuartzCore/QuartzCore.h"


@implementation BGradientView

-(id)initWithGradientType:(int)gradient
{
	if (self = [super init]){
		gradientType = gradient;
	}
    return self;
}

-(void)setGradientType:(int)_gradientType
{
	gradientType = _gradientType;
}

- (void) removeViews
{
	[[self viewWithTag:22] removeFromSuperview];
	[[self viewWithTag:33] removeFromSuperview];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
	self.contentMode = UIViewContentModeRedraw;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    
#pragma mark -
#pragma mark GRADIENT_BODY
    
	switch (gradientType) {
		case GRADIENT_BODY:{
			CGFloat components[8] = {
				250.0/255, 250.0/255, 250.0/255, 1.0f,
				220.0/255, 220.0/255, 220.0/255, 1.0f,
			};
			
			[self removeViews];
			
			CGFloat locations[2] = {0.0 , 1};
            
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
            
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
            
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			upperBorder.tag		= 22;
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			lowerBorder.tag		= 33;
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
            
            CGGradientRelease(gradient);
#endif
			
		}
			break;
            
#pragma mark -
#pragma mark GRADIENT_HEADER
            
		case GRADIENT_HEADER:{
			CGFloat components[8] = {
				226.0/255, 238.0/255, 254.0/255, 1.0f,
				159.0/255, 182.0/255, 212.0/255, 1.0f,
			};
			
			[self removeViews];
			
			CGFloat locations[2] = {0.0  , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
			upperBorder.tag		= 22;
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			lowerBorder.tag		= 33;
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
            
            CGGradientRelease(gradient);
#endif
            
		}
			break;
			
#pragma mark -
#pragma mark GRADIENT_FOOTER
			
		case GRADIENT_FOOTER:{
			CGFloat components[12] = {
				108.0/255, 128.0/255, 154.0/255, 1.0f,
				108.0/255, 128.0/255, 154.0/255, 1.0f,
				138.0/255, 158.0/255, 184.0/255, 1.0f,
			};
			
			CGFloat locations[3] = {0.0 , 0.5  , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,components,locations,(size_t)3);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            CGGradientRelease(gradient);
#endif
            
		}
			break;	
            
        case GRADIENT_FOOTER_LIGHT:{
			CGFloat components[8] = {
				163.0/255, 175.0/255, 194.0/255, 1.0f,
                117.0/255, 136.0/255, 164.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
            UIView *topBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 1, [self bounds].size.width, 2)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-2, self.frame.size.width, 2)];
			
            upperBorder.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
			upperBorder.backgroundColor = [UIColor colorWithRed:216.0/255 green:221.0/255 blue:229.0/255 alpha:0.9];
			lowerBorder.backgroundColor = [UIColor colorWithRed:216.0/255 green:221.0/255 blue:229.0/255 alpha:0.9];
			
            [self addSubview:topBorder];
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [topBorder release];
            [upperBorder release];
			[lowerBorder release];
            
            CGGradientRelease(gradient);
#endif
        
		}
			break;
        	
			
#pragma mark -
#pragma mark GRADIENT_BUTTONS
            
        case GRADIENT_NOTIF_CELL:{
			CGFloat components[16] = {
				121.0/255, 138.0/255, 163.0/255, 1.0f,
				72.0/255, 94.0/255, 125.0/255, 1.0f,
				64.0/255, 85.0/255, 118.0/255, 1.0f,
                46.0/255, 68.0/255, 102.0/255, 1.0f,
			};
			
			CGFloat locations[4] = {0.0, 0.49, 0.50, 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,components,locations,(size_t)4);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            CGGradientRelease(gradient);
#endif

		}
			break;
            
            
        case GRADIENT_NOTIF_UNDREAD_CELL:{
			CGFloat components[8] = {
				225./255, 230.0/255, 236.0/255, 1.0f,
				205.0/255, 213.0/255, 223.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0, 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
            
            UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
            
            CGGradientRelease(gradient);
#endif
            
        }
			break;
            
#pragma mark -
#pragma mark GRADIENT_BUTTONS
			
		case GRADIENT_BUTTONS:{
			CGFloat components[12] = {
				184.0/255, 188.0/255, 193.0/255, 1.0f,
				151.0/255, 165.0/255, 175.0/255, 1.0f,
				134.0/255, 157.0/255, 168.0/255, 1.0f
			};
			CGFloat locations[3] = {0.0 , 0.5 , 1};
			
			self.layer.cornerRadius  = 5.0;
			self.layer.masksToBounds = YES;
			self.layer.borderWidth   = 1.0;
    
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,components,locations,(size_t)3);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            CGGradientRelease(gradient);
#endif
			
		}
			break;
			
#pragma mark -
#pragma mark GRADIENT_CELLS
			
		case GRADIENT_CELL_HEAD:{
			CGFloat components[8] = {
				226.0/255, 238.0/255, 254.0/255, 1.0f,
				159.0/255, 182.0/255, 212.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
			
		}
			break;
            
        case GRADIENT_CELL_PLAIN:{
			CGFloat components[8] = {
				226.0/255, 238.0/255, 254.0/255, 1.0f,
				226.0/255, 238.0/255, 254.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
			
		}
			break;
            
		case GRADIENT_CELL_BODY:{
			CGFloat components[8] = {
				250.0/255, 250.0/255, 250.0/255, 1.0f,
				220.0/255, 220.0/255, 220.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
        
		}
			break;
            
        case GRADIENT_CELL_GRAY:{
			CGFloat components[8] = {
				250.0/255, 250.0/255, 250.0/255, 1.0f,
				220.0/255, 220.0/255, 220.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
			lowerBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
            
		}
			break;
			
		case GRADIENT_CELL_SPECIAL:{
			CGFloat components[12] = {
				194.0/255, 198.0/255, 203.0/255, 1.0f,
				181.0/255, 195.0/255, 205.0/255, 1.0f,
				164.0/255, 187.0/255, 198.0/255, 1.0f
			};
			CGFloat locations[3] = {0.0 , 0.5 , 1};
            
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,components,locations,(size_t)3);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-2, self.frame.size.width, 2)];
			
			upperBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
            
		}
			break;
			
		case GRADIENT_CELL_SELECTED:{
			CGFloat components[8] = {
				198.0/255, 202.0/255, 206.0/255, 1.0f,
				158.0/255, 166.0/255, 175.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:1.0];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
            
		}
			break;
			
		case GRADIENT_TOOLBAR:{
			CGFloat components[16] = {
				156.0/255, 168.0/255, 184.0/255, 1.0f,
				116.0/255, 135.0/255, 159.0/255, 1.0f,
				108.0/255, 128.0/255, 154.0/255, 1.0f,
				89.0/255,  112.0/255, 142.0/255, 1.0f,
			};
			
			CGFloat locations[4] = {0.0 ,0.5, 0.5, 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)4);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            
            CGGradientRelease(gradient);
#endif
            
		}
			break;
            
        case GRADIENT_BORDERED_VIEW:{
			CGFloat components[8] = {
				250.0/255, 250.0/255, 250.0/255, 1.0f,
				220.0/255, 220.0/255, 220.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
			UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:0.3];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:0.6];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [upperBorder release];
			[lowerBorder release];
			CGGradientRelease(gradient);
#endif
			
		}
			break;
            
        case GRADIENT_UNDREAD_MESSAGE_ICON:{
			CGFloat components[8] = {
				134.0/255, 177.0/255, 246.0/255, 1.0f,
				25.0/255, 63.0/255, 163.0/255, 1.0f,
			};
			
			CGFloat locations[2] = {0.0 , 1};
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,locations,(size_t)2);
			
			CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
			CGPoint midCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
			
			CGContextDrawLinearGradient(ctx, gradient, topCenter, midCenter, (CGGradientDrawingOptions)NULL);
			
            /*UIView *upperBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self bounds].size.width, 1)];
			UIView *lowerBorder = [[UIView alloc]initWithFrame:CGRectMake(0, [self bounds].size.height-1, self.frame.size.width, 1)];
			
			upperBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:0.3];
			lowerBorder.backgroundColor = [UIColor colorWithRed:107.0/255 green:109.0/255 blue:112.0/255 alpha:0.6];
			
			[self addSubview:upperBorder];
			[self addSubview:lowerBorder];
			
			[upperBorder release];
			[lowerBorder release];*/
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            CGGradientRelease(gradient);
#endif
			
		}
			break;
            
    }
	
#ifdef BEINTOO_ARC_AVAILABLE
#else
    CGColorSpaceRelease(colorSpace);
#endif
	
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
