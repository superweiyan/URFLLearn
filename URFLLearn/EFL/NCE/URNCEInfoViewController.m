//
//  URNCEInfoViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/9.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEInfoViewController.h"
#import "URNCEModule.h"
#import "URModuleManager.h"

@interface URNCEInfoViewController ()

@end

@implementation URNCEInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadData
{
    NSString *jsonPath = [self.volumePath stringByAppendingPathComponent:@"content.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError* error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    NSLog(@"%@", json);
}

@end
