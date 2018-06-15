//
//  URNCEDownloadTableViewCell.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/11.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URNCEDownloadTableViewCell : UITableViewCell

@property (nonatomic,   strong) NSString *tipName;
@property (nonatomic,   assign) CGFloat  progressValue;
@property (nonatomic,   strong) NSString *url;

@end
