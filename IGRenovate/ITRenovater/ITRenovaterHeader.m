//
//  ITRenovaterHeader.m
//  ITRenovate
//
//  Created by iGalactus on 15/12/7.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "ITRenovaterHeader.h"

@interface ITRenovaterHeader()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *transView;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

@property (nonatomic) BOOL isAnimation;

@end

@implementation ITRenovaterHeader

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.transView.frame.size.height == 0)
    {
        self.frame = CGRectMake(0,
                                self.superview.frame.origin.y - self.scrollView.contentInset.top - self.frame.size.height,
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
        
        if (scrollView) {
            
            self.scrollView = scrollView;
            
            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
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
            
            self.transView.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"it_renovater_arrow"].CGImage scale:1.0f orientation:UIImageOrientationDown];
            
            [self addSubview:self.transView];
        }
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat y = self.scrollView.contentOffset.y;
        
        if (self.headerType == ITRenovaterRenovating)
        {
            return;
        }
        
        if (y < 0 && y > - self.frame.size.height)
        {
            self.label.text = @"下拉刷新";
            
            [UIView animateWithDuration:0.3f animations:^{
                self.transView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        else if (y < - self.frame.size.height)
        {
            if (self.scrollView.isDragging)
            {
                self.label.text = @"松开刷新";
                
                [UIView animateWithDuration:0.3f animations:^{
                    self.transView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
            else
            {
                self.headerType = ITRenovaterRenovating;
            }
        }
    }
}

-(void)setHeaderType:(ITRenovaterType)headerType
{
    if (_headerType == headerType)
    {
        return;
    }
    
    switch (headerType) {
            
        case ITRenovaterStill:
        {
            [UIView animateWithDuration:0.25f animations:^{
                
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top - self.frame.size.height,
                                                                self.scrollView.contentInset.left,
                                                                self.scrollView.contentInset.bottom,
                                                                self.scrollView.contentInset.right);
                
            } completion:^(BOOL finished) {
                
                self.transView.hidden = NO;
                
                [self.indicator stopAnimating];
                
            }];
        }
            break;
        case ITRenovaterRenovating:
        {
            if (self.isAnimation)
            {
                return;
            }
            
            self.label.text = @"刷新中";
            
            self.transView.hidden = YES;
            
            [self.indicator startAnimating];
            
            self.isAnimation = YES;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top + self.frame.size.height,
                                                                self.scrollView.contentInset.left,
                                                                self.scrollView.contentInset.bottom,
                                                                self.scrollView.contentInset.right);
                
            } completion:^(BOOL finished) {
                
                if (finished)
                {
                    self.isAnimation = NO;
                    
                    if (self.headerCompleteBlock)
                    {
                        self.headerCompleteBlock();
                    }
                }
                
            }];
        }
            break;

            
        default:
            break;
    }
    
    _headerType = headerType;
}

-(void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
