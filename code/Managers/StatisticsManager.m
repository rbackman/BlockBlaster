//
//  ResourceManager.m
//  BlockBlaster
//
//  Created by Robert Backman on 16/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "StatisticsManager.h"
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "Tokens.h"
#import "TokenControl.h"

@implementation HighScore

@synthesize score;
@synthesize name;
@synthesize date;

-(id)initWithName:(NSString*)nme score:(uint64_t)scr
{
	self = [super init];
	if(self)
	{
		
		score = scr;
		name = [nme retain];
		date = [NSDate date];
	}
	return self;
}

- (void) dealloc
{
	[name release];
	[date release];
	[super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	[super init];
	
	score = [aDecoder decodeIntForKey:@"score"];
	name = [[aDecoder decodeObjectForKey:@"name"]retain];
	date = [[aDecoder decodeObjectForKey:@"date"]retain];
		
	return self;
}





- (void)encodeWithCoder:(NSCoder *)aCoder {
	
		[aCoder encodeObject:date forKey:@"date"];
	[aCoder encodeObject:name forKey:@"name"];
	
	[aCoder encodeInt:score forKey:@"score"];	
}



@end

@implementation StatisticsManager

//SYNTHESIZE_SINGLETON_FOR_CLASS(StatisticsManager);

@synthesize tokenInventory;
@synthesize game_BonusProb;
@synthesize bonusFade;
@synthesize game_scroll_speed;
@synthesize	game_BlockProb;
@synthesize	game_TurretProb;
@synthesize	game_BadGuysNum;
@synthesize fxVolume;
@synthesize musicVolume;
@synthesize graphicsLevel;
@synthesize bonusPoints;
@synthesize	game_BadGuy_Energy;
@synthesize	game_Turret_Energy;
@synthesize	game_Turret_FireRate;
@synthesize	game_Alien_FireRate;
@synthesize	game_Boss_FireRate;
@synthesize	game_Boss_Energy;
@synthesize game_Boss_Gun_Energy;
@synthesize player_MaxVelocity;

@synthesize	player_Lives;
@synthesize player_coins;
@synthesize player_Score;

@synthesize game_level_time;
@synthesize game_level;
@synthesize game_level_duration;
@synthesize highScores;

@synthesize resumed;
@synthesize quickPlay;


-(void)newHighScore:(NSString*)nme 
{
	
	if([highScores count]<8)
	{
		
		int index = 0;
		for(HighScore* sc in highScores)
		{
			if(player_Score>[sc score])
			{
				index++;
			}
		}
		
		
		
		HighScore* news = [[HighScore alloc] initWithName:nme score:player_Score];
		[highScores insertObject:news atIndex:index];
		[news release];
	}
	else
	{
		BOOL earns = NO;
		int index = 0;
		for(HighScore* sc in highScores)
		{
			if(player_Score>[sc score])
			{
				earns = YES;
				index++;
			}
		}
		if(earns)
		{
			HighScore* news = [[HighScore alloc] initWithName:nme score:player_Score];
			[highScores insertObject:news atIndex:index];
			[news release];
			
			while([highScores count]>8)
				[highScores removeObjectAtIndex:0];
			
		}
	}
	[self saveHighScores];
}

-(void)saveHighScores
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"HighScore.dat"];
	
	// Set up the encoder and storage for the game state data
	NSMutableData *scoreData;
	NSKeyedArchiver *encoder;
	scoreData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:scoreData];
	
	// Archive our object
	[encoder encodeObject:highScores forKey:@"highScores"];
	[encoder encodeObject:player_name forKey:@"playerName"];
	
	// Finish encoding and write to the gameState.dat file
	[encoder finishEncoding];
	[scoreData writeToFile:gameStatePath atomically:YES];
	[encoder release];	
}


-(void)readHighScores
{
	
	if(highScores)[highScores release];
	if(player_name)[player_name release];
	
	// Check to see if there is a gameState.dat file.  If there is then load the contents
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSMutableData *scoreData;
	NSKeyedUnarchiver *decoder;
	
	// Check to see if the ghosts.dat file exists and if so load the contents into the
	// entities array
	NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"HighScore.dat"];
	scoreData = [NSData dataWithContentsOfFile:documentPath];
	
	if (scoreData) 
	{
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:scoreData];
		
		highScores = [[decoder decodeObjectForKey:@"highScores"]retain];
		player_name = [[decoder decodeObjectForKey:@"playerName"]retain];
		
		[decoder release];
	}
	else
	{
		highScores = [[NSMutableArray alloc] init];
		player_name = @"Player";
	}
	
	
	
}

-(Token*)getToken:(int)i
{
	if(buttonToken[i]!=-1)
	{
		return	[tokenInventory objectAtIndex:buttonToken[i] ];
	}
	return nil;
}
-(void)setActiveToken:(int)i token:(Token*)ct
{
	if(ct)
		buttonToken[i]= [tokenInventory indexOfObject:ct];	
	else
		buttonToken[i]= -1;	
}
- (void)dealloc {
    
	[super dealloc];
}
-(void)update
{
	if(bonusFade>0)
	{
		bonusFade -= 0.07f;	
	}
	else
	{
		if(bonusPoints>10) player_Score+=bonusPoints;
		bonusPoints=0;
		bonusFade = 0;
	}
	
}
-(void)addScore:(uint64_t)score
{
	player_Score+=score;
	[self addBonusPoints:score];
}

-(void)addBonusPoints:(uint64_t)score
{
	bonusFade = 1;
	bonusPoints = bonusPoints +  2 * score;
}
-(void)clearBonusPoints
{
	bonusFade = 0;
	bonusPoints = 0;
}
-(bool)addCoins:(int)cns
{
	bool remain = TRUE;
	if((player_coins+cns)<0)
	{
		remain = FALSE;
	}
	else
	{
		player_coins+=cns;
	}
	
	if(player_coins<0)
	{
		player_coins=0;
		remain = FALSE;
	}
	return remain;
}
-(void)addToken:(Token*)tok
{
	bool foundToken = NO;

	for(Token* ownedToken in tokenInventory )
	{
		if([tok token_type] == [ownedToken token_type])
		{
			if([tok sub_type] == [ownedToken sub_type])
			{
				if([ownedToken owned])
				{
					[ownedToken addAmo:[tok num]];
				}
				else
				{
					[ownedToken upgrade];
				}
				foundToken = YES;
			}
		}
	}
	if(!foundToken)
	{
		[tokenInventory addObject:tok];
	}
	
}

-(void)newGame
{
	resumed = NO;
	game_level = START_LEVEL-1;
	player_coins = START_COINS;	
	game_level_duration = LEVEL_DURATION;
	//player MAX
	player_Score = 0;
	player_MaxVelocity = PLAYER_MAX_VELOCITY;
	player_Lives = PLAYER_START_LIVES;

	[self levelUp];
	
}
-(bool)isHighScore
{
	[self readHighScores];
	if([highScores count]<8)return YES;
	
	for(HighScore* sc in highScores)
	{
		if(player_Score>[sc score])return YES;	
	}
	return NO;
}
- (id)init {
	bonusPoints = 0;
	resumed = NO;
	fxVolume = 0.2;
	musicVolume = 0.1;
	graphicsLevel = 10;
	game_BonusProb = 0.1f;
quickPlay = NO;
	tokenInventory = [[NSMutableArray alloc] init];
	for(int i=0;i<4;i++) buttonToken[i]=-1;
	game_scroll_speed = 2;
	[self newGame];

	return self;
}
-(void)setStats
{
	switch (game_level)
	{
		case 1:
			game_BonusProb = 0.2f;
			game_BlockProb = 0.05f;
			game_TurretProb = 0.02;
			game_BadGuysNum = 3;
			game_Turret_FireRate= 35;
			game_Alien_FireRate =50;
			game_BadGuy_Energy = 2;
			game_Turret_Energy = 5;
			game_Boss_FireRate = 20;
			game_Boss_Energy = 40;
			game_Boss_Gun_Energy = 10;
			break;
		case 2:
			game_BonusProb = 0.1f;
			game_BlockProb = 0.06f;
			game_TurretProb = 0.06;
			game_BadGuysNum = 4;
			game_Turret_FireRate= 28;
			game_BadGuy_Energy = 4;
			game_Turret_Energy = 8;
			game_Boss_FireRate = 20;
			game_Alien_FireRate = 40;
			game_Boss_Energy = 50;
			game_Boss_Gun_Energy = 15;
			break;
			
		case 3:
			game_BonusProb = 0.1f;
			game_BlockProb = 0.07f;
			game_TurretProb = 0.08;
			game_BadGuysNum = 5;
			game_Turret_FireRate = 24;
			game_BadGuy_Energy = 6;
			game_Turret_Energy = 15;
			game_Boss_FireRate = 10;
			game_Alien_FireRate = 30;
			game_Boss_Energy = 60;
			game_Boss_Gun_Energy = 20;
			break;
		default:
			game_BonusProb = 0.08f;
			game_BlockProb = 0.05f+game_level*0.01f;
			game_TurretProb = 0.05f + game_level*0.05f;
			game_BadGuysNum = 5+game_level;
			game_Turret_FireRate = 24 - game_level - 3;
			game_BadGuy_Energy = 10 + game_level*2;
			game_Turret_Energy = 15 + game_level*3;
			game_Boss_FireRate = 24 - game_level - 3;
			game_Alien_FireRate= 30 - game_level - 3;
			game_Boss_Energy = 50 + 10*game_level;
			game_Boss_Gun_Energy = 10 + 5*game_level;
			if(game_Boss_FireRate<5)game_Boss_FireRate=5;
			if(game_Turret_FireRate<5)game_Turret_FireRate=5;
			if(game_Alien_FireRate<10)game_Alien_FireRate=10;
			if(game_BadGuysNum>8)game_BadGuysNum=8;
			if(game_BlockProb>0.5)game_BlockProb=0.5f;
			if(game_TurretProb>0.2)game_TurretProb=0.2f;
			
			break;
	}
}
-(void)levelUp
{
	game_level++;
	[self setStats];
	
}
-(int)getButtonToken:(int)i
{
	return buttonToken[i];	
}



- (id)initWithCoder:(NSCoder *)aDecoder {
	[self init];

	resumed = YES;
	tokenInventory = [[aDecoder decodeObjectForKey:@"inventory"] retain];
	
	buttonToken[0] = [aDecoder decodeIntForKey:@"token1"];
	buttonToken[1] = [aDecoder decodeIntForKey:@"token2"];
	buttonToken[2] = [aDecoder decodeIntForKey:@"token3"];
	buttonToken[3] = [aDecoder decodeIntForKey:@"token4"];
	
	game_level = [aDecoder decodeIntForKey:@"gameLevel"] ;
	
	[self setStats];
	
	player_Score = [aDecoder decodeInt64ForKey:@"score"];
	player_coins = [aDecoder decodeIntForKey:@"coins"] ;
	player_MaxVelocity = [aDecoder decodeFloatForKey:@"player_maxV"] ;
	fxVolume = [aDecoder decodeFloatForKey:@"fxVol"] ;
	musicVolume = [aDecoder decodeFloatForKey:@"musicVol"] ;
	graphicsLevel = [aDecoder decodeIntForKey:@"graphicsLevel"] ;
	
	return self;
}





- (void)encodeWithCoder:(NSCoder *)aCoder {

	[aCoder encodeObject:tokenInventory forKey:@"inventory"];
	[aCoder encodeInt:buttonToken[0] forKey:@"token1"];
	[aCoder encodeInt:buttonToken[1] forKey:@"token2"];
	[aCoder encodeInt:buttonToken[2] forKey:@"token3"];
	[aCoder encodeInt:buttonToken[3] forKey:@"token4"];
	[aCoder encodeInt:player_coins forKey:@"coins" ];
	[aCoder encodeInt:game_level forKey:@"gameLevel" ];
	[aCoder encodeInt64:player_Score forKey:@"score"];  
	[aCoder encodeFloat:player_MaxVelocity forKey:@"player_maxV"];
	[aCoder encodeInt:graphicsLevel forKey:@"graphicsLevel"];
	[aCoder encodeFloat:fxVolume forKey:@"fxVol"];
	[aCoder encodeFloat:musicVolume forKey:@"musicVol"];
	
}
	
@end
