//
//  MyTeamTableViewCell.h
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamModel.h"
//是否选中的block回调
typedef void(^slectedBlock) (BOOL select);
//数量改变的block
typedef void(^changeBlock) ();

//删除
typedef void (^delegeButtonBlock) ();

@interface MyTeamTableViewCell : UITableViewCell

//选中
@property (nonatomic) slectedBlock cartBlock;
//➖
@property (nonatomic)changeBlock cutBlock;
//➕
@property (nonatomic)changeBlock addBlock;
//加好按钮
@property (nonatomic)UIButton *addBtn;
//减号按钮
@property (nonatomic)UIButton *cutButton;

//删除
@property (nonatomic)delegeButtonBlock delegeBlock;





//选着按钮
@property (nonatomic,strong)UIButton * selectedButton;
//头像
@property (nonatomic,strong)UIImageView *headerImageView;
//车的类型
@property (nonatomic,strong)UILabel *carTypeLabel;
//定金
@property (nonatomic,strong)UILabel *moneyLabel;
//选中数量
@property (nonatomic,strong)UILabel *numberLabel;

//是否用着头车的按钮
@property (nonatomic,strong)UIButton *headerCarButton;
@property (nonatomic,strong)UIImageView *carImageView;
//删除按钮
@property (nonatomic,strong)UIButton *deleteButton;
 
//是否被选中按钮
@property (nonatomic,assign)BOOL isSelected;



-(void)reloadDataWith:(MyTeamModel*)model WithSuperController:(UIViewController*)superController;




@end
