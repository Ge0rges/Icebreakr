//
//  IBViewController.m
//  Icebreakr
//
//  Created by iD Student on 7/24/14.
//
//

#import "IBViewController.h"

@interface IBViewController ()

@end

@implementation IBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //set the labels
    if (![self.partyName isEqualToString:@""] && ![self.partyName isEqualToString:@" "]) {
        self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome to %@", self.partyName];
    } else {
        self.partyName = @"the Party";
    }
    
    if (![self.partyMessage isEqualToString:@""] && ![self.partyMessage isEqualToString:@" "]) {
        self.messsageLabel.text = [NSString stringWithFormat:@"%@, Please take a moment to fill out this form.", self.partyMessage];
    } else {
        self.partyMessage = self.messsageLabel.text;
    }
    
    //init the final hobbies
    finalHobbies = [NSMutableArray new];
    
    //set if this is the hoster
    NSMutableArray *people = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"data"]];
    if (people.count == 0) isHoster = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.hobbies count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //get the cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //get the button
    UIButton *button = (UIButton *)[cell viewWithTag:1];
    
    //set the cell title
    [button setTitle:[self.hobbies objectAtIndex:indexPath.row] forState:UIControlStateNormal];//then get the title from the hobbies array
    
    //set the background color depending if the object is in the finalhobbies
    button.backgroundColor = [UIColor colorWithRed:139/255.0 green:28/255.0 blue:61/255.0 alpha:1.0];
    if ([finalHobbies containsObject:button.titleLabel.text]) {//if the category is in the finalHobbies array
        button.backgroundColor = [UIColor colorWithRed:120/255.0 green:213/255.0 blue:152/255.0 alpha:1.0];//then make the background green
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];//get the cell
    //get the button
    UIButton *button = (UIButton *)[cell viewWithTag:1];
    
    if ([button.backgroundColor isEqual:[UIColor colorWithRed:120/255.0 green:213/255.0 blue:152/255.0 alpha:1.0]]) {//if the background is green (selected)
        button.backgroundColor = [UIColor colorWithRed:139/255.0 green:28/255.0 blue:61/255.0 alpha:1.0];//make the background red
        [finalHobbies removeObject:button.titleLabel.text];//remove the hobby
    } else {//otherwise
        button.backgroundColor = [UIColor colorWithRed:120/255.0 green:213/255.0 blue:152/255.0 alpha:1.0];//then make the background green
        [finalHobbies addObject:button.titleLabel.text];//add the hobby
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//deselect the row
    
    //hide the keyboard if user starts selecting categories
    //get the first responder
    id firstResponder;
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            firstResponder = subView;
        }
    }
    
    //resign the firstRespionder
    [firstResponder resignFirstResponder];
}

#pragma mark - UITextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.pinTF) [self endParty:nil];
    if (textField == self.customCategoryTF) [self addCategory:nil];
    if (textField == self.settingsPinTF) [self settings:nil];

    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.pinTF.alpha == 1 && self.pinTF.text.length == 0) {
        [UIView animateWithDuration:0.3 animations:^{self.pinTF.alpha = 0;}];
    }
    if (self.settingsPinTF.alpha == 1 && self.settingsPinTF.text.length == 0) {
        [UIView animateWithDuration:0.3 animations:^{self.settingsPinTF.alpha = 0;}];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //set the image as the persons photo
    userPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //populate the imageView
    [self.profileImageView setImage:userPhoto];
    
    //dismiss the vc
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //remove the add photo label
    [self.view viewWithTag:5].hidden = YES;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //dismiss the vc
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions
- (IBAction)takePhoto:(UIButton *)sender {
    //create a UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //configure it
    picker.allowsEditing = YES;
    picker.title = @"Take a photo so people can recognize you!";
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //show the image picker
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)done:(UIButton *)sender {
    if (self.nameTF.text.length == 0 || self.emailTF.text.length == 0 || userPhoto == nil || finalHobbies.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please Fill in all fields" message:@"It seems you either didn't fill out all the forms or didn't choose a hobby or didn't take a picture." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    } else {
        
        //disable the done button
        sender.enabled = NO;
        
        //create a person
        __block IBPerson *person = [IBPerson new];
        
        //configure the properties
        person.hobbies = [finalHobbies copy];
        person.name = self.nameTF.text;
        person.email = self.emailTF.text;
        person.partyName = self.partyName;
        person.photo = userPhoto;
        
        //add him to the array and write the array to the plist
        NSMutableArray *people = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"data"]];
        if (!people) {
            people = [NSMutableArray new];
        }
        
        [people addObject:person];
        NSData *peopleData = [NSKeyedArchiver archivedDataWithRootObject:people];
        [[NSUserDefaults standardUserDefaults] setObject:peopleData forKey:@"data"];
        
        //show the matched vc after the user is matched
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //generate the matches
            [person matchUpWithPeople:people];
            
            //show the vc only if the person has a match
            if (person.top2MatchedPeople.count > 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
                
                IBMatchedViewController *mvc = [storyboard instantiateViewControllerWithIdentifier:@"MatchedVC"];
                
                //configure the vc
                mvc.person = person;
                
                //present the main view controller
                [self presentViewController:mvc animated:YES completion:nil];
            
            } else if (!isHoster) {
                //no matches show a alert view
                [[[UIAlertView alloc] initWithTitle:@"Sorry no matches" message:@"Sorry we couldn't find any matches right now, try again later or tell your host to invite more people." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            
            //empty the fields
            self.nameTF.text = @"";
            self.emailTF.text = @"";
            
            //free any variables we don't need and empty the final hobbies array
            [finalHobbies removeAllObjects];
            person = nil;
            userPhoto = nil;
            
            //refresh the categories
            [self.categoryCollectionView reloadData];
            
            //add photo label
            [self.view viewWithTag:5].hidden = NO;
            
            //re enable the button
            sender.enabled = YES;
            
        });
    }
}

- (IBAction)endParty:(UIButton *)sender {
    NSString *pin = [[NSUserDefaults standardUserDefaults] stringForKey:@"pin"];
    if ([self.pinTF.text isEqualToString:pin]) {//make sure the user is authorized
        //empty the data and rewrite it to the [plist
        NSData *peopleData = [NSKeyedArchiver archivedDataWithRootObject:nil];
        [[NSUserDefaults standardUserDefaults] setObject:peopleData forKey:@"data"];
        
        //reset the vc
        //clear the fields
        self.partySetupVC.pinTF.text = @"";
        self.partySetupVC.nameTF.text = @"";
        self.partySetupVC.messageTF.text = @"";
        self.partySetupVC.hobbies = [NSMutableArray arrayWithObjects:@"Technology",@"Sports",@"Art",@"Food",@"Animals",@"Finance",@"Social Life",@"Entertainement",@"Biology",@"Chemisty",@"Physics",@"Medecine",@"Environement",@"Education", nil];
        self.partySetupVC.finalHobbies = [NSMutableArray arrayWithArray:self.partySetupVC.hobbies];
        
        //dismiss the vc
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (self.pinTF.alpha > 0) {
        self.pinTF.text = @"";
        [[[UIAlertView alloc] initWithTitle:@"Incorrect pin code" message:[NSString stringWithFormat:@"You entered a incorrect pin. Here's a hint: %@..",[pin stringByPaddingToLength:2 withString:@"" startingAtIndex:0]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{self.pinTF.alpha = 1;}];
    }
}

- (IBAction)addCategory:(UIButton *)sender {
    //dismiss the keyboard
    [self.customCategoryTF resignFirstResponder];
    
    if (self.customCategoryTF.text.length >= 2 && self.customCategoryTF.text.length <= 15) {//make sure the text is not too long or to short
        [self.hobbies addObject:self.customCategoryTF.text];
        [finalHobbies addObject:self.customCategoryTF.text];
        self.customCategoryTF.text = @"";
        [self.categoryCollectionView reloadData];
    } else {
        //show an alert view
        [[[UIAlertView alloc] initWithTitle:@"Please verify the custom category" message:@"It seems your custom category is either blank or too long. Please change it and press the add category button again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)settings:(UIButton *)sender {
    NSString *pin = [[NSUserDefaults standardUserDefaults] stringForKey:@"pin"];
    if ([self.settingsPinTF.text isEqualToString:pin]) {//make sure the user is authorized
        self.partySetupVC.hobbies = self.hobbies;
        self.partySetupVC.finalHobbies = [NSMutableArray arrayWithArray:self.partySetupVC.hobbies];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.settingsPinTF.alpha > 0) {
        self.settingsPinTF.text = @"";
        [[[UIAlertView alloc] initWithTitle:@"Incorrect pin code" message:[NSString stringWithFormat:@"You entered a incorrect pin. Here's a hint: %@..",[pin stringByPaddingToLength:2 withString:@"" startingAtIndex:0]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{self.settingsPinTF.alpha = 1;}];
    }

}

@end
