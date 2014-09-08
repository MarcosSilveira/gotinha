//
//  JAGMenu.m
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 26/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGMenu.h"

@implementation JAGMenu
{
    SKSpriteNode *botaoPlay;
}

-(id)initWithSize:(CGSize)size {
    
    self = [super initWithSize:size];
    if (self) {
        [self configuraMenu];
    }
    return self;
}
-(void) configuraMenu {
 
    self.backgroundColor = [SKColor whiteColor];
    
    botaoPlay = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:.7 green:.2 blue:.1 alpha:1.0] size:CGSizeMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) / 4)];
    botaoPlay.position = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(botaoPlay.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(botaoPlay.frame)*3);
    
    [self addChild:botaoPlay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode: self];
        
        if ([botaoPlay containsPoint:location]) {
            NSLog(@"teste");
            self.play = YES;
            }
    }
}

@end
