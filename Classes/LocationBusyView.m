//
//  LocationBusyView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationBusyView.h"


@implementation LocationBusyView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = NO;
		self.alpha = 0.8;
		
		UIActivityIndicatorView *a = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, frame.size.height - 20, frame.size.height - 20)];
		a.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[a startAnimating];
		[self addSubview:a];
		[a release];
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGSize s = self.bounds.size;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// clipping for rounded corners
	CGContextMoveToPoint(context, 10, 0);
	CGContextAddLineToPoint(context, s.width - 10, 0);
	CGContextAddArc(context, s.width - 10, 10, 10, M_PI * 1.5, 0, 0);
	CGContextAddLineToPoint(context, s.width, s.height - 10);
	CGContextAddArc(context, s.width - 10, s.height - 10, 10, 0, M_PI * .5, 0);
	CGContextAddLineToPoint(context, 10, s.height);
	CGContextAddArc(context, 10, s.height - 10, 10, M_PI * .5, M_PI, 0);
	CGContextAddLineToPoint(context, 0, 10);
	CGContextAddArc(context, 10, 10, 10, M_PI, M_PI * 1.5, 0);
	CGContextClip(context);
	
	CGContextAddRect(context, self.bounds);
	CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
	CGContextFillPath(context);

	
}


- (void)dealloc {
    [super dealloc];
}


@end
