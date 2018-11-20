TISIMAQ Plugin for Matlab R2013b

1.) Usage in Matlab 
The TISImaq_R2013.dll must be registered manually in Matlab.

Enter
imaqregister("{app}\win32\TISImaq_R2013.dll
or
imaqregister("{app}\x64\TISImaq_R2013.dll

where {app} is the installation directory. The default installationd directory is

c:\Program Files\TIS IMAQ for MATLAB R2013b

The register call for this is:

Matlab 32 bit:
imaqregister("c:\Program Files\TIS IMAQ for MATLAB R2013b\win32\TISImaq_R2013.dll)

Matlab 64bit:
imaqregister("c:\Program Files\TIS IMAQ for MATLAB R2013b\x64\TISImaq_R2013.dll)

Register of the plugin can be done also through the menu in the IMAQ Toolbox of matlab.


Changelog:

3.3.0.0
- Adaption of the old version to Matlab R2013b
- Y16 support added.
- The camera's video format specifies the pixel format of the Matlab image:
Y800 -> Mono8
Y16  -> Mono16
RGB24 -> RGB24
RGB24 -> RGB32



