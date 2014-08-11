//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"
//const uint32_t GOTA = 0x1 << 0;
//const uint32_t ENEMY = 0x1 << 1;
//const uint32_t ATTACK = 0x1 << 2;

@implementation JAGPlayGameScene{
    int width;
    int height;
    float timeTouch;
    float diferenca;
    CGPoint locations;
    SKCropNode *cropNode;
}

#pragma mark - Move to View
-(void)didMoveToView:(SKView *)view{
    diferenca = 80;
    width = self.scene.size.width;
    height = self.scene.size.height;
    
  //  [myWorld addChild:[self createCharacter]];
    self.physicsWorld.contactDelegate = (id)self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    [self touchesEnded:nil withEvent:nil];
    
    myWorld = [SKNode node];
    
    [self addChild:myWorld];
    
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-width/2, -height/2) toPoint:CGPointMake(width/2, -height/2)];
    
    camera = [SKNode node];
    camera.name = @"camera";
    
    [myWorld addChild:camera];

}

bool tocou;


-(id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
       // self.physicsWorld.contactDelegate = self;
         //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _gota =  [[JAGGota alloc] initWithPosition:CGPointMake(100, 100)];
        SKSpriteNode *obstaculo = [[SKSpriteNode alloc]initWithColor:([UIColor redColor]) size:(CGSizeMake(self.scene.size.width, 10)) ];
        obstaculo.position = CGPointMake(self.scene.size.width/2, 120);
        obstaculo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstaculo.size];
        obstaculo.physicsBody.dynamic = NO;
        obstaculo.physicsBody.categoryBitMask = ENEMY;
        obstaculo.physicsBody.collisionBitMask = GOTA;
        obstaculo.physicsBody.contactTestBitMask = GOTA;
        
        obstaculo.zPosition=10;
        
        obstaculo.physicsBody.restitution=0;
        obstaculo.name=@"wall";
      //  [self addChild:obstaculo];
        
        _gota.zPosition=100;
        //[self addChild:obstaculo];
        
        //[self addChild:_gota];
        
        diferenca = 80.0f;
        tocou = false;
        //_boing = [SKAction playSoundFileNamed:@"boing.mp3" waitForCompletion:NO];
        
       // _mask = [[SKSpriteNode init] initWithColor:[SKColor purpleColor]];
        
        
        //SKSpriteNode *pictureToMask = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        /*
        SKSpriteNode *pictureToMask = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(100, 100)];

        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size: CGSizeMake(100, 100)]; //100 by 100 is the size of the mask
        SKCropNode *cropNode = [SKCropNode node];
        cropNode.position = CGPointMake( 100,100);
        
        SKShapeNode* pathShape = [[SKShapeNode alloc] init];
        pathShape.lineWidth = 1;
        pathShape.fillColor = [SKColor clearColor];
        pathShape.strokeColor = [SKColor greenColor];
        pathShape.position=CGPointMake( 100,100);
        
        //[cropNode addChild:pathShape];
        //[cropNode addChild: pictureToMask];
        [cropNode setMaskNode: mask];
        
        */
        
        cropNode = [[SKCropNode alloc] init];
        
        
        
        //cropNode.zPosition=95;
        
       // cropNode.position=CGPointMake(100,100);
      
        
        [self creteMask];
        
        
        SKSpriteNode *cimas=[[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(1000,1000)];
        
        //cimas.zPosition=90;
        
        
        //[cropNode addChild:cimas];
        
        [cropNode addChild:_gota];
        
        [cropNode addChild:obstaculo];
        
       
        
        
        //[cropNode addChild:circleMask];
        //[cropNode setMaskNode:circleMask];
      
        
        //[self addChild:cimas];

        
        [self addChild: cropNode];
        
       // [self addChild:pathShape];

    }
    return self;
    
}

-(void)creteMask{
    SKNode *area=[[SKNode alloc] init];
    
    int radius=70;
    
    SKShapeNode *circleMask = [[SKShapeNode alloc ]init];
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, 0, 0, radius, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    circleMask.path = circle;
    //circleMask.lineWidth = 1; // replace 100 with DOUBLE the desired radius of the circle
    //circleMask.strokeColor = [SKColor redColor];
    circleMask.name=@"circleMask";
    
    
    SKShapeNode *circleBorder = [[SKShapeNode alloc ]init];
    CGMutablePathRef circleBor = CGPathCreateMutable();
    CGPathAddArc(circleBor, NULL, 0, 0, radius, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    circleBorder.path = circleBor;
    circleBorder.lineWidth = 1; // replace 100 with DOUBLE the desired radius of the circle
    circleBorder.strokeColor = [SKColor redColor];
    circleBorder.name=@"circleMask";

    
    
    circleMask.userInteractionEnabled = NO;
    //circleMask.zPosition=92;
    
    circleMask.fillColor = [SKColor clearColor];
    
    [area addChild:circleMask];
    
    area.position=CGPointMake(100,100);
    
    [cropNode setMaskNode:area];
    
    [cropNode addChild:area];
    
    //[cropNode addChild:circleBorder];
}


-(JAGGota *)createCharacter{
    _gota = [[JAGGota alloc] init];
    _gota.position = CGPointMake(0, -height/2.15+(platform.size.height));
    _gota.name = @"gota";

    
    return _gota;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    for (UITouch *touch in touches) {
        locations = [touch locationInNode:self];
        
        
        timeTouch = touch.timestamp;
        
        if ([_gota tocou:locations]) {
            tocou = true;
        }else{
            tocou = false;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
        //Se tocou na gota antes
        //Se tocou na gota antes
        if (tocou) {
            
            
            
            
            
            
        }else{
            
            //SE tocou fora movimenta
            //float difx=locations.x-location.x;
            
            float difx=_gota.position.x-location.x;
            
            //float dify=locations.y-location.y;
            
            float dify=_gota.position.y-location.y;
            
            
            BOOL negx=false;;
            
            bool negy=false;
            
            if(difx<0){
                negx=true;
                difx*=-1;
            }
            if(dify<0){
                negy=true;
                dify*=-1;
            }
            
            
            
            if (difx>dify) {
                if(negx){
                    [_gota mover:location withInterval:1.0 withTipe:4];
                    
                }else{
                    [_gota mover:location withInterval:1.0 withTipe:3];
                }
                
                
                
                
            }else{
                if(negy){
                    [_gota mover:location withInterval:1.0 withTipe:1];
                }else{
                    [_gota mover:location withInterval:1.0 withTipe:2];
                }
            }
        }
        
        
        //Logica da movimentacao
        //PathFinder
        //
        
        
        //logica da divisao
        //Condicaos de diferenca dos pontos
        
        
        
        //Logica do invisivel
        //Tempo de pressao
        
        
    }
}

-(void)update:(NSTimeInterval)currentTime{
    //depois de um tempo ou acao
    float distance = hypotf(_fogo.position.x-_gota.position.x, _fogo.position.y-_fogo.position.y);
    NSLog(@"%f",distance);
    if (distance <50) {
        
    [_fogo mover:(_gota.position) withInterval:2 withTipe:0];
    }
    [_hud update];
}
- (void)didSimulatePhysics{
 //   [self centerOnNode: [self childNodeWithName: @"//"]];
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        NSLog(@"hit");
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        NSLog(@"hit");}
    //Colisao com a parede
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"wall"]) ||
       ([contact.bodyA.node.name isEqualToString:@"wall"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ){
        
        //_gota.physicsBody.velocity=CGVectorMake(0, 0);
    
        _gota.physicsBody.velocity=CGVectorMake(0, 0);
        
    }
    
 //   return detected;

}


@end
