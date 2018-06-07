//
//  URMainLessionTableViewCell.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/7.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class URMainSuggestionItem;

@protocol AutoLayoutTableViewCellDelegate<NSObject>

- (void)needUpdateConstraintCell;

@end

@interface URMainLessionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AutoLayoutTableViewCellDelegate> cellDelegate;

@property (nonatomic, strong) URMainSuggestionItem      *item;

@end
