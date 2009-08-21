//
//  LowerLeftView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LowerLeftView.h"


@implementation LowerLeftView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGSize s = self.bounds.size;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextMoveToPoint(context, 0.0, 0.0);
	CGContextAddArc(context, s.width, 0.0, 10.0, M_PI, M_PI * .5, 1);
	CGContextAddLineToPoint(context, 0.0, s.height);
	CGContextAddLineToPoint(context, 0.0, 0.0);
	CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
	CGContextFillPath(context);	
}


- (void)dealloc {
    [super dealloc];
}


@end
