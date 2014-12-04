//
//  JAGAppDelegate.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGAppDelegate.h"
#import <StoreKit/StoreKit.h>
@implementation JAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    NSLog(@"Update on Transactions:");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                //                [self showTransactionAsInProgress:transaction deferred:NO];
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStateDeferred:
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                //                [self showTransactionAsInProgress:transaction deferred:YES];
                NSLog(@"Deferred");
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                //                [self failedTransaction:transaction];
                NSLog(@"Failed");
                break;
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                
                //                [self completeTransaction:transaction];
                NSLog(@"Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                //                [self restoreTransaction:transaction];
                NSLog(@"Restored");
                break;
            default:
                // For debugging
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
        
    }
}
@end
