//
//  ITRenovater.h
//  ITRenovate
//
//  Created by iGalactus on 15/12/8.
//  Copyright © 2015年 一斌. All rights reserved.
//

#ifndef ITRenovater_h
#define ITRenovater_h


typedef enum
{
    ITRenovaterStill = 0, //静止
    ITRenovaterPull = 1, //拉动中
    ITRenovaterRelease = 2, //等待释放
    ITRenovaterRenovating = 3, //刷新中
    
} ITRenovaterType;


#endif /* ITRenovater_h */
