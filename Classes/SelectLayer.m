//
//  SelectLayer.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SelectLayer.h"


@implementation SelectLayer

- (void)drawRect:(CGRect)rect {
    // Drawing code
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetRGBFillColor(context, 1, 1, 1, .15);
	CGContextFillRect(context, CGRectMake(0, 1, self.bounds.size.width, 1));
	CGContextSetRGBFillColor(context, 1, 1, 1, .08);
	CGContextFillRect(context, CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.height/2));
}

@end
