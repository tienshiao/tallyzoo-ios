//
//  ShakeView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShakeView;

@protocol ShakeViewDelegate <NSObject>
@optional
- (void)shakeHappened:(ShakeView*)view;
@end

@interface ShakeView : UIView {
	id delegate;
}

@property(assign, nonatomic) id delegate;

@end
