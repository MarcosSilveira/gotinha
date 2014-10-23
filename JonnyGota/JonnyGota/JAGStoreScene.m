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
    
}

-(void)didMoveToView:(SKView *)view{
    _identifiers = [NSArray arrayWithObjects:@"Super_Gotinha_",@"10_vidas", nil];
    
    [self validateProductIdentifiers:_identifiers];
    
    background = [[SKSpriteNode alloc]initWithImageNamed:@"loja_BG"];
    background.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    background.size = self.frame.size;
    background.zPosition = 0;
    
    backBT =[[SKSpriteNode alloc]initWithImageNamed:@"back_bt"];
    backBT.position = CGPointMake(self.frame.size.width*0.1, self.frame.size.height*0.9);
    backBT.size = CGSizeMake(backBT.texture.size.width/2, backBT.texture.size.height/2);
    
    //    item1 = [[SKSpriteNode alloc] initWithImageNamed:@"vidas5.png"];
    //    item1.size = CGSizeMake(item1.texture.size.width*0.7, item1.texture.size.height*0.7);
    //    item1.position = CGPointMake(self.frame.size.width*0.3, self.frame.size.height*0.58);
    //
    //    item2 = [[SKSpriteNode alloc]initWithImageNamed:@"vidas10.png"];
    //    item2.size = item1.size;
    //    item2.position = CGPointMake(self.frame.size.width*0.7, self.frame.size.height*0.58);
    //
    //    priceItem1 = [[SKSpriteNode alloc]initWithImageNamed:@"price099.png"];
    //    priceItem1.position = CGPointMake(item1.position.x, item1.position.y*0.8);
    //    priceItem1.size = CGSizeMake(self.frame.size.width*0.15, self.frame.size.height*0.15);
    //
    //    priceItem2 = [[SKSpriteNode alloc]initWithImageNamed:@"price199.png"];
    //    priceItem2.position = CGPointMake(item2.position.x, item2.position.y*0.8);
    //    priceItem2.size = CGSizeMake(self.frame.size.width*0.15, self.frame.size.height*0.15);
    //
    //    bt_bg = [[SKSpriteNode alloc]initWithImageNamed:@"bt_bg.png"];
    //    bt_bg.position = CGPointMake(self.frame.size.width*0.3, self.frame.size.height*0.5);
    //    bt_bg.size = CGSizeMake(item1.size.width*1.1, item1.size.height*2);
    //    bt_bg2 = [[SKSpriteNode alloc]initWithImageNamed:@"bt_bg.png"];
    //    bt_bg2.position = CGPointMake(self.frame.size.width*0.7, self.frame.size.height*0.5);
    //    bt_bg2.size = CGSizeMake(item1.size.width*1.1, item1.size.height*2);
    
    [self addChild:background];
    [self addChild:backBT];
    //    [self addChild:bt_bg];
    //    [self addChild:bt_bg2];
    //    [self addChild:item1];
    //    [self addChild:item2];
    //    [self addChild:priceItem1];
    //    [self addChild:priceItem2];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    JAGMenu *menu;
    for (UITouch *touch in touches) {
        
        if ([backBT containsPoint:[touch locationInNode:self]]) {
            menu = [[JAGMenu alloc]initWithSize:self.frame.size];
            [self.scene.view presentScene:menu transition:[SKTransition fadeWithDuration:1]];
        }
    }
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
    SKProduct *produtoTeste = self.products[0];
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
    }
    
    [self organizaBotoes]; // Custom method
}
-(void)requestingPayment{
    SKProduct *product = nil;//produto escolhido
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)organizaBotoes{
    float posXInicial = self.frame.size.width*0.2;
    float posYInicial = self.frame.size.height*0.58;
    float posX = posXInicial;
    float posY = posYInicial;
    float somaX = self.frame.size.width*0.103;
    
    if (_products.count !=0) {
        
        
        for (int i=0; i<_products.count; i++) {
            SKSpriteNode *nodoItem;
            SKSpriteNode *nodoPreco;
            
            SKProduct *produto = [_products objectAtIndex:i];
            if ([produto.productIdentifier isEqualToString:@"10_vidas"]) {
                NSLog(@"10 vidas retornou da loja");
                nodoPreco = [[SKSpriteNode alloc]initWithImageNamed:@"price099.png"];
                nodoItem = [[SKSpriteNode alloc]initWithImageNamed:@"vidas10.png"];
                nodoItem.position = CGPointMake(posX, posY);
                nodoPreco.position = CGPointMake(nodoItem.position.x*1.55, nodoItem.position.y*0.8);
                nodoItem.size = CGSizeMake(nodoItem.texture.size.width*0.7, nodoItem.texture.size.height*0.7);
                nodoPreco.size = CGSizeMake(self.frame.size.width*0.15, self.frame.size.height*0.15);
                [self.scene addChild:nodoItem];
                [self.scene addChild:nodoPreco];
            }
            else if([produto.productIdentifier isEqualToString:@"Super_Gotinha_"]){
                NSLog(@"Super gotinha retornou da loja");
                

            }
            posX = posX+somaX;
            
            //posY = posY*1.2;
            nodoItem.position = CGPointMake(posX,posY);
            nodoItem.zPosition = 1;
            
        }
    }
}
@end

























