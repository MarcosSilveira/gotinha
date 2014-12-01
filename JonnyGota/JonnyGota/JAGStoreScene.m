//
//  JAGStoreScene.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 26/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGStoreScene.h"
#import "JAGMenu.h"

@implementation JAGStoreScene{
    SKSpriteNode *background;
    SKSpriteNode *backBT;
    SKSpriteNode *item1;
    SKSpriteNode *item2;
    SKSpriteNode *priceItem1;
    SKSpriteNode *priceItem2;
    SKSpriteNode *bt_bg;
    SKSpriteNode *bt_bg2;
    SKLabelNode *message2;
    SKSpriteNode *recuperaBT;
    SKReceiptRefreshRequest *request;
    BOOL primeiroProdutoOK;
    
}

-(void)didMoveToView:(SKView *)view{
    primeiroProdutoOK = NO;
    _identifiers = [NSMutableArray arrayWithObjects:@"Super_Gotinha_",@"10_vidas", nil];
    
    [self validateProductIdentifiers:_identifiers];
    
    background = [[SKSpriteNode alloc]initWithImageNamed:@"loja_BG"];
    background.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    background.size = self.frame.size;
    background.zPosition = 0;
    
    backBT =[[SKSpriteNode alloc]initWithImageNamed:@"btBack"];
    backBT.position = CGPointMake(self.frame.size.width*0.1, self.frame.size.height*0.9);
    backBT.size = CGSizeMake(self.frame.size.width*0.08, self.frame.size.width*0.08);
    backBT.zRotation = M_PI;

    
    recuperaBT = [[SKSpriteNode alloc]initWithImageNamed:@"restaurarCompras.png"];
    recuperaBT.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.17);
    recuperaBT.size = CGSizeMake(recuperaBT.texture.size.width/2.2, recuperaBT.texture.size.height/2.2);
    recuperaBT.name = @"recuperaBT";
    
    message2 =[[SKLabelNode alloc]initWithFontNamed:@"AvenirNext-Bold"];
    message2.fontSize = self.frame.size.height*0.08;
    message2.text =NSLocalizedString(@"STORE_CARREGANDO_PRODUTOS", nil);
    message2.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);

    
    [self addChild:background];
    [self addChild:backBT];
    [self addChild:message2];
    [self addChild:recuperaBT];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    JAGMenu *menu;
    SKNode *auxNode;
    SKNode *auxNode2;
    for (UITouch *touch in touches) {
        auxNode = [self nodeAtPoint:[touch locationInNode:self]];
        
        if ([recuperaBT containsPoint:[touch locationInNode:self]]) {
            [self recuperaCompras];
        }

        if ([backBT containsPoint:[touch locationInNode:self]]) {
            menu = [[JAGMenu alloc]initWithSize:self.frame.size];
//            [self.scene.view presentScene:menu transition:[SKTransition fadeWithDuration:1]];
            
            SKAction *transi=[SKAction sequence:@[[SKAction playSoundFileNamed:@"botaoUp1.wav" waitForCompletion:NO],
                                                  [SKAction runBlock:^{
                [backBT runAction:[SKAction scaleBy:1.5 duration:0.8]];
            }],[SKAction waitForDuration:0.1],
                                                  [SKAction runBlock:^{
                [self.scene.view presentScene:menu transition:[SKTransition fadeWithDuration:1]];
            }]]];
            [self runAction:transi];

        }
        
        auxNode2 = [self.scene childNodeWithName:@"10_vidas"];
        
        if([auxNode2 containsPoint:[touch locationInNode:self]])
            [self requestingPayment:[self.scene childNodeWithName:@"10_vidas"].name];
        
        auxNode2 = [self.scene childNodeWithName:@"Super_Gotinha_"];
        
        if([auxNode2 containsPoint:[touch locationInNode:self]])
            [self requestingPayment:[self.scene childNodeWithName:@"Super_Gotinha_"].name];
    
        
        if([recuperaBT containsPoint:[touch locationInNode:self]])
            [self recuperaCompras];
        
    }

}
-(void)recuperaCompras{
//    SKPaymentQueue *queue = [[SKPaymentQueue alloc]init];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//    SKPaymentTransaction *transactionAux = queue.transactions[0];
//    NSMutableArray *productIDsToRestore = _identifiers;
//    SKPaymentTransaction *transaction = transactionAux;
//    
//    if ([productIDsToRestore containsObject:transaction.transactionIdentifier]) {
//        // Re-download the Apple-hosted content, then finish the transaction
//        // and remove the product identifier from the array of product IDs.
//    } else {
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    }

    
}
-(void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;

    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
    }
    
    [self organizaBotoes]; // Custom method
}
-(void)requestingPayment:(NSString*)productNamed{
    SKProduct *product;
    for (int i=0; i<_products.count; i++) {
        SKProduct *productAux = [_products objectAtIndex:i];
        if ([productNamed isEqualToString:productAux.productIdentifier])
            product = productAux;
        
    }
    if (product!= nil) {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

-(void)organizaBotoes{
    float posXInicial = self.frame.size.width*0.3;
    float posYInicial = self.frame.size.height*0.58;
    float posX = posXInicial;
    float posY = posYInicial;
    float somaX = self.frame.size.width*0.2;
    
    if (_products.count !=0) {
        if (!primeiroProdutoOK) {
            [message2 removeFromParent];
            primeiroProdutoOK = YES;
        }

        
        for (int i=0; i<_products.count; i++) {
            SKSpriteNode *nodoItem;
            SKSpriteNode *nodoPreco;
            
            SKProduct *produto = [_products objectAtIndex:i];
            if ([produto.productIdentifier isEqualToString:@"10_vidas"]) {
                NSLog(@"10 vidas retornou da loja");
                nodoPreco = [[SKSpriteNode alloc]initWithImageNamed:@"price199.png"];
                nodoItem = [[SKSpriteNode alloc]initWithImageNamed:@"vidas10.png"];
                nodoItem.position = CGPointMake(posX, posY);
                nodoPreco.position = CGPointMake(nodoItem.position.x, nodoItem.position.y*0.8);
                nodoItem.size = CGSizeMake(nodoItem.texture.size.width*0.7, nodoItem.texture.size.height*0.7);
                nodoPreco.size = CGSizeMake(self.frame.size.width*0.15, self.frame.size.height*0.15);
                bt_bg = [[SKSpriteNode alloc]initWithImageNamed:@"bt_bg.png"];
                bt_bg.position = CGPointMake(nodoItem.position.x, nodoItem.position.y*0.9);
                bt_bg.size = CGSizeMake(nodoPreco.size.width*1.1, nodoPreco.size.height*2);
                bt_bg.zPosition = 0;
                bt_bg.name = produto.productIdentifier;
                [self.scene addChild:nodoItem];
                [self.scene addChild:nodoPreco];
                [self.scene addChild:bt_bg];
            }
            else if([produto.productIdentifier isEqualToString:@"Super_Gotinha_"]){
                NSLog(@"Super gotinha retornou da loja");
                nodoPreco = [[SKSpriteNode alloc]initWithImageNamed:@"price099.png"];
                nodoItem = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:CGSizeMake(30,30)];
                nodoItem.position = CGPointMake(posX, posY);
                nodoPreco.position = CGPointMake(nodoItem.position.x, nodoItem.position.y*0.8);
//                nodoItem.size = CGSizeMake(nodoItem.texture.size.width*0.7, nodoItem.texture.size.height*0.7);
                nodoPreco.size = CGSizeMake(self.frame.size.width*0.15, self.frame.size.height*0.15);
                bt_bg = [[SKSpriteNode alloc]initWithImageNamed:@"bt_bg.png"];
                bt_bg.position = CGPointMake(nodoItem.position.x, nodoItem.position.y*0.9);
                bt_bg.size = CGSizeMake(nodoPreco.size.width*1.1, nodoPreco.size.height*2);
                bt_bg.zPosition = 0;
                bt_bg.name = produto.productIdentifier;
                [self.scene addChild:nodoItem];
                [self.scene addChild:nodoPreco];
                [self.scene addChild:bt_bg];

            }
            posX = posX+somaX;
            
            //posY = posY*1.2;

            nodoItem.zPosition = 1;
            nodoPreco.zPosition = 1;
            
        }
    }
}
@end

























