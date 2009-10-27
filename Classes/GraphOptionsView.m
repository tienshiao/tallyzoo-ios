//
//  GraphOptionsView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphOptionsView.h"
#import "UIColor-Expanded.h"


@implementation GraphOptionsView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;

		UIFont *f = [UIFont boldSystemFontOfSize:16];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
		label.text = @"Graph Type";
		label.font = f;
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[self addSubview:label];
		[label release];
		
		summedCheck = [[CheckboxView alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
		summedCheck.label.text = @"Adding up over time";
		summedCheck.label.font = f;
		summedCheck.label.textColor = [UIColor whiteColor];
		summedCheck.delegate = self;
		[self addSubview:summedCheck];

		summedDailyCheck = [[CheckboxView alloc] initWithFrame:CGRectMake(10, 55, 200, 20)];
		summedDailyCheck.label.text = @"Daily Totals over time";
		summedDailyCheck.label.font = f;
		summedDailyCheck.label.textColor = [UIColor whiteColor];
		summedDailyCheck.delegate = self;
		[self addSubview:summedDailyCheck];
		
		notSummedCheck = [[CheckboxView alloc] initWithFrame:CGRectMake(10, 80, 200, 20)];
		notSummedCheck.label.text = @"Values over time";
		notSummedCheck.label.font = f;
		notSummedCheck.label.textColor = [UIColor whiteColor];
		notSummedCheck.delegate = self;
		[self addSubview:notSummedCheck];

		label = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 200, 20)];
		label.text = @"Time Window";
		label.font = f;
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[self addSubview:label];
		[label release];
		
		slidingCheck = [[CheckboxView alloc] initWithFrame:CGRectMake(10, 130, 100, 20)];
		slidingCheck.label.text = @"Sliding";
		slidingCheck.label.font = f;
		slidingCheck.label.textColor = [UIColor whiteColor];
		slidingCheck.delegate = self;
		[self addSubview:slidingCheck];

		calendarCheck = [[CheckboxView alloc] initWithFrame:CGRectMake(10, 155, 100, 20)];
		calendarCheck.label.text = @"Calendar";
		calendarCheck.label.font = f;
		calendarCheck.label.textColor = [UIColor whiteColor];
		calendarCheck.delegate = self;
		[self addSubview:calendarCheck];
		
		
		doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:9];
		[doneButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
		doneButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
		[doneButton setTitle:@"Done" forState:UIControlStateNormal];
		[doneButton sizeToFit];
		CGRect r = doneButton.frame;
		r.origin.x = self.bounds.size.width - r.size.width - 2;
		r.origin.y = self.bounds.size.height - r.size.height - 2;
		doneButton.frame = r;
		[self addSubview:doneButton];
		
		[doneButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
	
	// color the background
	CGContextAddRect(context, CGRectMake(0, 0, s.width, s.height));
	CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"191970"] CGColor]);
	CGContextFillPath(context);
	
}

- (void)buttonPressed:(id)sender {
	// save settings
	int type = 0;
	
	if (slidingCheck.checked == YES) {
		if (summedCheck.checked == YES) {
			type = TZACTIVITY_SLIDING_SUMMED;
		} else if (summedDailyCheck.checked == YES) {
			type = TZACTIVITY_SLIDING_SUMMED_DAILY;
		} else if (notSummedCheck.checked == YES) {
			type = TZACTIVITY_SLIDING_NOTSUMMED;
		}
	} else {
		if (summedCheck.checked == YES) {
			type = TZACTIVITY_CALENDAR_SUMMED;
		} else if (summedDailyCheck.checked == YES) {
			type = TZACTIVITY_CALENDAR_SUMMED_DAILY;
		} else if (notSummedCheck.checked == YES) {
			type = TZACTIVITY_CALENDAR_NOTSUMMED;
		}		
	}
	
	if (type != activity.graph_type) {
		activity.graph_type = type;
		[activity save];
	}
	
	if ([delegate respondsToSelector:@selector(buttonPressed:)]) {
		[delegate buttonPressed:self];
	}
}

- (void)checkSelected:(id)sender {
	if (sender == summedCheck) {
		summedDailyCheck.checked = NO;
		notSummedCheck.checked = NO;
	} else if (sender == summedDailyCheck) {
		summedCheck.checked = NO;
		notSummedCheck.checked = NO;
	} else if (sender == notSummedCheck) {
		summedCheck.checked = NO;
		summedDailyCheck.checked = NO;
	} else if (sender == slidingCheck) {
		calendarCheck.checked = NO;
	} else if (sender == calendarCheck) {
		slidingCheck.checked = NO;
	}
}

- (TZActivity *)activity {
	return activity;
}

- (void)setActivity:(TZActivity *)a {
	if (activity == a) {
		return;
	}
	
	[a retain];
	[activity release];
	activity = a;
	
	summedCheck.checked = NO;
	summedDailyCheck.checked = NO;
	notSummedCheck.checked = NO;
	slidingCheck.checked = NO;
	calendarCheck.checked = NO;
	if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED) {
		slidingCheck.checked = YES;
		summedCheck.checked = YES;
	} else if (activity.graph_type == TZACTIVITY_SLIDING_SUMMED_DAILY) {
		slidingCheck.checked = YES;
		summedDailyCheck.checked = YES;
	} else if (activity.graph_type == TZACTIVITY_SLIDING_NOTSUMMED) {
		slidingCheck.checked = YES;
		notSummedCheck.checked = YES;
	} else if (activity.graph_type == TZACTIVITY_CALENDAR_SUMMED) {
		calendarCheck.checked = YES;
		summedCheck.checked = YES;
	} else if (activity.graph_type == TZACTIVITY_CALENDAR_SUMMED_DAILY) {
		calendarCheck.checked = YES;
		summedDailyCheck.checked = YES;
	} else if (activity.graph_type == TZACTIVITY_CALENDAR_NOTSUMMED) {
		calendarCheck.checked = YES;
		notSummedCheck.checked = YES;
	}
	
	[self setNeedsDisplay];
}

- (void)dealloc {
	[activity release];
	delegate = nil;
	
	[summedCheck release];
	[summedDailyCheck release];
	[notSummedCheck release];
	
	[slidingCheck release];
	[calendarCheck release];
	
	[doneButton release];
	
    [super dealloc];
}


@end
