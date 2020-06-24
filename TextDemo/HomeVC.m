//
//  HomeVC.m
//  LearnMacDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import "HomeVC.h"
#import "ScaryBugsDoc.h"
#import "ScaryBugData.h"
#import "HomeTableViewCell.h"
#import "EDStarRating.h"
#import <Quartz/Quartz.h>
#import "NSImage+Extras.h"


@interface HomeVC ()<NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSScrollView *tableContainerView;

@property (nonatomic, strong) NSTableView *tableView;

@property (nonatomic, strong) NSMutableArray *bugs;

@property (nonatomic, strong) NSTextField *bugTitleView;

@property (nonatomic, strong) EDStarRating *bugRating;

@property (nonatomic, strong) NSImageView *bugImageView;

@property (nonatomic, strong) NSButton *changeBtn;

@property (nonatomic, strong) NSButton *deleteButton;

@end

@implementation HomeVC

- (void)loadView{
    NSRect rect = [[NSApplication sharedApplication] mainWindow].frame;
    self.view = [[NSView alloc] initWithFrame:rect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    self.view.wantsLayer = YES;
//
//    self.view.layer.backgroundColor = [NSColor redColor].CGColor;
    
    [self initData];
    
    [self initTableView];
    
    [self rightUI];
}

#pragma mark - NSTableViewDataSource,NSTableViewDelegate
#pragma mark -required methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.bugs.count;
}
//这个方法虽然不返回什么东西，但是必须实现，不实现可能会出问题－比如行视图显示不出来等。（10.11貌似不实现也可以，可是10.10及以下还是不行的）
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

#pragma mark -other methods
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 32;
}
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
//    NSString *strIdt=[tableColumn identifier];
    HomeTableViewCell *aView = [tableView makeViewWithIdentifier:@"HomeTableViewCell" owner:self];
//    if (!aView){
//        aView = [[HomeTableViewCell alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 32)];
//    }
//    else
//            for (NSView *view in aView.subviews)[view removeFromSuperview];

//    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(15, 20, 156+50, 17)];
//    textField.stringValue = @"123";
//    textField.font = [NSFont systemFontOfSize:15.0f];
//    textField.textColor = [NSColor blackColor];
//    textField.drawsBackground = NO;
//    textField.bordered = NO;
//    textField.focusRingType = NSFocusRingTypeNone;
//    textField.editable = NO;
//    [aView addSubview:textField];
    
    ScaryBugsDoc *doc = [self.bugs objectAtIndex:row];
    
    aView.image.image = doc.thumbImage;
    
    aView.title.stringValue = doc.data.title;
    
    return aView;
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    NSLog(@"====%ld", (long)row);
//    _selectedRowNum = row;
    return YES;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"%@", tableColumn.dataCell);
}
#pragma mark - tableview滚动处理
-(void)tableviewDidScroll:(NSNotification *)notification
{
    NSClipView *contentView = [notification object];
//    CGFloat scrollY = contentView.visibleRect.origin.y-20;//这里减去20是因为tableHeader的20高度
//    _scrollTF.stringValue = [NSString stringWithFormat:@"滚动 %.1f",scrollY];
}

// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
    self.tableView = notification.object;

    // 获取选中的数据
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    // 根据数据，设置详情视图内容
    [self setDetailInfo:selectedDoc];
    // Enable/Disable buttons based on selection
    BOOL buttonsEnabled = (selectedDoc!=nil);
    [self.deleteButton setEnabled:buttonsEnabled];
    [self.changeBtn setEnabled:buttonsEnabled];
    [self.bugRating setEditable:buttonsEnabled];
    [self.bugTitleView setEnabled:buttonsEnabled];
}

#pragma mark - Data
// 获取选中的数据模型
- (ScaryBugsDoc *)selectedBugDoc{
    NSInteger selectedRow = [self.tableView selectedRow];            // 获取table view 的选中行号
    if (selectedRow >= 0 && self.bugs.count  > selectedRow) {
        ScaryBugsDoc *selectedBug = [self.bugs objectAtIndex:selectedRow];
        return selectedBug;
    }
    return nil;
}

// 这个方法，根据数据设置视图信息
- (void)setDetailInfo:(ScaryBugsDoc *)doc{
    NSString    *title = @"";        // 初始化为空字符串
    NSImage     *image = nil;    // 初始化为空值
    float rating=0.0;                      // 初始化默认值为0
    if( doc != nil ){    // 如果有数据
        title = doc.data.title;
        image = doc.fullImage;
        rating = doc.data.rating;
    }
    [self.bugTitleView setStringValue:title];       // 设置显示的标题
    [self.bugImageView setImage:image];         // 设置显示的图片
    [self.bugRating setRating:rating];                  // 设置评分
}

- (void)addAction:(NSButton *)sender{
    // 1.创建数据模型
    ScaryBugsDoc *newDoc = [[ScaryBugsDoc alloc] initWithTitle:@"New Bug" rating:0.0 thumbImage:nil fullImage:nil];
    // 2. 添加模型到数组中
    [self.bugs addObject:newDoc];
    // 3. 获取添加后的行号
    NSInteger newRowIndex = self.bugs.count - 1;
    // 4. 在table view 中插入新行
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    // 5. 设置新行选中，并可见
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.tableView scrollRowToVisible:newRowIndex];
}

- (void)removeAction:(NSButton *)sender{
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc ){
        // 1. 从数字中删除数据模型
        [self.bugs removeObject:selectedDoc];
        // 2. table view 删除选中的行
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.tableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
        // 3. 清空详情视图内容
        [self setDetailInfo:nil];
    }
}

- (void) changeAction:(NSButton *)sender{
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    // 当table view 有选中数据时，才可以进行更换图片
    if(selectedDoc){
        [[IKPictureTaker pictureTaker] beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

// 图片选择后的回答方法
- (void) pictureTakerDidEnd:(IKPictureTaker *) picker returnCode:(NSInteger) code contextInfo:(void*) contextInfo{
    NSImage *image = [picker outputImage];
    if( image !=nil && (code == NSModalResponseOK) ){
        [self.bugImageView setImage:image];
        ScaryBugsDoc * selectedBugDoc = [self selectedBugDoc];
        if( selectedBugDoc ){
            // 1.设置选中的图片
            selectedBugDoc.fullImage = image;
            // 2. 设置缩略图片
            selectedBugDoc.thumbImage = [image imageByScalingAndCroppingForSize:CGSizeMake( 44, 44 )];
            // 3. 获取位置并刷新表格
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedBugDoc]];
            NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }
}

- (void)bugTitleViewAction:(NSNotification *)obj{
    NSLog(@"%@", [obj.object stringValue]);
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc ){
        // 1. 设置文本
        selectedDoc.data.title = [self.bugTitleView stringValue];
        // 2. 更新行
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedDoc]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}

#pragma mark - EDStarRatingProtocol
-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating
{
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc ){
        selectedDoc.data.rating = self.bugRating.rating;
    }
}

#pragma mark - initUI
-(void) rightUI{
    
    NSBox *box = [[NSBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableContainerView.frame) + 25, CGRectGetMinY(self.tableContainerView.frame), 5, CGRectGetHeight(self.tableContainerView.frame))];
    box.boxType = NSBoxSeparator;
    [self.view addSubview:box];
    
    NSTextField *name = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableContainerView.frame) + 50, CGRectGetMaxY(self.tableContainerView.frame) - 20, 100, 20)];
    name.backgroundColor = [NSColor clearColor];
    name.stringValue = @"名字";
    name.textColor = [NSColor whiteColor];
    name.editable = NO;
    name.bordered = NO;
    name.font = [NSFont systemFontOfSize:15];
    [self.view addSubview:name];
    
    self.bugTitleView = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMinY(name.frame) - 28 - 10, 165, 28)];
    _bugTitleView.bezelStyle =NSTextFieldRoundedBezel;
    [self.view addSubview:_bugTitleView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bugTitleViewAction:) name:NSControlTextDidEndEditingNotification object:_bugTitleView];
    
    NSTextField *rating = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMinY(_bugTitleView.frame) - 10 - 20, 100, 20)];
    rating.backgroundColor = [NSColor clearColor];
    rating.stringValue = @"评分";
    rating.textColor = [NSColor whiteColor];
    rating.editable = NO;
    rating.bordered = NO;
    rating.font = [NSFont systemFontOfSize:15];
    [self.view addSubview:rating];
    
    self.bugRating = [[EDStarRating alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMinY(rating.frame) - 10 - 44, 165, 44)];
    self.bugRating.starImage = [NSImage imageNamed:@"star.png"];
    self.bugRating.starHighlightedImage = [NSImage imageNamed:@"shockedface2_full.png"];
    self.bugRating.starImage = [NSImage imageNamed:@"shockedface2_empty.png"];
    self.bugRating.maxRating = 5.0;
    self.bugRating.delegate = (id<EDStarRatingProtocol>) self;
    self.bugRating.horizontalMargin = 2;
    self.bugRating.editable=YES;
    self.bugRating.displayMode=EDStarRatingDisplayFull;
    self.bugRating.rating= 0.0;
    self.bugRating.editable = NO;
    [self.view addSubview:_bugRating];
    
    self.bugImageView = [[NSImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMinY(_bugRating.frame) - 10 - 150, 171, 150)];
    _bugImageView.image = [NSImage imageNamed:@"ladybug.jpg"];
    _bugImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [self.view addSubview:_bugImageView];
    
    self.changeBtn = [[NSButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMinY(_bugImageView.frame) - 10 - 32, 171, 32)];
    _changeBtn.bezelStyle = NSBezelStyleRounded;
    [_changeBtn setTitle:@"改变图片"];
    _changeBtn.target = self;
    _changeBtn.action = @selector(changeAction:);
    [self.view addSubview:_changeBtn];
    
}

- (void)initTableView{
    self.tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(20, 66, 221, 291)];
    _tableContainerView.borderType = NSBezelBorder;
    self.tableView = [[NSTableView alloc] initWithFrame:CGRectMake(0, 20, self.tableContainerView.frame.size.width - 20, self.tableContainerView.frame.size.height)];
    _tableView.backgroundColor = [NSColor clearColor];
    _tableView.focusRingType = NSFocusRingTypeNone;                             //tableview获得焦点时的风格
//    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;//行高亮的风格
    _tableView.headerView.frame = NSZeroRect;   //表头
    _tableView.usesAlternatingRowBackgroundColors = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 32;
    [_tableView registerNib:[[NSNib alloc] initWithNibNamed:@"HomeTableViewCell" bundle:nil] forIdentifier:@"HomeTableViewCell"];
    //    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    //    [column1 setWidth:_tableView.frame.size.width];
    //    [_tableView addTableColumn:column1];
    
    // 第一列
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
//    [column1 setWidth:130];
    [_tableView addTableColumn:column1];//第一列
    
    //        // 第二列
    //        NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"secondColumn"];
    //        [column2 setWidth:200];
    //        [_tableView addTableColumn:column2];//第二列
    
        
        [_tableContainerView setDocumentView:_tableView];
        [_tableContainerView setDrawsBackground:NO];        //不画背景（背景默认画成白色）
        [_tableContainerView setHasVerticalScroller:YES];   //有垂直滚动条
        //[_tableContainer setHasHorizontalScroller:YES];   //有水平滚动条
        _tableContainerView.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
        [self.view addSubview:_tableContainerView];
        
        //监测tableview滚动
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(tableviewDidScroll:)
                                                    name:NSViewBoundsDidChangeNotification
                                                  object:[[_tableView enclosingScrollView] contentView]];
    
    NSButton *addBtn = [[NSButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableContainerView.frame) - 70, CGRectGetMinY(self.tableContainerView.frame) - 20 - 20, 30, 30)];
    addBtn.bezelStyle = NSBezelStyleRegularSquare;
    [addBtn setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
    addBtn.target = self;
    addBtn.action = @selector(addAction:);
    [self.view addSubview:addBtn];
    
    self.deleteButton = [[NSButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableContainerView.frame) - 30, CGRectGetMinY(self.tableContainerView.frame) - 20 - 20, 30, 30)];
    _deleteButton.bezelStyle = NSBezelStyleRegularSquare;
    [_deleteButton setImage:[NSImage imageNamed:NSImageNameRemoveTemplate]];
    _deleteButton.target = self;
    _deleteButton.action = @selector(removeAction:);
    [self.view addSubview:_deleteButton];
}

- (void) initData{
    ScaryBugsDoc *bug1 = [[ScaryBugsDoc alloc] initWithTitle:@"potatoBug" rating:4 thumbImage:[NSImage imageNamed:@"potatoBugThumb.jpg"] fullImage:[NSImage imageNamed:@"potatoBug.jpg"]];
    ScaryBugsDoc *bug2 = [[ScaryBugsDoc alloc] initWithTitle:@"centipede" rating:4 thumbImage:[NSImage imageNamed:@"centipedeThumb.jpg"] fullImage:[NSImage imageNamed:@"centipede.jpg"]];
    ScaryBugsDoc *bug3 = [[ScaryBugsDoc alloc] initWithTitle:@"wolfSpider" rating:4 thumbImage:[NSImage imageNamed:@"wolfSpiderThumb.jpg"] fullImage:[NSImage imageNamed:@"wolfSpider.jpg"]];
    ScaryBugsDoc *bug4 = [[ScaryBugsDoc alloc] initWithTitle:@"ladybug" rating:4 thumbImage:[NSImage imageNamed:@"ladybugThumb.jpg"] fullImage:[NSImage imageNamed:@"ladybug.jpg"]];

    self.bugs = [NSMutableArray arrayWithObjects:bug1, bug2, bug3, bug4, nil];
}

@end
