//
//  HomeController.m
//  LaoliangStory
//
//  Created by tens on 15-10-19.
//  Copyright (c) 2015年 tens. All rights reserved.
//

#import "HomeViewController.h"
#import "StorydetailViewController.h"
#import "ItemView.h"
#import "ItemMedol.h"


#define imageWidth  (TSWedth - 50)/2
#define imageHeight (imageWidth + 30)


@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (nonatomic,strong)NSMutableArray *infoArrays;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_topbar"] forBarMetrics:UIBarMetricsDefault];
    // 设置字体的颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    [self loadData];
    
    [self setScrollView];
    [self addViewToScrollView];
    
    

}

#pragma mark-- 设置ScrollView
-(void)setScrollView{

    self.myScrollView.contentSize = CGSizeMake(TSWedth, (imageHeight + 10) * 4);
}

-(void)addViewToScrollView
{

    ItemView *itemView = nil;
    for (int i = 0; i < 7 ; i++) {
        
        itemView = [[[NSBundle mainBundle]loadNibNamed:@"ItemView"owner:self options:nil]lastObject];
        [self.myScrollView addSubview:itemView];
        CGFloat itemViewX = 15;
        CGFloat itemViewY = 15 + (i / 2) * (imageWidth +50);
        if (i % 2 != 0) {
            itemViewX = 30 +imageWidth ;
        }
        itemView.frame = CGRectMake(itemViewX, itemViewY, imageWidth, imageHeight);
        
        itemView.medol = self.infoArrays[i];
    }
}

#pragma mark-- 加载数据
-(void)loadData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"];

    NSArray *medolArrays = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dictionary in medolArrays) {
        ItemMedol *medol = [[ItemMedol alloc]initWithDictary:dictionary];
        [self.infoArrays addObject:medol];
    }

}



//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    StorydetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"StorydetailViewController"];
//    [self.navigationController pushViewController:detail animated:YES];
//    
//}

-(NSMutableArray *)infoArrays
{
    if (_infoArrays == nil) {
        _infoArrays = [[NSMutableArray alloc]init];
    }
    return _infoArrays;
}


@end