//
//  AddTipView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 10/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddTipView.h"
#import "UIColor-Expanded.h"

@implementation AddTipView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#define X_WIDTH 180
#define PADDING 2
#define TOP_PADDING 60
#define RADIUS 10
#define ARROW_HEIGHT 15
#define ARROW_WIDTH 15
#define ARROW_OFFSET 10
- (void)drawRect:(CGRect)rect {
    // Drawing code
	NSString *text = @"Use this button to add new Activities that you want to track.\n\nTap to dismiss.";
	CGSize s = [text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(X_WIDTH, 1000)];
	CGRect b = self.bounds;
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextBeginPath(context);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, b.size.width - PADDING - RADIUS - X_WIDTH, 0 + TOP_PADDING + ARROW_HEIGHT);
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING - RADIUS - ARROW_OFFSET - ARROW_WIDTH/2, 0 + TOP_PADDING + ARROW_HEIGHT);
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING - RADIUS - ARROW_OFFSET, 0 + TOP_PADDING);
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING - RADIUS - ARROW_OFFSET + ARROW_WIDTH/2, 0 + TOP_PADDING + ARROW_HEIGHT);
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING - RADIUS, 0 + TOP_PADDING + ARROW_HEIGHT);
	CGPathAddArc(path, NULL, b.size.width - PADDING - RADIUS, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS, RADIUS, M_PI * 1.5, M_PI * 2, 0);
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS + s.height);
	CGPathAddArc(path, NULL, b.size.width - PADDING - RADIUS, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS + s.height, RADIUS, 0, M_PI/2, 0);
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING - RADIUS - X_WIDTH, 0 + TOP_PADDING + ARROW_HEIGHT + 2 * RADIUS + s.height);
	CGPathAddArc(path, NULL, b.size.width - PADDING - RADIUS - X_WIDTH, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS + s.height, RADIUS, M_PI/2, M_PI, 0);	
	CGPathAddLineToPoint(path, NULL, b.size.width - PADDING - 2 * RADIUS - X_WIDTH, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS);
	CGPathAddArc(path, NULL, b.size.width - PADDING - RADIUS - X_WIDTH, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS, RADIUS, M_PI, M_PI * 1.5, 0);	
	
	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"041336"] CGColor]);
	CGContextFillPath(context);	

	
	CGContextAddPath(context, path);
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextStrokePath(context);
	
	CGContextSetRGBFillColor(context, 1, 1, 1, 1); 
	[text drawInRect:CGRectMake(b.size.width - PADDING - RADIUS - X_WIDTH, 0 + TOP_PADDING + ARROW_HEIGHT + RADIUS, s.width, s.height) 
			withFont:[UIFont boldSystemFontOfSize:16] 
	   lineBreakMode:UILineBreakModeWordWrap 
		   alignment:UITextAlignmentLeft];
	
	CGPathRelease(path);
	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.hidden = YES;
}

- (void)dealloc {
    [super dealloc];
}


@end
