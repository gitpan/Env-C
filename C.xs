#include "EXTERN.h"
#include "perl.h"
#include "ppport.h"
#include "XSUB.h"

#include <stdlib.h> /* setenv/getenv */
#include <stdio.h> /* sprintf */

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

char *
env_c_getenv(key)
    char *key

    CODE:
    RETVAL = getenv(key);

    OUTPUT:
    RETVAL

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

int
env_c_setenv(key, val, override=1)
    char *key
    char *val
    int override

    CODE:
#ifdef WIN32
    if (override || getenv(key) == NULL) {
        char *buff = malloc(strlen(key) + strlen(val) + 2);
        if (buff != NULL) {
            sprintf(buff, "%s=%s", key, val);
            RETVAL = _putenv(buff);
            free(buff);
        }
        else {
            RETVAL = -1;
        }
    }
    else {
        RETVAL = -1;
    }
#else
    RETVAL = setenv(key, val, override);
#endif

    OUTPUT:
    RETVAL

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

void
env_c_unsetenv(key)
    char *key

    PREINIT:
#ifdef WIN32
    char *buff;
#endif

    CODE:
#ifdef WIN32
    buff = malloc(strlen(key) + 2);
    sprintf(buff, "%s=", key);
    _putenv(buff);
    free(buff);
#else
    unsetenv(key);
#endif

MODULE = Env::C		PACKAGE = Env::C  PREFIX = env_c_

AV*
env_c_getallenv()

    PREINIT:
    int i = 0;
    char *p;
    AV *av = Nullav;
#ifndef __BORLANDC__
    extern char **environ;
#endif

    CODE:
    RETVAL = Perl_newAV(aTHX);

    do {
        Perl_av_push(aTHX_ RETVAL, newSVpv((char*)environ[i++], 0));
    } while ((char*)environ[i] != '\0');

    OUTPUT:
    RETVAL




    


    
