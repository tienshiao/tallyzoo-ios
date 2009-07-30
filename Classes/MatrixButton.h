//
//  MatrixButton.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MatrixButton;

@protocol MatrixButtonDelegate <NSObject>
@optional
- (void)matrixButtonClicked:(MatrixButton *)mb;
- (void)matrixButtonHeld:(MatrixButton *)mb;
@end

@interface MatrixButton : UIView {
	NSString *title;
	BOOL black;
	BOOL down;
	
	id<MatrixButtonDelegate> delegate;
}

@property(copy, nonatomic) NSString *title;
@property(assign, nonatomic) BOOL down;
@property(assign, nonatomic) id<MatrixButtonDelegate> delegate;

@end
