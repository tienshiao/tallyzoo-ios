//
//  MatrixButton.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "TZActivity.h"

@class MatrixButton;

@protocol MatrixButtonDelegate <NSObject>
@optional
- (void)matrixButtonClicked:(MatrixButton *)mb;
- (void)matrixButtonHeld:(MatrixButton *)mb;
@end

@interface MatrixButton : UIView {
	BOOL black;
	BOOL down;
	BOOL held;
	
	id delegate;
	
	TZActivity *activity;
	
	CFURLRef clickDownURL;
	SystemSoundID clickDownID;
	CFURLRef clickUpURL;
	SystemSoundID clickUpID;	
	
	float hold_threshold;
}

@property(assign, nonatomic) BOOL down;
@property(assign, nonatomic) id delegate;
@property(nonatomic, retain) TZActivity *activity;

- (id)initWithActivity:(TZActivity *)a;

@end
