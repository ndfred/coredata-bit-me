#import "SQLiteBenchmark.h"
#import "Benchmark+Private.h"
#import "sqlite3.h"

@interface SQLiteBenchmark ()

@property (assign, nonatomic) sqlite3 *database;

- (void)beginTransation;
- (void)endTransation;

@end

@implementation SQLiteBenchmark

@synthesize database = _database;

- (NSString *)name {
    return @"SQLite";
}

- (void)runWithChannelsCount:(NSUInteger)channelsCount programsCount:(NSUInteger)programsCount {
    NSString *databasePath = self.class.cleanDatabaseURL.relativePath;
    NSURL *statementsFileURL = [[NSBundle mainBundle] URLForResource:@"TVGuide" withExtension:@"sql"];
    NSString *statement = [NSString stringWithContentsOfURL:statementsFileURL usedEncoding:NULL error:nil];

    NSAssert(sqlite3_open(databasePath.UTF8String, &_database) == SQLITE_OK,
             @"Could not create the SQL database: %s", sqlite3_errmsg(_database));
    NSAssert(sqlite3_exec(_database, statement.UTF8String, NULL, NULL, NULL) == SQLITE_OK,
             @"Could not create the SQL database: %s", sqlite3_errmsg(_database));

    [self beginTransation];

    [super runWithChannelsCount:channelsCount programsCount:programsCount];

    [self endTransation];

    NSAssert(sqlite3_close(_database) == SQLITE_OK,
             @"Could not close the SQL database: %s", sqlite3_errmsg(_database));
    _database = NULL;
}

- (void)beginTransation {
    NSAssert(sqlite3_exec(_database, "BEGIN TRANSACTION;", NULL, NULL, NULL) == SQLITE_OK,
             @"Could not begin transaction: %s", sqlite3_errmsg(_database));
}

- (void)endTransation {
    NSAssert(sqlite3_exec(_database, "COMMIT TRANSACTION;", NULL, NULL, NULL) == SQLITE_OK,
             @"Could not end transaction: %s", sqlite3_errmsg(_database));
}

- (void)flush {
    [self endTransation];
    [self beginTransation];
}

- (void)createChannelWithIdentifier:(NSUInteger)identifier name:(NSString *)name {
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO channels VALUES (%d, \"%@\");", identifier, name];

    NSAssert(sqlite3_exec(_database, statement.UTF8String, NULL, NULL, NULL) == SQLITE_OK,
             @"Could not create channel %d: %s", identifier, sqlite3_errmsg(_database));
}

- (void)createProgramWithIdentifier:(NSUInteger)identifier name:(NSString *)name {
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO programs VALUES (%d, \"%@\");", identifier, name];

    NSAssert(sqlite3_exec(_database, statement.UTF8String, NULL, NULL, NULL) == SQLITE_OK,
             @"Could not create program %d: %s", identifier, sqlite3_errmsg(_database));
}

- (void)createBroadcastWithChannelIdentifier:(NSUInteger)channelIdentifier programIdentifier:(NSUInteger)programIdentifier {
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO broadcasts VALUES (%d, %d);", channelIdentifier, programIdentifier];

    NSAssert(sqlite3_exec(_database, statement.UTF8String, NULL, NULL, NULL) == SQLITE_OK,
             @"Could not create channel %d > %d: %s", channelIdentifier, programIdentifier, sqlite3_errmsg(_database));
}

@end
