//
//  ViewController.h
//  Pong Game
//
//  Created by Vladimir Mazunin on 02/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "AIPlayer.h"
#import "Ball.h"

@interface ViewController : UIViewController

@property (strong, nonatomic, nonnull) Player *playerHuman;
@property (strong, nonatomic, nonnull) AIPlayer *playerAI;
@property (strong, nonatomic, nonnull) Ball *ball;

@property (nonatomic) NSInteger playerHumanScore;
@property (nonatomic, nonnull) UILabel *playerHumanLabel;
@property (nonatomic) NSInteger playerAIScore;
@property (nonatomic, nonnull) UILabel *playerAILabel;


@end

