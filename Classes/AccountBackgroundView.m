//
//  AccountBackgroundView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AccountBackgroundView.h"


@implementation AccountBackgroundView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	CGSize s = self.bounds.size;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 10, 0);
	CGPathAddLineToPoint(path, NULL, s.width - 10, 0);
	CGPathAddArc(path, NULL, s.width - 10, 10, 10, M_PI * 1.5, 0, 0);
	CGPathAddLineToPoint(path, NULL, s.width, s.height - 10);
	CGPathAddArc(path, NULL, s.width - 10, s.height - 10, 10, 0, M_PI * .5, 0);
	CGPathAddLineToPoint(path, NULL, 10, s.height);
	CGPathAddArc(path, NULL, 10, s.height - 10, 10, M_PI * .5, M_PI, 0);
	CGPathAddLineToPoint(path, NULL, 0, 10);
	CGPathAddArc(path, NULL, 10, 10, 10, M_PI, M_PI * 1.5, 0);

	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextFillPath(context);
	
	CGContextAddPath(context, path);
	CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 0, s.height / 2);
	CGContextAddLineToPoint(context, s.width, s.height / 2);
	CGContextStrokePath(context);
	
	CGPathRelease(path);
}


- (void)dealloc {
    [super dealloc];
}


@end
