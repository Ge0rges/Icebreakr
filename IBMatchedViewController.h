//
//  IBMatchedViewController.h
//  Icebreakr
//
//  Created by iD Student on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import "IBPerson.h"

@interface IBMatchedViewController : UIViewController

@property (strong, nonatomic) IBPerson *person;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UILabel *interestsLabel1;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UILabel *interestsLabel2;

@end
