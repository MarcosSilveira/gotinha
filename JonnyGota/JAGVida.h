//
//  JAGVida.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/11/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JAGVida : NSObject {
    JAGVida *vida;
}

@property NSInteger vidas;

@property NSDate *timerlast;

@property bool inprogress;

@property (nonatomic, retain) JAGVida *vida;

-(void)consultar;

-(void)fazerConsultas:(int)time;

+ (id)sharedManager;

@end
