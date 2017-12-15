g++ Firebender.cpp  -std=c++17  -I /home/sysadmin/Desktop/firebender/json/src   -lcurl -ldlib -lboost_system -o  firebender
cd  eschalot/
make 
cd ../
mv eschalot/eschalot eschalot.bin
mv Debug/settings.json .
chmod 755  eschalot.bin firebender
