XCMultiSortTableView
====================

![ScreenShort](https://raw.github.com/kingiol/XCMultiSortTableView/master/screenshot/screenShort.gif)

Purpose
=======

XCMultiSortTableView is a fixed head and sortable columns tableView.
please visit the demo [XCMultiSortTableView](https://github.com/kingiol/XCMultiSortTableView)，the core part is the XCMultiSortTableView folder in demo files.

Usage
=====

1.add [files](https://github.com/kingiol/XCMultiSortTableView/tree/master/XCMultiTableDemo/XCMultiSortTableView) to your project

2.add `#import "XCMultiSortTableView.h"` to your top of the files you wish to use XCMultiSortTableView in, and set the `delegate`

3.add the code like this
>
	XCMultiTableView *tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    [self.view addSubview:tableView];

Inspiration
===========

inspiration from [MultiColumnTableViewForiOS](https://github.com/Xenofex/MultiColumnTableViewForiOS)

