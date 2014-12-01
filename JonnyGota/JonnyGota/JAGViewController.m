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
#import "JAGVida.h"

@implementation JAGViewController

- (void)viewWillLayoutSubviews
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // Configure the view.
    SKView *skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.

    SKScene *sceneMenu = [[JAGMenu alloc] initWithSize:skView.bounds.size];
    sceneMenu.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene \\
    
    JAGVida *vida=[JAGVida sharedManager];
    
    [vida fazerConsultas:0];
    
    [skView presentScene:sceneMenu];
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
