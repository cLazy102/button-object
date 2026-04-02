
#import <UIKit/UIKit.h>

@interface nutbatnoi : NSObject <UIGestureRecognizerDelegate>
- (instancetype)initWithTitle:(NSString *)tieude flagptr:(bool *)controco;
@property (nonatomic, strong) UIColor *mauon;
@property (nonatomic, strong) UIColor *mauoff;
@property (nonatomic, assign, readonly) BOOL dangbat;
@property (nonatomic, copy) void (^onToggle)(BOOL dangbat);
- (void)show;
- (void)hide;
- (void)dongboflag;
- (void)ganhienptr:(bool *)hienptr;
+ (instancetype)taotoancuc:(NSString *)tieude flagptr:(bool *)flagptr hienptr:(bool *)hienptr mauon:(UIColor *)mauon mauoff:(UIColor *)mauoff;
@end

#pragma mark - khungchamxuyen (Chào các hắc cơ)
@interface khungchamxuyen : UIView
@end

@implementation khungchamxuyen
- (UIView *)hitTest:(CGPoint)diem withEvent:(UIEvent *)sukien {
    UIView *trung = [super hitTest:diem withEvent:sukien];
    return (trung == self) ? nil : trung;
}
@end

#pragma mark - nút đa năng

@interface nutbatnoi () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) khungchamxuyen *khung;
@property (nonatomic, strong) UIButton *nut;
@property (nonatomic, assign) bool *controco;
@property (nonatomic, assign, readwrite) BOOL dangbat;
@property (nonatomic, copy) NSString *tieude;
@property (nonatomic, assign) bool *hienptr;
@property (nonatomic, assign) BOOL dangbatcu;
@property (nonatomic, assign) BOOL hiencu;
@end

@implementation nutbatnoi

static NSMutableArray<nutbatnoi *> *danhsachnut;
static CADisplayLink *dongbo;

+ (void)ticktoancuc {
    NSArray<nutbatnoi *> *arr = [danhsachnut copy];
    for (nutbatnoi *bt in arr) {
        [bt ticktudong];
    }
}

+ (void)dongbochay:(CADisplayLink *)link {
    (void)link;
    [self ticktoancuc];
}

- (instancetype)initWithTitle:(NSString *)tieude flagptr:(bool *)controco {
    self = [super init];
    if (!self) return nil;
    _tieude = tieude.length ? tieude : @"nut";
    _controco = controco;
    if (controco) _dangbat = (*controco) ? YES : NO;
    else _dangbat = NO;
    _mauon = [UIColor colorWithRed:0.15 green:0.85 blue:0.35 alpha:1.0];
    _mauoff = [UIColor colorWithRed:1.00 green:0.25 blue:0.25 alpha:1.0];
    _dangbatcu = _dangbat;
    _hiencu = YES;
    return self;
}

- (void)show {
    if (self.khung) { self.khung.hidden = NO; [self capnhathienthi]; return; }
    CGFloat rong = 42, cao = 42;
    CGFloat gocx = UIScreen.mainScreen.bounds.size.width - 70.0;
    CGFloat gocy = UIScreen.mainScreen.bounds.size.height - 250.0;
    self.khung = [[khungchamxuyen alloc] initWithFrame:CGRectMake(gocx, gocy, rong, cao)];
    self.khung.backgroundColor = UIColor.clearColor;
    self.khung.userInteractionEnabled = YES;
    self.khung.multipleTouchEnabled = YES;
    self.khung.exclusiveTouch = NO;
    UIPanGestureRecognizer *keo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(keo:)];
    keo.cancelsTouchesInView = NO;
    keo.delaysTouchesBegan = NO;
    keo.delaysTouchesEnded = NO;
    keo.minimumNumberOfTouches = 1;
    keo.maximumNumberOfTouches = 1;
    keo.delegate = self;
    if ([keo respondsToSelector:@selector(setRequiresExclusiveTouchType:)]) keo.requiresExclusiveTouchType = NO;
    [self.khung addGestureRecognizer:keo];
    self.nut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nut.frame = self.khung.bounds;
    self.nut.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.nut.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    self.nut.layer.cornerRadius = MIN(rong, cao) * 0.5f;
    self.nut.clipsToBounds = YES;
    self.nut.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];// size chưx
    self.nut.multipleTouchEnabled = YES;
    self.nut.exclusiveTouch = NO;
    [self.khung addSubview:self.nut];
    UITapGestureRecognizer *cham = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cham)];
    cham.numberOfTapsRequired = 1;
    cham.delegate = self;
    if ([cham respondsToSelector:@selector(setRequiresExclusiveTouchType:)]) cham.requiresExclusiveTouchType = NO;
    [self.nut addGestureRecognizer:cham];
    [cham requireGestureRecognizerToFail:keo];
    UIWindow *cuaso = [self cuasototnhat];
    if (!cuaso) cuaso = UIApplication.sharedApplication.keyWindow;
    UIView *goc = cuaso.rootViewController.view ?: cuaso;
    cuaso.multipleTouchEnabled = YES;
    goc.multipleTouchEnabled = YES;
    goc.exclusiveTouch = NO;
    [goc addSubview:self.khung];
    [self capnhathienthi];
}

- (void)hide {
    if (!self.khung) return;
    [self.khung removeFromSuperview];
    self.khung = nil;
    self.nut = nil;
}

- (void)dongboflag {
    if (self.controco) {
        self.dangbat = (*self.controco) ? YES : NO;
        [self capnhathienthi];
    }
}

- (void)capnhathienthi {
    if (!self.nut) return;
    NSString *tieude = self.tieude ?: @"nut";
    [self.nut setTitle:tieude forState:UIControlStateNormal];
    UIColor *mau = self.dangbat ? (self.mauon ?: [UIColor greenColor]) : (self.mauoff ?: [UIColor redColor]);
    [self.nut setTitleColor:mau forState:UIControlStateNormal];
    self.nut.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    self.nut.transform = CGAffineTransformMakeScale(0.90, 0.90);
    } completion:^(__unused BOOL xong) {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    self.nut.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)cham {
    self.dangbat = !self.dangbat;
    if (self.controco) *self.controco = self.dangbat ? true : false;
    [self capnhathienthi];
    if (self.onToggle) self.onToggle(self.dangbat);
    self.dangbatcu = self.dangbat;
}

- (void)keo:(UIPanGestureRecognizer *)g {
    UIView *v = self.khung;
    if (!v || !v.superview) return;
    CGPoint dich = [g translationInView:v.superview];
    if (g.state == UIGestureRecognizerStateChanged || g.state == UIGestureRecognizerStateEnded) {
    CGPoint tam = CGPointMake(v.center.x + dich.x, v.center.y + dich.y);
    CGFloat nuarong = v.bounds.size.width * 0.5f;
    CGFloat nuacao = v.bounds.size.height * 0.5f;
    CGFloat maxx = v.superview.bounds.size.width - nuarong;
    CGFloat maxy = v.superview.bounds.size.height - nuacao;
    CGFloat minx = nuarong;
    CGFloat miny = nuacao;
    tam.x = fmin(fmax(tam.x, minx), maxx);
    tam.y = fmin(fmax(tam.y, miny), maxy);
    v.center = tam;
    [g setTranslation:CGPointZero inView:v.superview];
    }
}

- (UIWindow *)cuasototnhat {
    if (@available(iOS 13.0, *)) {
        for (UIScene *canh in UIApplication.sharedApplication.connectedScenes) {
            if (canh.activationState == UISceneActivationStateForegroundActive &&
                [canh isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in ((UIWindowScene *)canh).windows) {
                    if (w.isKeyWindow) return w;
                }
            }
        }
    }
    return UIApplication.sharedApplication.keyWindow;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gr shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)khac {
    return YES;
}

- (void)ganhienptr:(bool *)hienptr {
    _hienptr = hienptr;
    _hiencu = hienptr ? (*hienptr ? YES : NO) : YES;
    _dangbatcu = self.controco ? (*self.controco ? YES : NO) : self.dangbat;
}

- (void)ticktudong {
    BOOL hien = self.hienptr ? (*self.hienptr ? YES : NO) : YES;
    if (hien != self.hiencu) {
    self.hiencu = hien;
    if (hien) [self show];
    else [self hide];
    }

    BOOL on = self.controco ? (*self.controco ? YES : NO) : self.dangbat;
    if (on != self.dangbatcu) {
    self.dangbatcu = on;
    self.dangbat = on;
    [self capnhathienthi];
    }
}

+ (instancetype)taotoancuc:(NSString *)tieude flagptr:(bool *)flagptr hienptr:(bool *)hienptr mauon:(UIColor *)mauon mauoff:(UIColor *)mauoff
{
    if (!danhsachnut) danhsachnut = [NSMutableArray new];
    nutbatnoi *bt = [[nutbatnoi alloc] initWithTitle:tieude flagptr:flagptr];
    if (mauon)  bt.mauon  = mauon;
    if (mauoff) bt.mauoff = mauoff;
    [bt ganhienptr:hienptr];
    [bt ticktudong];
    [danhsachnut addObject:bt];
    if (!dongbo) {
    dongbo = [CADisplayLink displayLinkWithTarget:[nutbatnoi class] selector:@selector(dongbochay:)];
    [dongbo addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }

    return bt;
}

@end