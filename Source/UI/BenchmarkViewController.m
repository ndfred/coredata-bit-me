#import "BenchmarkViewController.h"
#import "CoreDataBenchmark.h"
#import "SQLiteBenchmark.h"

@interface BenchmarkViewController ()

- (NSArray *)benchmarkWithProgramsCount:(NSUInteger)programsCount;

@end

@implementation BenchmarkViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSMutableArray *csvLines = [NSMutableArray array];
    NSMutableArray *csvStringLines = [NSMutableArray array];
    NSArray *titles = [NSArray arrayWithObjects:
                       @"Benchmark name", @"Programs count",
                       @"Channels creation", @"Programs creation", @"Broadcasts creation",
                       nil];

    [csvLines addObject:titles];
    [csvLines addObjectsFromArray:[self benchmarkWithProgramsCount:100]];
    [csvLines addObjectsFromArray:[self benchmarkWithProgramsCount:1000]];
    [csvLines addObjectsFromArray:[self benchmarkWithProgramsCount:4000]];
    [csvLines addObjectsFromArray:[self benchmarkWithProgramsCount:8000]];

    for (NSArray *csvLine in csvLines) {
        [csvStringLines addObject:[csvLine componentsJoinedByString:@"\t"]];
    }

    NSLog(@"CSV benchmark data:\n%@", [[csvStringLines componentsJoinedByString:@"\n"] stringByReplacingOccurrencesOfString:@"." withString:@","]);
}

- (NSArray *)benchmarkWithProgramsCount:(NSUInteger)programsCount {
    NSArray *benchmarks = [NSArray arrayWithObjects:
                           [[CoreDataBenchmark alloc] init],
                           [[CoreDataBenchmark alloc] initWithRelationShipsEnabled:NO],
                           [[SQLiteBenchmark alloc] init],
                           nil];
    NSMutableArray *results = [NSMutableArray array];

    for (Benchmark *benchmark in benchmarks) {
        NSMutableArray *benchmarkResults = [NSMutableArray arrayWithObjects:benchmark.name, [NSString stringWithFormat:@"%d", programsCount], nil];

        [benchmark runWithChannelsCount:100 programsCount:programsCount];
        [benchmarkResults addObjectsFromArray:benchmark.rawResults];
        [results addObject:benchmarkResults];
    }

    return results;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
