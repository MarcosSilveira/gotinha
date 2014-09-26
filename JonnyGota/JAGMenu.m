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
    botaoStoreText    = [SKTexture textureWithImageNamed:@"store"];
    
    fundo = [[SKSpriteNode alloc] initWithTexture:bg];
    [fundo setSize: CGSizeMake(self.size.width, self.size.height)];
    fundo.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    logo = [[SKSpriteNode alloc] initWithTexture:logoText];
    [logo setSize: CGSizeMake(self.size.width, self.size.height)];
    logo.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    botaoPlay = [[SKSpriteNode alloc] initWithTexture:botaoPlayText];
    botaoPlay.size = CGSizeMake(self.frame.size.width *.25, self.frame.size.height *.16);
    botaoPlay.position = CGPointMake(self.size.width/2, self.size.height/2.8);
    
    botaoStore = [[SKSpriteNode alloc] initWithTexture:botaoStoreText];
    botaoStore.size = CGSizeMake(self.frame.size.width*.25, self.frame.size.height*.15);
    botaoStore.position = CGPointMake(self.size.width/2, self.size.height/5.1);
    
    [self addChild:fundo];
    [self addChild:logo];
    [self addChild:botaoPlay];
    [self addChild:botaoStore];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode: self];
        
        if ([botaoPlay containsPoint:location]) {
            
            SKScene *scene = [[JAGPlayGameScene alloc] initWithSize:self.frame.size level:@2 andWorld:@1];
            
            SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            [self.scene.view presentScene:scene transition:trans];
        }
        else if([botaoStore containsPoint:location]){
            NSLog(@"Chamar Store");
        }
    }
}

@end
