//
//  Monk.h
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractEntity.h"

@class GameScene;
@class Token;
@class BezierCurve;

@interface Bonus : AbstractEntity {

	Token* _token;
	Vector2f buttonPos;
	bool homming;
	bool rotating;
	bool animated;
	BezierCurve* curve;
	float curveTime;
	int amount;
	float length;
	float scale;

	
}


- (id)initWithLocation:(Vector2f)aLocation goal:(Vector2f)goal token:(Token*)tok ;

@property (nonatomic,readonly)Token* _token;



@end
