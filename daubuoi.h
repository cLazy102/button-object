#import <UIKit/UIKit.h>

@interface nutbatnoi : NSObject <UIGestureRecognizerDelegate>
- (instancetype)initWithTitle:(NSString *)tieude flagPtr:(bool *)contro_co;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *offColor;
@property (nonatomic, assign, readonly) BOOL dangbat;
@property (nonatomic, copy) void (^onToggle)(BOOL dangbat);
- (void)show;
- (void)hide;
- (void)syncFromFlag;
@end