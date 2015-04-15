//
//  IBPartytSetupViewController.m
//  Icebreakr
//
//  Created by iD Student on 7/24/14.
//
//

#import "IBPartytSetupViewController.h"

@interface IBPartytSetupViewController ()

@end

@implementation IBPartytSetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //create anm array of categories
    self.hobbies = [NSMutableArray arrayWithObjects:@"Technology",@"Sports",@"Art",@"Food",@"Animals",@"Finance",@"Social Life",@"Entertainment",@"Biology",@"Chemisty",@"Physics",@"Medicine",@"Environment",@"Education", nil];
    self.finalHobbies = [self.hobbies mutableCopy];
    
    //round the tableView corners
    self.categoriesTableView.layer.cornerRadius = 5.0;
    self.categoriesTableView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UItableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.hobbies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = cell.backgroundColor;
    //set the cell title
    cell.textLabel.text = [self.hobbies objectAtIndex:indexPath.row];//then get the title from the hobbies array
    
    //set the checkmark depending if the object is in the finalhobbies
    cell.accessoryType = UITableViewCellAccessoryNone;//no checkmarks by default
    
    if ([self.finalHobbies containsObject:cell.textLabel.text]) {//if the category is in the finalHobbies array
        cell.accessoryType = UITableViewCellAccessoryCheckmark;// then add a checkmark
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//get the cell
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {//if a checkmark is present
        cell.accessoryType = UITableViewCellAccessoryNone;//remove it
        [self.finalHobbies removeObject:cell.textLabel.text];//remove the hobby
    } else {//otherwise
        cell.accessoryType = UITableViewCellAccessoryCheckmark;//add one
        [self.finalHobbies addObject:cell.textLabel.text];//add the hobby
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//deselect the row
}

#pragma mark - UITextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.messageTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
}


#pragma mark - IBActions
- (IBAction)selectAllCategories:(UITapGestureRecognizer *)sender {
    //add all the hobbies to the final hobbies
    self.finalHobbies = nil;
    self.finalHobbies = [NSMutableArray arrayWithArray:self.hobbies];
    
    //reload the tableView to shoz the checkmarks
    [self.categoriesTableView reloadData];
}

- (IBAction)done:(UIButton *)sender {
    if (self.pinTF.text.length <= 2) {
        [[[UIAlertView alloc] initWithTitle:@"Please make sure your set a valid pin code" message:@"It seems you didn't enter a pin code or it is too short. Your pin code must be at least 3 characters long." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    } else {
        //store the password
        [[NSUserDefaults standardUserDefaults] setObject:self.pinTF.text forKey:@"pin"];
        
        //get the instance of the view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
        IBViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
        
        //configure the vc
        vc.hobbies = self.finalHobbies;
        vc.partyMessage = self.messageTF.text; 
        vc.partyName = self.nameTF.text;
        vc.partySetupVC = self;
        
        //present the main view controller
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

- (IBAction)addCategory:(UIButton *)sender {
    //dismiss the keyboard
    [self.customCategoryTF resignFirstResponder];
    
    if (self.customCategoryTF.text.length >= 2 && self.customCategoryTF.text.length <= 15) {//make sure the text is not too long or to short
        [self.hobbies addObject:self.customCategoryTF.text];
        [self.finalHobbies addObject:self.customCategoryTF.text];
        self.customCategoryTF.text = @"";
        [self.categoriesTableView reloadData];
    } else {
        //show an alert view
        [[[UIAlertView alloc] initWithTitle:@"Please verify the custom category" message:@"It seems your custom category is either blank or too long. Please change it and press the add category button again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)showPinInfo:(UIButton *)sender {
    [[[UIAlertView alloc] initWithTitle:@"Pin" message:@"This passcode will not be encrypted & is temporary. It must be at least 3 characters long. It is used to make sure only YOU can end the party, we also suggest turning on Guided Access to make sure no one quits this app." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end
