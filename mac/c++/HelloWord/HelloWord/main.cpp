#include <iostream>
#include "XmlParser.h"

using namespace std;

int main (int argc, char *argv[])
{
	cout << "Hello world!" << endl;
	
	XmlParser *xmlParser = new XmlParser();
	xmlParser->Display();
	
	delete xmlParser;
	
	return 0;
}

