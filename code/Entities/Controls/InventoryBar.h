
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

#import "Common.h"


@class MenuControl;
@class Image;
@class SpriteSheet;
@class TokenControl;
@class GameScene;
@class Token;
@class AngelCodeFont;

enum inventory_tutorial_states
{
	PRESS_TAB,
	SELECT_MISSLE,
	SELECT_LASER,
	PRESS_BUTTON,
	BUY_AMMO,
	GUNS_ARMED
};


enum inventory_states{
	INVENTORY_ACTIVE,
	INVENTORY_OPENING,
	INVENTORY_EXPANDING,
	INVENTORY_SHRINKING,
	INVENTORY_CLOSED,
	INVENTORY_OPEN,
	INVENTORY_CLOSING,
	INVENTORY_DEACTIVATE,
	INVENTORY_INACTIVE,
	INVENTORY_TOKENS_ENTERING,
	INVENTORY_TOKENS_LEAVING,
	
};

@class WeaponButton;

@interface InventoryBar : AbstractControl {
	
	bool imagesLoaded;
	MenuControl* tab;
	AngelCodeFont* font;
	Image *_weapBar;
	Image *_blueBut;
	Image *_redBut;
	Image *_yellowBut;
	Vector2f weap_bar_position;
	float weap_bar_position_min;
	Image* green_token_highlight;
	WeaponButton* weap_bar_buttons[4];
	WeaponButton*  weap_bar_active_button;
	TokenControl* inventory_active_token;

//	TokenControl* weap_bar_buttons[4];
//	bool butOn[4];
//	Vector2f but1,but2,but3,but4;
//	Rec weap_bar_button_1_Rec, weap_bar_button_2_Rec, weap_bar_button_3_Rec, weap_bar_button_4_Rec, 
//	int   activeButNum;

	Rec weap_bar_retract_button_rec;
	Rec weap_bar_bounds;
		Rec inventory_token_bounds;
	
	
	bool weap_bar_closed;
	bool weap_bar_retracting;
	bool weap_bar_retracting_dir;
	


	bool inventory_closed;
	bool tokensPresent;
	
	GameScene* _gamescene;
	
	float  startPos;
	int  bar_state;
	float  sliderScale;
	Vector2f inventoryPos;
	
		
	Vector2f buyAmmoPos;
	Image*  slider;
	Image*  tokenImage;

	Image* statsBackgroud;
	Vector2f statsPos;
	float  tokenStop;
	float tokenStartPos;
	float  tokenPos;
	float  clickStart;
	float  tokenStart;

	Vector2f movingInventoryPos;
	NSMutableArray*  ownedTokens;

	MenuControl* buyAmmo;
}


@property(nonatomic,readonly) bool inventory_closed;
-(bool)tokensToLoad;
-(void)autoLoad;
-(Token*)getToken:(int)i;
-(void)addBonus:(Vector2f)pos;
- (id)initWithLocation:(Vector2f)p ;
- (void)closeInventory;
- (void)openInventory;
-(void)openWeapBar;
-(void)closeWeapBar;
-(BOOL)closed;
- (bool)butOn:(int)i;
- (bool)hit:(Vector2f)pos press:(int)prs;
- (void)update:(float)theDelta;
- (void)render;

- (void)reset;
- (void)loadTokens;
- (void)loadImages;
- (void)unloadImages;
//-(void)fireWeapons;
-(void)updateWeaponBar;
-(void)updateInventory;
@end
