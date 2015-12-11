//
//  UIScrollView+IGRenovater.m
//  ITRenovate
//
//  Created by iGalactus on 15/12/7.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "UIScrollView+ITRenovater.h"
#import <objc/runtime.h>

#define IGHEADER_HEIGHT 60
#define IGFOOTER_HEIGHT 60

@interface UIScrollView()

@property (nonatomic,copy) itFooterCallbackBlock footerCallbackBlock;
@property (nonatomic,copy) itHeaderCallbackBlock headerCallbackBlock;

@property (nonatomic,strong) ITRenovaterHeader *myHeader;
@property (nonatomic,strong) ITRenovaterFooter *myFooter;

@end

@implementation UIScrollView (ITRenovater)
static char ITHeaderKey , ITHeaderBlockKey, ITFooterKey , ITFooterBlockKey;

-(void)it_insertHeaderWithCallbackBlock:(itHeaderCallbackBlock)callbackBlock
{
    if (self.headerCallbackBlock) //已经有header
    {
        return;
    }
    
    self.headerCallbackBlock = callbackBlock;
    
    if (!self.myHeader)
    {
        self.myHeader = [[ITRenovaterHeader alloc] initWithScrollView:self];
        
        __weak typeof(self) wself = self;
        
        self.myHeader.headerCompleteBlock = ^(){
            
            if (wself.headerCallbackBlock)
            {
                wself.headerCallbackBlock();
            }
        
        };
    }
    
    [self addSubview:self.myHeader];
    
    self.myHeader.frame = CGRectMake(0, 0, 0, IGHEADER_HEIGHT);
}

-(void)it_insertFooterWithCallbackBlock:(itFooterCallbackBlock)callbackBlock
{
    if (self.footerCallbackBlock) //已经有footer
    {
        return;
    }
    
    self.footerCallbackBlock = callbackBlock;
    
    if (!self.myFooter)
    {
        self.myFooter = [[ITRenovaterFooter alloc] initWithScrollView:self];
        
        __weak typeof(self) wself = self;
        
        self.myFooter.footerCompleteBlock = ^(){
            
            if (wself.footerCallbackBlock)
            {
                wself.footerCallbackBlock();
            }
        };
    }
    
    [self addSubview:self.myFooter];
    
    self.myFooter.frame = CGRectMake(0, 0, 0, IGFOOTER_HEIGHT);
}

-(void)it_removeHeader
{
    if (!self.myHeader)
    {
        return;
    }
    
    self.myHeader.headerType = ITRenovaterStill;
    
    [self.myHeader removeFromSuperview];
    
    self.myHeader = nil;
}

-(void)it_removeFooter
{
    if (!self.myFooter)
    {
        return;
    }
    
    self.myFooter.footerType = ITRenovaterStill;
    
    [self.myFooter removeFromSuperview];
    
    self.myFooter = nil;
}

-(void)it_headerRenovate
{
    self.myHeader.headerType = ITRenovaterRenovating;
    
    [self setContentOffset:CGPointMake(0, - IGHEADER_HEIGHT) animated:YES];
}

-(void)it_footerRenovate
{
    self.myFooter.footerType = ITRenovaterRenovating;
}

-(void)it_headerComplete
{
    self.myHeader.headerType = ITRenovaterStill;
}

-(void)it_footerComplete
{
    self.myFooter.footerType = ITRenovaterStill;
}

-(void)setMyHeader:(ITRenovaterHeader *)myHeader
{
    objc_setAssociatedObject(self, &ITHeaderKey, myHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ITRenovaterHeader *)myHeader
{
    return objc_getAssociatedObject(self, &ITHeaderKey);
}

-(void)setMyFooter:(ITRenovaterFooter *)myFooter
{
    objc_setAssociatedObject(self, &ITFooterKey, myFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ITRenovaterFooter *)myFooter
{
    return objc_getAssociatedObject(self, &ITFooterKey);
}

-(void)setHeaderCallbackBlock:(itHeaderCallbackBlock)headerCallbackBlock
{
    objc_setAssociatedObject(self, &ITHeaderBlockKey, headerCallbackBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(itHeaderCallbackBlock)headerCallbackBlock
{
    return objc_getAssociatedObject(self, &ITHeaderBlockKey);
}

-(void)setFooterCallbackBlock:(itFooterCallbackBlock)footerCallbackBlock
{
    objc_setAssociatedObject(self, &ITFooterBlockKey, footerCallbackBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(itFooterCallbackBlock)footerCallbackBlock
{
    return objc_getAssociatedObject(self, &ITFooterBlockKey);
}

@end
