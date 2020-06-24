//
//  HomeTableViewCell.h
//  LearnMacDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : NSTableCellView
@property (weak) IBOutlet NSImageView *image;
@property (weak) IBOutlet NSTextField *title;

@end

NS_ASSUME_NONNULL_END
