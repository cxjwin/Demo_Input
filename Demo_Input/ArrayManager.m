//
//  ArrayManager.m
//  Demo_NSArrayKVO
//
//  Created by 蔡 雪钧 on 14-4-13.
//  Copyright (c) 2014年 cxjwin. All rights reserved.
//

#import <objc/message.h>
#import "ArrayManager.h"

NSString *const kArrayKey = @"array";

@interface ArrayManager ()

@property (nonatomic, strong) NSMutableArray *array;

// KVO Methods
- (NSUInteger)countOfArray;

- (id)objectInArrayAtIndex:(NSUInteger)index;

- (void)insertObject:(id)obj inArrayAtIndex:(NSUInteger)index;

- (void)removeObjectFromArrayAtIndex:(NSUInteger)index;

- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)obj;

@end

@implementation ArrayManager

+ (instancetype)sharedManager {
    static ArrayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        NSAssert(manager, @"manager is't nil");
    });
    return manager;
}

- (void)dealloc {
    NSAssert(self != [[self class] sharedManager], @"Signleton should't call this method");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUDPMessage:) name:@"KUDPMessage" object:nil];
    }
    return self;
}

- (void)setRealArray:(NSMutableArray *)realArray {
    self.array = realArray;
}

- (NSMutableArray *)realArray {
    return [self mutableArrayValueForKey:kArrayKey];
}

- (NSUInteger)countOfArray {
   return [self.array count];
}

- (id)objectInArrayAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

- (void)insertObject:(id)obj inArrayAtIndex:(NSUInteger)index {
    [self.array insertObject:obj atIndex:index];
}

- (void)removeObjectFromArrayAtIndex:(NSUInteger)index {
    [self.array removeObjectAtIndex:index];
}

- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)obj {
    [self.array replaceObjectAtIndex:index withObject:obj];
}

- (void)getUDPMessage:(NSNotification *)notification {
    NSString *msg = [notification object];
    SEL sel = NSSelectorFromString([msg stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
    if ([self respondsToSelector:sel]) {
        objc_msgSend(self, sel);
    }
}

static int num = 0;

- (void)addObjects {
    NSMutableArray *tempArray = [self.realArray mutableCopy];
    for (int i = 0; i < 10; ++i) {
        // [self.realArray addObject:[NSNumber numberWithInt:(++num)]];
        [tempArray addObject:[NSNumber numberWithInt:(++num)]];
    }
    self.realArray = tempArray;
}

- (void)removeObjects {
    if ([self.realArray count] <= 10) {
        return;
    }
    
    for (int i = 0; i < 10; ++i) {
        [self.realArray removeLastObject];
        --num;
    }
}

@end
