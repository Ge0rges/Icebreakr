//
//  IBPerson.h
//  Icebreaker
//
//  Created by iD Student on 7/24/14.
//
//

#import <Foundation/Foundation.h>
#import "Mailgun.h"

@interface IBPerson : NSObject <NSCoding>

@property (strong, nonatomic) NSArray *hobbies;
@property (strong, nonatomic) NSArray *matchedPeople;
@property (strong, nonatomic) NSArray *top2MatchedPeople;

@property (strong, nonatomic) NSString *partyName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) UIImage *photo;


-(void)matchUpWithPeople:(NSArray *)people;
-(void)emailMatches:(UIButton *)sender;

@end
