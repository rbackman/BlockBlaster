#import "Tokens.h"
#import "StatisticsManager.h"
#import "Director.h"
#import "Image.h"
#import "SpriteSheet.h"

@implementation Token

@synthesize token_type;
@synthesize sub_type;
@synthesize name;
@synthesize cost;
@synthesize token_level;
@synthesize owned;
@synthesize num;
@synthesize empty;
@synthesize unlimited;
@synthesize reloadRate;
@synthesize timeCount;
@synthesize sub_type_name;
@synthesize gameImage;
@synthesize shopImage;
@synthesize amoCost;
@synthesize amoAmount;
@synthesize energy;
@synthesize loaded;

- (void) dealloc
{
	[name release];
	[sub_type_name release];
	if(gameImage)[gameImage release];
	if(shopImage)[shopImage release];
	[super dealloc];
}

-(id) initWithType:(int)tp name:(NSString*)nm;
{
	[super init];
	_director = [Director sharedDirector];
	loaded = NO;
	energy = 1;
	amoCost = 20;
	amoAmount = 10;
	owned = NO;
	token_level = 0;
	timeCount = 0;
	reloadRate = 10;
	token_type = tp;	
	name = nm;
	num = 5;
	empty = NO;
	unlimited = NO;
	firstThrough = YES;
	return self;
}


-(void)loadImage:(bool)shop
{
	bool beenLoaded = NO;
	
	if(shop)
	{
		if(shopImage != nil) beenLoaded = YES;
	}
	else
	{
		if(gameImage != nil) beenLoaded = YES;
	}
	if(!beenLoaded)
	{
	
	SpriteSheet* shopSheet = nil;
	SpriteSheet* gameSheet = nil; 
	shopImage = nil;
	gameImage = nil;
	if(shop) shopSheet = [[ResourceManager sharedResourceManager] _shopTokenSheet];
		else gameSheet =[[ResourceManager sharedResourceManager] _gameTokenSheet];

	switch (token_type) 
	{
		case MISSLE_TOKEN:
		{
			switch (sub_type) 
			{
				case EXPLOSIVE_MISSLE:		if(shopSheet)shopImage = [shopSheet getSpriteAtX:2 y:1];		if(gameSheet)gameImage = [gameSheet getSpriteAtX:2 y:2];	break;
				case NARROW_RANGE_MISSLE:	if(shopSheet)shopImage = [shopSheet getSpriteAtX:2 y:0];		if(gameSheet)gameImage = [gameSheet getSpriteAtX:2 y:1];	break;
				case CLUSTER_MISSLE:       	if(shopSheet)shopImage = [shopSheet getSpriteAtX:3 y:0];		if(gameSheet)gameImage = [gameSheet getSpriteAtX:3 y:1]; break;		
				case GUIDED_MISSLE: if(shopSheet)shopImage = [shopSheet getSpriteAtX:1 y:0];		if(gameSheet)gameImage = [gameSheet getSpriteAtX:1 y:1];	break;
				case STANDARD_MISSLE:	    
				default: 
					if(shopSheet)shopImage = [shopSheet getSpriteAtX:0 y:0];	 if(gameSheet)gameImage = [gameSheet getSpriteAtX:0 y:1];			break;
					break;
			}	
		}
			break;
		case SHIELDS_TOKEN:
			switch (sub_type) 
		{
				
			case REFLECTOR_SHIELD:	if(shopSheet)shopImage = [shopSheet getSpriteAtX:1 y:1];	if(gameSheet)gameImage = [gameSheet getSpriteAtX:1 y:2]; break;
			case STANDARD_SHIELD:
			default: 	
						if(shopSheet)shopImage = [shopSheet getSpriteAtX:0 y:1];	
						if(gameSheet)gameImage = [gameSheet getSpriteAtX:0 y:2];
				break;
		}	
			
			break;
		case LASER_TOKEN:
			switch (sub_type) 
		{
				
			case DOUBLE_LASER: if(shopSheet)shopImage = [shopSheet getSpriteAtX:1 y:2];  if(gameSheet)gameImage = [gameSheet getSpriteAtX:1 y:3]; break;
			case TRIPLE_LASER:if(shopSheet)shopImage = [shopSheet getSpriteAtX:2 y:2];  if(gameSheet)gameImage = [gameSheet getSpriteAtX:2 y:3]; break;
			case STANDARD_LASER:	
			default: 	if(shopSheet)shopImage = [shopSheet getSpriteAtX:0 y:2]; if(gameSheet)gameImage = [gameSheet getSpriteAtX:0 y:3];
				break;
		}	
			
			
			break;
		case GUARDIAN_TOKEN:
			if(shopSheet)shopImage = [shopSheet getSpriteAtX:0 y:3]; if(gameSheet)gameImage =  [gameSheet getSpriteAtX:0 y:4];
		break;
		default:
			break;
	}
	}
}
-(bool)update;
{
	ready = NO;
	if(firstThrough)
	{
		firstThrough = NO;
	}
	if(num<=0 && !unlimited)
	{
		num = 0;
		empty = YES;
		ready = NO;
	}
	else if(CFAbsoluteTimeGetCurrent() - lastFireTime >  (reloadRate * 1.0/FRAME_PER_SEC) )
	{
		lastFireTime = CFAbsoluteTimeGetCurrent();
		
		if(token_type == MISSLE_TOKEN && sub_type==CLUSTER_MISSLE)
			num -= [(MissileToken*)self clusterNum];
		else
			num--;
		
		empty = NO;
		timeCount = 0;
		ready = YES;
	}
	return ready;
}
-(void)upgrade
{
	if(!owned)
	{
		token_level = 1;
		owned = YES;
	} else token_level++;

	[self setStats];
}
-(void)addAmo:(int)n
{
	if(!unlimited)
	{
		num+=n;
		if(num<=0)
		{
			num = 0;
			empty = YES;
		}
	}
}
-(void)sellToken
{
	token_level = 0;
	owned = NO;
	[self setStats];
}
-(void)setStats
{
	cost = 30 + 30*token_level;

}



- (id)initWithCoder:(NSCoder *)aDecoder {
	[super init];
	
	cost = 100;
	amoCost = 100;
	amoAmount = 100;
	
	firstThrough = YES;
	
	timeCount = 0;
	token_level = [aDecoder decodeIntForKey:@"token_level"];
	token_type = [aDecoder decodeIntForKey:@"token_type"] ;
	sub_type = [aDecoder decodeIntForKey:@"token_sub_type"];
	owned = [aDecoder decodeBoolForKey:@"token_owned"];
	name = [ [aDecoder decodeObjectForKey:@"token_name"]retain ];
	sub_type_name = [[aDecoder decodeObjectForKey:@"token_subtype_name"] retain ];
	empty = [aDecoder decodeBoolForKey:@"token_empty"];
	unlimited = [aDecoder decodeBoolForKey:@"token_unlimited"];
	num = [aDecoder decodeIntForKey:@"token_num"];
	[self setStats];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder 
{
	[aCoder encodeInt:token_level forKey:@"token_level" ];
	[aCoder encodeInt:token_type forKey:@"token_type" ];
	[aCoder encodeInt:sub_type forKey:@"token_sub_type" ];
	[aCoder encodeBool:owned forKey:@"token_owned"];
	[aCoder encodeObject:name forKey:@"token_name"];
	[aCoder encodeObject:sub_type_name forKey:@"token_subtype_name"];
	[aCoder encodeBool:empty forKey:@"token_empty"];
	[aCoder encodeBool:unlimited forKey:@"token_unlimited"];
	[aCoder encodeInt:num forKey:@"token_num"];

}


@end
@implementation MissileToken

@synthesize explosionRadius;
@synthesize trackingAccuracy;
@synthesize speed;
@synthesize clusterNum;

-(id) initWithType:(int)tp  
{
	[super initWithType:MISSLE_TOKEN name:@"Missile"];
	sub_type = tp;
	clusterNum = 1;
	num = 10;
	[self setStats];
	return self;
}



-(void)setStats
{
	cost = 30+50*token_level;
	amoCost = 20 + 10*token_level;
	amoAmount = 10 + 3*token_level;
	energy = 5 + token_level*2;

	explosionRadius = 0;
	trackingAccuracy = 10;

	
	switch (sub_type)
	{
		case STANDARD_MISSLE:
			sub_type_name = @"Standard";
			speed = 10;
			reloadRate = 30 - token_level;
		break;
		case GUIDED_MISSLE:
			cost = 50+20*token_level;
			amoCost = 5 + 5*token_level;
			amoAmount = 15 + 10*token_level;
			energy = 2 + token_level;
			
			sub_type_name = @"Guided";
			reloadRate = 35 - 4*token_level;
			speed = 12;
			trackingAccuracy = 5;
			break;
		case 	DART_MISSLE:
			sub_type_name = @"Dart";
			reloadRate = 20 - token_level/2;
			cost = 10+30*token_level;
			amoCost = 30 + 80*token_level;
			amoAmount = 15 + 10*token_level;
			energy = 1 + token_level/2;
			
			sub_type_name = @"Guided";
			reloadRate = 10 - token_level;
			speed = 25;
			break;
		case NARROW_RANGE_MISSLE:
			sub_type_name = @"Narrow Range";
			reloadRate = 20 - reloadRate/2;
			speed = 4;
			break;
		case EXPLOSIVE_MISSLE:
			cost = 75+30*token_level;
			sub_type_name = @"Explosive";
			explosionRadius = 50 + 30*token_level;
			reloadRate = 40 - token_level*2;
			speed = 6+token_level;
			break;
		case CLUSTER_MISSLE:
			cost = 60+30*token_level;
			amoCost = 30 + 10*token_level;
			clusterNum = 2+token_level;
			amoAmount = clusterNum*3;
			energy = 1 + token_level/2;
			
			sub_type_name = @"Cluster";
	
			reloadRate = 40 - 2*token_level;
			
			trackingAccuracy = 20;
			speed = 8;
			break;
		default:
			sub_type_name = @"Default";
			speed = 8;
			reloadRate = 45 - token_level;
		break;
	}	
	if(reloadRate<1)reloadRate=1;
}

@end
@implementation LaserToken

@synthesize speed;


-(id) initWithType:(int)tp  
{
	[super initWithType:LASER_TOKEN name:@"Laser"];
	sub_type = tp;
	unlimited = YES;
	[self setStats];
	return self;
	
}

-(void)setStats
{
	
	energy = 1+(int)(token_level/3);
	switch (sub_type)
	{
		case STANDARD_LASER:
			cost = 50 + 68*token_level;
			sub_type_name = @"Standard";
			reloadRate = 7.0 - 0.6*token_level;
			if(reloadRate<0)reloadRate = 1;
			speed = 16;
		break;
		case DOUBLE_LASER: 
			sub_type_name = @"Double";
			cost = 70 + 28*token_level;
			reloadRate = ABS(6 - 0.15*token_level);
			if(reloadRate<0)reloadRate = 1;
			speed = 16;
		break;
		case TRIPLE_LASER: 
			sub_type_name = @"Triple";
			cost = 120 + 38*token_level;
			reloadRate = 5 - 0.2*token_level;
			if(reloadRate<0)reloadRate = 1;
			speed = 16;
		break;
		case CHARGING_LASER:
		default:
			
			sub_type_name = @"default";
			speed = 8;
			break;
	}	
}

@end
@implementation ShieldToken


@synthesize maxEnergy;

-(bool)update
{
	if(num>0)
	{
		num--;
		if(num<0)
		{
			num = 0; 
			empty = YES; 
			return NO;
		}
		else return YES;
	}
	else return NO;
}
-(id) initWithType:(int)tp  
{
	[super initWithType:SHIELDS_TOKEN name:@"Shield"];
	sub_type = tp;
	num = 3;
	unlimited = NO;
	[self setStats];
	return self;
	
}


-(void)setStats
{
	
	amoCost = 50 + 10*token_level;
	amoAmount = 3*token_level;
	switch (sub_type)
	{
		case REFLECTOR_SHIELD:
			sub_type_name = @"Reflector";
			radius =50;
			damageReduction = 0.9;
			maxEnergy = 100+50*token_level;
			regenRate = 5;
			cost = 150 + 38*token_level;
			break;
		case STANDARD_SHIELD:
		default:
			sub_type_name = @"Standard";
			 radius =40;
			damageReduction = 0.7;
			maxEnergy = 100+20*token_level;
			regenRate = 5;
			cost = 40+30*token_level;
			break;
	
	}	
}

@end

#import "Guardian.h"

@implementation GuardianToken

@synthesize maxNum;

-(id) initWithType:(int)tp
{
	[super initWithType:GUARDIAN_TOKEN name:@"Guardian"];
	firstThrough = YES;
	sub_type = tp;
	[self setStats];
	return self;
	
}

-(bool)update
{
	if(firstThrough)
	{
		launched_guardians	= [[(GameScene*)[_director currentScene] guardians] retain];
		firstThrough = NO;
	}
	if(num>0)
	{
		if([launched_guardians count]< maxNum)
		{
			num--;
			return YES;
		}
	}
	else num = 0;

	return NO;
}

-(void)setStats
{
	cost = 100 + 35*token_level;
	amoCost = 50 + 10*token_level;
	amoAmount = 10*token_level;
	reloadRate = 6 - 0.5*token_level;
	switch (sub_type)
	{
		case STANDARD_GUARDIAN:
			sub_type_name = @"Standard";
			trackRate = 3;
			energy = 30 + 5*token_level;
			maxNum = 3+token_level;	
			break;
		case STATIONARY_GUARDIAN:
			sub_type_name = @"Chilinator";
			trackRate = 3;
			energy = 30+ 5*token_level;
			maxNum = 3+token_level;	
			break;
	}	
}
@end

@implementation EnergyToken

-(id) initWithType:(int)tp  
{
	[super initWithType:ENERGY_TOKEN name:@"Energy"];
	sub_type = tp;
	[self setStats];
	return self;
	
}


-(void)setStats
{
	cost = 20 + 38*token_level;
	amoCost = 20 + 10*token_level;
	amoAmount = 10 + 10*token_level;
	
	switch (sub_type)
	{
		case STANDARD_ENERGY:
			sub_type_name = @"standard";
			num = 300;
		break;
			
	}	
}

@end


/*
@implementation GuardianToken

@synthesize guardianType;


-(id) initWithType:(int)tp
{
	[super initWithType:ENERGY_TOKEN name:@"Energy"];
	energyType = tp;
	[self setStats];
	return self;
	
}

-(void)upgrade
{
	[super upgrade];
}

-(void)setStats
{
	cost = 40+ 35*token_level;
	switch (guardianType)
	{
		case STANDARD_ENERGY:
			energy_name = @"standard";
			amount = 50;
		break;
		case SUPER_ENERGY:
			energy_name = @"super";
			amount = 200;
		break;
	}	
}



@end
*/