//
//  GraphView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZActivity.h"

@interface GraphView : UIView {
	double ymax;
	double ymin;
	int ysig;
	double ywidth;
	NSDate *xmax;
	NSDate *xmin;
	
	int timespan;
	NSTimeInterval x_start_sec;
	NSTimeInterval x_end_sec;
	
	NSNumberFormatter *formatter;
	NSDateFormatter *dateFormatter;
	
	
	float canvasWidth;
	
	TZActivity *activity;
	
	NSArray *timespans;
	
	UIButton *infoButton;
}

@property (nonatomic, retain) TZActivity *activity;

@end
