//
//  FBFileMaper.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/15.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBFileMaper.h"

#include <sys/mman.h>
#include <sys/stat.h>


@implementation FBFileMaper

- (id)initWithPath:(NSString *)path
{
  self = [super init];
  if (self) {
  }
  return self;
}


+ (BOOL)updateFile:(NSString *)path offset:(long)offset data:(NSData *)data
{
  if ( path.length<=0 ) { return NO; }
  if ( offset<0 ) { return NO; }
  if ( data.length<=0 ) { return NO; }

  // 打开文件
  int fileDescriptor = open([path UTF8String], O_RDWR, 0);
  if ( fileDescriptor<0 ) {
    // 打开失败
    return NO;
  } else {
    // 打开成功，文件存在，获取文件大小
    struct stat fileStat;
    if ( fstat(fileDescriptor, &fileStat)!=0 ) {
      // 获取文件大小失败
      return NO;
    } else {
      // 获取文件大小成功
      if ( (offset+data.length)>fileStat.st_size ) {
        // 超出边界
        return NO;
      } else {

        long pageSize = sysconf(_SC_PAGE_SIZE);
        long startPage = offset/pageSize;
        long endPage = (offset+data.length)/pageSize;

        for ( long i=startPage; i<=endPage; ++i ) {
          // 最后一页映射不满页，其它全是满页
          size_t mapLength = pageSize;
          if ( i==endPage ) {
            mapLength = (offset+data.length) - i*pageSize;
          }

          void *ptr = mmap(NULL,
                           mapLength,
                           PROT_WRITE,
                           MAP_SHARED,
                           fileDescriptor,
                           i*pageSize);

          long copyOffset = 0;
          long copyLength = pageSize;
          if ( i==startPage ) {
            copyOffset = 0;
            copyLength =  pageSize - offset%pageSize;
          } else if ( i==endPage ) {
            copyLength = (offset+data.length) % pageSize;
          } else {
            copyOffset = 000;
          }
          memcpy(ptr, data.bytes, copyLength);
        }

      }



    }
  }

  return YES;




//  int outError;
//  struct stat statInfo;
//
//  // Return safe values on error.
//  outError = 0;
//  *outDataPtr = NULL;
//  *outDataLength = 0;
//
//
//  int fileDescriptor = open( inPathName, O_RDWR, 0 );
//  if( fileDescriptor < 0 ) {
//    outError = errno;
//  } else {
//
//    if( fstat( fileDescriptor, &statInfo ) != 0 ) {
//      outError = errno;
//    } else {
//      // Map the file into a read-only memory region.
//      *outDataPtr = mmap(NULL,
//                         4, //statInfo.st_size,
//                         PROT_WRITE,
//                         MAP_SHARED,
//                         fileDescriptor,
//                         4096);
//      if( *outDataPtr == MAP_FAILED ) {
//        outError = errno;
//      } else {
//        // On success, return the size of the mapped file.
//        *outDataLength = statInfo.st_size;
//      }
//    }
//
//    // Now close the file. The kernel doesn’t use our file descriptor.
//    close( fileDescriptor );
//  }
//
//  return outError;
}

@end
