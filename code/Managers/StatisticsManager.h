//
//  ResourceManager.h
//  BlockBlaster
//
//  Created by Robert Backman on 16/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "SynthesizeSingleton.h"

@class Token;
@class TokenControl;

//This class will store all the game stats for saving and upgrading
@interface HighScore : NSObject <NSCoding>
{
	NSString* name;
	uint64_t score;
	NSDate* date;
}
@property(nonatomic,readonly) uint64_t score;
@property(nonatomic,readonly) NSString* name;
@property(nonatomic,readonly) NSDate* date;
-(id)initWithName:(NSString*)nme score:(uint64_t)scr;
@end


@interface StatisticsManager : NSObject <NSCoding>  {
	bool resumed;
	bool quickPlay;
	
	int bonusPoints;
	float bonusFade;

	
	int graphicsLevel;
	float fxVolume;
	float musicVolume;
	
	int game_level;
	float game_scroll_speed;
	uint64_t game_level_time;
	uint64_t game_level_duration;
	int player_Lives;
	uint64_t player_Score;
	int level_score;
	int player_coins;
	float player_MaxVelocity;
	
	float game_BlockProb;
	float game_TurretProb;
	float game_BonusProb;
	int game_BadGuysNum;
	int game_BadGuy_Energy;
	int game_Turret_Energy;
	int game_Turret_FireRate;
	int game_Alien_FireRate;
	int game_Boss_FireRate;
	int game_Boss_Energy;
	int game_Boss_Gun_Energy;
	

	NSMutableArray* highScores;
	NSString* player_name;
	
	NSMutableArray* tokenInventory;
	
	
	int buttonToken[4];



		
}
-(void)newGame;
-(int)getButtonToken:(int)i;
-(void)setStats;
-(void)levelUp;
-(void)addBonusPoints:(uint64_t)score;
-(void)clearBonusPoints;

-(void)saveHighScores;
-(void)readHighScores;
-(void)newHighScore:(NSString*)nme ;
-(bool)isHighScore;
-(void)addScore:(uint64_t)score;
-(bool)addCoins:(int)cns;
-(Token*)getToken:(int)i;
-(void)update;
-(void)setActiveToken:(int)i token:(Token*)ct;
-(void)addToken:(Token*)tok;

@property(nonatomic,readonly)float game_BonusProb;
@property(nonatomic,readwrite) bool quickPlay;
@property(nonatomic,readonly) 	NSMutableArray* highScores;
@property(nonatomic,readonly) 	int game_Boss_Gun_Energy;
@property(nonatomic,readonly) float bonusFade;
@property(nonatomic,readwrite) bool resumed;
@property(nonatomic, assign) NSMutableArray *tokenInventory;

@property(nonatomic,readonly)	int bonusPoints;
@property(nonatomic,readwrite)  int graphicsLevel;
@property(nonatomic,readwrite)  float fxVolume;
@property(nonatomic,readwrite)  float musicVolume;

@property(nonatomic,readwrite) float game_scroll_speed;
@property(nonatomic,readwrite) uint64_t game_level_time;
@property(nonatomic, readwrite) int game_level;
@property(nonatomic, readwrite)  uint64_t game_level_duration;
@property(nonatomic, readwrite) uint64_t player_Score;


@property(nonatomic, readonly) float game_BlockProb;
@property(nonatomic, readonly) float game_TurretProb;
@property(nonatomic, readonly) int game_BadGuysNum;
@property(nonatomic, readonly) int game_BadGuy_Energy;
@property(nonatomic, readonly) int game_Turret_Energy;
@property(nonatomic, readonly) int game_Turret_FireRate;
@property(nonatomic, readonly) int game_Alien_FireRate;
@property(nonatomic, readonly) int game_Boss_FireRate;
@property(nonatomic, readonly) int game_Boss_Energy;
@property(nonatomic, readonly) float player_MaxVelocity;


//player Current
@property(nonatomic, assign) int player_coins;
@property(nonatomic, assign) int player_Lives;

//+ (StatisticsManager *)sharedStatisticsManager;



@end
