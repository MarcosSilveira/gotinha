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
    
    botaoPlay = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:.3 green:.2 blue:.001 alpha:1.0] size:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 4)];
    botaoPlay.position = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(botaoPlay.frame) / 2, CGRectGetHeight(self.frame) - CGRectGetHeight(botaoPlay.frame) / 2);
    
    [self addChild:botaoPlay];
}

@end
