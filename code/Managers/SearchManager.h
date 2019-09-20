//
//  SearchManager.h
//  BlockBlaster
//
//  Created by Robert backman on 12/9/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@class SpriteSheet;
@class SearchNode;
@class SearchManager;
@class AbstractEntity;
@class Block;
// Class that is responsible for  organizing searches



@interface SearchManager : NSObject {

    NSMutableArray    *_searchNodes;
	NSMutableArray* front_nodes;
	
	SpriteSheet* _spriteSheet16;
	int curCol;
	SearchNode* first;
	SearchNode* last;
	AbstractEntity* origin;
	AbstractEntity* destination;
	
	float closestDisStart;
	float closestDisEnd;
	
	bool startEndFound;
	bool pathFound;
	bool expanding;
	int minWeight;


	
}


+ (SearchManager *)sharedSearchManager;



-(void)addNode:(int)ht pos:(Vector2f)p;
-(void)addBlockedNode:(int)ht pos:(Vector2f)p ent:(Block*)ent ;
-(void)updateNodes:(float)delta;
-(bool)getPath:(NSMutableArray*)pth;
-(void)update;
-(void)render;
-(void)newCol;
-(bool)findStartEnd:(AbstractEntity*)start to:(AbstractEntity*)end;
-(void)runSearch;

-(void)reset;
-(void) add:(SearchNode*) item parent:(SearchNode*)prnt;
-(bool) expandNode:(SearchNode*)r ;
-(void)updateQueue;



@property(nonatomic,assign) SpriteSheet* _spriteSheet16;
@property(nonatomic,readonly) bool pathFound;
@property(nonatomic,readonly) bool startEndFound;
@property(nonatomic,readonly) bool expanding;


@property(nonatomic,assign) SearchNode* first;
@property(nonatomic,assign) SearchNode* last;

@end
