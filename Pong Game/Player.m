//
//  Player.m
//  Pong Game
//
//  Created by Vladimir Mazunin on 05/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//
#import "Player.h"
@interface Player()

@property (nonatomic) CGRect screenRect;

@end

@implementation Player

#pragma mark - Init Player
- (instancetype) initPlayerWithWidth: (CGFloat) width andHeight: (CGFloat) height
{
    self.screenRect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    self.backgroundColor = [UIColor greenColor];
    self.northPoint = CGPointMake(self.center.x, self.center.y + height);
    self.southPoint = CGPointMake(self.center.x, self.center.y - height);
    self.westPoint = CGPointMake(self.center.x - width, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + width, self.center.y);
    self.velocity = CGVectorMake(0.0, 0.0);
    return self;
}

#pragma mark - UIResponder
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    if ([self isInAllowedArea:touchPoint]) {
        self.center = touchPoint;
        [self recount];
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self.superview];
    if ([self isInAllowedArea:touchPoint]) {
        self.center = touchPoint;
//        [self recount];
    } else {
        touchPoint.y = self.center.y;
        self.center = touchPoint;
//        [self recount];
    }
}

#pragma mark - Area Count
- (void) recount
{
    self.northPoint = CGPointMake(self.center.x, self.center.y + self.frame.size.height/2.0);
    self.southPoint = CGPointMake(self.center.x, self.center.y - self.frame.size.height/2.0);
    self.westPoint = CGPointMake(self.center.x - self.frame.size.width/2.0, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + self.frame.size.width/2.0, self.center.y);
}

/*Allowed to touch area is rectangular area between 7/8 and 6/8 of screen hight
 *Touches should begin in this area*/
- (BOOL) isInAllowedArea: (CGPoint) touchPoint
{
    if ((self.screenRect.size.height * 0.750 < touchPoint.y) & (touchPoint.y < self.screenRect.size.height * 0.875)) {
        return YES;
    } else {
        return NO;
    }
}

@end
