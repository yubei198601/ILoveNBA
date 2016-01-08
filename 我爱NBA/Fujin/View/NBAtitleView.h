//
//  NBAtitleView.h
//  我爱NBA
//
//  Created by philipyu on 15/12/23.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBAtitleView : UIView
-(void)addTarget:(nullable id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;
+(_Nonnull instancetype)titleView;
@end
