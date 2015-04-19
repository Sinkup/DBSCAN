# DBSCAN
Objective-C Implementation of Density-Based Spatial Clustering of Applications with Noise 

基于密度的聚类算法


**Usage:**

```obj-c
    NSArray points = @[[NSValue valueWithCGPoint:CGPointMake(60, 40)],
                        [NSValue valueWithCGPoint:CGPointMake(20, 35)],
                        [NSValue valueWithCGPoint:CGPointMake(63, 67)]
                        /*...*/];
    DBSCAN *cluter = [[DBSCAN alloc] initWithRadius:100 minNumberOfPointsInCluster:2 andDistanceCalculator:^float(id obj1, id obj2) {
        CGPoint point1 = [(NSValue *)obj1 CGPointValue];
        CGPoint point2 = [(NSValue *)obj2 CGPointValue];
        
        CGFloat deltaX = point2.x - point1.x;
        CGFloat deltaY = point2.y - point1.y;
        
        return sqrtf(deltaX * deltaX + deltaY * deltaY);
    }];
    
    NSArray *results = [cluter clustersFromPoints:points];
```
