//
//  GraphView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <float.h>
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
		
		infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		CGRect r = infoButton.frame;
		r.origin.x = self.bounds.size.width - r.size.width - 2;
		r.origin.y = self.bounds.size.height - r.size.height - 2;
		infoButton.frame = r;
		[self addSubview:infoButton];
		
		[infoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

		graphOptionsView = [[GraphOptionsView alloc] initWithFrame:self.bounds];
		graphOptionsView.delegate = self;
		graphOptionsView.hidden = YES;
		[self addSubview:graphOptionsView];
    }
    return self;
}

- (void)findMinMax {
	NSMutableArray *counts = nil;
	double current = activity.initial_value;
	ysig = activity.init_sig;
	
	[xmin release];
	xmin = nil;
	[xmax release];
	xmax = nil;
	
	ymin = 0.0;
	ymax = 0.0;
	
	// TODO adjust ymin/ymax based on visible x timespan
	if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED) {
		ymin = current;
		ymax = current;
		for (TZCount *c in activity.counts) {
			current += c.amount;
			if (current < ymin) {
				ymin = current;
			}
			if (current > ymax) {
				ymax = current;
			}
			if (c.amount_sig > ysig) {
				ysig = c.amount_sig;
			}
		}
	} else if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED_DAILY) {
		ymin = DBL_MAX;
		ymax = -DBL_MAX;
		counts = [activity getDayCounts];
		if ([counts count]) {
			for (TZCount *c in counts) {
				current = c.amount;
				if (current < ymin) {
					ymin = current;
				} 
				if (current > ymax) {
					ymax = current;
				}
				if (c.amount_sig > ysig) {
					ysig = c.amount_sig;
				}
			}		
		} else {
			ymin = 0;
			ymax = 0;
		}
	} else if (activity.graph_type == TZACTIVITY_SLIDING_NOTSUMMED) {
		ymin = DBL_MAX;
		ymax = -DBL_MAX;
		if ([activity.counts count]) {
			for (TZCount *c in activity.counts) {
				current = c.amount;
				if (current < ymin) {
					ymin = current;
				}
				if (current > ymax) {
					ymax = current;
				}
				if (c.amount_sig > ysig) {
					ysig = c.amount_sig;
				}
			}		
		} else {
			ymin = 0;
			ymax = 0;
		}
	}
	
	if (ymin == ymax) {
		double half = ymin / 2.0;
		ymin -= half;
		ymax += half;
	}
	
	// all data
	if (timespan == TIMESPAN_ALL) {
		if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED_DAILY) {
			if ([counts count]) {
				xmin = [[dateFormatter dateFromString:[[counts objectAtIndex:0] created_on]] retain];
				xmax = [[dateFormatter dateFromString:[[counts objectAtIndex:[counts count] - 1] created_on]] retain];
			}
		} else {
			if ([activity.counts count]) {
				xmin = [[dateFormatter dateFromString:[[activity.counts objectAtIndex:0] created_on]] retain];
				xmax = [[dateFormatter dateFromString:[[activity.counts objectAtIndex:[activity.counts count] - 1] created_on]] retain];
			}
		}
		x_start_sec = [xmin timeIntervalSinceReferenceDate];
		x_end_sec = [xmax timeIntervalSinceReferenceDate];
		
		if (x_start_sec == x_end_sec) {
			x_start_sec -= 12 * 60 * 60;
			x_end_sec += 12 * 60 * 60;
		}
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
		
		NSString *type = nil;
		if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED ||
			activity.graph_type == TZACTIVITY_CALENDAR_SUMMED) {
			type = @"Adding up over time";
		} else if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED_DAILY ||
				   activity.graph_type == TZACTIVITY_CALENDAR_SUMMED_DAILY) {
			type = @"Daily Totals over time";
		} else if (activity.graph_type == TZACTIVITY_SLIDING_NOTSUMMED ||
				   activity.graph_type == TZACTIVITY_CALENDAR_NOTSUMMED) {
			type = @"Values over time";
		}
		
		if (type) {
			CGSize ts = [type sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
			CGContextSetRGBFillColor(context, 1, 1, 1, .6);
			[type drawAtPoint:CGPointMake(s.width - 10 - ts.width, 2) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		}
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
	CGContextMoveToPoint(context, 0, s.height - 22);
	CGContextAddLineToPoint(context, s.width, s.height - 22);
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
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding + s.height - top_padding - 22 - ns.height) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];

	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin + (ymax - ymin) / 3]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding + (s.height - top_padding - 22 - ns.height) * 2 / 3) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];

	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymin + (ymax - ymin) * 2 / 3]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding + (s.height - top_padding - 22 - ns.height) / 3) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];	
	
	numString = [formatter stringFromNumber:[NSNumber numberWithDouble:ymax]];
	[numString drawAtPoint:CGPointMake(s.width - ywidth - 3, top_padding) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];

	
	double xwidth = s.width - ywidth - 6;
	double xwidth_secs = x_end_sec - x_start_sec;

	// draw x lines
	int x_lines = 0;
	if (timespan == TIMESPAN_ALL) {
		x_lines = 5;
	} else if (timespan == TIMESPAN_1D) {
		x_lines = 5;
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
		CGContextMoveToPoint(context, x_pos, s.height - 23);
		CGContextAddLineToPoint(context, x_pos, top_padding);
		CGContextStrokePath(context);			
	}
	
	// draw x axis labels
	NSDateFormatter *xformatter = [[NSDateFormatter alloc] init];
	if (timespan == TIMESPAN_ALL) {
		// TODO magic picking thingy
		if (xwidth_secs < 60 * 5) {
			[xformatter setDateFormat:@"mm:ss"];	
		} else if (xwidth_secs < 60 * 60 * 2) {
			[xformatter setDateFormat:@"HH:mm"];	
		} else if (xwidth_secs < 60 * 60 * 24 * 2) {
			[xformatter setDateFormat:@"ha"];	
		} else if (xwidth_secs < 60 * 60 * 24 * 7) {
			[xformatter setDateFormat:@"ccc"];	
		} else if (xwidth_secs < 60 * 60 * 24 * 30) {
			[xformatter setDateFormat:@"d"];
		} else if (xwidth_secs < 60 * 60 * 24 * 30 * 6) {
			[xformatter setDateFormat:@"M/d"];
		} else {
			[xformatter setDateFormat:@"MMM"];			
		}
	} else if (timespan == TIMESPAN_1D) {
		[xformatter setDateFormat:@"ha"];
	} else if (timespan == TIMESPAN_1W) {
		[xformatter setDateFormat:@"ccc"];
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
	for (int i = 0; i < x_lines; i++) {
		double x_pos = i * xwidth / x_lines;
		NSDate *d = [NSDate dateWithTimeIntervalSinceReferenceDate:xwidth_secs * i / x_lines + x_start_sec];
		NSString *ds = [xformatter stringFromDate:d];
		CGSize xs = [ds sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		if (i > 0) {
			[ds drawAtPoint:CGPointMake(x_pos - xs.width / 2 , s.height - 20) withFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
		}
	}
	[xformatter release];
	
	if (activity) {
		// draw graph
		double current = activity.initial_value;
		double c_secs;
		double x_pos;
		double y_pos;
		
		if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED) {
			int i = 0;
			for (TZCount *c in activity.counts) {
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current += c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				if (i == 0) {
					CGContextMoveToPoint(context, x_pos, s.height - 23 - y_pos);
				} else {
					CGContextAddLineToPoint(context, x_pos, s.height - 23 - y_pos);
				}
				i++;
			}
			CGContextSetRGBStrokeColor(context, 1, 1, 1, .6);
			CGContextSetLineWidth(context, 2);
			CGContextStrokePath(context);
			
			// fill graph
			current = activity.initial_value;
			double first_x_pos;
			i = 0;
			for (TZCount *c in activity.counts) {			
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current += c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				if (i == 0) {
					CGContextMoveToPoint(context, x_pos, s.height - 23 - y_pos);
					first_x_pos = x_pos;
				} else {
					CGContextAddLineToPoint(context, x_pos, s.height - 23 - y_pos);
				}
				i++;
			}
			CGContextAddLineToPoint(context, x_pos, s.height - 23);
			CGContextAddLineToPoint(context, first_x_pos, s.height - 23);
			CGContextSetRGBFillColor(context, 1, 1, 1, 0.15);
			CGContextFillPath(context);
			
			// draw points
			current = activity.initial_value;
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
			for (TZCount *c in activity.counts) {
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current += c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				CGContextAddEllipseInRect(context, CGRectMake(x_pos - 2, s.height - 23 - y_pos - 2, 4, 4));
				CGContextFillPath(context);						
			}						
		} else if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED_DAILY) {
			NSMutableArray *counts = [activity getDayCounts];
			int i = 0;
			for (TZCount *c in counts) {
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current = c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				if (i == 0) {
					CGContextMoveToPoint(context, x_pos, s.height - 23 - y_pos);
				} else {
					CGContextAddLineToPoint(context, x_pos, s.height - 23 - y_pos);
				}
				i++;
			}
			CGContextSetRGBStrokeColor(context, 1, 1, 1, .6);
			CGContextSetLineWidth(context, 2);
			CGContextStrokePath(context);
			
			// fill graph
			current = activity.initial_value;
			double first_x_pos;
			i = 0;
			for (TZCount *c in counts) {			
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current = c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				if (i == 0) {
					CGContextMoveToPoint(context, x_pos, s.height - 23 - y_pos);
					first_x_pos = x_pos;
				} else {
					CGContextAddLineToPoint(context, x_pos, s.height - 23 - y_pos);
				}
				i++;
			}
			CGContextAddLineToPoint(context, x_pos, s.height - 23);
			CGContextAddLineToPoint(context, first_x_pos, s.height - 23);
			CGContextSetRGBFillColor(context, 1, 1, 1, 0.15);
			CGContextFillPath(context);						

			// draw points
			current = activity.initial_value;
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
			for (TZCount *c in counts) {
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current = c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				CGContextAddEllipseInRect(context, CGRectMake(x_pos - 2, s.height - 23 - y_pos - 2, 4, 4));
				CGContextFillPath(context);						
			}				
		} else if (activity.graph_type == TZACTIVITY_SLIDING_NOTSUMMED) {
			int i = 0;
			for (TZCount *c in activity.counts) {
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current = c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				if (i == 0) {
					CGContextMoveToPoint(context, x_pos, s.height - 23 - y_pos);
				} else {
					CGContextAddLineToPoint(context, x_pos, s.height - 23 - y_pos);
				}
				i++;
			}
			CGContextSetRGBStrokeColor(context, 1, 1, 1, .6);
			CGContextSetLineWidth(context, 2);
			CGContextStrokePath(context);
			
			// fill graph
			current = activity.initial_value;
			double first_x_pos;
			i = 0;
			for (TZCount *c in activity.counts) {			
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current = c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				if (i == 0) {
					CGContextMoveToPoint(context, x_pos, s.height - 23 - y_pos);
					first_x_pos = x_pos;
				} else {
					CGContextAddLineToPoint(context, x_pos, s.height - 23 - y_pos);
				}
				i++;
			}
			CGContextAddLineToPoint(context, x_pos, s.height - 23);
			CGContextAddLineToPoint(context, first_x_pos, s.height - 23);
			CGContextSetRGBFillColor(context, 1, 1, 1, 0.15);
			CGContextFillPath(context);		
			
			// draw points
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
			for (TZCount *c in activity.counts) {
				NSDate *cdate = [dateFormatter dateFromString:c.created_on];
				current = c.amount;
				c_secs = [cdate timeIntervalSinceReferenceDate];
				x_pos = (c_secs - x_start_sec) / (xwidth_secs) * xwidth;
				y_pos = (current - ymin) / (ymax - ymin) * (s.height - 23 - top_padding);
				CGContextAddEllipseInRect(context, CGRectMake(x_pos - 2, s.height - 23 - y_pos - 2, 4, 4));
				CGContextFillPath(context);						
			}			
		}
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

- (void)buttonPressed:(id)sender {
	
	// disable user interaction during the flip
	self.userInteractionEnabled = NO;
	
	// setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (graphOptionsView.hidden) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
		graphOptionsView.hidden = NO;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		graphOptionsView.hidden = YES;
    }
	[UIView commitAnimations];
}

- (void)transitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	self.userInteractionEnabled = YES;
	if (graphOptionsView.hidden == YES) {
		[self findMinMax];
		[self setNeedsDisplay];
	}
}

- (TZActivity *)activity {
	return activity;
}

- (void)setActivity:(TZActivity *)a {
//	if (activity == a) {
//		return;
//	}
	[a retain];
	[activity release];
	activity = a;
	
	[activity loadCounts];
	
	[self findMinMax];	
	[self setNeedsDisplay];
	
	graphOptionsView.activity = activity;
}


- (void)dealloc {
	[formatter release];
	formatter = nil;
	[dateFormatter release];
	dateFormatter = nil;
	
	[xmax release];
	xmax = nil;
	[xmin release];
	xmin = nil;
	
	[timespans release];
	timespans = nil;
	
	[activity release];
	activity = nil;

	[infoButton release];
	infoButton = nil;
	
	[graphOptionsView release];
	graphOptionsView = nil;
	
    [super dealloc];
}


@end
