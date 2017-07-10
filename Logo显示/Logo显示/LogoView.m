//
//  LogoView.m
//  Logo显示
//
//  Created by class on 09/07/2017.
//  Copyright © 2017 八点钟学院. All rights reserved.
//

#import "LogoView.h"

static const float kAmplitude = 20.0; //波峰
static const float kFrequency = 0.5;  //频率
static const float kInvokeOffset = 5; //偏移位置
static const float kAnimationDuration = 8;  //动画事件
@interface LogoView()

@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)NSMutableArray *imageViews;
@property(nonatomic,strong)NSMutableArray *shapeLayers;
@property(nonatomic,assign)NSUInteger invokeIndex;
@property(nonatomic) float offsetAngle;
@property(nonatomic,strong)CADisplayLink *displayLink;
@property(nonatomic,strong)NSArray *logoImages;
@property(nonatomic,strong)NSMutableArray *layerAnimations;

@end


@implementation LogoView

- (instancetype)initWithFrame:(CGRect)frame logoImages:(NSArray *)logoImages backImage:(UIImage *)backImage{
    self = [super initWithFrame:frame];
    if(self){
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.image = backImage;
        [self addSubview:_bgImageView];
        
        _imageViews = [[NSMutableArray alloc] init];
        _shapeLayers = [[NSMutableArray alloc] init];
        _layerAnimations = [[NSMutableArray alloc] init];
        _logoImages = logoImages;
        
        //默认每条波浪线的初相偏移值为PI/2
        //如果波浪线多于3条，初相偏移值为 2PI/波浪线数目
        _offsetAngle = M_PI_2;
        if(_logoImages.count > 3){
            _offsetAngle = 2 * M_PI/logoImages.count ;
        }
        
        for (UIImage *logoImage in logoImages) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.image = logoImage;
            
           
            //设置mask
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.position = CGPointMake(0, self.bounds.size.height);

            imageView.layer.mask = shapeLayer;
            [_shapeLayers addObject:shapeLayer];
           // [self.layer addSublayer:shapeLayer];
            
            [self addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    return self;
}


//开始动画
- (void)beginAnimation{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLayer)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.currentStatus = YES;
    [self moveAnimation];
}

//结束动画
- (void)stopAnimation{
    self.currentStatus = NO;
    for (CAShapeLayer *currentShapeLayer in self.shapeLayers) {
        [currentShapeLayer removeAllAnimations];
        currentShapeLayer.path = nil;
    }
    [self.displayLink invalidate];
    
}

//更新所有imageView mask的layer形状
- (void)updateLayer{
    
    self.invokeIndex++;
    for (NSUInteger i = 0; i < self.shapeLayers.count; i++) {
        
        CAShapeLayer *currentShapeLayer = [self.shapeLayers objectAtIndex:i];
        currentShapeLayer.path = [self createBezierPath:i].CGPath;
        
    }
}

//把mask对应的layer产生从下往上的动画
- (void)moveAnimation{
    
    for (NSUInteger i = 0; i < self.shapeLayers.count; i++) {
        
        CAShapeLayer *currentShapeLayer = [self.shapeLayers objectAtIndex:i];
        CABasicAnimation *upAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        upAnimation.fromValue =[NSValue valueWithCGPoint:CGPointMake(0, self.bounds.size.height)] ;
        upAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        upAnimation.duration = kAnimationDuration;
        upAnimation.repeatCount = HUGE_VALF;
        [currentShapeLayer addAnimation:upAnimation forKey:@""];
        [self.layerAnimations addObject:upAnimation];
    }
}

//绘制mask对应的layer形状
- (UIBezierPath *)createBezierPath:(NSUInteger)currentIndex{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height )];
    [path addLineToPoint:CGPointMake(0, self.bounds.size.height )];
    
    
    CGFloat  y ;
    //绘制正弦曲线
    for(int x = 0; x <= self.bounds.size.width; x++){

        y = kAmplitude * sin(x * 360.0 / self.bounds.size.width  * (M_PI/ 180.0) * kFrequency + self.invokeIndex * kInvokeOffset * (M_PI/180.0) + self.offsetAngle * currentIndex  );
        
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    [path closePath];
    return path;

}
@end
