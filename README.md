# c2-alpha-dither

This 2018 WebGL fragment shader (src/alphadither.fx) is a modified version of a shader for use in the [Construct 2](https://www.scirra.com/store/construct-2) game engine, generated for the 3x IGF nominated game [Hypnospace Outlaw](http://www.hypnospace.net/) ([Steam](https://store.steampowered.com/app/844590/Hypnospace_Outlaw/)). 

Based on input dither value (and optionally on existing alpha value of the pixel) this shader adjusts the alpha value of virtual pixels to output various dither patterns of varying "transparency."

![screenshot](https://github.com/thatwhichis/c2-alpha-dither/blob/master/screenshot.png)
