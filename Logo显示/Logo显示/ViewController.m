//
//  ViewController.m
//  Logo显示
//
//  Created by class on 12/03/2017.
//  Copyright © 2017 八点钟学院. All rights reserved.
//

#import "ViewController.h"
#import "LogoView.h"

@interface ViewController ()


@property(nonatomic,strong)LogoView *logoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *logoImages = [[NSMutableArray alloc] init];
    UIImage *greenImage = [UIImage imageNamed:@"logoGreen"];
    [logoImages addObject:greenImage];
    UIImage *blueImage = [UIImage imageNamed:@"logoBlue"];
    [logoImages addObject:blueImage];
    UIImage *redImage = [UIImage imageNamed:@"logoRed"];
    [logoImages addObject:redImage];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    
    
    self.logoView = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 400, 400) logoImages:logoImages backImage:logoImage];
    self.logoView.center = self.view.center;
    
    [self.view addSubview:self.logoView];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(self.logoView.currentStatus == YES){
        [self.logoView stopAnimation];
    }else{
        [self.logoView beginAnimation];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
