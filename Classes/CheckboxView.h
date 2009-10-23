//
//  CheckboxView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckboxView : UIView {
	UILabel *label;
	
	BOOL checked;
	BOOL highlighted;
	
	id delegate;
}

@property (nonatomic, retain) UILabel *label;
@property (assign, nonatomic) BOOL checked;
@property (assign, nonatomic) id delegate;

@end
