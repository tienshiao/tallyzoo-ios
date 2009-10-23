//
//  CheckboxView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CheckboxView.h"


@implementation CheckboxView

@synthesize label;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		CGRect r = frame;
		r.origin.x = 23;
		r.origin.y = 0;
		r.size.width = r.size.width - 23;
		label = [[UILabel alloc] initWithFrame:r];
		label.backgroundColor = [UIColor clearColor];
		[self addSubview:label];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGRect r = CGRectMake(2, 2, 16, 16);
	
	if (checked) {
		CGContextAddEllipseInRect(context, r);
		CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
		CGContextFillPath(context);
		CGContextAddEllipseInRect(context, r);		
		CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
//		CGContextSetLineWidth(context, 2);
		CGContextStrokePath(context);
		
		CGRect inner = CGRectMake(7, 8, 6, 6);
		CGContextAddEllipseInRect(context, inner);
		CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
		CGContextFillPath(context);
		inner = CGRectMake(7, 7, 6, 6);
		CGContextAddEllipseInRect(context, inner);
		CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
		CGContextFillPath(context);
		
	} else {
		CGContextAddEllipseInRect(context, r);		
		CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
		CGContextFillPath(context);
		CGContextAddEllipseInRect(context, r);		
		CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
//		CGContextSetLineWidth(context, 2);
		CGContextStrokePath(context);		
	}
	
	if (highlighted) {
	} else {
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	checked = !checked;
	[self setNeedsDisplay];
	
	if ([delegate respondsToSelector:@selector(checkSelected:)]) { 
		[delegate checkSelected:self];
	}		
}

- (BOOL)checked {
	return checked;
}

- (void)setChecked:(BOOL)c {
	if (checked == c) {
		return;
	}
	
	checked = c;
	[self setNeedsDisplay];
}

- (void)dealloc {
	[label release];
	label = nil;
	
    [super dealloc];
}


@end
