//
//  MatrixButton.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixButton.h"
#import "UIColor-Expanded.h"

@implementation MatrixButton

@synthesize delegate;

- (id)initWithActivity:(TZActivity *)a {
    if (self = [super init]) {
        // Initialization code
		self.userInteractionEnabled = YES;
		self.down = NO;
		self.activity = a;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)c {
	[super setBackgroundColor:c];
	
//	double test = 0.299 * c.red * 255.0 + 0.587 * c.green * 255.0 + 0.114 * c.blue * 255.0;
//	NSLog(@"%f %f %f", c.red, c.green, c.blue);
	
	if (0.299 * c.red * 255 + 0.587 * c.green * 255 + 0.114 * c.blue * 255 > 100) {
		black = YES;
	} else {
		black = NO;
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef currentContext = UIGraphicsGetCurrentContext();

	CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.45,  // Start color
	1.0, 1.0, 1.0, 0.06 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
	if (self.down) {
		CGContextDrawLinearGradient(currentContext, glossGradient, bottomCenter, midCenter, 0);
	} else {
		CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
	}
	
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
	
	// TODO draw edge
	// TODO draw title better
	if (black) {
		CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
	} else {
		CGContextSetRGBFillColor(currentContext, 1, 1, 1, 1);
	}
	
	CGSize s = [activity.name sizeWithFont:[UIFont boldSystemFontOfSize:16] 
						          forWidth:self.bounds.size.width 
							 lineBreakMode:UILineBreakModeWordWrap];
	if (s.height < self.bounds.size.height) {
		CGRect r = self.bounds;
		r.origin.y = (r.size.height - s.height) / 2;
		r.size.height = s.height;
		
		[activity.name drawInRect:r 
						 withFont:[UIFont boldSystemFontOfSize:16] 
				    lineBreakMode:UILineBreakModeWordWrap 
				        alignment:UITextAlignmentCenter];
	} else {
		[activity.name drawInRect:self.bounds 
						 withFont:[UIFont systemFontOfSize:16] 
					lineBreakMode:UILineBreakModeWordWrap 
				        alignment:UITextAlignmentCenter];
	}
	
	// TODO draw badge
}

#define HOLD_THRESHOLD 2.0
- (void)timeoutTouch {
	if (delegate && [delegate respondsToSelector:@selector(matrixButtonHeld:)]) { 
		[delegate maxtrixButtonHeld:self];
	}	
	NSLog(@"hold event triggered");
	self.down = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// start timer
	[self performSelector:@selector(timeoutTouch) withObject:nil afterDelay:HOLD_THRESHOLD];
	self.down = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// cancel timer
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutTouch) object:nil];
	if (delegate && [delegate respondsToSelector:@selector(matrixButtonClicked:)]) { 
		[delegate maxtrixButtonClicked:self];
	}		
	NSLog(@"button even triggered");
	self.down = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutTouch) object:nil];
	self.down = NO;
}

- (BOOL)down {
	return down;
}

- (void)setDown:(BOOL) d {
	if (d != down) {
		[self setNeedsDisplay];
		down = d;
	}
}

- (TZActivity *)activity {
	return activity;
}

- (void)setActivity:(TZActivity *)a {
	[a retain];
	[activity release];
	activity = a;
	[self setBackgroundColor:a.color];
	[self setNeedsDisplay];
}

- (void)dealloc {
    [super dealloc];
	[activity release];
}


@end
