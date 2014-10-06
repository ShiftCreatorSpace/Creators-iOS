//
//  ShiftTransitionAnimation.swift
//  creators
//
//  Created by Natasja Nielsen on 10/6/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // the animator object responsible for presenting
        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // the animator object responsible for dismissing
        let dismissalAnimator = TransitionDismissalAnimator()
        return dismissalAnimator
    }
}

class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = self .transitionDuration(transitionContext)
        
        // take a snapshot of the detail ViewController so we can do whatever with it (cause it's only a view), and don't have to care about breaking constraints
        let snapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        snapshotView.center = fromViewController.view.center
        containerView.addSubview(snapshotView)
        
        // hide the detail view until the snapshot is being animated
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: nil,
            animations: { () -> Void in
                snapshotView.transform = CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                snapshotView.removeFromSuperview()
                toViewController.view.alpha = 1.0
                transitionContext.completeTransition(finished)
        })
    }
}

class TransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = self .transitionDuration(transitionContext)
        
        let snapshotView = fromViewController.view.resizableSnapshotViewFromRect(fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        snapshotView.center = toViewController.view.center
        containerView.addSubview(snapshotView)
        
        fromViewController.view.alpha = 0.0
        
        let toViewControllerSnapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        containerView.insertSubview(toViewControllerSnapshotView, belowSubview: snapshotView)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            snapshotView.alpha = 0.0
            }) { (finished) -> Void in
                toViewControllerSnapshotView.removeFromSuperview()
                snapshotView.removeFromSuperview()
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}