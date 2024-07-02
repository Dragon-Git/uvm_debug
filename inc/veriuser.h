#ifndef VERIUSER_H
#define VERIUSER_H
/*
 * Copyright (c) 2002-2014 Stephen Williams (steve@icarus.com)
 *
 *    This source code is free software; you can redistribute it
 *    and/or modify it in source code form under the terms of the GNU
 *    General Public License as published by the Free Software
 *    Foundation; either version 2 of the License, or (at your option)
 *    any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

/*
 * This header file contains the definitions and declarations needed
 * by an Icarus Verilog user using tf_ routines.
 *
 * NOTE 1: Icarus Verilog does not directly support tf_ routines. This
 * header file defines a tf_ compatibility later. The functions that
 * are implemented here are actually implemented using VPI routines.
 *
 * NOTE 2: The routines and definitions of the tf_ library were
 * clearly not designed to account for C++, or even ANSI-C. This
 * header file attempts to fix these problems in a source code
 * compatible way. In the end, though, it is not completely
 * possible. Instead, users should not use this or the acc_user.h
 * header files or functions in new applications, and instead use the
 * more modern vpi_user.h and VPI functions.
 *
 * This API is provided by Icarus Verilog only to support legacy software.
 */


#ifdef __cplusplus
# define EXTERN_C_START extern "C" {
# define EXTERN_C_END }
#else
# define EXTERN_C_START
# define EXTERN_C_END
#endif

#ifndef __GNUC__
# undef  __attribute__
# define __attribute__(x)
#endif

EXTERN_C_START

# include  "_pli_types.h"

/*
 * defines for tf_message
 */
#define ERR_MESSAGE 1
#define ERR_WARNING 2
#define ERR_ERROR   3
#define ERR_INTERNAL 4
#define ERR_SYSTEM   5

/*
 * These are some defines for backwards compatibility. They should not
 * be used in new code.
 */
#ifndef TRUE
# define TRUE 1
#endif
#ifndef FALSE
# define FALSE 0
#endif
#ifndef __cplusplus
# ifndef true
#  define true 1
# endif
# ifndef false
#  define false 0
# endif
# ifndef bool
#  define bool int
# endif
#endif

/*
 * structure for veriusertfs array
 */
typedef struct t_tfcell
{
      short type;               /* usertask|userfunction|userrealfunction */
      short data;               /* data passed to user routine */
      int   (*checktf)(int user_data, int reason);
      int   (*sizetf)(int user_data, int reason);
      int   (*calltf)(int user_data, int reason);
      int   (*misctf)(int user_data, int reason, int paramvc);
      char  *tfname;            /* name of the system task/function */
      int   forwref;            /* usually set to 1 */
      char  *tfveritool;        /* usually ignored */
      char  *tferrmessage;      /* usually ignored */
      char  reserved[20];            /* reserved */
} s_tfcell, *p_tfcell;

/*
 * Normal PLI1.0 modules export a veriusertfs array that contains all
 * the function definitions for use by the simulator. The user code is
 * expected to supply that array. The method of export varies amongst
 * Verilog simulators, but at least one vendor gets a pointer to the
 * veriusertfs array by calling a boot function that takes no
 * arguments and returns a pointer to the table.
 *
 * The Icarus Verilog bootstrap process is a little bit different, and
 * is described in the vpi_user.h header file. However, a fairly
 * simple adaptation to your application fixes it so that it
 * automatically boots with Icarus Verilog.
 *
 * The trick is to write a vlog_startup_routine that calls the
 * veriusertfs_register_table function. A simple example:
 *
 *   static struct s_tfcell my_veriusertfs_table[] = {
 *          [... table entries, null terminated ...]
 *   };
 *
 *   // Cadence compatibility
 *   struct s_tfcell* my_bootstrap(void)
 *   { return my_veriusertfs_table; }
 *
 *   // Icarus Verilog compatibility
 *   static void veriusertfs_register(void)
 *   {
 *       veriusertfs_register_table(my_veriusertfs_table);
 *   }
 *   void (*vlog_startup_routines[])() = { &veriusertfs_register, 0 };
 *
 * The veriusertfs_register function and vlog_startup_routines table
 * are specific to Icarus Verilog, and arrange for automatic loading
 * of the PLI1 application. The vvp program will treat this as any
 * other VPI module.
 *
 * By structuring the bootstrap process in this manner, it is
 * plausible to make source code compatibility with a variety of
 * Verilog simulators.
 *
 * NOTE: The cadpli module of Icarus Verilog also makes it possible to
 * be *binary* compatible with other simulators. Create the
 * my_bootstrap function and leave out the vlog_startu