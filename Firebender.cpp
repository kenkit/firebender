#include <curl/curl.h>

#include <stdio.h>
#include <iostream>
#include <string>
#include <map>
#include <unordered_map>
#include <condition_variable>
#include <mutex>
#include <thread>
#include <regex> // second solution

#include <boost/filesystem.hpp>
#include <boost/container/flat_map.hpp>
#include <boost/timer/timer.hpp>
#include <boost/algorithm/string/replace.hpp>
#include "boost/algorithm/string.hpp"
#include <boost/thread.hpp>
#include<boost/regex.hpp>

#include <boost/unordered_map.hpp>


#include "json.hpp"

#include <fstream>


#include <dlib/server.h>
#include <dlib/logger.h>
#include <dlib/misc_api.h>
#include <dlib/threads.h>

using namespace std;
////to do
//http://www.forexfactory.com/ff_calendar_thisweek.xml
//mt5-user-204359 pwd-gmi8tvja inv-6tyfxezh
void clear(void);
int say(std::string s);

size_t CurlWrite_CallbackFunc_StdString(void *contents, size_t size, size_t nmemb, std::string *s);


struct user_data{
	std::string url;
	std::string curr_user;
	std::string api_secret;
	std::string json;
	int connect_type;

};
std::string local_db_connect(user_data user_data)
{
	  CURLcode ret;
  CURL *hnd;
  struct curl_slist *slist1;
std::string scan_result;
  slist1 = NULL;
  slist1 = curl_slist_append(slist1, "Content-Type: application/json");
		curl_slist_append(slist1, ("api_secret: "+user_data.api_secret).c_str());
		curl_slist_append(slist1, ("userhash: "+user_data.curr_user).c_str());
  hnd = curl_easy_init();
  curl_easy_setopt(curl, CURLOPT_PROXY,"socks5h://localhost:9050");///CHANGE THIS TO MATCH YOUR TOR CLIENT PORT
  curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_SOCKS5);
  curl_easy_setopt(hnd, CURLOPT_URL, user_data.url.c_str());
  curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
  curl_easy_setopt(hnd, CURLOPT_POSTFIELDS, user_data.json.c_str());
  curl_easy_setopt(hnd, CURLOPT_COOKIE, ("userhash="+user_data.curr_user).c_str());
  curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/7.38.0");
  curl_easy_setopt(hnd, CURLOPT_HTTPHEADER, slist1);
  curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
  curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "POST");
  curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(hnd, CURLOPT_VERBOSE, 0);
  curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, CurlWrite_CallbackFunc_StdString);
  curl_easy_setopt(hnd, CURLOPT_WRITEDATA, &scan_result);
  ret = curl_easy_perform(hnd);

  curl_easy_cleanup(hnd);
  hnd = NULL;
  curl_slist_free_all(slist1);
  slist1 = NULL;


return  scan_result;
}



std::string urlEncode(std::string str) {
	using namespace std;
	string new_str = "";
	char c;
	int ic;
	const char* chars = str.c_str();
	char bufHex[10];
	int len = strlen(chars);

	for (int i = 0; i<len; i++) {
		c = chars[i];
		ic = c;
		// uncomment this if you want to encode spaces with +
		/*if (c==' ') new_str += '+';
		else */if (isalnum(c) || c == '-' || c == '_' || c == '.' || c == '~') new_str += c;
		else {
			sprintf(bufHex, "%X", c);
			if (ic < 16)
				new_str += "%0";
			else
				new_str += "%";
			new_str += bufHex;
		}
	}
	return new_str;
}
std::string TCHARPtr2string(const TCHAR* ptsz)
{
	if (sizeof(TCHAR) == 1)
		return "";
	int len = wcslen(ptsz);
	char* psz = new char[2 * len + 1];
	wcstombs(psz, ptsz, 2 * len + 1);
	std::string s = psz;
	delete[] psz;
	return s;
}
size_t CurlWrite_CallbackFunc_StdString(void *contents, size_t size, size_t nmemb, std::string *s)
{
	size_t newLength = size*nmemb;
	size_t oldLength = s->size();
	try
	{
		s->resize(oldLength + newLength);
	}
	catch (std::bad_alloc &e)
	{
		//handle memory problem
		return 0;
	}

	std::copy((char*)contents, (char*)contents + newLength, s->begin() + oldLength);
	return size*nmemb;
}
std::string convert_date(std::string date)
{
	//2017-08-17T10:30:00.014Z
	int found = date.find_first_of("T");
	//int found2 = date.find_first_of("Z");
	std::string date2;
	std::string time;
	date2.assign(date, 0, found);
	
	time.assign(date,found + 1, 8);

	date2 = date2+" "+time;
	date2 = urlEncode(date2);
	return date2;
}

void clear() {
	COORD topLeft = { 0, 0 };
	HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
	CONSOLE_SCREEN_BUFFER_INFO screen;
	DWORD written;

	GetConsoleScreenBufferInfo(console, &screen);
	FillConsoleOutputCharacterA(
		console, ' ', screen.dwSize.X * screen.dwSize.Y, topLeft, &written
	);
	FillConsoleOutputAttribute(
		console, FOREGROUND_GREEN | FOREGROUND_RED | FOREGROUND_BLUE,
		screen.dwSize.X * screen.dwSize.Y, topLeft, &written
	);
	SetConsoleCursorPosition(console, topLeft);
}

std::string ssystem (const char *command) {
    char tmpname [L_tmpnam];
    std::tmpnam ( tmpname );
    std::string scommand = command;
    std::string cmd = scommand + " > " + tmpname;
    std::system(cmd.c_str());
    std::ifstream file(tmpname, std::ios::in );
    std::string result;
        if (file) {
      while (!file.eof()) result.push_back(file.get());
          file.close();
    }
    remove(tmpname);
    return result;
}


void getBtwString(std::string oStr, std::string sStr1, std::string sStr2, std::string &rStr)
{
    using namespace std::literals::string_literals;
    auto start = sStr1;
    auto end = sStr2;
    std::regex base_regex(start + "(.*)" + end);
    auto example = oStr;
    std::smatch base_match;
    std::string matched;
    if (std::regex_search(example, base_match, base_regex)) {
    if (base_match.size() == 2) {
        matched = base_match[1].str();
        }
       rStr = matched;
	}

}

int do_job(std::string settings_json)
{
int status;
	using namespace nlohmann;
user_data request_j,send_j;
json settings = json::parse(settings_json);

request_j.url="http://flamyop4nnz27qnu.onion/json?type=get_job";
request_j.connect_type=1;
send_j.url="http://flamyop4nnz27qnu.onion/json?type=submit_job";
send_j.connect_type=0;

request_j.curr_user=settings["user_id"].get<std::string>();
send_j.curr_user=settings["user_id"].get<std::string>();
request_j.api_secret=settings["api_secret"].get<std::string>();
send_j.api_secret=settings["api_secret"].get<std::string>();

std::string jobs=local_db_connect(request_j);

if(jobs.length()<4)
return status;
json j1 = json::parse(jobs);
	
	std::string cur_user ,onion_url, private_key ,terms,display_hash,strout,json_string;
	int origin;
	
				cur_user= j1["curr_user"].get<std::string>();
				status=j1["status_code"].get<int>();

	if (!j1["error"].get<bool>()) {

		if(j1["status_code"].get<int>()!=0)
		return status;
			origin=j1["jobs"]["origin"].get<int>();
			terms=j1["jobs"]["terms"].get<std::string>();
		display_hash=ssystem(std::string("eschalot.exe -vt2  -p "+terms).c_str());
		boost::replace_all(display_hash, "\n", "<br>");	
		getBtwString(display_hash,"-----BEGIN RSA PRIVATE KEY-----<br>","<br>-----END RSA PRIVATE KEY-----<br>",private_key); 
		
		getBtwString(display_hash,"<br>","<br>-----BEGIN RSA PRIVATE KEY-----",onion_url); 
			//std::cout<<"******************************************"<< std::endl<<
		 	//private_key<<std::endl
			// <<"******************************************"<< std::endl;
		//boost::algorithm::erase_all(private_key,  "<br>");	 
		//boost::replace_all(display_hash,  "<br>","\n");	

		json_string="{ \"jobs\": { \"origin\": "+std::to_string(origin);
		json_string+=", \"onionurl\": \"";
		json_string+=onion_url+"\", \"terms\": \"";
		json_string+=terms+"\", \"private_key\": \"";
		json_string+=private_key;
		json_string+="\" }, \"error\": false, \"status_code\": 0, \"curr_user\": \"";
		json_string+=cur_user+"\" }";


send_j.curr_user=cur_user;
//send_j.bitcoin_address;
send_j.json=json_string;

std::string sendjobresult=local_db_connect(send_j);
std::cout<<sendjobresult;
return 0;
}
	std::cout<<"Current User:"<<cur_user<<" status:"<<status<<std::endl;




return status;
}

int main(void)
{
ifstream mysettings("settings.json");


std::string settings((std::istreambuf_iterator<char>(mysettings)),
                 std::istreambuf_iterator<char>());

mysettings.close();


while(1){
	int status=do_job(settings);
if(status!=0&&status!=1)
break;
dlib::sleep(2000);

}


	std::cin.get();

	return 0;
}

#ifdef _WIN32
void kill_by_pid(int pid)
{
	HANDLE handy;
	handy = OpenProcess(SYNCHRONIZE | PROCESS_TERMINATE, TRUE, pid);
	TerminateProcess(handy, 0);
}

int say(std::string s)
{
	using namespace std;
	string part1content;
	string part2content;
	string word, complete;
	const char * temp2 = "WScript.exe Scrpt.vbs";
	const char * temp = "Scrpt.vbs";

	string pat1 = (
		"\'By Timbo\n\n\
Const SVSFlagsAsync = 1\n\
const SVSFPurgeBeforeSpeak =2\n\n\
Dim Speech\n\
Dim FSO\n\n\
CreateObjects\n\
Main\n\
DestroyObjects\n\
Quit\n\n\
Sub Main\n\
        Dim sText\n\n\
        sText = (\""
		);
	string pat2 =
		(
			"\")\n\
	Speech.rate = 0.05\n\
        If sText <> \"\" Then\n\
                SpeakText sText\n\n\
        End If\n\
End Sub\n\n\
Sub SpeakText(sText)\n\
        On Error Resume Next\n\
        Speech.Speak sText, SVSFlagsAsync + SVSFPurgeBeforeSpeak\n\
        Do\n\
                Sleep 200\n\
        Loop Until Speech.WaitUntilDone(10)\n\
End Sub\n\n\
Sub StopSpeaking()\n\
        On Error Resume Next\n\
        Speech.Speak vbNullString, SVSFPurgeBeforeSpeak\n\
        Set Speech = Nothing\n\
End Sub\n\n\
Sub CreateObjects\n\
        Set Speech = CreateObject(\"SAPI.SpVoice\")\n\
		with Speech \n\
			Set .voice = .getvoices.item(1)\n\
			.Volume = 100\n\
			.Rate = 4\n\
		end with\n\
        Set FSO = CreateObject(\"Scripting.FileSystemObject\")\n\
End Sub\n\n\
Sub DestroyObjects\n\
        Set Speech = Nothing\n\
        Set FSO = Nothing\n\
End Sub\n\n\
Sub Sleep(nTimeout)\n\
        WScript.Sleep nTimeout\n\
End Sub\n\n\
Sub Quit\n\
        WScript.Quit\n\
End Sub\n\n\
"
);

	/*Will say string s*/

	complete = pat1 + s + pat2;

	ofstream myfile;
	myfile.open(temp);
	myfile << complete;
	myfile.close();
	system(temp2);
	complete.clear();
	s.clear();
	return 0;
}
#endif