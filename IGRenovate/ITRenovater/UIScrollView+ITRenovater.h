//
//  UIScrollView+ITRenovater.h
//  ITRenovate
//
//  Created by iGalactus on 15/12/7.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRenovaterFooter.h"
#import "ITRenovaterHeader.h"

typedef void (^ itHeaderCallbackBlock) ();
typedef void (^ itFooterCallbackBlock) ();

@interface UIScrollView (ITRenovater)

-(void) it_insertHeaderWithCallbackBlock:(itHeaderCallbackBlock)callbackBlock;
-(void) it_insertFooterWithCallbackBlock:(itFooterCallbackBlock)callbackBlock;

-(void) it_headerComplete;
-(void) it_footerComplete;

-(void) it_headerRenovate;
-(void) it_footerRenovate;

-(void) it_removeHeader;
-(void) it_removeFooter;

@end
