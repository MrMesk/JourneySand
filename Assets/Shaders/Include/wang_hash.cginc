#ifndef _WANG_HASH_CGINC_
#define _WANG_HASH_CGINC_

//taken from http://www.reedbeta.com/blog/2013/01/12/quick-and-easy-gpu-random-numbers-in-d3d11/
//Please see also http://www.burtleburtle.net/bob/hash/integer.html
uint wang_hash(uint seed)
{
    seed = (seed ^ 61) ^ (seed >> 16);
    seed *= 9;
    seed = seed ^ (seed >> 4);
    seed *= 0x27d4eb2d;
    seed = seed ^ (seed >> 15);
    return seed;
}

#endif
