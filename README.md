# Minecraft-Mods-Optimizer: The universal solution for reducing minecraft modpacks file size and ram usage.

# How does this work ?
This simple shell script make use of lossy png and ogg compression to produce lighter file size. 

# What type of performance gain can I expect ?
Normally, Minecraft keeps an extra copy of every file it loads out of a JAR file. This wastes a ton of memory.

Since this script will create a lighter mod file, you can expect a diminution in ram usage (less copied to memory) and a faster start time, especially when you have modpack with many different textures/sounds.

In general, you should gain some performance for everything related to loading something in the assets.

You may also experience less CPU overhead when playing several sounds effects at the same time.


#Side note: At the time of writing this file, I didn't check if minecraft makes use of the stereo channel of its audio files  to create a spaced sound environment.
If not, then I'll optimize the audio a bit further.

#Side Note 2: You should also check out these links:
1.7.10: https://forum.feed-the-beast.com/threads/guide-how-to-run-infinity-evolved-with-1-0gb-ram-allocation.149222/

1.8-1.13: https://www.curseforge.com/minecraft/mc-mods/foamfix-for-minecraft

#License
This piece of software relies on a few other ones: PNGQuant; FFMPEG; ZIP/UNZIP.
When using my script, you must respect the license of each of these programs.





