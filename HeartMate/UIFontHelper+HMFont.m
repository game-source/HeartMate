//
//  UIFontHelper+HMFont.m
//  HeartMate
//
//  Created by xaoxuu on 05/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "UIFontHelper+HMFont.h"

static inline void ax_exchangeSelector(Class theClass, SEL originalSelector, SEL newSelector) {
    Method method_origin = class_getClassMethod(theClass, originalSelector);
    Method method_new = class_getClassMethod(theClass, newSelector);
    method_exchangeImplementations(method_origin, method_new);
}


@implementation UIFontHelper (HMFont)

+ (void)load{

    ax_exchangeSelector([self class], @selector(robotoFontWithName:size:), @selector(ax_robotoFontWithName:size:));
    
    ax_exchangeSelector([self class], @selector(boldRobotoFontOfSize:), @selector(ax_boldRobotoFontOfSize:));
    
}

+ (nullable UIFont *)ax_robotoFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font;
    if (fontName == nil) {
        font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:fontSize];
    } else {
        font = [UIFont fontWithName:fontName size:fontSize];
    }
    
    if (!font)
        font = [UIFont systemFontOfSize:fontSize];
    
    return [font copy];
}



+ (UIFont *)ax_boldRobotoFontOfSize:(CGFloat)fontSize {
    return [UIFontHelper robotoFontWithName:@"ChalkboardSE-Bold" size:fontSize];
}


@end

/*

+ (UIFont *)robotoFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font;
    if (fontName == nil) {
        font = [UIFont fontWithName:@"roboto-regular" size:fontSize];
    } else {
        font = [UIFont fontWithName:fontName size:fontSize];
    }
    
    if (!font)
        font = [UIFont systemFontOfSize:fontSize];
        
        return [font copy];
}

+ (UIFont *)robotoFontOfSize:(CGFloat)fontSize {
    
    return [UIFontHelper robotoFontWithName:nil size:fontSize];
}

+ (UIFont *)boldRobotoFontOfSize:(CGFloat)fontSize {
    return [UIFontHelper robotoFontWithName:@"roboto-bold" size:fontSize];
}

*/

/**

 
 + (nullable UIFont *)robotoFontWithName:(nullable NSString *)fontName size:(CGFloat)fontSize;
 + (nullable UIFont *)robotoFontOfSize:(CGFloat)fontSize;
 + (nullable UIFont *)boldRobotoFontOfSize:(CGFloat)fontSize;
 @end
 
 
static inline void ax_exchangeSelector(Class theClass, SEL originalSelector, SEL newSelector) {
    Method method_origin = class_getInstanceMethod(theClass, originalSelector);
    Method method_new = class_getInstanceMethod(theClass, newSelector);
    method_exchangeImplementations(method_origin, method_new);
}


static inline BOOL ax_class_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}


@implementation UINavigationController (AXExtension)



- (void)ax_hidesBottomBarWhenPushed:(BOOL)hide{
    // @xaoxuu: origin method
    Method method_origin = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    // @xaoxuu: flag dictionary
    NSMutableDictionary *imps = objc_getAssociatedObject(self, UINavigationControllerAXExtensionKey);
    if (!imps) {
        imps = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UINavigationControllerAXExtensionKey, imps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    BOOL isExchanged = [imps[[NSString stringWithFormat:@"%p",method_origin]] boolValue];
    if (hide^isExchanged) {
        // @xaoxuu: new method
        Method method_new = class_getInstanceMethod([self class], @selector(ax_pushViewControllerHidesBottomBar:animated:));
        // @xaoxuu: add new method to class
        ax_class_addMethod([self class], @selector(ax_pushViewControllerHidesBottomBar:animated:), method_new);
        // @xaoxuu: exchange methods
        ax_exchangeSelector([self class], @selector(pushViewController:animated:), @selector(ax_pushViewControllerHidesBottomBar:animated:));
        imps[[NSString stringWithFormat:@"%p",method_origin]] = @(hide);
    }
}



- (void)ax_pushViewControllerNamed:(NSString *)vcName{
    [self ax_pushViewControllerNamed:vcName animated:YES completion:^(UIViewController * _Nonnull targetVC) {
        // @xaoxuu: do nothing.
    } failure:^(NSError * _Nonnull error) {
        // @xaoxuu: do nothing.
    }];
}


- (void)ax_pushViewControllerNamed:(NSString *)vcName animated:(BOOL)animated completion:(void (^)(UIViewController *targetVC))completion failure:(void (^)(NSError *error))failure{
    UIViewController *vc = [[NSClassFromString(vcName) class] new];
    if (vc) {
        [self pushViewController:vc animated:animated];
        if (completion) {
            completion(vc);
        }
    } else {
        NSError *error = [NSError axkit_errorWithCode:AXKitErrorCodePushNavVC reason:^NSString *{
            return [NSString stringWithFormat:@"The targetVC named: \'%@\' not found.\n",vcName];
        }];
        AXLogError(error);
        if (failure && error) {
            failure(error);
        }
    }
}


- (void)ax_popToViewControllerWithIndexFromRoot:(NSUInteger)index animated:(BOOL)animated{
    NSArray *vcs = self.viewControllers;
    NSUInteger targetIndex = MIN(index, vcs.count-1);
    [self popToViewController:vcs[targetIndex] animated:YES];
}

- (void)ax_popToViewControllerWithIndexFromSelf:(NSUInteger)index animated:(BOOL)animated{
    NSArray *vcs = self.viewControllers;
    index = MIN(index, vcs.count-1);
    NSUInteger targetIndex = vcs.count-1-index;
    [self popToViewController:vcs[targetIndex] animated:YES];
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}


#pragma mark - 私有


- (void)ax_pushViewControllerHidesBottomBar:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (!self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = NO;
    } else {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [self ax_pushViewControllerHidesBottomBar:viewController animated:animated];
}


@end

*/
