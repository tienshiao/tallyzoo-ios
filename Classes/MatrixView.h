//
//  MatrixView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixButton.h"


@interface MatrixView : UIView {
	NSMutableArray *buttons;
	int _page;
}

- (id)initWithFrame:(CGRect)frame andScreenNumber:(int)page;
- (void)reloadData;

@end
