//
//  ViewController.m
//  Pong Game
//
//  Created by Vladimir Mazunin on 02/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import "ViewController.h"

const CGFloat maxSpeed = 20.0;

@interface ViewController ()

@property (nonatomic) CGRect screenRect;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGVector direction;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenRect = [[UIScreen mainScreen] bounds];
    [self prepareUI];

    //Set ball initialization speed
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        self.direction = CGVectorMake(0, maxSpeed);
        NSLog(@"Current direction: dx= %f dy= %f", self.direction.dx, self.direction.dy);
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
    
}

#pragma mark - Main Timer Function

- (void) trigger
{
    [self recountEntities];
    //Checking collisions with walls
    if (([self isCollisionDetectedWithEastWall]) | ([self isCollisionDetectedWithWestWall])) {
        self.direction = CGVectorMake(self.direction.dx * -1, self.direction.dy);
    };
    
    //Checking collisions with players
    BOOL scored = NO;
    //Ball is going up
    if (self.ball.velocity.dy < 0) {
        if ([self isCollisionDetectedWithAIPlayer]) {
            if ((self.playerAI.velocity.dx != 0) && (self.playerAI.velocity.dx != 0)) {
                self.direction = self.playerAI.velocity;
            } else {
                self.direction = CGVectorMake(self.direction.dx, self.direction.dy * -1);
            }
        } else {
            if ([self isAIPlayerDefeated]) {
                self.playerHumanScore++;
                scored = YES;
                [self.timer invalidate];
            }
        }
    } else {
        //Ball is going down
        if ([self isCollisionDetectedWithPlayer]) {
            if ((self.playerHuman.velocity.dx != 0) && (self.playerHuman.velocity.dx != 0)) {
                self.direction = self.playerHuman.velocity;
            } else {
                self.direction = CGVectorMake(self.direction.dx, self.direction.dy * -1);
            }
        } else {
            if ([self isPlayerHumanDefeated]) {
                //Same situation as showed in AIPlayer block
                self.playerAIScore++;
                scored = YES;
                [self.timer invalidate];
            }
        }
    }
    
//    [self.ball moveInDirection:self.direction];
    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void){
        self.ball.center = CGPointMake(self.ball.center.x + self.direction.dx, self.ball.center.y + self.direction.dy);
        self.ball.velocity = self.direction;
    } completion:^(BOOL finished) {
        if (scored) {
            [self.ball stop];
            self.direction = CGVectorMake(0, 0);
            CGPoint spawnPoint = self.view.center;
            self.ball.center = spawnPoint;
            spawnPoint.y = self.screenRect.size.height * (0.750 + 0.125/2.0);
            self.playerHuman.center = spawnPoint;
            spawnPoint.y = self.screenRect.size.height * (0.125 + 0.125/2.0);
            self.playerAI.center = spawnPoint;
            
            self.playerAILabel.text = [NSString stringWithFormat:@"%li", (long)self.playerAIScore];
            self.playerHumanLabel.text = [NSString stringWithFormat:@"%li", (long)self.playerHumanScore];
            
            [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
                self.direction = CGVectorMake(0, maxSpeed);
            }];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
        }
    }];
}

#pragma mark - Interactions
- (void) recountEntities
{
    self.ball.northPoint = CGPointMake(self.ball.center.x, self.ball.center.y - self.ball.layer.cornerRadius);
    self.ball.southPoint = CGPointMake(self.ball.center.x, self.ball.center.y + self.ball.layer.cornerRadius);
    self.ball.westPoint = CGPointMake(self.ball.center.x - self.ball.layer.cornerRadius, self.ball.center.y);
    self.ball.eastPoint = CGPointMake(self.ball.center.x + self.ball.layer.cornerRadius, self.ball.center.y);

    self.playerHuman.velocity = CGVectorMake(self.playerHuman.center.x - self.playerHuman.previousPosition.x, self.playerHuman.center.y - self.playerHuman.previousPosition.y);
    self.playerHuman.previousPosition = self.playerHuman.center;
}

#pragma mark - Create UI
- (void) prepareUI
{
    self.playerHuman = [[Player alloc] initPlayerWithWidth:self.screenRect.size.width/3.0 andHeight:self.screenRect.size.height/30.0];
    self.playerAI = [[AIPlayer alloc] initAIPlayerWithWidth:self.screenRect.size.width/3.0 andHeight:self.screenRect.size.height/30.0];
    self.ball = [[Ball alloc] initWithRadius:self.screenRect.size.height/30.0];
    
    self.playerHumanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenRect.size.width * 0.1, self.screenRect.size.height * 0.9, 150.0, 15.0)];
    self.playerHumanLabel.textColor = [UIColor blackColor];
    self.playerHumanLabel.text = @"0";
    
    self.playerAILabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenRect.size.width * 0.9, self.screenRect.size.height * 0.1, 150.0, 15.0)];
    self.playerAILabel.textColor = [UIColor blackColor];
    self.playerAILabel.text = @"0";
    
    CGPoint spawnPoint = self.view.center;
    self.ball.center = spawnPoint;
    spawnPoint.y = self.screenRect.size.height * (0.750 + 0.125/2.0);
    self.playerHuman.center = spawnPoint;
    spawnPoint.y = self.screenRect.size.height * (0.125 + 0.125/2.0);
    self.playerAI.center = spawnPoint;
    
    [self.view addSubview:self.ball];
    [self.view addSubview:self.playerHuman];
    [self.view addSubview:self.playerAI];
    [self.view addSubview:self.playerAILabel];
    [self.view addSubview:self.playerHumanLabel];
}

#pragma mark - Collision Detection
- (BOOL) isCollisionDetectedWithPlayer
{
    self.playerHuman.northPoint = CGPointMake(self.playerHuman.center.x, self.playerHuman.center.y - self.playerHuman.frame.size.height/2.0);
    self.playerHuman.southPoint = CGPointMake(self.playerHuman.center.x, self.playerHuman.center.y + self.playerHuman.frame.size.height/2.0);
    self.playerHuman.westPoint = CGPointMake(self.playerHuman.center.x - self.playerHuman.frame.size.width/2.0, self.playerHuman.center.y);
    self.playerHuman.eastPoint = CGPointMake(self.playerHuman.center.x + self.playerHuman.frame.size.width/2.0, self.playerHuman.center.y);
    
    if ((self.ball.southPoint.y >= self.playerHuman.northPoint.y) && (self.ball.southPoint.y <= self.playerHuman.southPoint.y)) {
        if ((self.ball.southPoint.x >= self.playerHuman.westPoint.x) && (self.ball.southPoint.x <= self.playerHuman.eastPoint.x)) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (BOOL) isCollisionDetectedWithAIPlayer
{
    self.playerAI.northPoint = CGPointMake(self.playerAI.center.x, self.playerAI.center.y - self.playerAI.frame.size.height/2.0);
    self.playerAI.southPoint = CGPointMake(self.playerAI.center.x, self.playerAI.center.y + self.playerAI.frame.size.height/2.0);
    self.playerAI.westPoint = CGPointMake(self.playerAI.center.x - self.playerAI.frame.size.width/2.0, self.playerAI.center.y);
    self.playerAI.eastPoint = CGPointMake(self.playerAI.center.x + self.playerAI.frame.size.width/2.0, self.playerAI.center.y);
    
    if ((self.ball.northPoint.y < self.playerAI.southPoint.y) && (self.ball.northPoint.y > self.playerAI.northPoint.y)) {
        if ((self.ball.northPoint.x > self.playerAI.westPoint.x) && (self.ball.northPoint.x < self.playerAI.eastPoint.x)) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (BOOL) isCollisionDetectedWithEastWall
{
    if (self.ball.westPoint.x <= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isCollisionDetectedWithWestWall
{
    if (self.ball.eastPoint.x >= self.screenRect.size.width) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isAIPlayerDefeated
{
    if (self.ball.northPoint.y <= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isPlayerHumanDefeated
{
    if (self.ball.southPoint.y >= self.screenRect.size.height) {
        return YES;
    } else {
        return NO;
    }
}

@end
