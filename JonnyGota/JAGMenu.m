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
    SKLabelNode *lblGame;
    SKLabelNode *lblPlay;
}

-(id)initWithSize:(CGSize)size {
    
    self = [super initWithSize:size];
    NSLog(@"menu presentation");
    if (self) {
        [self configuraMenu];
    }
    return self;
}
-(void) configuraMenu {
 
    self.backgroundColor = [SKColor colorWithRed:.3 green:.3 blue:1.0 alpha:1.0];
    
    botaoPlay = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:.0 green:.0 blue:1.0 alpha:1.0] size:CGSizeMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) / 4)];
    botaoPlay.position = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(botaoPlay.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(botaoPlay.frame)*3);
    
    lblGame = [[SKLabelNode alloc] init];
    lblGame.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/4);
    [lblGame setFontColor:[SKColor yellowColor]];
    lblGame.fontSize = 20.0;
    lblGame.text = @"As Aventuras da Gotinha";
    
    lblPlay = [[SKLabelNode alloc] init];
    [lblPlay setFontColor:[SKColor yellowColor]];
    lblPlay.text = @"Play";
    
    [self addChild:botaoPlay];
    [self addChild:lblGame];
    
    [botaoPlay addChild:lblPlay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode: self];
        
        if ([botaoPlay containsPoint:location]) {
            NSLog(@"teste");
            self.play = YES;
            
            SKScene *scene = [[JAGPlayGameScene alloc] initWithSize:self.frame.size level:@1 andWorld:@1];
            
            SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            [self.scene.view presentScene:scene transition:trans];
            }
    }
}

@end
