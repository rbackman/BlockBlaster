//
//  MenuState.h
//  BlockBlaster
//
//  Created by Robert Backman on 31/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"

@class AbstractEntity;
@class Token;
@class SpriteSheet;

#define TUTORIAL_WEAP_LAST_STEP 5
enum{
	weap_sell,
	weap_buy,
	weap_resume
};
@interface WeaponShopScene : AbstractScene 
{
	NSMutableArray *token_controls;
	
	Token* activeToken;
	Image *menuBackground;
	Image *tokenImage;
	
	int cols;
	int rows;
	Vector2f tokenOrigin;
	Vector2f textOrigin;
	
	int maxH;
	int maxL;
	Rec tokenBound;
	float startPos;
	float originStart;
	Vector2f sellPos,buyPos,resumePos;
	MenuControl* sellBut;
	MenuControl* buyBut;
	MenuControl* resumeBut;
	
	Vector2f tutPos;
	Image* tutBackdrop;
	Image* tutArrow;
	Vector2f tutPointTo;
	bool showArrow;
	int tutorialNextStep;
	
	int tutorialStep;
	bool showNext;
	NSString* line1;
	NSString* line2;
	NSString* line3;
	NSString* line4;
	Image* tokenToSelectImage;
	TokenControl* tokenToSelect;
	MenuControl* nextBut;
	
}
-(void)addTokenControl:(Token*)theToken;
-(void)tutProceed;

@property(nonatomic,assign) Token* activeToken;
@property (nonatomic,readonly) Vector2f tokenOrigin;
@end
