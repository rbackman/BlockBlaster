//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "Boss1.h"
#import "GameScene.h"
#import "Laser.h"
#import "BezierCurve.h"
#import "Ribbon.h"

@implementation Tenticle

@synthesize endPos;
@synthesize endTent;
@synthesize gunAlive;
@synthesize child;



- (id)initWithLocation:(Vector2f)ofst angle:(float)ang parent:(AbstractEntity*)p tenticleImage:(Image*)im num:(int)tn;
{
	self = [super init];
	if (self != nil) {
		child = nil;
		tentNum = tn;
		gunAlive = YES;
		_parent = p;
		parent_offset = ofst;
		_angle = ang;
		 restAngle = ang;
		endPos = Vector2fAdd( [self globalPosition] , Vector2fRotate(Vector2fMake(40, 0), -_angle) );
		position = [self globalPosition] ;
		
		type = BOSS_TENTICLE;
		_size.width = 32;
		_size.height = 32;
		energy = 10;

		width_offset = 0;
		height_offset = 0;
		

		image = im;
	
        fireDelay = RANDOM_0_TO_1()*30;
		explodeCount = 24;
		explode = YES;
				
    }
    return self;
}
-(void)blowUp
{
	if(endTent && !gunAlive) 
	{
		[_stats addScore:10];
		[_scene addExplosion:MISSLE_BASIC_EXPLOSION entity:self];
		
		active = NO;
		if([_parent type]==BOSS_TENTICLE)
		{
			[(Tenticle*)_parent setEndTent:YES];
			[(Tenticle*)_parent setChild:nil];
		}
	}
	else if(child)
	{
		[child blowUp];	
	}
}

-(void)setArmAngle:(float)ang
{
	_angle = ang + restAngle;	
}
-(void)update:(float)theDelta
{
	[super update:theDelta];
	

	
	if(endTent && !gunAlive) 
	{
		[self blowUp];
	}
	
	if(active)
	{
		position = [self globalPosition];
		endPos = Vector2fAdd( position , Vector2fRotate( Vector2fMake(40, 0) ,  [self globalAngle] ) );
	}
	else
	{
		for(int i=0;i<5;i++)[_scene addCoin:position];
		alive = NO	;
	}

	}
-(void)render
{
	
	if(active)
	{
	glPushMatrix();

	glTranslatef(position.x, position.y, 0);
	//glScalef(0.75, 0.75, 0.75);
	glRotatef([self globalAngle] , 0, 0, 1);
	glTranslatef(20,0, 0);
		glRotatef(180, 0, 0, 1);
	if(!exploded)
	{
		[image renderAtPoint:CGPointZero centerOfImage:YES];	
		
	}
	
	glPopMatrix();
	}
		
		
}
@end




@implementation BossGun



// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Tenticle*)pt gunImage:(Image*)i;
{
	self = [super init];
	if (self != nil) {
		
		image = i;
		
		tent  =  pt;
		position = [tent endPos] ;
		collideBounds = YES;
		gunAngle = 0;
		target_Lock = NO;
		type = BOSS_GUN;
		_size.width = 64;
		_size.height = 64;

		energy = [_stats game_level]*5;

		width_offset = 0;
		height_offset = 0;
		explodeCount = 24;
		explode = YES;
			
    }
    return self;
}
-(void)setTarget:(Vector2f)tg
{
	target_Lock = YES;
	target = tg;	
}

-(void)update:(float)theDelta
{
	[super update:theDelta];
	//_angle +=1;
	
	
	if(!active)
	{
		alive = NO;
		[_stats addScore:10];
		[_scene addExplosion:MISSLE_BASIC_EXPLOSION entity:self];
	}
	
	if(active)
	{
		position = [tent endPos];
		
		if(target_Lock)
		{
			float goalAngle = gunAngle + RADIANS_TO_DEGREES(Vector2fangle(Vector2fSub(target,position)));
			if(ABS(goalAngle) < 5) 
			{
				

				[_scene playSound:TURRET_FIRE pos:position];
					ls = [[Laser alloc]initWithLocation:position color:YELLOW_BALL];
					[_scene addRibbon:ls type:YELLOW_RIB];
					[ls set_speed:12];
					[ls setDir:-gunAngle];
					[_scene addBadguyWeapon:ls];
					[ls release];
					target_Lock = NO;
					

				
			}
			else if(goalAngle<0) gunAngle+=5;
			else gunAngle-=5;
		
	}
	else
	{
		gunAngle+=3;	
	}
	}
	else
	{

	[tent setGunAlive:NO];
	[tent blowUp];
		active = NO	;
	}
	
	
	
	
	
}
-(void)render
{
	if(active)
	{
	[image setRotation: 180+gunAngle];
	[image renderAtPoint:Vector2fToCGPoint( position ) centerOfImage:YES];	
			if(DEBUG_COLLISION)[super drawBounds];
	}
	
	
}
@end




@implementation Boss1
@synthesize guns;

- (void)dealloc {
	
	[image release];
	[tenticleImage release];
	[gunImage release];
	[eyeImage release];
	[CoreImage release];
	[ball release];
	[tenticles release];
	[guns release];
	[super dealloc];
}

- (id)initWithLocation:(Vector2f)aLocation {
    self = [super init];
	if (self != nil) 
	{
		type = BOSS;
		_size.width = 100;
		_size.height = 100;
		collideBounds = YES;
		tenticlesPerCurve = 3;
	
		width_offset = 0;
		height_offset = 0;
		tenticles = [[NSMutableArray alloc] init];
		guns = [[NSMutableArray alloc] init];
		image = [[_resourceManager _spriteSheet64] getSpriteAtXYWH:6 y:0 w:2 h:2];
		gunImage = [[_resourceManager _spriteSheet16] getSpriteAtXYWH:3 y:1 w:2 h:1];
		eyeImage = [[_resourceManager _spriteSheet32] getSpriteAtX:7 y:1];
		tenticleImage = [[_resourceManager _spriteSheet32] getSpriteAtXYWH:0 y:6 w:2 h:1];
		
		firstThrough = YES;
		_angle = 0;
		for(int i=0;i<4;i++)
		{
			gunPos[i] =  Vector2fRotate(Vector2fMake(65, 0),_angle + 45+i*90) ;
		}
		
		explode = YES;
		
		
		[self reset];

        _speed = 0;
	//	followCurve = NO;
    }
    return self;
}
-(void)reset
{
	energy = [_stats game_Boss_Energy];
	tenticlesDead = NO;
	openP = 0;
	_vel.x = -0.5;
	delay = 0;
	maxDelay = 120 - [_stats game_level]*10;
	opening = YES;
	minDAngle = 0.5;
	maxDAngle = 2;
	dangle = maxDAngle;
	extension = 0;
	exploded = NO;
	eyeAngle = 180;
	eyeOffset = Vector2fMake(-10, 0);
	seeking = NO;
	seekDelay = 5;
	alive = YES;
	active = YES;
	explodeCount = 0;
	explode = YES;
	position.x = MAXW+100;
	position.y = MAXH/2 + 30;
	[guns removeAllObjects];
	[tenticles removeAllObjects];

	for(int i=0;i<4;i++)
	{
		AbstractEntity* lastTent = self;
		for(int j=1;j<=tenticlesPerCurve; j++)
		{
			
			Tenticle* tt;
			BossGun* gun;
			if(j==1)
				tt = [ [Tenticle alloc] initWithLocation:gunPos[i]  angle: 45 + i*90 parent:lastTent tenticleImage:tenticleImage num:j];
			else  tt = [ [Tenticle alloc] initWithLocation:Vector2fMake(40, 0)  angle:0 parent:lastTent tenticleImage:tenticleImage num:j];
			
			if(j==tenticlesPerCurve) [tt setEndTent:YES];
			
			gun = [[BossGun alloc] initWithLocation:tt gunImage:gunImage];
			lastTent = tt;
			[guns addObject:gun];
			[tenticles addObject:tt];
			[tt release];
			[gun release];
		}
	}
	for(Tenticle* tt in tenticles)
	{
	
		if( [[tt _parent] type] == BOSS_TENTICLE)
		{
			[(Tenticle*)[tt _parent] setChild:tt];
		}
		[tt setArmAngle:-60];
	}
}

- (void)update:(GLfloat)aDelta {
	
	if(active)
	{
		if(firstThrough)
		{
			[super update:aDelta];
			eyeAngle = -RADIANS_TO_DEGREES(Vector2fangle(Vector2fSub([_scene getPlayerPos], position)));
			firstThrough = NO;	
		}
	
		_angle+=dangle;
		delay -- ;
		if(delay<=0)
		{ opening = !opening; changing = YES; delay = maxDelay;  }

		if(changing)
		{
			
			if(opening)
			{
				openP+=0.01;
				
				if(openP >= 1.0)
				{
					changing = NO;
				}
				else
				{
					dangle = minDAngle + maxDAngle * (1.0 -  sBump(openP));
				}
							
				extension = openP;
			}
			else
			{
				openP-=0.01;
				if(openP <= 0.0)
				{
					changing = NO;
				}
				else
				{
					dangle = minDAngle +  maxDAngle *  (1.0 - sBump(openP));
				}
				
		
				extension = openP;
			}
			
			
			for(int i=0;i<4;i++)
			{
				gunPos[i] =  Vector2fRotate(Vector2fMake(65, 0), _angle + 45+i*90) ;
			}
			
			for(Tenticle* tt in tenticles)
			{
				[tt setArmAngle:-60 + extension*120];
			}
		}
	}
	else
	{
		if(exploded)
		{
			[_stats addScore:100];
			exploded = NO;
			alive = NO;
			[_scene	addExplosion:BOSS_EXPLOSION entity:self];
		}
	}
	

	
	NSMutableArray* discard = [NSMutableArray array];
	for(AbstractEntity* gn in guns)
	{
		if(	![gn alive])[discard addObject:gn];
		else [gn update:aDelta];	
	}
	[guns removeObjectsInArray:discard];
	
	for(AbstractEntity* tt in tenticles)
	{
		if(	![tt alive])[discard addObject:tt];
		else [tt update:aDelta];	
	}
	[tenticles removeObjectsInArray:discard];
	
	
	if([tenticles count]==0 && !tenticlesDead)
	{
			tenticlesDead = YES;
		maxDelay = maxDelay/3;
	}
	
	
	
	
	[self setDir:_angle];


	if(position.x <= MAXW-50)
	{
		_vel.x=0;
	}
	else
	{
		_vel.x = -[_stats game_scroll_speed];
	}
	position = Vector2fAdd(position, _vel);

	if(seeking)
	{
		float goalAngle = eyeAngle + RADIANS_TO_DEGREES(Vector2fangle(Vector2fSub([_scene getPlayerPos], position)));
		if(ABS(goalAngle) < 5) 
			
		{
			seeking=NO;
			for(BossGun* tt in guns)
			{
				[tt setTarget:[_scene getPlayerPos]];
			}
			Laser* ls;
			[_scene playSound:TURRET_FIRE pos:position];
			Vector2f lp = Vector2fAdd(position, Vector2fRotate(Vector2fMake(23, 12),-eyeAngle));
			ls = [[Laser alloc]initWithLocation:lp color:YELLOW_BALL];
			[ls set_speed:16];
			[_scene addRibbon:ls type:YELLOW_RIB];
			[ls setDir:-eyeAngle];
			[_scene addBadguyWeapon:ls];
			[ls release];
			
			lp = Vector2fAdd(position, Vector2fRotate(Vector2fMake(23, -12),-eyeAngle));
			ls = [[Laser alloc]initWithLocation:lp color:YELLOW_BALL];
			[ls set_speed:16];
			[_scene addRibbon:ls type:YELLOW_RIB];
			[ls setDir:-eyeAngle];
			[_scene addBadguyWeapon:ls];
			[ls release];
			
		
		}
		else if(goalAngle<0) eyeAngle+=3;
		else eyeAngle-=3;
	}
	else
	{
		seekDelay--;
		if(seekDelay<=0)
		{
			seeking = YES;
			seekDelay = maxDelay;
		}	
	}
	
	
	[eyeImage setRotation:180+eyeAngle];
		
    // Pick a new angle at
    
 
}
-(bool)hits:(AbstractEntity*)pt;
{
	bool ht = NO;
	for(AbstractEntity* tt in guns)
	{
		if([tt hits:pt])
		{ 
			ht = YES; 
			[tt removeEnergy:[pt energy] ]; 
		//	printf("hit weap energy:%d\n",[tt energy]);
		}
	}

	if(tenticlesDead && !exploded)
	{
		if([super hits:pt])
		{
			ht = YES;
			[self removeEnergy:[pt energy] ];
			
			if(!alive)
			{
				for(int i=0;i<10;i++)
				{
					[_scene	addCoin:position];
				}	
			}
		}
	}
	return ht;
}
- (void)render {


	
	/*for(BezierCurve* c in tenticles)
	{
		[c render];
	}*/
if(active)
{
	for(AbstractEntity* tt in tenticles)
	{
		[tt render];	
	}
	
	for(AbstractEntity* tt in guns)
	{
		[tt render];	
	}

	
	[image setRotation:-_angle];
	[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:TRUE];

	eyeOffset = Vector2fRotate(Vector2fMake(20, 0), -eyeAngle);
	[eyeImage renderAtPoint:Vector2fToCGPoint(Vector2fAdd(position, eyeOffset)) centerOfImage:YES];
	
}

	if(DEBUG_COLLISION)[super drawBounds];
}
@end

