//
//  JAGCharacter.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"

@implementation JAGCharacter
-(id)init{
    self = [super init];
    return self;
}
-(void)configPhysics{
 //   self = [super configPhysics];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution=0;
 //   return self;

}
-(void)Animar{

}
@end
