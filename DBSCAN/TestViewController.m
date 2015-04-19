//
//  TestViewController.m
//  DBSCAN
//
//  Created by RealCloud on 14-7-21.
//  Copyright (c) 2014年 RealCloud. All rights reserved.
//

#import "TestViewController.h"
#import "DBSCAN.h"

@interface TestViewController ()

@property (nonatomic, retain) NSArray *points;

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.points = @[[NSValue valueWithCGPoint:CGPointMake(60, 40)],
//                        [NSValue valueWithCGPoint:CGPointMake(20, 35)],
//                        [NSValue valueWithCGPoint:CGPointMake(63, 67)],
//                        [NSValue valueWithCGPoint:CGPointMake(25, 20)],
//                        [NSValue valueWithCGPoint:CGPointMake(30, 23)],
//                        [NSValue valueWithCGPoint:CGPointMake(23, 56)],
//                        [NSValue valueWithCGPoint:CGPointMake(158, 455)],
//                        [NSValue valueWithCGPoint:CGPointMake(34, 123)],
//                        [NSValue valueWithCGPoint:CGPointMake(304, 212)],
//                        [NSValue valueWithCGPoint:CGPointMake(131, 200)],
//                        [NSValue valueWithCGPoint:CGPointMake(110, 240)],
//                        [NSValue valueWithCGPoint:CGPointMake(140, 206)],
//                        [NSValue valueWithCGPoint:CGPointMake(130, 280)],
//                        [NSValue valueWithCGPoint:CGPointMake(212, 420)],
//                        [NSValue valueWithCGPoint:CGPointMake(120, 320)],
//                        [NSValue valueWithCGPoint:CGPointMake(20, 290)],
//                        [NSValue valueWithCGPoint:CGPointMake(70, 250)],
//                        [NSValue valueWithCGPoint:CGPointMake(250, 260)],
//                        [NSValue valueWithCGPoint:CGPointMake(190, 450)],
//                        [NSValue valueWithCGPoint:CGPointMake(170, 410)],
//                        [NSValue valueWithCGPoint:CGPointMake(290, 40)],
//                        [NSValue valueWithCGPoint:CGPointMake(40, 305)],
//                        [NSValue valueWithCGPoint:CGPointMake(54, 434)],
//                        [NSValue valueWithCGPoint:CGPointMake(38, 20)],
//                        [NSValue valueWithCGPoint:CGPointMake(88, 23)],
//                        [NSValue valueWithCGPoint:CGPointMake(23, 56)],
//                        [NSValue valueWithCGPoint:CGPointMake(178, 455)],
//                        [NSValue valueWithCGPoint:CGPointMake(34, 234)],
//                        [NSValue valueWithCGPoint:CGPointMake(304, 520)],
//                        [NSValue valueWithCGPoint:CGPointMake(131, 134)],
//                        [NSValue valueWithCGPoint:CGPointMake(110, 222)],
//                        [NSValue valueWithCGPoint:CGPointMake(140, 206)],
//                        [NSValue valueWithCGPoint:CGPointMake(130, 280)],
//                        [NSValue valueWithCGPoint:CGPointMake(112, 420)],
//                        [NSValue valueWithCGPoint:CGPointMake(120, 320)],
//                        [NSValue valueWithCGPoint:CGPointMake(80, 290)],
//                        [NSValue valueWithCGPoint:CGPointMake(70, 250)],
//                        [NSValue valueWithCGPoint:CGPointMake(250, 260)],
//                        [NSValue valueWithCGPoint:CGPointMake(165, 450)],
//                        [NSValue valueWithCGPoint:CGPointMake(200, 410)],
//                        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    self.points = [NSArray arrayWithContentsOfFile:[path stringByAppendingPathComponent:@"points"]];
    self.points = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"points"]];
    if (!self.points || self.points.count <= 0) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        int32_t width = size.width;
        int32_t height = size.height;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1000];
        for (NSInteger index = 0; index < 1000; index++) {
            CGPoint point = CGPointMake(arc4random() % width * 1.0, arc4random() % height * 1.0);
            [array addObject:[NSValue valueWithCGPoint:point]];
        }
        
//        BOOL success = [array writeToFile:[path stringByAppendingPathComponent:@"points"] atomically:YES];
        [NSKeyedArchiver archiveRootObject:array toFile:[path stringByAppendingPathComponent:@"points"]];
        self.points = array;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DBSCAN *cluter = [[DBSCAN alloc] initWithRadius:100 minNumberOfPointsInCluster:2 andDistanceCalculator:^float(id obj1, id obj2) {
        CGPoint point1 = [(NSValue *)obj1 CGPointValue];
        CGPoint point2 = [(NSValue *)obj2 CGPointValue];
        
        CGFloat deltaX = point2.x - point1.x;
        CGFloat deltaY = point2.y - point1.y;
        
//        return sqrtf(deltaX * deltaX + deltaY * deltaY);
        return (deltaX * deltaX + deltaY * deltaY);
    }];
    
    NSLog(@"start...");
    NSArray *results = [cluter clustersFromPoints:self.points];
    
//    NSLog(@"done: %@", results);
    NSLog(@"done.");
    [self drawWithPoints:results];
    [self drawWithPoints:cluter.noisePoints];
}

- (void)drawWithPoints:(NSArray *)points
{
    for (id obj in points) {
        if ([obj isKindOfClass:[NSArray class]]) {
            UIColor *color = [self randomColor];
//            if ([(NSArray *)obj count] < 3) {
//                color = [UIColor blackColor];
//            }
            for (NSValue *point in obj) {
                UIView *view = [self circleViewAtPoint:[point CGPointValue] withRaduis:5];
                view.backgroundColor = color;
                [self.view addSubview:view];
            }
        } else {
            UIView *view = [self circleViewAtPoint:[(NSValue *)obj CGPointValue] withRaduis:5];
            view.backgroundColor = [UIColor blackColor];
            [self.view addSubview:view];
        }
    }
}

- (UIView *)circleViewAtPoint:(CGPoint)center withRaduis:(CGFloat)raduis
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, raduis * 2, raduis * 2)];
    view.center = center;
    view.layer.cornerRadius = raduis;
    view.clipsToBounds = YES;
    
    return view;
}

- (UIColor *)randomColor
{
    int r1 = arc4random() % 200 + 40;
    int r2 = arc4random() % 200 + 40;
    int r3 = arc4random() % 200 + 40;
    return [UIColor colorWithRed:r1/255.0 green:r2/255.0 blue:r3/255.0 alpha:1.0];
}



@end
