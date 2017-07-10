//
//  LogoView.h
//  Logo显示
//
//  Created by class on 09/07/2017.
//  Copyright © 2017 八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoView : UIView

//根据logo颜色和
- (instancetype)initWithFrame:(CGRect)frame logoImages:(NSArray *)logoImages backImage:(UIImage *)backImage;

//开始动画
- (void)beginAnimation;

//结束动画
- (void)stopAnimation;

@property(nonatomic,assign)BOOL currentStatus;
@end
