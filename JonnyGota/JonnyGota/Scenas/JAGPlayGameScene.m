//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"
const uint32_t GOTA = 0x1 << 0;
const uint32_t ENEMY = 0x1 << 1;
const uint32_t ATTACK = 0x1 << 2;

@implementation JAGPlayGameScene{
    int width;
    int height;
    float timeTouch;
    float diferenca;
    CGPoint locations;
}

#pragma mark - Move to View
-(void)didMoveToView:(SKView *)view{
    diferenca = 80;
    width = self.scene.size.width;
    height = self.scene.size.height;
    
    [myWorld addChild:[self createCharacter]];
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

-(JAGGota *)createCharacter{
    gota = [[JAGGota alloc] init];
    gota.position = CGPointMake(0, -height/2.15+(platform.size.height));
    gota.name = @"spartan";
    gota.zPosition = 1;
    gota.physicsBody.categoryBitMask = GOTA;
    gota.physicsBody.collisionBitMask = ATTACK | ENEMY;
    gota.physicsBody.contactTestBitMask = ATTACK | ENEMY;
    
    return gota;
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
        //PathFinder
        //
        
        
        //logica da divisao
        //Condicaos de diferenca dos pontos
        if(locations.x-location.x<diferenca*-1){
                //Lado direito ?
            [_gota mover:location withInterval:1.0];
            
            break;
        }else{
            if(locations.x-location.x<diferenca){
                //lado esquerdo ?
                
                [_gota mover:location withInterval:1.0];
                break;
            }
        }
        if(locations.y-location.y<diferenca*-1){
            //pra Cima ?
            
            [_gota mover:location withInterval:1.0];
            break;
        }else{
            if(locations.y-location.y<diferenca){
                //pra baixo ?
                
                
                [_gota mover:location withInterval:1.0];
                break;
            }
        }
        
        
        //Logica do invisivel
        //Tempo de pressao
        
        
    }
}

-(void)update:(NSTimeInterval)currentTime{
    
    //depois de um tempo? ou acao
    [_hud update];
}


@end
