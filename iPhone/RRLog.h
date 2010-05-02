/* RRLog.h

   written by mathew chasan
   25 Apr 2010

   Copyright (C) 2010 Bitsyrup.com

   -----------
   DESCRIPTION
   -----------

   used to add log levels to the program

*/

#if !defined (__RRLOG_H__)
#    define   __RRLOG_H__

#import <Foundation/Foundation.h>

#define LOG_LEVEL_NONE  0
#define LOG_LEVEL_ERROR 1
#define LOG_LEVEL_WARN  2
#define LOG_LEVEL_INFO  3
#define LOG_LEVEL_DEBUG 4

#define RR_LOG_LEVEL LOG_LEVEL_DEBUG

#if (RR_LOG_LEVEL >= LOG_LEVEL_DEBUG) 
#define LOG_DEBUG(f, ...) (NSLog([@"DEBUG %@ %d: " stringByAppendingString:f], [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __VA_ARGS__))
#else
#define LOG_DEBUG(f, ...) 
#endif

#if (RR_LOG_LEVEL >= LOG_LEVEL_INFO) 
#define LOG_INFO(f, ...) (NSLog([@"INFO  %@ %d: " stringByAppendingString:f], [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __VA_ARGS__))
#else
#define LOG_INFO(f, ...) 
#endif

#if (RR_LOG_LEVEL >= LOG_LEVEL_WARN) 
#define LOG_WARN(f, ...) (NSLog([@"WARN  %@ %d: " stringByAppendingString:f], [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __VA_ARGS__))
#else
#define LOG_WARN(f, ...) 
#endif

#if (RR_LOG_LEVEL >= LOG_LEVEL_ERROR) 
#define LOG_ERROR(f, ...) (NSLog([@"ERROR %@ %d: " stringByAppendingString:f], [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __VA_ARGS__))
#else
#define LOG_ERROR(f, ...) 
#endif

#endif  /* __RRLOG_H__ */
