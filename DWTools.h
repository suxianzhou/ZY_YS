#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DWTools : NSObject

+ (NSInteger)getFileSizeWithPath:(NSString *)filePath Error:(NSError **)error;

+ (UIImage *)getImage:(NSString *)videoPath atTime:(NSTimeInterval)time Error:(NSError **)error;

+ (BOOL)saveVideoThumbnailWithVideoPath:(NSString *)vieoPath toFile:(NSString *)ThumbnailPath Error:(NSError **)error;

+ (NSString *)formatSecondsToString:(NSInteger)seconds;
@end
