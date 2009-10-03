//
//  CountTipView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 10/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CountTipView.h"
#import "UIColor-Expanded.h"


@implementation CountTipView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#define TOP_PADDING 5
#define RADIUS 10
#define ARROW_HEIGHT 15
#define ARROW_WIDTH 15
#define ARROW_OFFSET 40

- (void)drawRect:(CGRect)rect {
    // Drawing code
	NSString *text = @"Press this button to count. Press and hold to enter more details.\n\nTap to dismiss.";
	CGRect b = self.bounds;
	double X_WIDTH = b.size.width - ARROW_WIDTH - 2 * RADIUS - 2;
	CGSize s = [text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(X_WIDTH, 1000)];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(context);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, ARROW_WIDTH + RADIUS, 0 + TOP_PADDING);
	CGPathAddLineToPoint(path, NULL, ARROW_WIDTH + RADIUS + X_WIDTH, 0 + TOP_PADDING);
	CGPathAddArc(path, NULL, ARROW_WIDTH + RADIUS + X_WIDTH, 0 + TOP_PADDING + RADIUS, RADIUS, M_PI * 1.5, M_PI * 2, 0);
	CGPathAddLineToPoint(path, NULL, ARROW_WIDTH + RADIUS * 2 + X_WIDTH, 0 + TOP_PADDING + RADIUS + s.height);
	CGPathAddArc(path, NULL, ARROW_WIDTH + RADIUS + X_WIDTH, 0 + TOP_PADDING + RADIUS + s.height, RADIUS, 0, M_PI/2, 0);
	CGPathAddLineToPoint(path, NULL, ARROW_WIDTH + RADIUS, 0 + TOP_PADDING + 2 * RADIUS + s.height);
	CGPathAddArc(path, NULL, ARROW_WIDTH + RADIUS, 0 + TOP_PADDING + RADIUS + s.height, RADIUS, M_PI/2, M_PI, 0);	
	CGPathAddLineToPoint(path, NULL, ARROW_WIDTH, 0 + TOP_PADDING + RADIUS + ARROW_OFFSET + ARROW_HEIGHT/2);
	CGPathAddLineToPoint(path, NULL, 0, 0 + TOP_PADDING + RADIUS + ARROW_OFFSET);
	CGPathAddLineToPoint(path, NULL, ARROW_WIDTH, 0 + TOP_PADDING + RADIUS + ARROW_OFFSET - ARROW_HEIGHT/2);
	CGPathAddLineToPoint(path, NULL, ARROW_WIDTH, 0 + TOP_PADDING + RADIUS);
	CGPathAddArc(path, NULL, ARROW_WIDTH + RADIUS, 0 + TOP_PADDING + RADIUS, RADIUS, M_PI, M_PI * 1.5, 0);	
	
	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"041336"] CGColor]);
	CGContextFillPath(context);	
	
	
	CGContextAddPath(context, path);
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextStrokePath(context);
	
	CGContextSetRGBFillColor(context, 1, 1, 1, 1); 
	[text drawInRect:CGRectMake(ARROW_WIDTH + RADIUS, 0 + TOP_PADDING + RADIUS, s.width, s.height) 
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
