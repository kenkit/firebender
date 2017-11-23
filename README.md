# Firebender (A Flamey Onion Client)

## AV:Build Status

<img src="https://ci.appveyor.com/api/projects/status/github/kenkit/firebender?svg=true" alt="Project Badge" width="300">

<img src="https://img.shields.io/github/stars/kenkit/firebender.svg" alt="Project Stars" width="100">


- Automatic builds are available in the release directory.

- I am working on intergrating eschalot into the project automatically.

## [[DOWNLOAD]][1]

Download the app and setup Tor to listen on port 9050 in your torc

After setting up tor, open the **Api page** on our **server** and copy the contents of that **text box** to your **settings.json**.

Put settings.json in the same directory as **Firebender.exe**

![](https://i.imgur.com/Rbb0UIn.jpg)

Then you have to either download or build **eschalot.exe** and put it in the same directory as **Firebender.exe**

Then launch Firebender after starting tor.

![Firebend](https://i.imgur.com/2fLKzJU.jpg "Firebend")

If **Firebender.exe** stops updating with a status other than **1** that, it means there were errors detected. Just press enter and check your keys and start again.

If it crashes it means it failed to connect to our server.

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



[1]: https://github.com/kenkit/firebender/releases "DOWNLOAD"