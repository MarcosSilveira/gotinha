//
//  JAGTutorial.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/11/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSMultilineLabelNode.h"

@interface JAGTutorial : SKNode

@property (nonatomic) NSMutableArray *compenentes;

@property (nonatomic) int indice;

@property (nonatomic) SKSpriteNode *nextButton;

@property (nonatomic) SKSpriteNode *prevButton;

@property (nonatomic) DSMultilineLabelNode *labelContent;

@property (nonatomic) SKSpriteNode *imageContent;

@property (nonatomic) CGSize frames;

-(bool)next;

-(void)prev;

-(bool)validadeTouch:(UITouch*) toque;

-(instancetype)initWithComponents:(NSMutableArray *)comps
                    withSizeFrame:(CGSize) frame;

@end
