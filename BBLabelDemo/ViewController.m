//
//  ViewController.m
//  BBLabelDemo
//
//  Created by Boby on 14/11/25.

#import "ViewController.h"
#import "BBLabel.h"
@interface ViewController ()
{
    BBLabel* contentLab;
    UIButton *changeNum;
    UIButton *changeText;
    UIButton *changeLineHight;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadSHLLabel];
    
    changeNum = [[UIButton alloc]initWithFrame:CGRectMake(20, 300, 60, 30)];
    [changeNum setBackgroundColor:[UIColor grayColor]];
    [changeNum setTitle:@"改变行" forState:UIControlStateNormal];
    [changeNum addTarget:self action:@selector(changeNumClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeNum];
    
    changeText = [[UIButton alloc]initWithFrame:CGRectMake(130, 300, 60, 30)];
    changeText.tag = 100;
    [changeText setBackgroundColor:[UIColor grayColor]];
    [changeText setTitle:@"改文字" forState:UIControlStateNormal];
    [changeText addTarget:self action:@selector(changeTextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeText];
    
    changeLineHight = [[UIButton alloc]initWithFrame:CGRectMake(240, 300, 60, 30)];
    [changeLineHight setBackgroundColor:[UIColor grayColor]];
    [changeLineHight setTitle:@"改行高" forState:UIControlStateNormal];
    [changeLineHight addTarget:self action:@selector(changeLineHightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeLineHight];
}

//自定义Label
- (void) loadSHLLabel
{
    
    contentLab = [[BBLabel alloc] init];
    contentLab.text = @"腾讯首款3D轻动作跑酷手游《天天风之旅》至今已发布炎、白雪、忍者、狐妖、游戏宅与青蛙王子六大角色。唯美的造型与独特的技能让他们人气十足";;
    contentLab.font = [UIFont systemFontOfSize:16];
    contentLab.numberOfLines = 2;
    contentLab.linesSpace = 20;
    contentLab.textColor = [UIColor whiteColor];
    contentLab.backgroundColor = [UIColor grayColor];
    contentLab.frame = CGRectMake(20, 60, 280, [contentLab wordsDrawInViewHeightWithWidth:280.0f]);
    [self.view addSubview:contentLab];
}

- (void) changeNumClick
{
    if (contentLab.numberOfLines == 0)
    {
        contentLab.numberOfLines = 2;
    }
    else
    {
        contentLab.numberOfLines = 0;
    }
    contentLab.frame = CGRectMake(20, 60, 280, [contentLab wordsDrawInViewHeightWithWidth:280.0f]);
}

- (void) changeTextClick:(UIButton *)btn
{
    
    if (btn.tag == 100)
    {
        btn.tag = 101;
        contentLab.text = @"BBLabel是一个自动换行，能设置行高的Label";
    }
    else
    {
        btn.tag = 100;
        contentLab.text = @"腾讯首款3D轻动作跑酷手游《天天风之旅》至今已发布炎、白雪、忍者、狐妖、游戏宅与青蛙王子六大角色。唯美的造型与独特的技能让他们人气十足";
    }
    contentLab.frame = CGRectMake(20, 60, 280, [contentLab wordsDrawInViewHeightWithWidth:280.0f]);
}

- (void) changeLineHightClick
{
    if (contentLab.linesSpace == 20)
    {
        contentLab.linesSpace = 10;
    }
    else
    {
        contentLab.linesSpace = 20;
    }
    contentLab.frame = CGRectMake(20, 60, 280, [contentLab wordsDrawInViewHeightWithWidth:280.0f]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
