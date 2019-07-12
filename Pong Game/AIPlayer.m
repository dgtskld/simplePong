//
//  AIPlayer.m
//  Pong Game
//
//  Created by Vladimir Mazunin on 09/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import "AIPlayer.h"

@implementation AIPlayer

- (instancetype) initAIPlayerWithWidth: (CGFloat) width andHeight: (CGFloat) height
{
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    self.backgroundColor = [UIColor yellowColor];
    self.northPoint = CGPointMake(self.center.x, self.center.y + height);
    self.southPoint = CGPointMake(self.center.x, self.center.y - height);
    self.westPoint = CGPointMake(self.center.x - width, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + width, self.center.y);
    self.velocity = CGVectorMake(0.0, 0.0);
    return self;
}

- (void) recount
{
    self.northPoint = CGPointMake(self.center.x, self.center.y + self.frame.size.height/2.0);
    self.southPoint = CGPointMake(self.center.x, self.center.y - self.frame.size.height/2.0);
    self.westPoint = CGPointMake(self.center.x - self.frame.size.width/2.0, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + self.frame.size.width/2.0, self.center.y);
}

@end
