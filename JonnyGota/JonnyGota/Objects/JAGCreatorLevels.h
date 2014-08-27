//
//  JAGCreatorLevels.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 18/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAGLevel.h"


@interface JAGCreatorLevels : NSObject

+ (void)initializeLevel:(NSNumber *)level ofWorld:(NSNumber *)world onScene:(SKScene *)scene;

+ (NSNumber *)numberOfLevels:(int)mundo;
+ (NSString *)nameOfLevel:(NSNumber *)level;
+ (NSString *)nameOfWorld:(NSNumber *)world;
+ (NSNumber *)numberOfWorlds;
+ (NSString *)descriptionOfLevel:(NSNumber *)level;
+ (void)playLevel:(NSNumber *)level ofWorld:(NSNumber *)world withTransition:(SKTransition *)transition onScene:(SKScene *)lastScene;





@end
