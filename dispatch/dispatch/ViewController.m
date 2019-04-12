//
//  ViewController.m
//  dispatch
//
//  Created by Jun Zhou on 2019/4/10.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) dispatch_queue_t readWriteQueue;

@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSConditionLock *conditionLock;
@property (assign, nonatomic) int firstCount;
@property (assign, nonatomic) int secondCount;
@property (assign, nonatomic) int thirdCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    _readWriteQueue = dispatch_queue_create("readWriteQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 8; ++i) {
        [self read];
        [self write];
    }
     */
    
    _array = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    _conditionLock = [[NSConditionLock alloc] initWithCondition:0];
    _firstCount = 0;
    _secondCount = 1;
    _thirdCount = 2;
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(arrayPrintFirst) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(arrayPrintSecond) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(arrayPrintThird) object:nil] start];
    
}

- (void)read {
    dispatch_async(_readWriteQueue, ^{
        sleep(1);
        NSLog(@"read task");
    });
    
    
}

- (void)write {
    dispatch_barrier_async(_readWriteQueue, ^{
        sleep(1);
        NSLog(@"write task");
    });
}

- (void)arrayPrintFirst {
    
    [_conditionLock lockWhenCondition:_firstCount % 3];
    NSLog(@"%@", [NSThread currentThread]);
    
    while (_firstCount < _array.count) {
        NSLog(@"value: %@", _array[_firstCount]);
        _firstCount += 3;
    }
    [_conditionLock unlockWithCondition:_firstCount % 3 + 1];
    
}

- (void)arrayPrintSecond {
    [_conditionLock lockWhenCondition:_secondCount % 3];
    NSLog(@"%@", [NSThread currentThread]);
    
    while (_secondCount < _array.count) {
        NSLog(@"value: %@", _array[_secondCount]);
        _secondCount += 3;
    }
    [_conditionLock unlockWithCondition:_secondCount % 3 + 1];
}

- (void)arrayPrintThird {
    [_conditionLock lockWhenCondition:_thirdCount % 3];
    NSLog(@"%@", [NSThread currentThread]);
    
    while (_thirdCount < _array.count) {
        NSLog(@"value: %@", _array[_thirdCount]);
        _thirdCount += 3;
    }
    [_conditionLock unlockWithCondition:_thirdCount % 3 + 1];
}

@end
