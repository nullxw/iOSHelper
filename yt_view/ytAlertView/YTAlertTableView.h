//
//  YTAlertTableView.h
//  ImhtDoctor
//
//  Created by imht-ios on 14-6-23.
//  Copyright (c) 2014年 imht. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NSInteger(^numberOfRowsInSectionBlock)(UITableView *table, NSInteger section);
typedef UITableViewCell *(^tableCellBlock)(UITableView *table, NSIndexPath *indexPath);
typedef void(^selectCellBlock)(UITableView *table, NSIndexPath *indexPath);



@interface YTAlertTableView : UIView<UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

/**
 *  tableview 的三个代理方法
 *  @param YTTableRowsInSection     cell的数量代理
 *  @param YTTableCell              cell的代理
 *  @param YTTableSelectAction      点击事件的代理
 */
@property (copy, nonatomic) numberOfRowsInSectionBlock      YTTableRowsInSection;
@property (copy, nonatomic) tableCellBlock                  YTTableCell;
@property (copy, nonatomic) selectCellBlock                 YTTableSelectAction;


/**
 *  init 方法         !!!!! 必须使用该方法初始化 !!!!!!
 *
 *  @param title        头部的 显示
 *  @param canceltitle  底部显示 显示
 *  @param cell         tableviewcell 代理方法
 *  @param numberOfRows tableviewnumberofrows 代理方法
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                    andCancel:(NSString *)canceltitle
                 andTableCell:(tableCellBlock)cell
                   andNumRows:(numberOfRowsInSectionBlock)numberOfRows;

/**
 *  显示界面
 *
 *  @return 返回显示 是否成功
 */
- (BOOL)show;






@end





