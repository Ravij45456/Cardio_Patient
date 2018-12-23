#import "DatabaseManager.h"
#import "AppDelegate.h"

@implementation DatabaseManager

#pragma mark - General Query Code:-
-(NSString *)filePath{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [path objectAtIndex:0];
    return [directory stringByAppendingPathComponent:@"HeartRateApp.sqlite"];
}

-(void)openDB{
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Database couldn't open" delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Insert Query Code:-
//==================== Insert Query Code ======================//

-(BOOL)insertValueIntoTable:(NSString*)query err:(NSString*)error{
    [self openDB];
    char *err;
    NSLog(@"QUERY~~~~~~>>%@",query);
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK){
        sqlite3_close(db);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        [alert show];
        return  NO;
    }
    return YES;
}

#pragma mark - Select Query Code:-
//==================== Select Query Code ======================//
-(NSMutableArray*) getAllDataUsingQuery:(NSString*)query
{
    [self openDB];
    
    //NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *resultsArray = [NSMutableArray array];
    sqlite3_stmt *statement1;
    NSLog(@"QUERY~~~~~~>>%@",query);
    if (sqlite3_prepare_v2(db, [query UTF8String], -1, &statement1, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement1) == SQLITE_ROW) {
            int columns = sqlite3_column_count(statement1);
            NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:columns];
            
            for (int i = 0; i<columns; i++) {
                const char *name = sqlite3_column_name(statement1, i);
                NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                const char *value = (const char*)sqlite3_column_text(statement1, i);
                //NSString *temp = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
                NSString *temp = @"";
                if (value == nil){
                    temp = @"";
                }else{
                    temp = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
                }
                [result setValue:temp forKey:columnName];
            } //end for
            
            [resultsArray addObject:result];
            //[result release];
            
        } //end while
        sqlite3_finalize(statement1);
    }
    
    sqlite3_close(db);
    
    return resultsArray;
}

#pragma mark - Delete Query Code:-
//======================== Delete Query code ===================//
-(BOOL)deleteAllRecordsFromTable:(NSString*)tablename{
    [self openDB];
    char *err;
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@",tablename];
    //NSLog(@"QUERY~~~~~~>>%@",query);
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        sqlite3_close(db);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting Error." delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        [alert show];
        return  NO;
    }
    return YES;
}

-(BOOL)deleteQryRecordsFromTable:(NSString*)delQuery{
    [self openDB];
    char *err;
    //NSLog(@"QUERY~~~~~~>>%@",delQuery);
    if (sqlite3_exec(db, [delQuery UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        sqlite3_close(db);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting Error." delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        [alert show];
        return  NO;
    }
    return YES;
}

-(BOOL)deleteRecordFromTable:(NSString *)tableName recordID:(int)recordID{
    [self openDB];
    sqlite3_stmt *delStmt=nil;
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE Id = %d",tableName,recordID];
    //NSLog(@"QUERY~~~~~~>>%@",query);
    if (sqlite3_prepare_v2(db, [query UTF8String], -1, &delStmt, NULL) != SQLITE_OK){
        sqlite3_close(db);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting Error." delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        [alert show];
        return  NO;
    }
    while(sqlite3_step(delStmt)==SQLITE_ROW){
    }
    sqlite3_finalize(delStmt);
    return YES;
}

-(BOOL)delRecordFromTable:(NSString *)tableName recordName:(NSString *)recordName recordID:(int)recordID{
    [self openDB];
    sqlite3_stmt *delStmt=nil;
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %d",tableName,recordName, recordID];
    //NSLog(@"QUERY~~~~~~>>%@",query);
    if (sqlite3_prepare_v2(db, [query UTF8String], -1, &delStmt, NULL) != SQLITE_OK){
        sqlite3_close(db);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting Error." delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [AppDelegate GetLocalizebundle], @"") otherButtonTitles:nil];
        [alert show];
        return  NO;
    }
    while(sqlite3_step(delStmt)==SQLITE_ROW){
    }
    sqlite3_finalize(delStmt);
    return YES;
}

@end
