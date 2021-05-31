#  启动源码阅读
> dyldStartup.s
__dyld_start:
// call dyldbootstrap::start(app_mh, argc, argv, slide, dyld_mh, &startGlue)
bl  __ZN13dyldbootstrap5startEPK12macho_headeriPPKclS2_Pm

> dyldInitialization
```
namespace dyldbootstrap {
{
	// if kernel had to slide dyld, we need to fix up load sensitive locations
	// we have to do this before using any global variables
	if ( slide != 0 ) {
		rebaseDyld(dyldsMachHeader, slide);
	}

	// allow dyld to use mach messaging
	mach_init();

	// kernel sets up env pointer to be just past end of agv array
	const char** envp = &argv[argc+1];
	
	// kernel sets up apple pointer to be just past end of envp array
	const char** apple = envp;
	while(*apple != NULL) { ++apple; }
	++apple;

	// set up random value for stack canary
	__guard_setup(apple);

#if DYLD_INITIALIZER_SUPPORT
	// run all C++ initializers inside dyld
	runDyldInitializers(dyldsMachHeader, slide, argc, argv, envp, apple);
#endif

	// now that we are done bootstrapping dyld, call dyld's main
	uintptr_t appsSlide = slideOfMainExecutable(appsMachHeader);
	return dyld::_main(appsMachHeader, appsSlide, argc, argv, envp, apple, startGlue);
}
}
```

> 获取运行的ASLR uintptr_t appsSlide = slideOfMainExecutable(appsMachHeader);
https://opensource.apple.com/source/xnu/xnu-1456.1.26/EXTERNAL_HEADERS/mach-o/loader.h
如果想看header相关内容，需要到xnu源码，EXTERNAL_HEADERS/loader.h 54 行

> 然后到dyld::main 
```
uintptr_t
_main(const macho_header* mainExecutableMH, uintptr_t mainExecutableSlide, 
		int argc, const char* argv[], const char* envp[], const char* apple[], 
		uintptr_t* startGlue)
```

