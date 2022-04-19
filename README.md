# Broadcast-Upload-Extension
A simple broadcast upload extension to help you test your ReplayKit code before app review.

## Why you are here
You are trying to use ReplayKit in an iOS app and App Review is rejecting you because they expect you to also implement a Broadcast Upload Extension but refuse to tell you that it's a requirement.  This contradicts the spirit of app extensions, you're irritated and they keep suggesting that you look to the Apple Developer Forums where you find answers like this https://developer.apple.com/forums/thread/60566.

Spoiler alert, the post is 5+ years old with zero replies.

## How to solve your issue
This is a simple implementation of a Broadcast Upload Extension that encodes your stream and saves it as an mp4 into the Photos Library.

I recommend that you title your extensions with simple names like 'Record' or 'Local' or some other simple, short title to help convey what they do without the horrible word-wrapping that occurs in Apple's UI.

1. First, create a Broadcast Upload Extension target in your app. You will also need a Broadcast Upload Setup UI target so you can do that at the same time or later.

* The title of the Broadcast Upload Extension will show up in the list of extensions when you long press the screen record button in the iOS control pannel.
* The title of the Setup UI extension will show up in the RPBroadcastActivityViewController, but you end up at the same block of code either way.

2. Add PhotoAddUsageDescription to the Info.plist in the Upload Extension
3. Use swift package manager to include git@github.com:romiroma/BroadcastWriter.git for your Upload Extension.
4. Copy the code from the .swift files here into your corresponding files in the new targets you created.
5. Replace the indicated strings in your code.
6. Test to make sure it works!

## Thank You!
This code is a compilation of solutions I was able to find across Stack Overflow, GitHub and other random places.
https://github.com/romiroma/BroadcastWriter/commits?author=romiroma provided a great starting place, thank you for that!
And of course thanks goes out to everyone on the internet that tried to explain how this worked, except Apple who did a horrible job at it.
