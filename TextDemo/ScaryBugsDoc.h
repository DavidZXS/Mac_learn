//
//  ScaryBugsDoc.h
//  LearnMacDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScaryBugData;

NS_ASSUME_NONNULL_BEGIN


@interface ScaryBugsDoc : NSObject

@property (nonatomic, strong) ScaryBugData *data;

@property (nonatomic, strong) NSImage *thumbImage;

@property (nonatomic, strong) NSImage *fullImage;

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating thumbImage:(NSImage *)thumbImage fullImage:(NSImage *)fullImage;


@end

NS_ASSUME_NONNULL_END
