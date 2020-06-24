//
//  ScaryBugData.h
//  LearnMacDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScaryBugData : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) CGFloat rating;

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating;

@end

NS_ASSUME_NONNULL_END
