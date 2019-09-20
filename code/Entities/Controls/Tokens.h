@class StatisticsManager;
@class Image;
@class Director;

enum token_types{
	MISSLE_TOKEN,
	LASER_TOKEN,
	SHIELDS_TOKEN,
	GUARDIAN_TOKEN,
	ENERGY_TOKEN
};
@interface Token : NSObject <NSCoding>  {
	Image* gameImage;
	Image* shopImage;
	Director* _director;
	NSString* name;
	NSString* sub_type_name;
	
	bool loaded;
	bool ready;
	bool owned;
	bool empty;
	bool unlimited;
	bool firstThrough;
	
	int energy;
	int reloadRate;
	int timeCount;
	int token_type;
	int sub_type;
	int token_level;
	int num;
	int cost;
	int amoCost;
	int amoAmount;
		CFTimeInterval	lastFireTime;
}

-(id) initWithType:(int)tp name:(NSString*)nm ;
-(void)upgrade;
-(void)sellToken;
-(void)setStats;
-(void)addAmo:(int)n;
-(bool)update;
-(void)loadImage:(bool)shop;

@property(nonatomic,readwrite) bool loaded;
@property(nonatomic,readonly) int energy;
@property(nonatomic,readonly) Image* shopImage;
@property(nonatomic,readonly) Image* gameImage;
@property(nonatomic,readonly) int amoCost;
@property(nonatomic,readonly) int amoAmount;
@property(nonatomic,readonly) int reloadRate;
@property(nonatomic,readonly) int timeCount;
@property(nonatomic,readonly) bool unlimited;
@property(nonatomic,readonly) bool empty;
@property(nonatomic,readwrite) bool owned;
@property(nonatomic,readwrite) int sub_type;
@property(nonatomic,readwrite) int num;
@property(nonatomic,readonly)  int token_level;
@property(nonatomic,readonly) int token_type;
@property(nonatomic,readonly) 	NSString* name;
@property(nonatomic,readonly) 	NSString* sub_type_name;
@property(nonatomic,readonly) int cost;

@end


//MISSLE TOKEN
enum missile_token_types{
	STANDARD_MISSLE,
	DART_MISSLE,
	NARROW_RANGE_MISSLE,
	EXPLOSIVE_MISSLE,
	CLUSTER_MISSLE,
	GUIDED_MISSLE
};
@interface MissileToken : Token 
{
	float explosionRadius;
	float trackingAccuracy;
	float speed;
	int clusterNum;

}

-(id) initWithType:(int)tp;

@property(nonatomic,readonly) int clusterNum;
@property(nonatomic,readonly) float explosionRadius;
@property(nonatomic,readonly) float trackingAccuracy;
@property(nonatomic,readonly) float speed;


@end


//LASER_TOKEN
enum laser_token_types{
	STANDARD_LASER,
	DOUBLE_LASER,
	TRIPLE_LASER,
	CHARGING_LASER,
};
@interface LaserToken : Token 
{
	float speed;
}

-(id) initWithType:(int)tp;

@property(nonatomic,readonly) float speed;



@end


//SHIELD_TOKEN
enum shield_token_types{
	STANDARD_SHIELD,
	REFLECTOR_SHIELD,
};
@interface ShieldToken : Token 
{
	float radius;
	float damageReduction;
	float maxEnergy;
	float regenRate;
}

@property(nonatomic,readonly) float maxEnergy;
-(id) initWithType:(int)tp;


@end


//GUARDIAN_TOKEN
enum guardian_token_types{
	STANDARD_GUARDIAN,
	STATIONARY_GUARDIAN,
};

@interface GuardianToken : Token 
{

	NSString* guardian_name;
	float trackRate;

	int maxNum;
	NSMutableArray* launched_guardians;
}

@property (nonatomic,readonly)int maxNum;

-(id) initWithType:(int)tp;


@end


//SHIELD_TOKEN
enum energy_token_types{
	STANDARD_ENERGY,
	SUPER_ENERGY
};

@interface EnergyToken : Token 
{
	int amount;
	float regenRate;
}

-(id) initWithType:(int)tp;


@end
