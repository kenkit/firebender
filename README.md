# Firebender (A Flamey Onion Client)

- Automatic builds are not available yet. But am working on  this.

- Please build by yourself for now.



After downloading please update your tor **socks port** in Firebender.cpp to point to your Tor clients port.

After setting up the server address, open the **Api page** on our **server** and copy the contents of that **text box** to your **settings.json**.
![](https://i.imgur.com/Rbb0UIn.jpg)

![Firebend](https://i.imgur.com/2fLKzJU.jpg "Firebend")

If Firebender stops updating with a status other than **1** that, it means there were errors detected. Just press enter and check your keys and start again.

I will add more info on the error codes as time goes by.

When a job is received from our server. Firebender will automatically work on them and send them to our server. 


This project was built using the following lib
- Boost
- Libcurl
- dlib
- jsonpp

Other tools need to use it are
- [Eschalot](https://github.com/ReclaimYourPrivacy/eschalot "Eschalot")

After building the above open the project file and update your dependancies in visual studio  and build.
Also download eschalot build and put it in the same directory firebender.exe was generated.
Normally firebender will run and display status 1 while waiting for jobs.
Flamey Onions will be available on the clearnet in a week or so.

**I have my hands full, I also have to work on the main system. The client works for now improvements to this code are accepted and will be merged if they are okay.**

## AV:Build Status

<img src="https://ci.appveyor.com/api/projects/status/github/kenkit/firebender?svg=true" alt="Project Badge" width="300">

<img src="https://img.shields.io/github/stars/kenkit/firebender.svg" alt="Project Stars" width="100">


