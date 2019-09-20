//
//  SettingsScene.h
//  Tutorial1
//
//  Created by Robert Backman on 07/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
@class SliderControl;
@class MenuControl;

@interface SettingsScene : AbstractScene {
	SliderControl* fxVolume;
	SliderControl* musicVolume;
	SliderControl* graphicsLevel;
	SliderControl* _velSensitivity;
	MenuControl* exitControl;
}

@end
