//
//  JAGMenu.m
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 26/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGMenu.h"
#import "JAGPlayGameScene.h"

@implementation JAGMenu
{
    SKSpriteNode *botaoPlay;
    SKSpriteNode *logo;
    SKSpriteNode *fundo;
    SKLabelNode *lblGame;
    SKLabelNode *lblPlay;
    SKTexture *botaoPlayText;
    SKTexture *logoText;
    SKTexture *bg;
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
    
    fundo = [[SKSpriteNode alloc] initWithTexture:bg];
    [fundo setSize: CGSizeMake(self.size.width, self.size.height)];
    fundo.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    logo = [[SKSpriteNode alloc] initWithTexture:logoText];
    [logo setSize: CGSizeMake(self.size.width, self.size.height)];
    logo.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    botaoPlay = [[SKSpriteNode alloc] initWithTexture:botaoPlayText];
    botaoPlay.size = CGSizeMake(self.frame.size.width * .3, self.frame.size.height * .2);
    botaoPlay.position = CGPointMake(self.size.width/2, self.size.height/4);
    
    [self addChild:fundo];
    [self addChild:logo];
    [self addChild:botaoPlay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode: self];
        
        if ([botaoPlay containsPoint:location]) {
            
            SKScene *scene = [[JAGPlayGameScene alloc] initWithSize:self.frame.size level:@2 andWorld:@1];
            
            SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            [self.scene.view presentScene:scene transition:trans];
        }
    }
}

@end
