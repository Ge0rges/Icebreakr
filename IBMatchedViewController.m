 //
//  IBMatchedViewController.m
//  Icebreaker
//
//  Created by iD Student on 7/25/14.
//
//

#import "IBMatchedViewController.h"

@interface IBMatchedViewController ()

@end

@implementation IBMatchedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IBPerson *bestMatch = (IBPerson *)[(NSArray *)[self.person.top2MatchedPeople objectAtIndex:0] objectAtIndex:0];
    IBPerson *secondBestMatch;
    if (self.person.top2MatchedPeople.count > 1) secondBestMatch = (IBPerson *)[(NSArray *)[self.person.top2MatchedPeople objectAtIndex:1] objectAtIndex:0];
    
    //first person
    [self.imageView1 setImage:bestMatch.photo];
    [self.nameLabel1 setText:bestMatch.name];
    [self.interestsLabel1 setText:[NSString stringWithFormat:@"Interested in: %@",[bestMatch.hobbies componentsJoinedByString:@","]]];
    
    if (self.person.top2MatchedPeople.count > 1) {//if we have a second match
        //second person
        [self.imageView2 setImage:secondBestMatch.photo];
        [self.nameLabel2 setText:secondBestMatch.name];
        [self.interestsLabel2 setText:[NSString stringWithFormat:@"Interested in: %@",[secondBestMatch.hobbies componentsJoinedByString:@","]]];
    } else {
        //hide the second person's label and image view
        [self.imageView2 setHidden:YES];
        [self.nameLabel2 setHidden:YES];
        [self.interestsLabel2 setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)emailResults:(UIButton *)sender {
    sender.enabled = NO;
    [self.person emailMatches:sender];
}

- (IBAction)done:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
