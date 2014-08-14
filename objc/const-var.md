
`#define ANIMATION_DURATION 0.3`
- This is a preprocessor directive; whenever the string ANIMATION_DURATION is found in your source code, it is replaced with 0.3

`static const NSTimeInterval kAnimationDuration = 0.3;`
- “The const qualifier means that the compiler will throw an error if you try to alter the value”
- “The static qualifier means that the variable is local to the translation unit in which it is defined”
