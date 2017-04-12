//
//  TableViewCell.m
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.//
#import "NSString+category.h"
#import "UILabel+category.h"
#import "UIColor+category.h"
#import "TableViewCell.h"
#import "VideoModel.h"
#import "Header.h"

@interface TableViewCell ()

@property (nonatomic, strong) UIImageView *posterImageView; //缩略图

@property (nonatomic, strong) UILabel *titleLabel; //标题

@property (nonatomic, strong) UILabel *videoSize; //视频大小

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self layoutSetting];
    }
    return self;
}

- (void)layoutSetting {
    
    self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, H(10),W(100),H(80))];
    [self.contentView addSubview:self.posterImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.posterImageView.frame) + 10, 10, kScreenWidth - CGRectGetMaxX(self.posterImageView.frame) - 50 , H(30))];
    [self.contentView addSubview:self.titleLabel];
    
    self.videoSize = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.posterImageView.frame) + 10, CGRectGetMaxY(self.titleLabel.frame) + 10,kScreenWidth - CGRectGetMaxX(self.posterImageView.frame) - 50, H(30))];
    [self.contentView addSubview:self.videoSize];
    
}

- (void)setModel:(VideoModel *)model {
    if (_model != model) {
        _model = model;
        self.titleLabel.text = [NSString stringWithFormat:@"视频名称：%@",model.videoName];
        self.videoSize.text = [NSString stringWithFormat:@"视频大小：%@",[NSString byteUnitConvert:model.videoSize]];
        self.posterImageView.image = [UIImage imageWithContentsOfFile:model.videoImgPath];
    }
}

@end
