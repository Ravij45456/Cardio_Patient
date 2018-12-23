#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject{
    sqlite3 *db;
}

-(NSString *)filePath;
-(void)openDB;

//========== Insert Query ===========//
-(BOOL)insertValueIntoTable:(NSString*)query err:(NSString*)error;


//==================== Select Query Code ======================//
-(NSMutableArray*) getAllDataUsingQuery:(NSString*)query;

//======================== Delete Query code ===================//
-(BOOL)deleteAllRecordsFromTable:(NSString*)tablename;

-(BOOL)deleteQryRecordsFromTable:(NSString*)delQuery;

-(BOOL)deleteRecordFromTable:(NSString *)tableName recordID:(int)recordID;

-(BOOL)delRecordFromTable:(NSString *)tableName recordName:(NSString *)recordName recordID:(int)recordID;



@end
