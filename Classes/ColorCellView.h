//
//  ColorCellView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ColorView.h"

@interface ColorCellView : UITableViewCell {
	UIColor *color;
	UILabel *label;
	
	ColorView *colorView;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UILabel *label;

@end
