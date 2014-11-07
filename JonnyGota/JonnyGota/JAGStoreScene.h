//
//  JAGStoreScene.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 26/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <StoreKit/StoreKit.h>


@interface JAGStoreScene : SKScene<SKRequestDelegate,SKProductsRequestDelegate>
@property NSArray *products;
@property NSMutableArray *identifiers;
-(void)validateProductIdentifiers:(NSArray *)productIdentifiers;
-(void)recuperaCompras;
@end
