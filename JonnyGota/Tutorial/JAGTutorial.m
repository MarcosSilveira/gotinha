//
//  JAGTutorial.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/11/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGTutorial.h"
#import "JAGCompTutorial.h"

@implementation JAGTutorial

-(instancetype)initWithComponents:(NSMutableArray *)comps withSizeFrame:(CGSize)frame{
    self=[super init];
    
    self.compenentes=comps;
    
    //Preparar todos o resto
    

    self.prevButton=[[SKSpriteNode alloc] initWithImageNamed:@"back_bt"];
    
    //Positions
    
    self.prevButton.position=CGPointMake(frame.width*0.2, frame.height*0.2);
    
    self.prevButton.size=CGSizeMake(frame.width*0.1, frame.height*0.1);
    
    self.nextButton=[[SKSpriteNode alloc] initWithImageNamed:@"back_bt"];
    
    self.nextButton.zRotation = M_PI*(1);
    
    self.nextButton.position=CGPointMake(frame.width*0.8, frame.height*0.2);;
    
    self.nextButton.size=CGSizeMake(frame.width*0.1, frame.height*0.1);
    
    self.indice=0;
    
    JAGCompTutorial *comp=(JAGCompTutorial *) self.compenentes[self.indice];
    
    
    self.labelContent =[DSMultilineLabelNode labelNodeWithFontNamed:@"VAGRoundedStd-Thin"];
    
    self.labelContent.fontSize = 14;
    self.labelContent.text = comp.mensagem;
    
    self.labelContent.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    self.labelContent.position=CGPointMake(frame.width*0.5, frame.height*0.7);
    
    self.labelContent.paragraphWidth = frame.width*.6;
    
     self.frames=frame;
    
    SKSpriteNode *background=[[SKSpriteNode alloc] initWithImageNamed:@"backTuto"];
    background.size=CGSizeMake(frame.width*0.8, frame.height*0.75);
//    [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(frame.width*0.8, frame.height*0.75)];
    
    background.position=CGPointMake(frame.width*0.5, frame.height*0.5);
    
    
    
    [self addChild:background];

    [self colocarImage:comp.image];
    
    
    self.zPosition=500;
   
    [self addChild:self.labelContent];
    
    [self addChild:self.nextButton];
    
    [self addChild:self.prevButton];
    
    
    
    return self;
}

-(bool)validadeTouch:(UITouch *)toque{
    CGPoint ponto=[toque locationInNode:self];
    bool ok=false;
    if ([self verificaToque:ponto withSprite:self.prevButton]) {
        [self prev];
    }else if([self verificaToque:ponto withSprite:self.nextButton]){
        ok=[self next];
    }
    
    return ok;
}

-(BOOL)verificaToque:(CGPoint) ponto
          withSprite:(SKSpriteNode *)sprite{
    if((ponto.x >= (sprite.position.x - sprite.size.width/2)) && (ponto.x < (sprite.position.x+sprite.size.width/2))){
        if((ponto.y >= (sprite.position.y - sprite.size.height/2)) && (ponto.y < (sprite.position.y+sprite.size.height/2))){
            return true;
        }
    }
    return false;
}

-(bool)next{
    if (self.indice+1<self.compenentes.count) {
        self.indice++;
        JAGCompTutorial *comp=(JAGCompTutorial *) self.compenentes[self.indice];
        self.labelContent.text = comp.mensagem;
//        NSMutableArray *array=[[NSMutableArray alloc] init];
//        [array addObject:comp.image.texture];
//        [self.imageContent runAction:[SKAction animateWithTextures:array timePerFrame:0.1f]];
        
        [self.imageContent removeFromParent];
        
        [self colocarImage:comp.image];
        
        //Trocar a Texture
        
//        [self.imageContent.texture=]
    }else{
        //Remover tudo
        self.paused=NO;
        [self removeFromParent];
        return true;
    }
    
    return false;
}

-(void)colocarImage:(SKSpriteNode *) image{
    self.imageContent=image;
    
    self.imageContent.position=CGPointMake(self.frames.width*0.5, self.frames.height*0.4);
    
    self.imageContent.size=CGSizeMake(self.frames.width*0.4, self.frames.height*0.3);
    
    [self addChild:self.imageContent];
   

}

-(void)prev{
    if (self.indice!=0) {
        //Faz
        self.indice--;
        JAGCompTutorial *comp=(JAGCompTutorial *) self.compenentes[self.indice];
        self.labelContent.text = comp.mensagem;
        
        [self.imageContent removeFromParent];
        
        [self colocarImage:comp.image];
        
    }
}

@end
