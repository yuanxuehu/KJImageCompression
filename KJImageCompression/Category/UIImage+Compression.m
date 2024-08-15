//
//  UIImage+Compression.m
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)

+ (UIImage *)kj_compressWithImage:(UIImage *)image imageType:(KJImageFormat)imageType specifySize:(CGFloat)size {
    if (size == 0) {
        return image;
    }
    
    if (imageType == KJImageFormatPNG) {
        NSData *data = UIImagePNGRepresentation(image);
        return [self kj_compressWithImage:data specifySize:size];
    } else if (imageType == KJImageFormatJPEG) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        return [self kj_compressWithImage:data specifySize:size];
    }

    return image;
}

+ (UIImage *)kj_compressWithImage:(NSData *)imageData specifySize:(CGFloat)size {
    if (!imageData || size == 0) {
        return nil;
    }
    
    CGFloat specifySize = size * 1000 * 1000;
    
    KJImageFormat imageFormat = [NSData kj_imageFormatWithImageData:imageData];
    if (imageFormat == KJImageFormatPNG) {
        //核心代码：png图片压缩
        UIImage *image = [UIImage imageWithData:imageData];
        while (imageData.length > specifySize) {
            CGFloat targetWidth = image.size.width * 0.9;
            CGFloat targetHeight = image.size.height * 0.9;
            CGRect maxRect = CGRectMake(0, 0, targetWidth, targetHeight);
            //UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(targetWidth), floorf(targetHeight)), NO, [UIScreen mainScreen].scale);
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(targetWidth), floorf(targetHeight)), NO, 1.0);
            [image drawInRect:maxRect];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageData = UIImagePNGRepresentation(image);
        }
        return image;
    }
    
    if (imageFormat == KJImageFormatJPEG) {
        //核心代码：JPEG图片压缩
        UIImage *resultImage = [UIImage imageWithData:imageData];
        while (imageData.length > specifySize) {
            CGFloat ratio = (CGFloat)specifySize / imageData.length;
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
            UIGraphicsBeginImageContext(size);
            // Use image to draw (drawInRect:), image is larger but more compression time
            // Use result image to draw, image is smaller but less compression time
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageData = UIImageJPEGRepresentation(resultImage, 1);
                        
            //resultImage = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
            resultImage = [UIImage imageWithData:imageData scale:1.0];
        }
        return resultImage;
    }
    
    if (imageFormat == KJImageFormatGIF) {
        //核心代码：gif图片压缩
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        size_t count = CGImageSourceGetCount(source);
        NSTimeInterval duration = count * (1 / 30.0);
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
            UIImage *image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            [images addObject:image];
            CGImageRelease(cgImage);
        }
        CFRelease(source);
        
        while (imageData.length > specifySize) {
            for (UIImage *image in images) {
                UIImage *img = image;
                CGFloat targetWidth = img.size.width * 0.9;
                CGFloat targetHeight = img.size.height * 0.9;
                CGRect maxRect = CGRectMake(0, 0, targetWidth, targetHeight);
                //UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(targetWidth), floorf(targetHeight)), NO, [UIScreen mainScreen].scale);
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(targetWidth), floorf(targetHeight)), NO, 1.0);
                [img drawInRect:maxRect];
                img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                imageData = UIImagePNGRepresentation(img);
            }
        }
        return [UIImage animatedImageWithImages:images duration:duration];
    }
    
    return [UIImage imageWithData:imageData];
}

@end

