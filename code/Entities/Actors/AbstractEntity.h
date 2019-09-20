//
//  AbstractEntity.h
//  BlockBlaster
//
//  Created by Robert Backman on 04/03/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"
#import "AbstractScene.h"
#import "GameScene.h"
#import "Explosion.h"

@class Token;
@class GameScene;
@class ParticleEmitter;
@class BezierCurve;
@class SearchNode;

// Entity states
enum entityState {
	kEntity_Idle = 0,
	kEntity_Dead = 1,
	kEntity_Dying = 2,
	kEntity_Alive = 3,
	kEntity_Following_Path = 4
};


@interface AbstractEntity : NSObject <NSCoding> {
	// Do we have a reference to the current scene
    bool firstThrough;
	GameScene *_scene;
	Director *_director;
	ResourceManager *_resourceManager;
	SoundManager    *_soundManager;
	StatisticsManager* _stats;
	
	GLuint type;	//enitity type : enum above
	bool resumed;
	Token* token;	//associated token
	bool alive;
	bool active;
	bool beenTargeted;
	bool beenFiredAt;
	
	bool diesOfOldAge;
	int death;
	int age;
	
	signed int energy;

	bool explode,exploded;
	int  explodeCount;
	
	AbstractEntity* _parent;
	Vector2f parent_offset;

	float zDepth;
	float _angle;
	float _dAngle;
	float _speed;
	Vector2f position;
	Vector2f _vel;
	Vector2f _accel;
	Vector2f tailPos;
	
	Image *image;
	Animation *animation;

	Dimension _size;
	float radius;
	Rec _bounds;
	bool collideBounds;
	int height_offset, width_offset;
}
@property (nonatomic, readonly)	float zDepth;
@property (nonatomic, readonly)GLuint type;
@property (nonatomic, assign) Token* token;
@property (nonatomic, readwrite) Vector2f parent_offset;
@property (nonatomic, retain)  AbstractEntity* _parent;
@property (nonatomic, assign)  Vector2f position;
@property (nonatomic, assign)  Vector2f _vel;
@property (nonatomic,readwrite) float _angle;
@property (nonatomic, assign) 	bool beenFiredAt;
@property (nonatomic, assign) bool beenTargeted;
@property(nonatomic,readonly) bool diesOfOldAge;
@property (nonatomic, readonly) Image *image;
@property (nonatomic)bool alive;
@property (nonatomic)bool explode;
@property(nonatomic,readwrite)	int  explodeCount;
@property (nonatomic)bool active;
@property (nonatomic)Dimension _size;
@property (nonatomic) float radius;
@property (nonatomic)int energy;
@property(nonatomic,readonly) 	bool collideBounds;


//@property (nonatomic)bool beenHit;
-(Vector2f)globalPosition;
-(float)globalAngle;
-(void)setDir:(float)deg ;
- (NSComparisonResult)compareZdepth:(id)otherObject;
-(void)set_speed:(float)sp;
// Selector that updates the entities logic i.e. location, collision status etc
- (void)update:(GLfloat)delta;
-(void)setImage:(int)im;
-(void)pointAt:(Vector2f)pt;
-(Vector2f)getTailPos;
// Selector that renders the entity
- (void)render;
-(void)drawBounds;
-(Bounds)getBounds;
-(bool)hits:(AbstractEntity*)other;



-(void)removeEnergy:(int)eng;
-(void)destroy;

-(void)blowUp;

@end
