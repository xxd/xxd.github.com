
- 获取File信息的方法NSURL
```
NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
NSArray *directoryContent = [[NSFileManager defaultManager] 
contentsOfDirectoryAtURL:documentsURL
includingPropertiesForKeys:@[NSURLContentModificationDateKey]
options:NSDirectoryEnumerationSkipsHiddenFiles
error:nil];
```