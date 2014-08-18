//
//  JAGViewController.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGViewController.h"
#import "JAGPlayGameScene.h"
#import "JAGLevel.h"
#import "JAGCreatorLevels.h"


@implementation JAGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    SKScene *scene =[[JAGPlayGameScene alloc] initWithSize:skView.bounds.size level:@1 andWorld:@1];
    //SKScene * scene = [JAGP sceneWithSize:skView.bounds.size];
    
    
    
    //JAGPlayGameScene *scene=[[JAGPlayGameScene alloc] init];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    
   
    [skView presentScene:scene];
    
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1];
    [JAGCreatorLevels playLevel:@1 ofWorld:@(1) withTransition:transition onScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
