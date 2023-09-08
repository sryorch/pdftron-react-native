#import "PTSignaturesManager+Swizzling.h"
#import <objc/runtime.h>

@implementation PTSignaturesManager (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(createSignature:withStrokeColor:withStrokeThickness:withinRect:saveSignature:);
        SEL swizzledSelector = @selector(swizzled_createSignature:withStrokeColor:withStrokeThickness:withinRect:saveSignature:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        if (originalMethod && swizzledMethod) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        } else {
            NSLog(@"Method swizzling failed. Methods not found.");
        }
    });
}

// The swizzled method
- (PTPDFDoc *)swizzled_createSignature:(NSMutableArray *)points withStrokeColor:(UIColor *)strokeColor withStrokeThickness:(CGFloat)thickness withinRect:(CGRect)rect saveSignature:(BOOL)saveSignature {    
    // Call the original method (which is now `swizzled_createSignature:` because we've exchanged their implementations)
    return [self swizzled_createSignature:points withStrokeColor:strokeColor withStrokeThickness:8.0 withinRect:rect saveSignature:saveSignature];
}

@end
