# Firebender (A Flamey Onion Client)

## AV:Build Status

<img src="https://ci.appveyor.com/api/projects/status/github/kenkit/firebender?svg=true" alt="Project Badge" width="300">

<img src="https://img.shields.io/github/stars/kenkit/firebender.svg" alt="Project Stars" width="100">


- Automatic builds are available in the release directory.


## [[DOWNLOAD]][1]

Download the app and modify your settings.json to point to your account nfo. open the **Api page** on our **server** and copy the contents of that **text box** to your **settings.json**. 
Add your tor_port to the settings so that Firebender can connect through your tor client.
Use the tor port which your tor browser listens to (This app connects to our site using tor)

After setting up tor, 


Put settings.json in the same directory as **Firebender.exe**


![](https://i.imgur.com/Rbb0UIn.jpg)



Then launch Firebender after starting tor.

![Firebend](https://i.imgur.com/QhWKfIA.jpg "Firebend")

If **Firebender.exe** stops updating with a status other than **1** that, it means there were errors detected. Just press enter and check your keys and start again.

If it crashes it means it failed to connect through tor.


When a job is received from our server. Firebender will automatically work on them and send them to our server. 


This project was built using the following lib
- Boost
- Libcurl
- dlib
- jsonpp

Official eschalot repo:

- [Eschalot](https://github.com/ReclaimYourPrivacy/eschalot "Eschalot")


When everything is set ,firebender will  display "waiting for jobs.."


Flamey Onions will be available on the clearnet in a week or so.

**I have my hands full, I also have to work on the main system. Firebender works for now, improvements to this code are accepted and will be merged if they are okay, someone can lets say add shalot and other types of miners.**



[1]: https://github.com/kenkit/firebender/releases "DOWNLOAD"