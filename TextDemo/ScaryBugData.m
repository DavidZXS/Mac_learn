//
//  ScaryBugData.m
//  LearnMacDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import "ScaryBugData.h"

@implementation ScaryBugData

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating{
    if (self = [super init]) {
        self.title = title;
        self.rating = rating;
    }
    return self;
}

@end
