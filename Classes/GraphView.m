//
//  GraphView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "TZCount.h"
#import "UIColor-Expanded.h"


#define FONT_SIZE 16

#define TIMESPAN_1D  0
#define TIMESPAN_1W  1
#define TIMESPAN_1M  2
#define TIMESPAN_3M  3
#define TIMESPAN_6M  4
#define TIMESPAN_1Y  5
#define TIMESPAN_ALL 6


@implementation GraphView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		formatter = [[NSNumberFormatter alloc] init];
		[formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		
		timespan = TIMESPAN_ALL;
		
		timespans = [[NSArray alloc] initWithObjects:@"1d", @"1w", @"1m", @"3m", @"6m", @"1y", @"all", nil];
		
		[self findMinMax];	
    }
    return self;
}

- (void)findMinMax {
	double current = activity.initial_value;
	ymin = activity.initial_value;
	ymax = activity.initial_value;
	ysig = activity.init_sig;
	
	// TODO adjust ymin/ymax based on visible x timespan
//	NSEnumerator *e = [activity.counts objectEnumerator];
//	TZCount *c;
//	while (c = (TZCount *)[e nextObject]) {
	for (TZCount *c in activity.counts) {
		current += c.amount;
		if (current < ymin) {
			ymin = current;
		} else if (current > ymax) {
			ymax = current;
		}
		if (c.amount_sig > ysig) {
			ysig = c.amount_sig;
		}
	}
	
	// all data
	if (timespan == TIMESPAN_ALL) {
		if ([activity.counts count]) {
			xmin = [[dateFormatter dateFromString:[[activity.counts objectAtIndex:0] created_on]] retain];
			xmax = [[dateFormatter dateFromString:[[activity.counts objectAtIndex:[activity.counts count] - 1] created_on]] retain];
		}
				
		x_start_sec = [xmin timeIntervalSinceReferenceDate];
		x_end_sec = [xmax timeIntervalSinceReferenceDate];
	} else if (timespan == TIMESPAN_1D) {
		x_start_sec = [NSDate timeIntervalSinceReferenceDate] - 24 * 60 * 60;
		x_end_sec = [NSDate timeIntervalSinceReferenceDate];
	} else if (timespan == TIMESPAN_1W) {
		x_start_sec = [NSDate timeIntervalSinceReferenceDate] - 7 * 24 * 60 * 60;
		x_end_sec = [NSDate timeIntervalSinceReferenceDate];
	} else if (timespan == TIMESPAN_1M) {
		x_start_sec = [NSDate timeIntervalSinceReferenceDate] - 30 * 24 * 60 * 60;
		x_end_sec = [NSDate timeIntervalSinceReferenceDate];
	} else if (timespan == TIMESPAN_3M) {
		x_start_sec = [NSDate timeIntervalSinceReferenceDate] - 90 * 24 * 60 * 60;
		x_end_sec = [NSDate timeIntervalSinceReferenceDate];		
	} else if (timespan == TIMESPAN_6M) {
		x_start_sec = [NSDate timeIntervalSinceReferenceDate] - 180 * 24 * 60 * 60;
		x_end_sec = [NSDate timeIntervalSinceReferenceDate];				
	} else if (timespan == TIMESPAN_1Y) {
		x_start_sec = [NSDate timeIntervalSinceReferenceDate] - 365 * 24 * 60 * 60;
		x_end_sec = [NSDate timeIntervalSinceReferenceDate];				
	}

	
	
	[formatter setMaximumFractionDigits:ysig];
	[formatter setMinimumFractionDigits:ysig];
	
	ywidth = 0;
	
	NSString *numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin]];
	CGSize s = [numString sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
	if (s.width > ywidth) {
		ywidth = s.width;
	}
	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin + ((ymax - ymin) / 3)]];
	s = [numString sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
	if (s.width > ywidth) {
		ywidth = s.width;
	}
	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin + (2 * (ymax - ymin) / 3)]];
	s = [numString sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
	if (s.width > ywidth) {
		ywidth = s.width;
	}
	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymax]];
	s = [numString sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
	if (s.width > ywidth) {
		ywidth = s.width;
	}	
}

#define TOP_PADDING 25

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGSize s = self.bounds.size;
	BOOL showName = s.height > 270;
	double top = (showName) ? TOP_PADDING : 0;
	double top_padding = (showName) ? 2 * TOP_PADDING : TOP_PADDING;
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
	
	// color the background
	CGContextAddRect(context, CGRectMake(0, 0, s.width, s.height));
	CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"191970"] CGColor]);
	CGContextFillPath(context);

	// do the shading for the upper half
	CGContextAddRect(context, CGRectMake(0, 0, s.width, s.height / 2));
	CGContextSetRGBFillColor(context, 1, 1, 1, .1);
	CGContextFillPath(context);
	
	// draw name
	if (showName) {
		NSString *name = activity.name;
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
		[name drawAtPoint:CGPointMake(10, 2) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
	}

	// draw timespans
	double width = s.width / [timespans count];
	for (int i = 0; i < [timespans count]; i++) {
		NSString *t = [timespans objectAtIndex:i];
		CGSize ts = [t sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		double x_offset = i * width + (width - ts.width) / 2;
		if (i == timespan) {
			CGContextMoveToPoint(context, x_offset, top + 2);
			CGContextAddLineToPoint(context, x_offset + ts.width, top + 2);
			CGContextAddArc(context, x_offset + ts.width, top + 2 + ts.height/2, ts.height/2, M_PI * 1.5, M_PI * .5, 0);
			CGContextAddLineToPoint(context, x_offset, top + 2 + ts.height);
			CGContextAddArc(context, x_offset, top + 2 + ts.height/2, ts.height/2, M_PI * .5, M_PI * 1.5, 0);
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
			CGContextFillPath(context);

			CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"191970"] CGColor]);
			[t drawAtPoint:CGPointMake(x_offset, top + 2) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		} else {
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
			[t drawAtPoint:CGPointMake(x_offset, top + 2) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		}
	}
	
	CGContextSetLineWidth(context, 1);

	// draw x axis
	CGContextMoveToPoint(context, 0, s.height - 20);
	CGContextAddLineToPoint(context, s.width, s.height - 20);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, .6);
	CGContextStrokePath(context);
	
	// draw y axis
/*	CGContextMoveToPoint(context, s.width - ywidth - 6, s.height - 21);
	CGContextAddLineToPoint(context, s.width - ywidth - 6, 20);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, .6);
	CGContextStrokePath(context);	*/

	// draw y axis labels
	CGContextSetRGBFillColor(context, 1, 1, 1, 1); 
	NSString *numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin]];
	CGSize ns = [numString sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding + s.height - top_padding - 20 - ns.height) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];

	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin + (ymax - ymin) / 3]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding + (s.height - top_padding - 20 - ns.height) * 2 / 3) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];

	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin + (ymax - ymin) * 2 / 3]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding + (s.height - top_padding - 20 - ns.height) / 3) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];	
	
	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymax]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];

	
	double xwidth = s.width - ywidth - 6;
	double xwidth_secs = x_end_sec - x_start_sec;

	// draw x lines
	int x_lines = 0;
	if (timespan == TIMESPAN_ALL) {
		x_lines = 5;
	} else if (timespan == TIMESPAN_1D) {
		x_lines = 7;
	} else if (timespan == TIMESPAN_1W) {
		x_lines = 6;
	} else if (timespan == TIMESPAN_1M) {
		x_lines = 4;
	} else if (timespan == TIMESPAN_3M) {
		x_lines = 2;
	} else if (timespan == TIMESPAN_6M) {
		x_lines = 5;
	} else if (timespan == TIMESPAN_1Y) {
		x_lines = 5;
	}
	CGContextSetRGBStrokeColor(context, 1, 1, 1, .6);
	for (int i = 0; i < x_lines; i++) {
		double x_pos = (i + 1) * xwidth / x_lines;
		CGContextMoveToPoint(context, x_pos, s.height - 21);
		CGContextAddLineToPoint(context, x_pos, top_padding);
		CGContextStrokePath(context);			
	}
	
	// draw x axis labels
	NSDateFormatter *xformatter = [[NSDateFormatter alloc] init];
	if (timespan == TIMESPAN_ALL) {
		// TODO magic picking thingy
		[xformatter setDateFormat:@"H"];
	} else if (timespan == TIMESPAN_1D) {
		[xformatter setDateFormat:@"H"];
	} else if (timespan == TIMESPAN_1W) {
		[xformatter setDateFormat:@"d"];
	} else if (timespan == TIMESPAN_1M) {
		[xformatter setDateFormat:@"d"];
	} else if (timespan == TIMESPAN_3M) {
		[xformatter setDateFormat:@"MMM"];
	} else if (timespan == TIMESPAN_6M) {
		[xformatter setDateFormat:@"MMM"];
	} else if (timespan == TIMESPAN_1Y) {
		[xformatter setDateFormat:@"MMM"];
	}
	CGContextSetRGBFillColor(context, 1, 1, 1, 1); 
	for (int i = 0; i <= x_lines; i++) {
		double x_pos = i * xwidth / x_lines;
		NSDate *d = [NSDate dateWithTimeIntervalSinceReferenceDate:xwidth_secs * i / x_lines + x_start_sec];
		NSString *ds = [xformatter stringFromDate:d];
		CGSize xs = [ds sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		if (i > 0) {
			[ds drawAtPoint:CGPointMake(x_pos - xs.width / 2 , s.height - 19) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		}
	}
	[xformatter release];
	
	if (activity) {
		// draw graph
		double current = activity.initial_value;
//		for (int i = 0; i < [activity.counts count]; i++) {
//			TZCount *c = [activity.counts objectAtIndex:i];
		int i = 0;
		for (TZCount *c in activity.counts) {
			NSDate *cdate = [dateFormatter dateFromString:c.created_on];
			current += c.amount;
			double c_secs = [cdate timeIntervalSinceReferenceDate];
			double x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
			double y_pos = (current - activity.initial_value) / (ymax - ymin) * (s.height - 21 - top_padding);
			if (i == 0) {
				CGContextMoveToPoint(context, x_pos, s.height - 21 - y_pos);
			} else {
				CGContextAddLineToPoint(context, x_pos, s.height - 21 - y_pos);
			}
			i++;
		}
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
		CGContextSetLineWidth(context, 2);
		CGContextStrokePath(context);
		
		// fill graph
		current = activity.initial_value;
		double first_x_pos;
//		for (int i = 0; i < [activity.counts count]; i++) {
//			TZCount *c = [activity.counts objectAtIndex:i];
		i = 0;
		for (TZCount *c in activity.counts) {			
			NSDate *cdate = [dateFormatter dateFromString:c.created_on];
			current += c.amount;
			double c_secs = [cdate timeIntervalSinceReferenceDate];
			double x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
			double y_pos = (current - activity.initial_value) / (ymax - ymin) * (s.height - 21 - top_padding);
			if (i == 0) {
				CGContextMoveToPoint(context, x_pos, s.height - 21 - y_pos);
				first_x_pos = x_pos;
			} else {
				CGContextAddLineToPoint(context, x_pos, s.height - 21 - y_pos);
			}
			i++;
		}
		CGContextAddLineToPoint(context, xwidth, s.height - 21);
		CGContextAddLineToPoint(context, first_x_pos, s.height - 21);
		CGContextSetRGBFillColor(context, 1, 1, 1, 0.15);
		CGContextFillPath(context);
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	int old_timespan = timespan;	
	double width = self.bounds.size.width / [timespans count];
	BOOL showName = self.bounds.size.height > 270;
	double top_padding = (showName) ? 2 * TOP_PADDING : TOP_PADDING;
	double top = (showName) ? TOP_PADDING : 0;
	
	for (UITouch *touch in touches) {
		CGPoint location = [touch locationInView:self];
		if (location.y > top && location.y < top_padding) {
			timespan = location.x / width;
		}
	}
	
	if (old_timespan != timespan) {
		[self findMinMax];
		[self setNeedsDisplay];
	}
}

- (TZActivity *)activity {
	return activity;
}

- (void)setActivity:(TZActivity *)a {
	if (activity == a) {
		return;
	}
	activity = a;
	
	[activity loadCounts];
	
	[self findMinMax];	
	[self setNeedsDisplay];
}


- (void)dealloc {
    [super dealloc];
	
	[formatter release];
	[dateFormatter release];
	
	[xmax release];
	[xmin release];
	
	[timespans release];
}


@end
