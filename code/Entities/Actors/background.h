

#import <UIKit/UIKit.h>
#import "AbstractEntity.h"

@class GameScene;

enum{
	SQUARE_64_SCAFOLD,
	YELLOW_SCAFOLD,
	SQUARE_32_SCAFOLD,
	STARS,
	SPACESHIP_CARGO,
	SPACESHIP_BATTLECRUISER,
	SPACESHIP_FISH,
	SPACE_STATION,
	WALL_BLOCK
};

@interface Background : AbstractEntity {
	int BGtype;
	float du;
	float dx;
	//Image* jetImage;
	
	Vector2f jetOffset;
	float scaleBackground ;

}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Vector2f)aLocation   BGtype:(int)tp;
-(void)makeJet;

@property (nonatomic,readwrite)	float du;


@end
