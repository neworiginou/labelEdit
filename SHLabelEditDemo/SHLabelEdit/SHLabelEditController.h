//
//  SHLabelEditController.h
//  SHLabelEdit
//
//  Created by shshy on 15/11/18.
//  Copyright © 2015年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHLabelModel;

@interface SHLabelEditController : UIViewController

typedef void(^selectHandler)(SHLabelModel *model,NSInteger index);
typedef void(^resultHandler)(NSArray *models);

- (instancetype)initWithCurrentChannelIndex:(NSInteger)index
                                 myChannels:(NSArray *)myChannels
                                recChannels:(NSArray *)recChannels
                              selectHandler:(selectHandler)select
                              resultHandler:(resultHandler)result;


@end
