//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "XCMultiSortTableView.h"

#import "XCMultiSortTableViewDefault.h"
#import "XCMultiSortTableViewBGScrollView.h"

#import "UIView+XCMultiSortTableView.h"

#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }

typedef NS_ENUM(NSUInteger, TableColumnSortType) {
    TableColumnSortTypeAsc = 0,
    TableColumnSortTypeDesc,
    TableColumnSortTypeNone
};

@interface XCMultiTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

- (void)reset;
- (void)adjustView;
- (void)setUpTopHeaderScrollView;
- (void)accessColumnPointCollection;
- (void)buildSectionFoledStatus:(NSInteger)section;

- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column;
- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation XCMultiTableView {
    XCMultiTableViewBGScrollView *topHeaderScrollView;
    XCMultiTableViewBGScrollView *contentScrollView;
    UITableView *leftHeaderTableView;
    UITableView *contentTableView;
    UIView *vertexView;

    UILabel *vertextLabel;
    
    NSMutableDictionary *sectionFoldedStatus;
    NSArray *columnPointCollection;
    
    NSMutableArray *leftHeaderDataArray;
    NSMutableArray *contentDataArray;
    
    NSMutableDictionary *columnTapViewDict;
    
    NSMutableDictionary *columnSortedTapFlags;
    
    BOOL responseToNumberSections;
    BOOL responseContentTableCellWidth;
    BOOL responseNumberofContentColumns;
    BOOL responseCellHeight;
    BOOL responseTopHeaderHeight;
    BOOL responseBgColorForColumn;
    BOOL responseHeaderBgColorForColumn;
}

@synthesize cellWidth, cellHeight, topHeaderHeight, leftHeaderWidth, sectionHeaderHeight, boldSeperatorLineWidth, normalSeperatorLineWidth;
@synthesize boldSeperatorLineColor, normalSeperatorLineColor;

@synthesize leftHeaderEnable;

@synthesize datasource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [[UIColor colorWithWhite:XCMultiTableView_BoraerColorGray alpha:1.0f] CGColor];
        self.layer.cornerRadius = XCMultiTableView_CornerRadius;
        self.layer.borderWidth = XCMultiTableView_BorderWidth;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        cellWidth = XCMultiTableView_DefaultCellWidth;
        cellHeight = XCMultiTableView_DefaultCellHeight;
        topHeaderHeight = XCMultiTableView_DefaultTopHeaderHeight;
        leftHeaderWidth = XCMultiTableView_DefaultLeftHeaderWidth;
        sectionHeaderHeight = XCMultiTableView_DefaultSectionHeaderHeight;
        
        boldSeperatorLineWidth = XCMultiTableView_DefaultBoldLineWidth;
        normalSeperatorLineWidth = XCMultiTableView_DefaultNormalLineWidth;
        
        boldSeperatorLineColor = [UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0];
        normalSeperatorLineColor = [UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0];
        
        vertexView = [[UIView alloc] initWithFrame:CGRectZero];
        vertexView.backgroundColor = [UIColor clearColor];
        vertexView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:vertexView];
        
        vertextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        vertextLabel.backgroundColor = [UIColor clearColor];
        vertextLabel.textAlignment = NSTextAlignmentCenter;
        [vertexView addSubview:vertextLabel];
        
        topHeaderScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        topHeaderScrollView.backgroundColor = [UIColor clearColor];
        topHeaderScrollView.parent = self;
        topHeaderScrollView.delegate = self;
        topHeaderScrollView.showsHorizontalScrollIndicator = NO;
        topHeaderScrollView.showsVerticalScrollIndicator = NO;
        topHeaderScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:topHeaderScrollView];
        
        leftHeaderTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        leftHeaderTableView.dataSource = self;
        leftHeaderTableView.delegate = self;
        leftHeaderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        leftHeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        leftHeaderTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:leftHeaderTableView];
        
        contentScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        contentScrollView.backgroundColor = [UIColor clearColor];
        contentScrollView.parent = self;
        contentScrollView.delegate = self;
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentScrollView];
        
        contentTableView = [[UITableView alloc] initWithFrame:contentScrollView.bounds];
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.backgroundColor = [UIColor clearColor];
        [contentScrollView addSubview:contentTableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat superWidth = self.bounds.size.width;
    CGFloat superHeight = self.bounds.size.height;
    
    if (leftHeaderEnable) {
        vertexView.frame = CGRectMake(0, 0, leftHeaderWidth, topHeaderHeight);
        vertextLabel.frame = vertexView.bounds;
        
        if ([self.datasource respondsToSelector:@selector(vertexName)]) {
            vertextLabel.text = [self.datasource vertexName];
        }
        
        topHeaderScrollView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, 0, superWidth - leftHeaderWidth - boldSeperatorLineWidth, topHeaderHeight);
        leftHeaderTableView.frame = CGRectMake(0, topHeaderHeight + boldSeperatorLineWidth, leftHeaderWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
        contentScrollView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, topHeaderHeight + boldSeperatorLineWidth, superWidth - leftHeaderWidth - boldSeperatorLineWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
    }else {
        topHeaderScrollView.frame = CGRectMake(0, 0, superWidth, topHeaderHeight);
        contentScrollView.frame = CGRectMake(0, topHeaderHeight + boldSeperatorLineWidth, superWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
    }
    
    [self adjustView];
}

- (void)reloadData {
    [self reset];
    [leftHeaderTableView reloadData];
    [contentTableView reloadData];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, boldSeperatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetStrokeColorWithColor(context, [boldSeperatorLineColor CGColor]);
    
    if (leftHeaderEnable) {
        CGFloat x = leftHeaderWidth + boldSeperatorLineWidth / 2.0f;
        CGContextMoveToPoint(context, x, 0.0f);
        CGContextAddLineToPoint(context, x, self.bounds.size.height);
        CGFloat y = topHeaderHeight + boldSeperatorLineWidth / 2.0f;
        CGContextMoveToPoint(context, 0.0f, y);
        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    }else {
        CGFloat y = topHeaderHeight + boldSeperatorLineWidth / 2.0f;
        CGContextMoveToPoint(context, 0.0f, y);
        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    }
    
    CGContextStrokePath(context);
}

- (void)dealloc {
    topHeaderScrollView = nil;
    contentScrollView = nil;
    leftHeaderTableView = nil;
    contentTableView = nil;
    vertexView = nil;
    columnPointCollection = nil;
}

#pragma mark - property

- (void)setDatasource:(id<XCMultiTableViewDataSource>)datasource_ {
    if (datasource != datasource_) {
        datasource = datasource_;
        
        responseToNumberSections = [datasource_ respondsToSelector:@selector(numberOfSectionsInTableView:)];
        responseContentTableCellWidth = [datasource_ respondsToSelector:@selector(tableView:contentTableCellWidth:)];
        responseNumberofContentColumns = [datasource_ respondsToSelector:@selector(arrayDataForTopHeaderInTableView:)];
        responseCellHeight = [datasource_ respondsToSelector:@selector(tableView:cellHeightInRow:InSection:)];
        responseTopHeaderHeight = [datasource_ respondsToSelector:@selector(topHeaderHeightInTableView:)];
        responseBgColorForColumn = [datasource_ respondsToSelector:@selector(tableView:bgColorInSection:InRow:InColumn:)];
        responseHeaderBgColorForColumn = [datasource_ respondsToSelector:@selector(tableView:headerBgColorInColumn:)];
        
        [self reset];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *target = nil;
    if (tableView == leftHeaderTableView) {
        target = contentTableView;
        if ([self.delegate respondsToSelector:@selector(tableViewWithType:didSelectRowAtIndexPath:)]) {
            [self.delegate tableViewWithType:MultiTableViewTypeLeft didSelectRowAtIndexPath:indexPath];
        }
    }else if (tableView == contentTableView) {
        target = leftHeaderTableView;
        if ([self.delegate respondsToSelector:@selector(tableViewWithType:didSelectRowAtIndexPath:)]) {
            [self.delegate tableViewWithType:MultiTableViewTypeRight didSelectRowAtIndexPath:indexPath];
        }
    }else {
        target = nil;
    }
    [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [tableView rectForHeaderInSection:section].size.height)];;
    if (tableView == leftHeaderTableView) {
        UITapGestureRecognizer *leftRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftHeaderTap:)];
        view.backgroundColor = [UIColor yellowColor];
        view.tag = section;
        [view addGestureRecognizer:leftRecognizer];
    }else {
        NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
        for (NSInteger i = 0; i < count; i++) {
            CGFloat cellW = [self accessContentTableViewCellWidth:i];
            CGFloat cellH = [tableView rectForHeaderInSection:section].size.height;
            
            CGFloat width = [[columnPointCollection objectAtIndex:i] floatValue];
            
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
            subView.center = CGPointMake(width, cellH / 2.0f);
            subView.clipsToBounds = YES;
            if (i == 1) {
                subView.backgroundColor = [UIColor grayColor];
            }else {
                subView.backgroundColor = [UIColor blackColor];
            }
            
            NSString *tagStr = [NSString stringWithFormat:@"%@_%@", @(section), @(i)];
            subView.tag = (int)tagStr;
            
            NSString *columnStr = [NSString stringWithFormat:@"%@_%@", @(section), @(i)];
            [columnTapViewDict setObject:subView forKey:columnStr];
            
            
            if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
                [columnSortedTapFlags setObject:[NSNumber numberWithInt:TableColumnSortTypeNone] forKey:columnStr];
            }
            
            
            UITapGestureRecognizer *contentHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
            
            [subView addGestureRecognizer:contentHeaderGecognizer];
            
            [view addSubview:subView];
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightInIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger rows = 0;
    if (![self foldedInSection:section]) {
        rows = [self rowsInSection:section];
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == leftHeaderTableView) {
        return [self leftHeaderTableView:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self contentTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *target = nil;
    if (scrollView == leftHeaderTableView) {
        target = contentTableView;
    }else if (scrollView == contentTableView) {
        target = leftHeaderTableView;
    }else if (scrollView == contentScrollView) {
        target = topHeaderScrollView;
    }else if (scrollView == topHeaderScrollView) {
        target = contentScrollView;
    }
    target.contentOffset = scrollView.contentOffset;
}

#pragma mark - private method

- (void)reset {
    
    columnTapViewDict = [NSMutableDictionary dictionary];
    columnSortedTapFlags = [NSMutableDictionary dictionary];
    
    [self accessDataSourceData];
    
    vertexView.backgroundColor = [self headerBgColorColumn:-1];
    [self accessColumnPointCollection];
    [self buildSectionFoledStatus:-1];
    [self setUpTopHeaderScrollView];
    [contentScrollView reDraw];
}

- (void)adjustView {
    
    CGFloat width = 0.0f;
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (int i = 1; i <= count + 1; i++) {
        if (i == count + 1) {
            width += normalSeperatorLineWidth;
        }else {
            width += normalSeperatorLineWidth + [self accessContentTableViewCellWidth:i - 1];
        }
    }
    
    NSLog(@"width:%f, height:%f", self.frame.size.width, self.frame.size.height);
    
    topHeaderScrollView.contentSize = CGSizeMake(width, topHeaderHeight);
    contentScrollView.contentSize = CGSizeMake(width, self.bounds.size.height - topHeaderHeight - boldSeperatorLineWidth);
    
    contentTableView.frame = CGRectMake(0.0f, 0.0f, width, self.bounds.size.height - topHeaderHeight - boldSeperatorLineWidth);
}

- (void)buildSectionFoledStatus:(NSInteger)section {
    if (sectionFoldedStatus == nil) sectionFoldedStatus = [NSMutableDictionary dictionary];

    NSUInteger sections = [self numberOfSections];
    for (int i = 0; i < sections; i++) {
        if (section == -1) {
            [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:i]];
        }else if (i == section) {
            if ([self foldedInSection:section]) {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:section]];
            }else {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:YES] forKey:[self sectionToString:section]];
            }
            break;
        }
    }
}

- (void)setUpTopHeaderScrollView {
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (NSInteger i = 0; i < count; i++) {
        
        CGFloat topHeaderW = [self accessContentTableViewCellWidth:i];
        CGFloat topHeaderH = [self accessTopHeaderHeight];
        
        CGFloat widthP = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH)];
        view.clipsToBounds = YES;
        view.center = CGPointMake(widthP, topHeaderH / 2.0f);
        view.tag = i;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [[datasource arrayDataForTopHeaderInTableView:self] objectAtIndex:i];
        
        [label sizeToFit];
        
        AlignHorizontalPosition alignPosition = AlignHorizontalPositionLeft;
        if ([self.datasource respondsToSelector:@selector(tableView:inColumn:)]) {
            alignPosition = [self.datasource tableView:self inColumn:i];
        }
        
        switch (alignPosition) {
            case AlignHorizontalPositionLeft:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(labelW * 0.5, topHeaderH * 0.5);
            }
                break;
            case AlignHorizontalPositionRight:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(topHeaderW - labelW * 0.5, topHeaderH * 0.5);
            }
                break;
            default:
            {
                label.center = CGPointMake(topHeaderW / 2.0f, topHeaderH / 2.0f);
            }
                break;
        }
        
        
        UIColor *color = [self headerBgColorColumn:i];
        view.backgroundColor = color;
        label.backgroundColor = color;
        
        [view addSubview:label];
        
        
        UITapGestureRecognizer *topHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
        
        [view addGestureRecognizer:topHeaderGecognizer];
        
        NSString *columnStr = [NSString stringWithFormat:@"-1_%@", @(i)];
        [columnTapViewDict setObject:view forKey:columnStr];
        
        if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
            [columnSortedTapFlags setObject:[NSNumber numberWithInt:TableColumnSortTypeNone] forKey:columnStr];
        }
        
        [topHeaderScrollView addSubview:view];
    }
    
    [topHeaderScrollView reDraw];

}

- (void)accessColumnPointCollection {
    NSUInteger columns = responseNumberofContentColumns ? [datasource arrayDataForTopHeaderInTableView:self].count : 0;
    if (columns == 0) @throw [NSException exceptionWithName:nil reason:@"number of content columns must more than 0" userInfo:nil];
    NSMutableArray *tmpAry = [NSMutableArray array];
    CGFloat widthColumn = 0.0f;
    CGFloat widthP = 0.0f;
    for (int i = 0; i < columns; i++) {
        CGFloat columnWidth = [self accessContentTableViewCellWidth:i];
        widthColumn += (normalSeperatorLineWidth + columnWidth);
        widthP = widthColumn - columnWidth / 2.0f;
        [tmpAry addObject:[NSNumber numberWithFloat:widthP]];
    }
    columnPointCollection = [tmpAry copy];
}

- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column {
    return responseContentTableCellWidth ? [datasource tableView:self contentTableCellWidth:column] : cellWidth;
}

- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"leftHeaderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat cellH = [self cellHeightInIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftHeaderWidth, cellH)];
    view.clipsToBounds = YES;
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [[leftHeaderDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [label sizeToFit];
    label.center = CGPointMake(leftHeaderWidth / 2.0f, cellH / 2.0f);
    
    UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:-1];
    view.backgroundColor = color;
    label.backgroundColor = color;
    
    [view addSubview:label];
    
    [cell.contentView addSubview:view];
    
    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}

- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    static NSString *cellID = @"contentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSMutableArray *ary = [[contentDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    for (NSInteger i = 0; i < count; i++) {
        
        CGFloat cellW = [self accessContentTableViewCellWidth:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
        
        CGFloat width = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        view.center = CGPointMake(width, cellH / 2.0f);
        view.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%@", [ary objectAtIndex:i]];
        
        [label sizeToFit];
        
        AlignHorizontalPosition alignPosition = AlignHorizontalPositionLeft;
        if ([self.datasource respondsToSelector:@selector(tableView:inColumn:)]) {
            alignPosition = [self.datasource tableView:self inColumn:i];
        }
        
        switch (alignPosition) {
            case AlignHorizontalPositionLeft:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(labelW * 0.5, cellH * 0.5);
            }
                break;
            case AlignHorizontalPositionRight:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(cellW - labelW * 0.5, cellH * 0.5);
            }
                break;
            default:
            {
                label.center = CGPointMake(cellW / 2.0f, cellH / 2.0f);
            }
                break;
        }
        
        
        UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:i];
        
        view.backgroundColor = color;
        label.backgroundColor = color;
        
        [view addSubview:label];
        
        [cell.contentView addSubview:view];
    }
    
    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}

#pragma mark - GestureRecognizer

- (void)leftHeaderTap:(UITapGestureRecognizer *)recognizer {
    
    @synchronized(self) {
        NSUInteger section = recognizer.view.tag;
        [self buildSectionFoledStatus:section];
       
        [leftHeaderTableView beginUpdates];
        [contentTableView beginUpdates];

        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < [self rowsInSection:section]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        if ([self foldedInSection:section]) {
            [leftHeaderTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [contentTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [leftHeaderTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [contentTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }

        [leftHeaderTableView endUpdates];
        [contentTableView endUpdates];
    }
}

- (void)contentHeaderTap:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    
    NSIndexPath *indexPath = [self accessUIViewVirtualTag:view];
    
    NSUInteger length = [indexPath length];
    
    if (length != 2) return;
    
    NSInteger section = indexPath.section;
    NSInteger column = indexPath.row;
    
    NSString *columnStr = [NSString stringWithFormat:@"%@_%@", @(section), @(column)];
    
    NSInteger columnFlag = [[columnSortedTapFlags objectForKey:columnStr] integerValue];
    
    if (section == -1) {
        NSUInteger rows = [self numberOfSections];
        
        TableColumnSortType newType = TableColumnSortTypeNone;
        
        if (columnFlag == TableColumnSortTypeNone || columnFlag == TableColumnSortTypeDesc) {
            newType = TableColumnSortTypeAsc;
        }else {
            newType = TableColumnSortTypeDesc;
        }
        
        for (NSInteger i = 0; i < rows; i++) {
            NSIndexPath *iPath = [NSIndexPath indexPathForRow:column inSection:i];
            
            NSString *str = [NSString stringWithFormat:@"%@_%@", @(iPath.section), @(iPath.row)];
            [columnSortedTapFlags setObject:[NSNumber numberWithUnsignedInteger:columnFlag] forKey:str];
            
            [self singleHeaderClick:iPath];
        }
        [columnSortedTapFlags setObject:[NSNumber numberWithInt:newType] forKey:columnStr];
        
    }else {
        [self singleHeaderClick:indexPath];
    }
    
    
    [leftHeaderTableView reloadData];
    [contentTableView reloadData];

}

- (void)singleHeaderClick:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger column = indexPath.row;
    
    NSString *columnStr = [NSString stringWithFormat:@"%@_%@", @(section), @(column)];
    NSInteger columnFlag = [[columnSortedTapFlags objectForKey:columnStr] integerValue];
    
    NSArray *leftHeaderDataInSection = [leftHeaderDataArray objectAtIndex:section];
    NSArray *contentDataInSection = [contentDataArray objectAtIndex:section];
    
    NSArray *sortContentData = [contentDataInSection sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSComparisonResult result =  [[obj1 objectAtIndex:column] compare:[obj2 objectAtIndex:column]];
        
        return result;
    }];
    
    NSMutableArray *sortIndexAry = [NSMutableArray array];
    for (int i = 0; i < sortContentData.count; i++) {
        id objI = [sortContentData objectAtIndex:i];
        for (int j = 0; j < contentDataInSection.count; j++) {
            id objJ = [contentDataInSection objectAtIndex:j];
            if (objI == objJ) {
                [sortIndexAry addObject:[NSNumber numberWithInt:j]];
                break;
            }
        }
    }
    
    NSMutableArray *sortLeftHeaderData = [NSMutableArray array];
    for (id index in sortIndexAry) {
        int i = [index intValue];
        [sortLeftHeaderData addObject:[leftHeaderDataInSection objectAtIndex:i]];
    }
    
    if (columnFlag == TableColumnSortTypeNone || columnFlag == TableColumnSortTypeDesc) {
        columnFlag = TableColumnSortTypeAsc;
    }else {
        columnFlag = TableColumnSortTypeDesc;
        NSEnumerator *leftReverseEnumerator = [sortLeftHeaderData reverseObjectEnumerator];
        NSEnumerator *contentReverseEvumerator = [sortContentData reverseObjectEnumerator];
        sortLeftHeaderData = [NSMutableArray arrayWithArray:[leftReverseEnumerator allObjects]];
        sortContentData = [NSArray arrayWithArray:[contentReverseEvumerator allObjects]];
    }
    
    [leftHeaderDataArray replaceObjectAtIndex:section withObject:sortLeftHeaderData];
    [contentDataArray replaceObjectAtIndex:section withObject:sortContentData];
    
    [columnSortedTapFlags setObject:[NSNumber numberWithUnsignedInteger:columnFlag] forKey:columnStr];
    
}

#pragma mark - other method

- (NSUInteger)rowsInSection:(NSUInteger)section {
    return [[leftHeaderDataArray objectAtIndex:section] count];
}

- (NSUInteger)numberOfSections {
    NSUInteger sections = responseToNumberSections ? [datasource numberOfSectionsInTableView:self] : 1;
    return sections < 1 ? 1 : sections;
}

- (NSString *)sectionToString:(NSUInteger)section {
    return [NSString stringWithFormat:@"%@", @(section)];
}

- (BOOL)foldedInSection:(NSUInteger)section {
    return [[sectionFoldedStatus objectForKey:[self sectionToString:section]] boolValue];
}

- (CGFloat)cellHeightInIndexPath:(NSIndexPath *)indexPath {
    return responseCellHeight ? [datasource tableView:self cellHeightInRow:indexPath.row InSection:indexPath.section] : cellHeight;
}

- (CGFloat)accessTopHeaderHeight {
    return responseTopHeaderHeight ? [datasource topHeaderHeightInTableView:self] : topHeaderHeight;
}

- (UIColor *)bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    return responseBgColorForColumn ? [datasource tableView:self bgColorInSection:section InRow:row InColumn:column] : [UIColor clearColor];
}

- (UIColor *)headerBgColorColumn:(NSUInteger)column {
    return responseHeaderBgColorForColumn ? [datasource tableView:self headerBgColorInColumn:column] : [UIColor clearColor];
}

- (void)accessDataSourceData {
    leftHeaderDataArray = [NSMutableArray array];
    contentDataArray = [NSMutableArray array];
    
    NSUInteger sections = [datasource numberOfSectionsInTableView:self];
    for (int i = 0; i < sections; i++) {
        [leftHeaderDataArray addObject:[datasource arrayDataForLeftHeaderInTableView:self InSection:i]];
        [contentDataArray addObject:[datasource arrayDataForContentInTableView:self InSection:i]];
    }
}

- (NSIndexPath *)accessUIViewVirtualTag:(UIView *)view {
    for (NSString *key in [columnTapViewDict allKeys]) {
        UIView *vi = [columnTapViewDict objectForKey:key];
        if (vi == view) {
            NSArray *sep = [key componentsSeparatedByString:@"_"];
            NSUInteger section = [[sep objectAtIndex:0] integerValue];
            NSUInteger row = [[sep objectAtIndex:1] integerValue];
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    return nil;
}

@end
