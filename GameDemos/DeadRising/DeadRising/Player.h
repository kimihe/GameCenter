
#import "Zombie.h"

@interface Player : Zombie {    
    int health;
}

- (void) setHealth: (int) hlth;
- (int) getHealth;

@end
