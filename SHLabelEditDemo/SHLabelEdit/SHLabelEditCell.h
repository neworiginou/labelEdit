//
//  SHLabelEditCell.h
//  SHLabelEdit
//
//  Created by shshy on 15/11/18.
//  Copyright © 2015年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHLabelModel;

@interface SHLabelEditCell : UICollectionViewCell

- (void)commitModel:(SHLabelModel *)model index:(NSIndexPath *)index;

@end
