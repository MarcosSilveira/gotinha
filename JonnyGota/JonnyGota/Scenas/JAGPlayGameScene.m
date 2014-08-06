//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"

@implementation JAGPlayGameScene{
    int width;
    int height;
    float timeTouch;

    CGPoint locations;
}

#pragma mark - Move to View
-(void)didMoveToView:(SKView *)view{

    width = self.scene.size.width;
    height = self.scene.size.height;
    
    gota = [[JAGGota alloc] init];
    self.physicsWorld.contactDelegate = (id)self;
    self.backgroundColor = [SKColor redColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.anchorPoint = CGPointMake (0.5,0.5);
    self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
    [self touchesEnded:nil withEvent:nil];
    
    myWorld = [SKNode node];
    
    [self addChild:myWorld];
    
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-width/2, -height/2) toPoint:CGPointMake(width/2, -height/2)];
    
    camera = [SKNode node];
    camera.name = @"camera";
    
    [myWorld addChild:camera];

    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    for (UITouch *touch in touches) {
        locations = [touch locationInNode:self];
        
        
        timeTouch=touch.timestamp;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
        
        //Logica da movimentacao
        
        
        
        //logica da divisao
        
        
        
        //Logica do invisivel
        
    }
}


@end
