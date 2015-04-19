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
    
    DBSCAN *cluter = [[DBSCAN alloc] initWithRadius:256 minNumberOfPointsInCluster:2 andDistanceCalculator:^float(id obj1, id obj2) {
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
