
#import "Car.h"
#import "GameManager.h"

@implementation Car

- (void) draw {        
    [super draw];  
    if (pos.y > H + 100) {
        pos.y = -100;
        speed.y += 0.1; 
    }    
}
    
@end