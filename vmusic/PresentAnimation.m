//
//  PresentAnimation.m
//  vmusic
//
//  Created by yufengvac on 2016/11/30.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "PresentAnimation.h"


@implementation PresentAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect finalPosition = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = CGRectOffset(finalPosition, -bounds.size.width, bounds.size.height);
    
    UIView *containerView= [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = finalPosition;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}


@end
