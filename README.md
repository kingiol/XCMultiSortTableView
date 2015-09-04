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
    
Usage In Swift
=========

implement protocol like this:

``` swift
@objc(arrayDataForContentInTableView:InSection:)
    func arrayDataForContentInTableView(tableView: XCMultiTableView!, inSection section: UInt) -> [AnyObject]! {
        return [""]
    }
    
    @objc(arrayDataForLeftHeaderInTableView:InSection:)
    func arrayDataForLeftHeaderInTableView(tableView: XCMultiTableView!, inSection section: UInt) -> [AnyObject]! {
        return [""]
    }
```

Inspiration
===========

inspiration from [MultiColumnTableViewForiOS](https://github.com/Xenofex/MultiColumnTableViewForiOS)

License
=======

MIT LICENSE

Copyright (C)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

