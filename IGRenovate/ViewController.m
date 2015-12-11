//
//  ViewController.m
//  IGRenovate
//
//  Created by iGalactus on 15/12/7.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ITRenovater.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.747 green:1.000 blue:0.575 alpha:1.000];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 10);
//    _scrollView.contentSize = self.view.frame.size;
    [self.view addSubview:_scrollView];
    
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.edges.equalTo(self.view);
//    }];
    
    [_scrollView it_insertHeaderWithCallbackBlock:^{
        NSLog(@"header call back");
    }];
    
    [_scrollView it_insertFooterWithCallbackBlock:^{
        NSLog(@"footer call back");
    }];
    
    
    UIButton *action = [[UIButton alloc] initWithFrame:CGRectMake(210, 200, 100, 100)];
    action.backgroundColor = [UIColor redColor];
    [action setTitle:@"头部收回" forState:0];
    [action addTarget:self action:@selector(actionClicked) forControlEvents:1<<6];
    [self.view addSubview:action];
    
    UIButton *action2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    action2.backgroundColor = [UIColor redColor];
    [action2 setTitle:@"头部主动刷新" forState:0];
    [action2 addTarget:self action:@selector(actionClicked2) forControlEvents:1<<6];
    [self.view addSubview:action2];
    
    UIButton *action3 = [[UIButton alloc] initWithFrame:CGRectMake(210, 310, 100, 100)];
    action3.backgroundColor = [UIColor redColor];
    [action3 setTitle:@"尾部收回" forState:0];
    [action3 addTarget:self action:@selector(actionClicked3) forControlEvents:1<<6];
    [self.view addSubview:action3];
    
    UIButton *action4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 310, 100, 100)];
    action4.backgroundColor = [UIColor redColor];
    [action4 setTitle:@"尾部主动刷新" forState:0];
    [action4 addTarget:self action:@selector(actionClicked4) forControlEvents:1<<6];
    [self.view addSubview:action4];
    

}

-(void)actionClicked3
{
    [_scrollView it_footerComplete];
}

-(void)actionClicked4
{
    [_scrollView it_footerRenovate];
}

-(void)actionClicked2
{
    [_scrollView it_headerRenovate];
}

-(void)actionClicked
{
    [_scrollView it_headerComplete];
}


@end
