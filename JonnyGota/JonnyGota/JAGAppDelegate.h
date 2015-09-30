//
//  JAGAppDelegate.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface JAGAppDelegate : UIResponder <UIApplicationDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) UIWindow *window;

@end
