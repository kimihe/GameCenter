
#import "Sprite.h"

@interface Animation : Sprite {   
} 

+ (CGPoint) getOriginBasedOnCenterOf: (CGRect) rectMaster 
                              andPic: (NSString *) picName
                        withFrameCnt: (int) fcnt;

@end
