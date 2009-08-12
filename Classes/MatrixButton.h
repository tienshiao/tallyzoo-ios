//
//  MatrixButton.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
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
	
	id<MatrixButtonDelegate> delegate;
	
	TZActivity *activity;
}

@property(assign, nonatomic) BOOL down;
@property(assign, nonatomic) id<MatrixButtonDelegate> delegate;
@property(nonatomic, retain) TZActivity *activity;

- (id)initWithActivity:(TZActivity *)a;

@end
