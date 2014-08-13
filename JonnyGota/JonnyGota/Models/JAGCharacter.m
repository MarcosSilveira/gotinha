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

-(NSMutableDictionary *)createJson{
    NSMutableDictionary *json=[[NSMutableDictionary alloc]init];
    
    NSNumber *temp=[[NSNumber alloc] initWithFloat:self.position.x];
    
    
    
    [json setObject:temp forKey:@"positionX"];
    
    temp=[[NSNumber alloc] initWithFloat:self.position.y];
    
    
    [json setObject:temp forKey:@"positionY"];
    
    [json setObject:_sprite.name forKey:@"sprite"];
    
    
    return json;
}

@end
