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
#import "PlayerViewController.h"
#import "LoadSqlistData.h"
#import <sqlite3.h>
#import "GroupMedol.h"
#import "ProgramsMedol.h"



#define imageWidth  (TSWedth - 50)/2
#define imageHeight (imageWidth + 30)
#define kDataBaseName @"LizhiFM.sqlite"


@interface HomeViewController () <OnclickItemViewDelegate>
{
    PlayerViewController *playerVC;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIButton *playerbutton;


@property (nonatomic,strong)NSMutableArray *infoArrays;

@property (strong,nonatomic)NSMutableArray *groupMedols;

@property (strong,nonatomic)NSMutableArray *programsMedols;


@property (strong,nonatomic) NSTimer *timer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMP3SqliteData];
    
    
    [self loadData];
    
    [self setScrollView];
    [self addViewToScrollView];
    
    // pauseMP3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAction) name:@"pauseMP3" object:nil];
    // playMP3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAction) name:@"playMP3" object:nil];
    
    
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerdataaction) userInfo:nil repeats:YES];
    }
    return  _timer;
}

#pragma mark--监听的方法
-(void)pauseAction
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)playAction
{
    [self.timer setFireDate:[NSDate distantPast]];
}



//播放按钮动画
- (void)timerdataaction
{
    NSArray *values = @[@"topbar_musicplayer_1",
                        @"topbar_musicplayer_2",
                        @"topbar_musicplayer_3",
                        @"topbar_musicplayer_4",
                        @"topbar_musicplayer_5"];
    NSString *str = values[arc4random()%5];
    [self.playerbutton setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    
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
        itemView.markTag = i;
        itemView.delegate = self;
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

-(void)loadMP3SqliteData
{
    sqlite3 *mysqlite = [LoadSqlistData openSqlite3dataBase:kDataBaseName];
    
    NSString *selectSQL1 = @"SELECT * FROM groups";
    self.groupMedols = [LoadSqlistData loadMP3GroupData:selectSQL1 withDataBase:mysqlite];
    NSString *selectSQL2 = @"SELECT * FROM programs";
    self.programsMedols = [LoadSqlistData loadMP3ProgramsData:selectSQL2 withDataBase:mysqlite];
}


-(void)OnClickViewkwithItem:(int)markTag 
{
    
    StorydetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"StorydetailViewController"];

    detail.medol = self.infoArrays[markTag];
    
    NSMutableArray *programsItemArray = [[NSMutableArray alloc]init];
    
    for (GroupMedol *groupMedol in self.groupMedols) {
    
        if ( ![groupMedol.title isEqualToString:detail.medol.title] ) {
        }else
        {   
            detail.groupId = groupMedol.groupId;
            
            for ( ProgramsMedol *programMedol in self.programsMedols) {
                if ([programMedol.radioId isEqualToString:groupMedol.groupId]) {
                    [programsItemArray addObject:programMedol];
                }
            }

            detail.programsMedolArray = programsItemArray;

            break ;

        }
        
        
    }
    
    
    [self.navigationController pushViewController:detail animated:NO];

}


- (IBAction)pushplayerbuttonaction:(UIButton *)sender {
    
    playerVC = [PlayerViewController defaultPlayerController];
        playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:playerVC animated:YES completion:nil];
    
}


-(NSMutableArray *)infoArrays
{
    if (_infoArrays == nil) {
        _infoArrays = [[NSMutableArray alloc]init];
    }
    return _infoArrays;
}

-(NSMutableArray *)groupMedols
{
    if (_groupMedols == nil) {
        _groupMedols = [[NSMutableArray alloc]init];
    }
    return _groupMedols;
}

-(NSMutableArray *)programsMedols
{
    if (_programsMedols == nil) {
        _programsMedols = [[NSMutableArray alloc]init];
    }
    return _programsMedols;
}
@end
