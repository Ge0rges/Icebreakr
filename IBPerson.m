//
//  IBPerson.m
//  Icebreaker
//
//  Created by iD Student on 7/24/14.
//
//

#import "IBPerson.h"

#define kHobbiesKey "hobbies_KEY"
#define kMatchedPeopleKey "matchedPeople_KEY"
#define kTop2MatchedPeopleKey "top2MatchedPeople_KEY"
#define kPartyNameKey "partyName_KEY"
#define kNameKey "name_KEY"
#define kEmailKey "email_KEY"
#define kPhotoKey "photo_KEY"

@implementation IBPerson

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.hobbies forKey:@kHobbiesKey];
    [coder encodeObject:self.matchedPeople forKey:@kMatchedPeopleKey];
    [coder encodeObject:self.top2MatchedPeople forKey:@kTop2MatchedPeopleKey];
    [coder encodeObject:self.partyName forKey:@kPartyNameKey];
    [coder encodeObject:self.name forKey:@kNameKey];
    [coder encodeObject:self.email forKey:@kEmailKey];
    [coder encodeObject:self.photo forKey:@kPhotoKey];

}

-(id)initWithCoder:(NSCoder *)decoder{
    if(self = [super init]){
        self.hobbies = [decoder decodeObjectForKey:@kHobbiesKey];
        self.matchedPeople = [decoder decodeObjectForKey:@kMatchedPeopleKey];
        self.top2MatchedPeople = [decoder decodeObjectForKey:@kTop2MatchedPeopleKey];
        self.partyName = [decoder decodeObjectForKey:@kPartyNameKey];
        self.name = [decoder decodeObjectForKey:@kNameKey];
        self.email = [decoder decodeObjectForKey:@kEmailKey];
        self.photo = [decoder decodeObjectForKey:@kPhotoKey];
    }
    return self;
}

-(void)matchUpWithPeople:(NSArray *)people {
    NSMutableArray *peopleMatched = [NSMutableArray new];
    for (IBPerson *person in people) {//for each person
        //create an array to store the person and the hobbies that were matched
        NSArray *personArray;
        NSMutableArray *hobbiesMatched = [NSMutableArray new];
        
        //check his hobbies against ours
        for (NSString *hobby in self.hobbies) {//for each of ours hobby
            for (NSString *personsHobby in person.hobbies) {//for each of his hobby
                //check if they match
                if ([hobby isEqualToString:personsHobby]) {
                    [hobbiesMatched addObject:hobby];
                }
            }
        }
        
        if (hobbiesMatched.count > 0 && person != self) {//if we got at least one hobby match
            personArray = [NSArray arrayWithObjects:person, hobbiesMatched, nil];//create the person array
            [peopleMatched addObject:personArray];//add it to our people matched arrays
        }
    }
    
    //update the property
    self.matchedPeople = [NSArray arrayWithArray:peopleMatched];
    
    //get the top 2 matches
    NSArray *sortedArray = [self.matchedPeople sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
        return [[NSNumber numberWithInteger:[[obj1 objectAtIndex:1] count]] compare:[NSNumber numberWithInteger:[[obj2 objectAtIndex:1] count]]];
    }];
    
    //update the property
    self.top2MatchedPeople = (sortedArray.count >= 2) ? [NSArray arrayWithObjects:[sortedArray objectAtIndex:0], [sortedArray objectAtIndex:1], nil] : (sortedArray.count >= 1) ? [NSArray arrayWithObjects:[sortedArray objectAtIndex:0], nil] : [NSArray new];
}

-(void)emailMatches:(UIButton *)sender {
    if (self.matchedPeople.count == 0 || self.top2MatchedPeople.count == 0)  dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self matchUpWithPeople:(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"data"]]];
    });
        
    //get the top 2 IBPersons
    IBPerson *bestMatch = (IBPerson *)[(NSArray *)[self.top2MatchedPeople objectAtIndex:0] objectAtIndex:0];
    IBPerson *secondBestMatch;
    if (self.top2MatchedPeople.count > 1) secondBestMatch = (IBPerson *)[(NSArray *)[self.top2MatchedPeople objectAtIndex:1] objectAtIndex:0];
 
    //email the user
    //declare the mailgun instance
    Mailgun *mailgun = [Mailgun clientWithDomain:@"ge0rges.com" apiKey:@"key-5ab378785450a6e84d1d34573da59962"];
    
    //generate the message
    NSString *messageString;
    if (!secondBestMatch) {
        messageString = [NSString stringWithFormat:@"Hello,\n You were matched with %@. You will find his/her profile picture attached so you can recognise him/her.\n Thank you for using Icebreaker,\n Have fun!\nP.S:You cannot reply to this email.jj", bestMatch.name];
    } else {
        messageString = [NSString stringWithFormat:@"Hello,\n You were matched with %@ and %@. You will find there profile pictures attached so you can recognise them.\n Thank you for using Icebreaker,\n Have fun!\nP.S:You cannot reply to this email.", bestMatch.name, secondBestMatch.name];
    }
    
    //declare the message
    MGMessage *message = [[MGMessage alloc] initWithFrom:@"Icebreaker <icebreaker@ge0rges.com>" to:[NSString stringWithFormat:@"%@ <%@>", self.name, self.email] subject:[NSString stringWithFormat:@"Your matches for %@", self.partyName] body:messageString];
    
    //add the images to the message
    if (bestMatch.photo) [message addImage:bestMatch.photo withName:@"First Person Photo" type:PNGFileType inline:YES];
    if (secondBestMatch.photo) [message addImage:secondBestMatch.photo withName:@"Second Person Photo" type:PNGFileType inline:YES];//only add the second image if we got a second match
        
    //send the message
    [mailgun sendMessage:message success:^(NSString *messageId) {
        sender.titleLabel.text = @"Sent!";
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email could not be sent. Please make sure you are connected to the internet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        sender.titleLabel.text = @"Failed";
    }];
}

@end
