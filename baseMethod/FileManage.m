//
//  FileManage.m
//  美美哒
//
//  Created by megvii on 14-8-5.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import "FileManage.h"
//#import "SDImageCache.h"
#import "UIImage+Resize.h"

#define KLgoinCokeName @"Some Key Value"

@interface FileManage ()

@property (strong, nonatomic) NSFileManager *fileManager;
@property (copy, nonatomic) NSString *document;

@end

@implementation FileManage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.document = [self documentsFile];
    }
    return self;
}

- (NSString *)documentsFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (instancetype)fileManage
{
    static FileManage *manage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[FileManage alloc] init];
    });
    return manage;
}

- (void)saveData:(NSData *)data withName:(NSString *)tagId
{
//    NSString *tagFilePath = [self.document stringByAppendingPathComponent:tagId];
    [self saveData:data withFileName:@"history" saveName:tagId];
}

- (NSData *)getDatawithName:(NSString *)tagId{

    return [self getTagDataWithTagId:tagId];
}

- (NSData *)getTagDataWithTagId:(NSString *)tagId
{
    NSString *tagFilePath = [NSString stringWithFormat:@"%@/history/%@", self.document, tagId];
    NSData *data = [NSData dataWithContentsOfFile:tagFilePath];
    
    return data;
}

//获取 指定位置 文件的路径
- (NSString *)pathForFileName:(NSString *)filename saveName:(NSString *)saveName{
    NSString *sourFile = [self.document stringByAppendingPathComponent:filename];
    NSString *sourPath = [sourFile stringByAppendingPathComponent:saveName];

    return sourPath;
}

//保存数据到指定 位置  -> /document/。。。/..
- (void)saveData:(NSData *)data withFileName:(NSString *)filename saveName:(NSString *)saveName
{
    NSString *sourFile = [self.document stringByAppendingPathComponent:filename];
    
    BOOL isDir = NO;
    BOOL existed = [self.fileManager fileExistsAtPath:sourFile isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [self.fileManager createDirectoryAtPath:sourFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *sourPath = [sourFile stringByAppendingPathComponent:saveName];
    
    [data writeToFile:sourPath atomically:YES];
}

//获得数据到指定 位置  -> /document/。。。/..
- (NSData *)getDatawithFileName:(NSString *)filename saveName:(NSString *)saveName
{
    NSString *sourFile = [self.document stringByAppendingPathComponent:filename];
    NSString *sourPath = [sourFile stringByAppendingPathComponent:saveName];
    NSData *data = [NSData dataWithContentsOfFile:sourPath];
    
    return data;
}

- (void)saveArrayForPlist:(NSMutableArray *)array withFileName:(NSString *)name
{
    NSString *sourPath = [self.document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];

    [array writeToFile:sourPath atomically:YES];
}

//保存plist
- (void)savePlist:(NSMutableArray *)array name:(NSString *)name
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *sourFile = [self.document stringByAppendingPathComponent:[NSString stringWithFormat:@"uploadhistroy"]];
        
        BOOL isDir = NO;
        BOOL existed = [self.fileManager fileExistsAtPath:sourFile isDirectory:&isDir];
        if (!(isDir == YES && existed == YES))
        {
            [self.fileManager createDirectoryAtPath:sourFile withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *sourPath = [sourFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
        
        [array writeToFile:sourPath atomically:YES];
    });
}

//读取Plist
- (NSMutableArray *)getPlist:(NSString *)name{
    NSString *sourFile = [self.document stringByAppendingPathComponent:[NSString stringWithFormat:@"uploadhistroy/%@.plist", name]];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:sourFile];
    return array;
}

- (void)saveLoginCoke:(NSDictionary *)cokeDic{

    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:cokeDic forKey:KLgoinCokeName];
    [archiver finishEncoding];
    
    [self saveData:data withFileName:KLgoinCokeName saveName:KLgoinCokeName];
}

- (NSDictionary *)getLoginCoke{
    
    NSData *data = [self getDatawithFileName:KLgoinCokeName saveName:KLgoinCokeName];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:KLgoinCokeName];
    [unarchiver finishDecoding];
    
    return myDictionary;
}

- (void)removeLoginCoke{
    NSString *path = [self pathForFileName:KLgoinCokeName saveName:KLgoinCokeName];
    [self.fileManager removeItemAtPath:path error:nil];
}

//保存图片
- (void)saveImage:(UIImage *)image WithName:(NSString *)name{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        
        [self saveData:data withFileName:@"imageCoke" saveName:name];
    });
}
- (UIImage *)readCokeImage:(NSString *)name{
   
    NSData *imageData = [self getDatawithFileName:@"imageCoke" saveName:name];
    UIImage *image  = [UIImage imageWithData:imageData scale:1];
    
    return image;
}


@end
