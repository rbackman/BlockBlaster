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

@class Image;
@class Token;
@class GameScene;

enum weap_button_states{
	WEAPON_ARMED,
	WEAPON_DISARMED,
	WEAPON_EMPTY
};
enum inventory_touch_events
{
	RELEASE_INVENTORY_OPEN,
	PRESS_INVENTORY_CLOSED,
	RELEASE_INVENTORY_CLOSED
};
@interface WeaponButton : AbstractControl 
{
	bool toggleMode;
	int lastTime;
	int buttonState;
	Image* armedButton;
	Image* disarmedButton;
	Image* emptyButton;
	Token* token;
	Vector2f offset;
	GameScene* _scene;
	bool active;
}
@property (nonatomic,readonly) bool active;
@property (nonatomic,readonly) Token* token;
- (id)initWithOffset:(Vector2f)theLocation;
-(void)move:(float)newX;
- (bool)hit:(Vector2f)pos press:(int)clsd;
- (void)update:(float)theDelta;
- (void)render;
-(void)loadToken:(Token*)tk;
-(void)unloadToken;

@end
