

#import "fragment.h"
#import "GameScene.h"

@implementation Fragment


- (void)dealloc {
	[image release];
    [super dealloc];
}

- (id)initWithLocation:(Vector2f)aLocation   fragPiece:(int)pce
{
    self = [super init];
	if (self != nil) {
		
		type = FRAGMENT;
		alive = YES;
		_size.width = 16;
		_size.height = 16;
        position = aLocation;
		diesOfOldAge = YES;
		_dAngle = RANDOM_MINUS_1_TO_1()*10;
		death = 30;
		image = [[_resourceManager _spriteSheet8] getSpriteAtX:pce y:0];
		
		_angle = RANDOM_0_TO_1()*360;
		_speed =RANDOM_0_TO_1()*5+3;	
		_accel= Vector2fMake(-0.5f	, 0.0f);
		
		_vel.x = _speed * cos(DEGREES_TO_RADIANS(_angle));
		_vel.y = _speed * sin(DEGREES_TO_RADIANS(_angle));
    }
    return self;
}

- (void)update:(GLfloat)aDelta 
{
	position = Vector2fAdd(position, _vel);
	_vel = Vector2fAdd(_vel,_accel);     // = Vector2fMultiply(_accel, 1.1f);
	
	_angle+=_dAngle;
	[image setColourFilterRed:1 green:1 blue:1 alpha: 1 - age/30.0f];
	[image setRotation:_angle];
	
	if(position.x>MAXW || position.x<0||position.y<0||position.y>MAXH)
		alive=NO;
	
	[super update:aDelta];
}

- (void)render {
	[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:TRUE];
}

@end

