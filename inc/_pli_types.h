#ifndef PLI_TYPES_H
#define PLI_TYPES_H

/*
 * If the host environment has the stdint.h header file,
 * then use that to size our PLI types.
 */
#ifndef __STDC_FORMAT_MACROS
# define __STDC_FORMAT_MACROS
#endif

# include  <inttypes.h>
typedef uint64_t PLI_UINT64;
typedef int64_t  PLI_INT64;
typedef uint32_t PLI_UINT32;
typedef int32_t  PLI_INT32;

typedef signed short   PLI_INT16;
typedef unsigned short PLI_UINT16;
typedef char           PLI_BYTE8;
typedef unsigned char  PLI_UBYTE8;

# define PLI_UINT64_FMT PRIu64

#endif /* PLI_TYPES_H */