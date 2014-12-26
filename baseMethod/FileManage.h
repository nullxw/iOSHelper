//
//  FileManage.h
//  美美哒
//
//  Created by megvii on 14-8-5.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManage : NSObject

+ (instancetype)fileManage;

- (NSString *)documentsFile;

//存储数据为 data 类型
- (void)saveData:(NSData *)data withName:(NSString *)tagId;
//读取data类型数据
- (NSData *)getDatawithName:(NSString *)tagId;


//保存plist
- (void)savePlist:(NSMutableArray *)array name:(NSString *)name;
//读取Plist
- (NSMutableArray *)getPlist:(NSString *)name;


//httpcoke
- (void)saveLoginCoke:(NSDictionary *)cokeDic;
- (NSDictionary *)getLoginCoke;
- (void)removeLoginCoke;


//保存图片
- (void)saveImage:(UIImage *)image WithName:(NSString *)name;
- (UIImage *)readCokeImage:(NSString *)name;


@end
