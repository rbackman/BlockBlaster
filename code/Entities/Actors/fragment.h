

#import <UIKit/UIKit.h>
#import "AbstractEntity.h"


@interface Fragment : AbstractEntity {

}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Vector2f)aLocation   fragPiece:(int)pce;



@end
