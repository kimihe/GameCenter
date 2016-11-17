
#import "MainView.h"

@implementation MainView

- (void) drawRect: (CGRect) rect {      
    if (!gameManager) {
        gameManager = [GameManager getInstance];
    }
    
    [gameManager drawStatesWithFrame: rect];  
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {	
    CGPoint p = [[touches anyObject] locationInView: self];     
    [gameManager touchBegan: p];  
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {   
    CGPoint p = [[touches anyObject] locationInView: self];        
    [gameManager touchMoved: p];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    [gameManager touchEnded];     
}

- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event {
    [gameManager touchEnded];
}

@end
