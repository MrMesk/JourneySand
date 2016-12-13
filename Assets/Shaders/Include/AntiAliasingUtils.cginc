#ifndef _ANTI_ALIASING_UTILS_
#define _ANTI_ALIASING_UTILS_

float AlphaDoor5A(float minU, float maxU, float doorMinU, float doorMaxU, float epsilon)
{    
    const float range = doorMaxU - doorMinU;
    const float subPosInRange = (minU - doorMinU) / range;
    const float subPosClamped = saturate(subPosInRange);
    
    const float highPosInRange = (maxU - doorMinU) / range;
    const float highPosClamped = saturate(highPosInRange);
    const float subIntegral = subPosClamped;
    const float highIntegral = highPosClamped;
    return saturate((highIntegral - subIntegral) / (highPosInRange - subPosInRange + epsilon));
}

float AlphaDoor5A(float minU, float maxU, float doorMinU, float doorMaxU)
{
    #if 0
    const float range = doorMaxU - doorMinU;
    const float subPosInRange = (minU - doorMinU) / range;
    const float subPosClamped = saturate(subPosInRange);
    
    const float highPosInRange = (maxU - doorMinU) / range;
    const float highPosClamped = saturate(highPosInRange);
    const float subIntegral = subPosClamped;
    const float highIntegral = highPosClamped;
    return saturate((highIntegral - subIntegral) / (highPosInRange - subPosInRange ));
    #else
    // highPosInRange - subPosInRange = (maxU - doorMinU) / range - (minU - doorMinU) / range;
    // highPosInRange - subPosInRange = (maxU - doorMinU - minU + doorMinU) / range;
    // highPosInRange - subPosInRange = (maxU - minU) / range;
    // 1 / (highPosInRange - subPosInRange) = range / (maxU - minU);
    
    // +
    
    // const float highPosInRange = (maxU - doorMinU) / range;
    // const float highPosClamped = saturate(highPosInRange);
    // highPosClamped = clamp(maxU - doorMinU, 0, range) / range
    // idem : subPosClamped = clamp(minU - doorMinU, 0, range) / range
    // ainsi : highIntegral - subIntegral = (clamp(maxU - doorMinU, 0, range) - clamp(minU - doorMinU, 0, range)) / range
    // ainsi  :
    // => 
    
    const float maxUClamped = clamp(maxU, doorMinU, doorMaxU);
    const float minUClamped = clamp(minU, doorMinU, doorMaxU);
    return saturate((maxUClamped - minUClamped) / (maxU - minU));
    
    #endif
}

#endif