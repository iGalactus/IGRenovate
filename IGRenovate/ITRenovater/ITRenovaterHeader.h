//
//  ITRenovaterHeader.h
//  ITRenovate
//
//  Created by iGalactus on 15/12/7.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRenovater.h"

@interface ITRenovaterHeader : UIView

-(instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic) ITRenovaterType headerType;
@property (nonatomic,copy) void (^ headerCompleteBlock)();

@end
