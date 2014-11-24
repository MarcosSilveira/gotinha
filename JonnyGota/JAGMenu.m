//
//  JAGMenu.m
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 26/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGMenu.h"
#import "JAGPlayGameScene.h"
#import "JAGStoreScene.h"
#import "JAGLevelSelectionScene.h"

@implementation JAGMenu
{
    SKSpriteNode *botaoPlay;
    SKSpriteNode *botaoStore;
    SKSpriteNode *logo;
    SKSpriteNode *fundo;
    SKLabelNode *lblGame;
    SKLabelNode *lblPlay;
    SKTexture *botaoPlayText;
    SKTexture *logoText;
    SKTexture *bg;
    SKTexture *botaoStoreText;
}

-(id)initWithSize:(CGSize)size {
    
    self = [super initWithSize:size];
    if (self) {
        
        [self configuraMenu];
    }
    return self;
}

-(void) configuraMenu {
    
    botaoPlayText = [SKTexture textureWithImageNamed:@"play"];
    logoText      = [SKTexture textureWithImageNamed:@"logo"];
    bg            = [ SKTexture textureWithImageNamed:@"menu"];
    botaoStoreText    = [SKTexture textureWithImageNamed:@"storeBT"];
    
    fundo = [[SKSpriteNode alloc] initWithTexture:bg];
    [fundo setSize: CGSizeMake(self.size.width, self.size.height)];
    fundo.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    logo = [[SKSpriteNode alloc] initWithTexture:logoText];
    [logo setSize: CGSizeMake(self.size.width, self.size.height)];
    logo.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    botaoPlay = [[SKSpriteNode alloc] initWithTexture:botaoPlayText];
    botaoPlay.size = CGSizeMake(self.frame.size.width *.28, self.frame.size.height *.15);
    botaoPlay.position = CGPointMake(self.size.width/2, self.size.height/2.8);
    
    botaoStore = [[SKSpriteNode alloc] initWithTexture:botaoStoreText];
    botaoStore.size = CGSizeMake(self.frame.size.width*.28, self.frame.size.height*.15);
    botaoStore.position = CGPointMake(self.size.width/2, self.size.height/5.1);
    
    [self addChild:fundo];
    [self addChild:logo];
    [self addChild:botaoPlay];
    [self addChild:botaoStore];
    NSLog(@"%@", NSLocalizedString(@"TESTE", nil));
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode: self];
        
        if ([botaoPlay containsPoint:location]) {
            
            
            
            SKScene *scene = [[JAGLevelSelectionScene alloc] initWithSize:self.frame.size];
            
            SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            
            SKAction *transi=[SKAction sequence:@[[SKAction runBlock:^{
                [botaoPlay runAction:[SKAction scaleBy:1.5 duration:0.8]];
            }],[SKAction waitForDuration:0.1],
                                                  [SKAction runBlock:^{
                [self.scene.view presentScene:scene transition:trans];
            }]]];
            [self runAction:transi];
            
            
                    }
        else if([botaoStore containsPoint:location]){
//            [botaoStore runAction:[SKAction scaleBy:1.5 duration:0.5]];
            SKScene *scene = [[JAGStoreScene alloc]initWithSize:self.frame.size];
//            [self.scene.view presentScene:scene transition:[SKTransition fadeWithDuration:1.0]];
            
             SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            
            SKAction *transi=[SKAction sequence:@[[SKAction runBlock:^{
                [botaoStore runAction:[SKAction scaleBy:1.5 duration:0.8]];
            }],[SKAction waitForDuration:0.1],
                                                  [SKAction runBlock:^{
                [self.scene.view presentScene:scene transition:trans];
            }]]];
            [self runAction:transi];
        }
    }
}

@end
