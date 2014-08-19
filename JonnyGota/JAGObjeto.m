//
//  JAGObjeto.m
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 18/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGObjeto.h"

@implementation JAGObjeto

- (instancetype)init
{
    self = [super init];
    return self;
}

-(void) criarObj:(CGPoint)posi comTipo:(NSInteger)tipo eSprite:(SKSpriteNode *) sprite {

    sprite = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(20, 20)];
    sprite.position = posi;
    _sprite = sprite;
    
    [self addChild:_sprite];
    
    _sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_sprite.frame.size.width, _sprite.frame.size.height)];
    _sprite.physicsBody.categoryBitMask = ITEM;
    
    self.physicsBody.categoryBitMask = ITEM;
    self.physicsBody.collisionBitMask = GOTA;

    
    _sprite.physicsBody.dynamic=NO;
    
    _tipo=tipo;
    switch (tipo) {
        case 1:
            _sprite.name = @"chave";
            break;
            
        case 2:
            _sprite.name = @"cronometro";
            break;
            
        case 3:
            _sprite.name = @"velocidade";
            break;
            
        default:
            break;
    }
}

-(void) habilidade:(JAGPlayGameScene *)scene{
    
    switch (_tipo) {
            
        case 1:
            break;
            
        case 2:
            scene.hud.tempoRestante+=10;
            break;
            
        case 3:
            break;
            
        default:
            break;
    }
}

@end
