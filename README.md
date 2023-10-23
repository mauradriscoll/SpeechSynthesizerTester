# Issues with `AVSpeechSynthesizer` using `speakUtterance` 
This is a sample app to reproduce an error when using `speakUtterance` and `AVSpeechSynthesizer`.

The particular error we are interested in is:

```
EXC_BAD_ACCESS: _Uninitialize > (err = PerformCommand(*graphNode, kAUUninitialize, NULL, 0)) > XTUM >
KERN_INVALID_ADDRESS at 0xd58ba54c0.
```
### Test Environment
Xcode 14.3.1 (14E300c) \
macOS Ventura 13.4.1 (c) (22F770820d)

**Devices we've tested on that reproduce the error:** \
iPhone 15 iOS 17.0.3

**Devices we've tested on that do not reproduce the error:**\
iPhone 6S iOS 15.7.9 \
iPhone 11 iOS 16.2 \
iPhone 11 iOS 16.7.1

### Steps to Reproduce:
1. Under `Signing and Capabilities` in the `SpeechSynthesizerTester` target settings be sure to change the `Developer Team` and `Bundle Identifier` \
  (Developer Team can be changed to your Personal Team and bundle identifier can be changed to `com.example.yourname.SpeechSynthesizerTester`)
2. In `Edit Scheme` verify that `Address Sanitizer` is **on** under `Diagnositics` (this should be on by default)
3. Run `SpeechSynthesizerTester` on a test device (**this must be run on a device and not a simulator**)
4. Tap the `Press to Speak` button
5. Observe an error in Xcode debug console with the stack trace: 
```
==55951==ERROR: AddressSanitizer: attempting free on address which was not malloc()-ed: 0x000111104080 in thread T2
    #0 0x10386827c in wrap_free+0x98 (/private/var/containers/Bundle/Application/1645A872-5862-462F-A988-FBAC5FBBC831/SpeechSynthesizerTester.app/Frameworks/libclang_rt.asan_ios_dynamic.dylib:arm64e+0x4427c) (BuildId: dd8fa69d78593aa0a0be22838752887c32000000200000000200000000000e00)
    #1 0x1f78deae8 in __cxa_decrement_exception_refcount+0x40 (/usr/lib/libc++abi.dylib:arm64e+0x13ae8) (BuildId: f26061f8fa3a3b11adf33b98d17f75f332000000200000000200000000001100)
    #2 0x19af88b10 in <redacted>+0x378 (/System/Library/PrivateFrameworks/AudioToolboxCore.framework/AudioToolboxCore:arm64e+0x10b10) (BuildId: 8f46cd5def783eb085e6d8dc67b7bb7132000000200000000200000000001100)
    #3 0x19af88758 in AudioConverterNew+0x154 (/System/Library/PrivateFrameworks/AudioToolboxCore.framework/AudioToolboxCore:arm64e+0x10758) (BuildId: 8f46cd5def783eb085e6d8dc67b7bb7132000000200000000200000000001100)
    #4 0x203374834 in <redacted>+0x84 (/System/Library/Frameworks/AudioToolbox.framework/libEmbeddedSystemAUs.dylib:arm64e+0xd834) (BuildId: 7e3aad17d95439ee917d8d0a6feada4132000000200000000200000000001100)
    #5 0x203379a00 in <redacted>+0x124 (/System/Library/Frameworks/AudioToolbox.framework/libEmbeddedSystemAUs.dylib:arm64e+0x12a00) (BuildId: 7e3aad17d95439ee917d8d0a6feada4132000000200000000200000000001100)
...
Address 0x000111104080 is a wild pointer inside of access range of size 0x000000000001.
SUMMARY: AddressSanitizer: bad-free (/private/var/containers/Bundle/Application/1645A872-5862-462F-A988-FBAC5FBBC831/SpeechSynthesizerTester.app/Frameworks/libclang_rt.asan_ios_dynamic.dylib:arm64e+0x4427c) (BuildId: dd8fa69d78593aa0a0be22838752887c32000000200000000200000000000e00) in wrap_free+0x98
Thread T2 created by T0 here:
    <empty stack>

==55951==ABORTING
```
### Notes:
1. To most reliably reproduce the error, please test on a device running iOS 17.0+. We have receivied crash reports from devices running iOS 16, but fewer than iOS 17. We have not received any crash reports from devices running iOS 15. We got our first reported crash due to this error on July 24th, 2023 \
(Here is a table taken from our crash reporting service that shows the number of crashes we have seen on specific iOS versions (as of October 20th, 2023): 
[speakUtteranceCrash.zip](https://github.com/mauradriscoll/SpeechSynthesizerTester/files/13079806/speakUtteranceCrash.zip))
2. There are many similar reports in Apple Dev Forums with no good workarounds (https://developer.apple.com/forums/thread/732335)
