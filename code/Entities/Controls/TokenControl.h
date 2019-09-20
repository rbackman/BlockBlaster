//
//  MenuControl.h
//  BlockBlaster
//
//  Created by Robert Backman on 21/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//
// This class controls the appearance and state of menu options.  It takes an image
// which represents the menu option itself and is resposible for both the logic and
// rendering of the item

#import <Foundation/Foundation.h>
#import "AbstractControl.h"
#import "Image.h"
#import "Common.h"
#import "SpriteSheet.h"
#import "WeaponShopScene.h"
#import "Tokens.h"
#import "GameScene.h"




@interface TokenControl : AbstractControl  {


	Token* _token;
	Image* gameImage;
	Image* shopImage;
	bool toggleActive;

	GameScene* _gamescene;
	WeaponShopScene* _scene;
	Vector2f offset;
	bool following;
	bool weapShop;
	
	bool scaleDown;
	float minScale;
	float maxScale;
	
	float scaleSpeed;
	float alphaSpeed;

	int *tokenTypes;
	float hitTime;
	bool tokenHit;

}

- (id)initWithImage:(Image*)tokenImage offset:(Vector2f)ofst token:(Token*)tokn weapShop:(bool)shop;
- (bool)updateWithLocation:(Vector2f)theTouchLocation;
- (void)updateWithDelta:(float)theDelta;
- (void)render:(bool)shop;
-(void)move:(int)newOffset;
-(bool)hit:(Vector2f)pos;
-(void)set_token:(Token*)tk;

@property(nonatomic,readwrite) bool following;
@property(nonatomic,readonly) Token* _token;
@property(nonatomic,readonly) Image* gameImage;
@property(nonatomic,readonly) Image* shopImage;

@property(nonatomic,assign) bool toggleActive;
@property(nonatomic,assign) float scaleSpeed;
@property(nonatomic,assign) float alphaSpeed;
@property(nonatomic,assign) float maxScale;
@property(nonatomic,assign) bool tokenHit;
@property(nonatomic,assign)  float hitTime;

@end

