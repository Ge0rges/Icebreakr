//
//  IBPartytSetupViewController.h
//  Icebreakr
//
//  Created by iD Student on 7/24/14.
//
//

#import <UIKit/UIKit.h>
#import "IBViewController.h"

@interface IBPartytSetupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *messageTF;
@property (strong, nonatomic) IBOutlet UITextField *pinTF;
@property (strong, nonatomic) IBOutlet UITextField *customCategoryTF;

@property (strong, nonatomic) NSMutableArray *finalHobbies;
@property (strong, nonatomic) NSMutableArray *hobbies;

@property (strong, nonatomic) IBOutlet UITableView *categoriesTableView;

@end