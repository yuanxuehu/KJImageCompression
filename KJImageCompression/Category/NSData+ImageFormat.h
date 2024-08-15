//
//  NSData+ImageFormat.h
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import <Foundation/Foundation.h>

/**
 图片类型
 */
typedef NS_ENUM(NSInteger, KJImageFormat) {
    KJImageFormatUndefined = -1,
    KJImageFormatJPEG = 0,
    KJImageFormatPNG,
    KJImageFormatGIF,
    KJImageFormatTIFF,
    KJImageFormatWebp,
};

@interface NSData (ImageFormat)

/**
 根据图片的data数据,获取图片类型
 
 @param data 图片的data数据
 @return 图片类型
 */
+ (KJImageFormat)kj_imageFormatWithImageData:(nullable NSData *)data;

@end

