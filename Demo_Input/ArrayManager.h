//
//  ArrayManager.h
//  Demo_NSArrayKVO
//
//  Created by 蔡 雪钧 on 14-4-13.
//  Copyright (c) 2014年 cxjwin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kArrayKey;

@interface ArrayManager : NSObject

@property (nonatomic, strong) NSMutableArray *realArray;

+ (instancetype)sharedManager;

@end
