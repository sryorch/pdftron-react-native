//
//  UIViewController+Swizzling.m
//  RNPdftron
//
//  Created by Erick Barbosa on 9/4/23.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
#import <Tools/PTFloatingSigViewController.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    // Ensures that swizzling is performed only once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Get class references
        Class baseClass = [UIViewController class];
        Class targetClass = [PTFloatingSigViewController class];

        // Define method selectors
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swizzled_viewWillAppear:);

        // Obtain method references
        Method originalMethod = class_getInstanceMethod(targetClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(baseClass, swizzledSelector);

        // Safety check before method swizzling
        if (originalMethod && swizzledMethod) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        } else {
            NSLog(@"Method swizzling failed. Methods not found.");
        }
    });
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    // Call the original implementation (since we've exchanged implementations)
    [self swizzled_viewWillAppear:animated];
    
    // Perform type check before casting and applying specific logic
    if ([self isKindOfClass:[PTFloatingSigViewController class]]) {
        PTFloatingSigViewController *sigViewController = (PTFloatingSigViewController *)self;

        [sigViewController.digSigView setStrokeThickness:4.0];
    }
}

@end
