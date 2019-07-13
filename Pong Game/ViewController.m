//
//  ViewController.m
//  Pong Game
//
//  Created by Vladimir Mazunin on 02/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import "ViewController.h"

const CGFloat maxSpeed = -10.0;

@interface ViewController ()

@property (nonatomic) CGRect screenRect;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *timerCollision;
@property (nonatomic) NSTimer *timerAIPlayer;

@property (nonatomic) CGVector direction;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenRect = [[UIScreen mainScreen] bounds];
    [self prepareUI];

    //Set ball initialization speed
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        self.direction = CGVectorMake(1, maxSpeed);
    }];
    
    self.timerCollision = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(recountEntities) userInfo:nil repeats:YES];
//    self.timerAIPlayer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(AIPlayerResponse) userInfo:nil repeats:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
}

#pragma mark - Main Timer Function
- (void) trigger
{
//    [self recountEntities];
    //Checking collisions with walls
    if (([self isCollisionDetectedWithEastWall]) | ([self isCollisionDetectedWithWestWall])) {
        self.direction = CGVectorMake(self.direction.dx * -1, self.direction.dy);
    };
    //Checking collisions with players
    BOOL scored = NO;
    //Ball is going up
    if (self.ball.velocity.dy < 0) {
        CGPoint interceptPoint = [self.playerAI interceptTheObject:self.ball.center withSpeed:self.ball.velocity];
        self.playerAI.prospectiveDirection = CGVectorMake(interceptPoint.x - self.playerAI.center.x, interceptPoint.y - self.playerAI.center.y);
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
                [self.timerAIPlayer invalidate];
            }
        }
    } else {
        //Ball is going down
        self.playerAI.prospectiveDirection = CGVectorMake(self.playerAI.startPosition.x - self.playerAI.center.x, self.playerAI.startPosition.y - self.playerAI.center.y);
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
                [self.timerAIPlayer invalidate];
            }
        }
    }
    [self.playerAI normalizeProspectiveDirection];
    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void){
        self.ball.center = CGPointMake(self.ball.center.x + self.direction.dx, self.ball.center.y + self.direction.dy);
        self.ball.velocity = self.direction;
        self.playerAI.center = CGPointMake(self.playerAI.center.x + self.playerAI.prospectiveDirection.dx, self.playerAI.center.y + self.playerAI.prospectiveDirection.dy);
        self.playerAI.center = CGPointMake(self.playerAI.center.x + 5, self.playerAI.center.y + 5);
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
            
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                self.direction = CGVectorMake(0, maxSpeed);
            }];
//            self.timerAIPlayer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(AIPlayerResponse) userInfo:nil repeats:YES];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
        }
    }];
}

#pragma mark - Interactions
- (void) AIPlayerResponse
{
    if (self.ball.velocity.dy < 0) {
        CGPoint interceptPoint = [self.playerAI interceptTheObject:self.ball.center withSpeed:self.ball.velocity];
        self.playerAI.prospectiveDirection = CGVectorMake(interceptPoint.x - self.playerAI.center.x, interceptPoint.y - self.playerAI.center.y);
    } else {
       self.playerAI.prospectiveDirection = CGVectorMake(self.playerAI.startPosition.x - self.playerAI.center.x, self.playerAI.startPosition.y - self.playerAI.center.y);
    }
    [self.playerAI normalizeProspectiveDirection];
    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.playerAI.center = CGPointMake(self.playerAI.center.x + self.playerAI.prospectiveDirection.dx, self.playerAI.center.y + self.playerAI.prospectiveDirection.dy);
    } completion:^(BOOL finished){}];
}

#pragma mark - Recounter
- (void) recountEntities
{
    self.playerHuman.northPoint = CGPointMake(self.playerHuman.center.x, self.playerHuman.center.y - self.playerHuman.frame.size.height/2.0);
    self.playerHuman.southPoint = CGPointMake(self.playerHuman.center.x, self.playerHuman.center.y + self.playerHuman.frame.size.height/2.0);
    self.playerHuman.westPoint = CGPointMake(self.playerHuman.center.x - self.playerHuman.frame.size.width/2.0, self.playerHuman.center.y);
    self.playerHuman.eastPoint = CGPointMake(self.playerHuman.center.x + self.playerHuman.frame.size.width/2.0, self.playerHuman.center.y);
    
    self.playerAI.northPoint = CGPointMake(self.playerAI.center.x, self.playerAI.center.y - self.playerAI.frame.size.height/2.0);
    self.playerAI.southPoint = CGPointMake(self.playerAI.center.x, self.playerAI.center.y + self.playerAI.frame.size.height/2.0);
    self.playerAI.westPoint = CGPointMake(self.playerAI.center.x - self.playerAI.frame.size.width/2.0, self.playerAI.center.y);
    self.playerAI.eastPoint = CGPointMake(self.playerAI.center.x + self.playerAI.frame.size.width/2.0, self.playerAI.center.y);
    
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
    self.playerAI.startPosition = spawnPoint;
    
    [self.view addSubview:self.ball];
    [self.view addSubview:self.playerHuman];
    [self.view addSubview:self.playerAI];
    [self.view addSubview:self.playerAILabel];
    [self.view addSubview:self.playerHumanLabel];
}

#pragma mark - Collision Detection
- (BOOL) isCollisionDetectedWithPlayer
{
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
