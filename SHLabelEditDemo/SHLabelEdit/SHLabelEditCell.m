//
//  SHLabelEditCell.m
//  SHLabelEdit
//
//  Created by shshy on 15/11/18.
//  Copyright © 2015年 expai. All rights reserved.
//

#import "SHLabelEditCell.h"
#import "SHLabelModel.h"

@interface SHLabelEditCell () {
    NSString *_title;
}

@property (nonatomic,strong) CALayer  *delLayer;

@end

@implementation SHLabelEditCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.delLayer = [CALayer layer];
        self.delLayer.frame = CGRectMake(frame.size.width-13 , -2, 15, 15);
        UIImage *image = [UIImage imageNamed:@"del.png"];
        self.delLayer.contents = (id)image.CGImage;
        [self.layer addSublayer:self.delLayer];
    }
    return self;
}

- (void)commitModel:(SHLabelModel *)model index:(NSIndexPath *)index {
    if (model) {
        self.delLayer.hidden = !model.edit;
        if (model.title) {
            _title = [model.title copy];
            [self setNeedsDisplay];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGRect textRect = [_title boundingRectWithSize:CGSizeMake(10000, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    CGRect newRect = CGRectMake((rect.size.width-textRect.size.width)/2, (rect.size.height-textRect.size.height)/2, textRect.size.width, textRect.size.height);
    [_title drawWithRect:newRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
}


@end
