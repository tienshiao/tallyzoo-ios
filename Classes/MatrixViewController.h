//
//  MatrixViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixView.h"

@interface MatrixViewController : UIViewController {
	MatrixView * _matrices[1];
	
	UIPageControl *_pageControl;
}

- (void)addItem:(id)sender;
- (void)editButtons:(id)sender;


@end
