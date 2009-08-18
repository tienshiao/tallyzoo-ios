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

- (id)initWithActivity:(TZActivity *)a {
    if (self = [super init]) {
        // Initialization code
		self.userInteractionEnabled = YES;
		self.down = NO;
		self.activity = a;	
		
		clickDownURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(),
											   CFSTR("click_down"),
											   CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(clickDownURL, &clickDownID);
		
		clickUpURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(),
											 CFSTR("click_up"),
											 CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(clickUpURL, &clickUpID);		
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)c {
	[super setBackgroundColor:c];
	
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
						 constrainedToSize:CGSizeMake(self.bounds.size.width, 1000)
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
	
	if (activity.display_total) {
		NSString *numString = [activity sum];
		s = [numString sizeWithFont:[UIFont boldSystemFontOfSize:16]];
		float radius = s.height / 2.0;
		float padding = 10.0;
		float width = s.width - 5.0;
		
		CGContextBeginPath(currentContext);
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, self.bounds.size.width - padding - radius, 0 + padding + 2 * radius);
		CGPathAddLineToPoint(path, NULL, self.bounds.size.width - padding - radius - width, 0 + padding + 2 * radius);
		CGPathAddArc(path, NULL, self.bounds.size.width - padding - radius - width, 0 + padding + radius, radius, M_PI/2, M_PI * 1.5, 0);
		CGPathAddLineToPoint(path, NULL, self.bounds.size.width - padding - radius, 0 + padding);
		CGPathAddArc(path, NULL, self.bounds.size.width - padding - radius, 0 + padding + radius, radius, M_PI * 1.5, M_PI/2, 0);
		
		CGContextSaveGState(currentContext);
		CGContextSetShadow(currentContext, CGSizeMake(0, -4), 3);
		
		CGContextAddPath(currentContext, path);
		CGContextSetRGBFillColor(currentContext, 1, 0, 0, 1.0);
		CGContextFillPath(currentContext);	
		CGContextRestoreGState(currentContext);

		
		CGContextAddPath(currentContext, path);
		CGContextSetLineWidth(currentContext, 2.0);
		CGContextSetRGBStrokeColor(currentContext, 1.0, 1.0, 1.0, 1.0);
		CGContextStrokePath(currentContext);
		
		CGContextSetRGBFillColor(currentContext, 1, 1, 1, 1); 
		[numString drawInRect:CGRectMake(self.bounds.size.width - padding - radius - (s.width - 2.5), padding, s.width, s.height) 
					 withFont:[UIFont boldSystemFontOfSize:16] 
				lineBreakMode:UILineBreakModeWordWrap 
					alignment:UITextAlignmentCenter];
	}
	
	CGContextBeginPath(currentContext);
	CGContextMoveToPoint(currentContext, 0, 0);
	CGContextAddLineToPoint(currentContext, self.bounds.size.width, 0);
	CGContextSetLineWidth(currentContext, 2.0);
	CGContextSetRGBStrokeColor(currentContext, 1, 1, 1, .6);
	CGContextStrokePath(currentContext);
	
	CGContextBeginPath(currentContext);
	CGContextMoveToPoint(currentContext, 0, 0);
	CGContextAddLineToPoint(currentContext, 0, self.bounds.size.height);
	CGContextAddLineToPoint(currentContext, self.bounds.size.width, self.bounds.size.height);
	CGContextAddLineToPoint(currentContext, self.bounds.size.width, 0);
	CGContextSetLineWidth(currentContext, 2.0);
	CGContextSetRGBStrokeColor(currentContext, 0, 0, 0, .6);
	CGContextStrokePath(currentContext);
	
}

#define HOLD_THRESHOLD 2.0
- (void)timeoutTouch {
	if (delegate && [delegate respondsToSelector:@selector(matrixButtonHeld:)]) { 
		[delegate matrixButtonHeld:self];
	}	
	self.down = NO;
	held = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// start timer
	[self performSelector:@selector(timeoutTouch) withObject:nil afterDelay:HOLD_THRESHOLD];
	AudioServicesPlaySystemSound(clickDownID);
	self.down = YES;
	held = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (held) {
		self.down = NO;
		held = NO;
		return;
	}
	// cancel timer
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutTouch) object:nil];
	AudioServicesPlaySystemSound(clickUpID);
	if (delegate && [delegate respondsToSelector:@selector(matrixButtonClicked:)]) { 
		[delegate matrixButtonClicked:self];
	}		
	self.down = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutTouch) object:nil];
	self.down = NO;
	held = NO;
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
	
	
	AudioServicesDisposeSystemSoundID(clickDownID);
	CFRelease(clickDownURL);
	AudioServicesDisposeSystemSoundID(clickUpID);
	CFRelease(clickUpURL);	
}

- (id)delegate {
	return delegate;
}

- (void)setDelegate:(id)d {
	delegate = d;
}


@end
