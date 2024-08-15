//
//  UIImage+Compression.h
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import <UIKit/UIKit.h>
#import "NSData+ImageFormat.h"

@interface UIImage (Compression)

/**
 压缩图片,压缩 JPEG,PNG, 不含 GIF

 @param image 压缩前的图片
 @param imageType 指明图片类型
 @param size 期望压缩后的大小,单位:MB
 @return 压缩后的图片
 */
+ (UIImage *)kj_compressWithImage:(UIImage *)image imageType:(KJImageFormat)imageType specifySize:(CGFloat)size;

/**
 压缩图片,压缩 JPEG,PNG,GIF

 @param imageData 压缩前图片的data
 @param size 期望压缩后的大小,单位:MB
 @return 压缩后的图片
 */
+ (UIImage *)kj_compressWithImage:(NSData *)imageData specifySize:(CGFloat)size;

@end


