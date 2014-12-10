//
//  IBViewController.h
//  Icebreaker
//
//  Created by iD Student on 7/24/14.
//
//

#import <UIKit/UIKit.h>
#import "IBPerson.h"
#import "IBMatchedViewController.h"
#import "IBPartytSetupViewController.h"

@class  IBPartytSetupViewController;

@interface IBViewController : UIViewController  <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *finalHobbies;
    
    UIImage *userPhoto;
    
    BOOL isHoster;
}

@property (strong, nonatomic) NSMutableArray *hobbies;

@property (strong, nonatomic) NSString *partyName;
@property (strong, nonatomic) NSString *partyMessage;

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *messsageLabel;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *customCategoryTF;
@property (strong, nonatomic) IBOutlet UITextField *pinTF;
@property (strong, nonatomic) IBOutlet UITextField *settingsPinTF;

@property (strong, nonatomic) IBOutlet UICollectionView *categoryCollectionView;

@property (strong, nonatomic) IBPartytSetupViewController *partySetupVC;

@end
