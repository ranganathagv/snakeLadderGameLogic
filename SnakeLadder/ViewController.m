//
//  ViewController.m
//  SnakeLadder
//
//  Created by Ranganatha G V on 16/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *reportBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentDialNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *winnerLbl;
@property (nonatomic, strong) NSMutableArray *allPositionsArray;
@property (nonatomic, strong) NSMutableArray *snakePositionsArray;
@property (nonatomic, strong) NSMutableArray *ladderUpPositionsArray;
@property (weak, nonatomic) IBOutlet UIButton *dialButton;
@property (nonatomic, strong) NSString *curPlayer;
@property (nonatomic, strong) NSMutableArray *dialNumbersArray;
@property (weak, nonatomic) IBOutlet UILabel *turnLbl;

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [_reportBackgroundView.layer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
    [_dialButton.layer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Documents directory path %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    
    [self createGameboardPositions];
    [self setNoOfPlayersAndInitializeGame];
}

- (void)createGameboardPositions {
    [self setAllPositions];
    [self setSnakePositions];
    [self setLadderUpPositions];
    [self setDialNumbers];
}
- (void)setAllPositions {
    _allPositionsArray = [NSMutableArray array];
    for (int i = 0; i < MAX_POSITION; i++) {
        [_allPositionsArray addObject:[NSNumber numberWithInt:i]];
    }
    NSLog(@"All Positions\n%@",_allPositionsArray);
}
- (void)setSnakePositions {
    _snakePositionsArray = [NSMutableArray array];
    for (int i = 0; i < NO_OF_SNAKE_POSITIONS; i++) {
        NSNumber *pos = [_allPositionsArray objectAtIndex:arc4random() % _allPositionsArray.count];
        while (pos == [NSNumber numberWithInt:0] || [_snakePositionsArray containsObject:pos]) { // to make sure we dont get 0th position or any duplicate entries
            pos = [_allPositionsArray objectAtIndex:arc4random() % _allPositionsArray.count];
        }
        [_snakePositionsArray addObject:pos];
    }
    NSLog(@"Snake Positions\n%@",_snakePositionsArray);
}
- (void)setLadderUpPositions {
    _ladderUpPositionsArray = [NSMutableArray array];
    for (int i = 0; i < NO_OF_LADDER_UP_POSITIONS; i++) {
        NSNumber *pos = [_allPositionsArray objectAtIndex:arc4random() % _allPositionsArray.count];
        while (pos == [NSNumber numberWithInt:0] || [_ladderUpPositionsArray containsObject:pos] || [_snakePositionsArray containsObject:pos]) {
            pos = [_allPositionsArray objectAtIndex:arc4random() % _allPositionsArray.count];
        }
        [_ladderUpPositionsArray addObject:pos];
    }
    NSLog(@"Ladder Up Positions\n%@",_ladderUpPositionsArray);
}

- (void)setDialNumbers {
    _dialNumbersArray = [NSMutableArray array];
    for (int i = 1; i <= MAX_DIAL_NO; i++) {
        [_dialNumbersArray addObject:[NSNumber numberWithInt:i]];
    }
}
- (void)setNoOfPlayersAndInitializeGame {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [CB_Utility managedObjectContext];
    
    SnakeLadder *slObj = nil;
    NSError *error = nil;
    for (int i = 1 ; i <= NO_OF_PLAYERS; i++) {
        NSString *playerName =  [NSString stringWithFormat:@"Player %d",i];
        NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"SnakeLadder"];
        [req setPredicate:[NSPredicate predicateWithFormat:@"playerName == %@", playerName]];
        NSArray *result = [context executeFetchRequest:req error:&error];
        
        if (result.count) { // Record exists  update the same
            slObj = [result lastObject];
        } else { // insert new record
            slObj = [NSEntityDescription insertNewObjectForEntityForName:@"SnakeLadder" inManagedObjectContext:context];
            slObj.playerName = playerName;
        }
        slObj.curPosition = 0;
        slObj.curDialNum = 0;
        slObj.winner = 0;
        [appDelegate saveContext];
    }
    
    
    // Fetch First Player data From DB and update UI
    
    _curPlayer = @"Player 1";
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"SnakeLadder"];
    [req setPredicate:[NSPredicate predicateWithFormat:@"playerName == %@", _curPlayer]];
    NSArray *result = [context executeFetchRequest:req error:&error];
    if (result.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SnakeLadder *sl = [result lastObject];
            _playerNameLbl.text = [NSString stringWithFormat:@"Player Name: %@",sl.playerName];
            _currentPositionLbl.text = [NSString stringWithFormat:@"Current Position: %d",sl.curPosition];
            _currentDialNoLbl.text = [NSString stringWithFormat:@"Dial Number: %d",sl.curDialNum];
            [_dialButton setTitle:@"Dial Now" forState:UIControlStateNormal];
            [_dialButton setTag:1];
            [_turnLbl setHidden:NO];
            _turnLbl.text = [NSString stringWithFormat:@"Next Turn: %@",_curPlayer];
        });
    }
    
}
- (IBAction)dialButtonTapAction:(id)sender {
    
    if (_dialButton.tag == 99999) { // when game is completed reset
        [self setNoOfPlayersAndInitializeGame];
        [_dialButton setTag:1];
        [_winnerLbl setHidden:YES];
        return;
    }
    
    NSInteger btnTag = _dialButton.tag; // Button tag gives the current player
    if (btnTag == 1) {
        _curPlayer = [NSString stringWithFormat:@"Player %ld",(long)btnTag];
        _dialButton.tag = 2;
    } else {
            _curPlayer = [NSString stringWithFormat:@"Player %ld",(long)btnTag];
            _dialButton.tag = 1;
    }
    NSNumber *curDialNo = [_dialNumbersArray objectAtIndex:arc4random() % _dialNumbersArray.count];
 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [CB_Utility managedObjectContext];
    NSError *error = nil;
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"SnakeLadder"];
    [req setPredicate:[NSPredicate predicateWithFormat:@"playerName == %@", _curPlayer]];
    NSArray *result = [context executeFetchRequest:req error:&error];
    if (result.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SnakeLadder *sl = [result lastObject];
//            int fPos =  sl.curPosition+ [curDialNo intValue]; // for testing
            int fPos = [self getFinalPositionAfterCalculation:sl.curPosition withCurDialNum:[curDialNo intValue]];
            sl.curPosition = fPos;
            _currentPositionLbl.text = [NSString stringWithFormat:@"Current Position: %d",sl.curPosition];
            sl.curDialNum = [curDialNo intValue];
            _currentDialNoLbl.text = [NSString stringWithFormat:@"Dial Number: %@",curDialNo];
            
            if (sl.curPosition >= MAX_POSITION) {
                sl.winner = YES;
                [_winnerLbl setHidden:NO];
                [_winnerLbl setText:[NSString stringWithFormat:@"Congratulations %@ you won!",sl.playerName]];
                [_dialButton setTitle:@"Done" forState:UIControlStateNormal];
                [_dialButton setTag:99999];
                [_turnLbl setHidden:YES];
            } else if (_dialButton.tag <= NO_OF_PLAYERS){ // show whose turn is next
                NSError *error = nil;
                NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"SnakeLadder"];
                [req setPredicate:[NSPredicate predicateWithFormat:@"playerName == %@", [NSString stringWithFormat:@"Player %ld",_dialButton.tag]]];
                NSArray *result = [context executeFetchRequest:req error:&error];
                if (result.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SnakeLadder *sl = [result lastObject];
                        _turnLbl.text = [NSString stringWithFormat:@"Next Turn: %@",sl.playerName];
                    });
                }
            }
        });
    }
    [appDelegate saveContext];
}


- (int)getFinalPositionAfterCalculation:(int)curPos withCurDialNum:(int)curDialNum {
    int movedToPos = curPos + curDialNum;
    NSNumber *num = [NSNumber numberWithInt:movedToPos];
    int fPosition = movedToPos;
    if ([_snakePositionsArray containsObject:num]) {
        fPosition -= NO_OF_SNAKE_POS_TO_LESS_FROM_CUR_POS;
        if (fPosition < 0) {
            fPosition = 0;
        }
    } else if ([_ladderUpPositionsArray containsObject:num]) {
        fPosition += NO_OF_LADDER_POS_TO_ADD_FOR_CUR_POS;
        if (fPosition > MAX_POSITION) {
            fPosition = MAX_POSITION;
        }
    }
    return fPosition;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
