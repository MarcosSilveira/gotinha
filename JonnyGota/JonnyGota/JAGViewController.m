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
#import "JAGMenu.h"


@implementation JAGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    SKScene *scene = [[JAGPlayGameScene alloc] initWithSize:skView.bounds.size level:@1 andWorld:@1];
    //SKScene * scene = [JAGP sceneWithSize:skView.bounds.size];
   // SKScene *scene = [[JAGMenu alloc] init];
    //JAGPlayGameScene *scene=[[JAGPlayGameScene alloc] init];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
   
    [skView presentScene:scene];
    
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
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
