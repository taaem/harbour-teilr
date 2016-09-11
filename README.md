## Teilr
This is an unofficial Tumblr Client for Sailfish OS.
Its an early project and can NOT considered stable.
Also many functionallity is missing.

### Building
```
git clone https://github.com/taaem/harbour-teilr.git
cd harbour-teilr

// SSH into the build VM
ssh -p 2222 -i ~/SailfishOS/vmshare/ssh/private_keys/engine/mersdk mersdk@localhost

// Build kQOAuth
// Installing dependencies
sb2 -t SailfishOS-i486 -m sdk-install -R zypper in openssl-devel openssl
sb2 -t SailfishOS-armv7hl -m sdk-install -R zypper in openssl-devel openssl

//Building and installing kQOAuth
sb2 -t SailfishOS-i486 -m sdk-build qmake
sb2 -t SailfishOS-i486 -m sdk-build make clean
sb2 -t SailfishOS-i486 -m sdk-build make
sb2 -t SailfishOS-i486 -m sdk-install -R make install

sb2 -t SailfishOS-armv7hl -m sdk-build qmake
sb2 -t SailfishOS-armv7hl -m sdk-build make clean
sb2 -t SailfishOS-armv7hl -m sdk-build make
sb2 -t SailfishOS-armv7hl -m sdk-install -R make install
```

Next you have to obtain API Keys from tumblr and put them into a file called privatekeys.h in the src/ directory.
For reference look at the examplekeys.h file.

Now you can build Teilr from the Sailfish OS IDE

### License
GPL-v2
