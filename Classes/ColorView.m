//
//  ColorView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ColorView.h"
#import "UIColor-Expanded.h"

@implementation ColorView

@synthesize color;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = nil;
		self.opaque = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGRect r;
	if (self.bounds.size.width < self.bounds.size.height) {
		r.size.width = self.bounds.size.width - 1;
		r.size.height = r.size.width;
	} else {
		r.size.width = self.bounds.size.height - 1;
		r.size.height = r.size.width;
	}
	r.origin.x = (self.bounds.size.width - r.size.width) / 2;
	r.origin.y = (self.bounds.size.height - r.size.height) / 2;	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextAddEllipseInRect(context, r);
	CGContextSetRGBFillColor(context, color.red, color.green, color.blue, 1.0);
	CGContextFillPath(context);	
	CGContextSetLineWidth(context, 1.0);
	CGContextSetRGBStrokeColor(context, 0.4, 0.4, 0.4, 1.0);
	CGContextAddEllipseInRect(context, r);
	CGContextStrokePath(context);
}


- (void)dealloc {
	[color release];

    [super dealloc];
}


@end
