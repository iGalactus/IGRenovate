//
//  ITRenovaterFooter.m
//  ITRenovate
//
//  Created by iGalactus on 15/12/7.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "ITRenovaterFooter.h"

@interface ITRenovaterFooter()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *transView;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

@property (nonatomic) BOOL isAnimation;

@end

@implementation ITRenovaterFooter

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.label.frame.size.height == 0)
    {
        self.frame = CGRectMake(0,
                                MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height + self.scrollView.contentInset.bottom),
                                self.superview.frame.size.width,
                                self.frame.size.height);
        
        self.transView.frame = CGRectMake(self.frame.size.width / 2 - 60, 15, 30, self.frame.size.height - 30);
        
        self.label.frame = CGRectMake(self.frame.size.width / 2, 0, 100, self.frame.size.height);
        
        self.indicator.frame = self.transView.frame;
    }
}

-(instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        
        if (scrollView)
        {
            self.scrollView = scrollView;
            
            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
            [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        }
        
        if (!self.label)
        {
            self.label = [[UILabel alloc] init];
            
            self.label.font = [UIFont systemFontOfSize:14];
            
            self.label.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
            
            [self addSubview:self.label];
        }
        
        if (!self.indicator)
        {
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            [self addSubview:self.indicator];
        }
        
        if (!self.transView)
        {
            self.transView = [[UIImageView alloc] init];
            
            self.transView.image = [UIImage imageNamed:@"it_renovater_arrow"];
            
            [self addSubview:self.transView];
        }
    }
    return self;
}

-(void)resizeSelfFrame
{
    self.frame = CGRectMake(0,
                            MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height + self.scrollView.contentInset.bottom),
                            self.superview.frame.size.width,
                            self.frame.size.height);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if (!self.isAnimation)
        {
            [self resizeSelfFrame];
        }
    }
    
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat y = self.scrollView.contentOffset.y;
        
        CGFloat willAimationHeight = MAX(self.scrollView.contentSize.height - self.scrollView.frame.size.height, 0) + self.frame.size.height;
        
        if (self.footerType == ITRenovaterRenovating)
        {
            return;
        }

        if (y > 0 && y < willAimationHeight)
        {
            self.label.text = @"上拉刷新";
            
            [UIView animateWithDuration:0.3f animations:^{
                self.transView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        else if (y >= willAimationHeight)
        {
            if (self.scrollView.isDragging)
            {
                self.label.text = @"释放刷新";
                
                [UIView animateWithDuration:0.3f animations:^{
                    self.transView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
            else
            {
                self.footerType = ITRenovaterRenovating;
            }
        }
    }
}

-(void)setFooterType:(ITRenovaterType)footerType
{
    if (_footerType == footerType)
    {
        return;
    }
    
    if (self.isAnimation)
    {
        return;
    }
    
    _footerType = footerType;
    
    switch (footerType)
    {
        case ITRenovaterStill:
        {
            self.isAnimation = YES;
            
            [UIView animateWithDuration:0.25f animations:^{
                
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                self.scrollView.contentInset.left,
                                                                self.scrollView.contentInset.bottom - self.frame.size.height,
                                                                self.scrollView.contentInset.right);
                
            } completion:^(BOOL finished) {
                
                self.transView.hidden = NO;
                
                [self.indicator stopAnimating];
                
                self.isAnimation = NO;
                
                [self resizeSelfFrame];

            }];
        }
            break;
        case ITRenovaterRenovating:
        {
            self.isAnimation = YES;
            
            [self.indicator startAnimating];
            
            self.label.text = @"刷新中";
            
            self.transView.hidden = YES;
            
            [UIView animateWithDuration:0.25f animations:^{
                
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                self.scrollView.contentInset.left,
                                                                self.scrollView.contentInset.bottom + self.frame.size.height,
                                                                self.scrollView.contentInset.right);
                
                self.transView.transform = CGAffineTransformMakeRotation(M_PI);
                
            } completion:^(BOOL finished) {
               
                self.isAnimation = NO;
                
                if (self.footerCompleteBlock)
                {
                    self.footerCompleteBlock();
                }
                
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
