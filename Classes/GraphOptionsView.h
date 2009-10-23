//
//  GraphOptionsView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZActivity.h"
#import "CheckboxView.h"


@interface GraphOptionsView : UIView {
	TZActivity *activity;
	id delegate;
	
	CheckboxView *summedCheck;
	CheckboxView *summedDailyCheck;
	CheckboxView *notSummedCheck;
	
	CheckboxView *slidingCheck;
	CheckboxView *calendarCheck;
	
	UIButton *doneButton;
}

@property (nonatomic, retain) TZActivity *activity;
@property (assign, nonatomic) id delegate;

@end
