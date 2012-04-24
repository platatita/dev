#pragma once

#include "stdafx.h"
using namespace std;

class MappingManager
{
	private:
		string _pathToMappingFile;

	public:
		MappingManager(string pathToMappingFile)
		{
			this->_pathToMappingFile = pathToMappingFile;
		};
		~MappingManager(void)
		{
		};

	public:
		void ReadMapping(vector<XboxButtonMapper> &xboxButtonMapperCollection)
		{				
			ifstream stream;				

			try
			{
				int lineNr = 0;
				OpenStream(stream);

				while(stream.good())
				{
					char buffer[128];
					stream.getline(buffer, 128);

					string line(buffer);						
					std::cout << "Read line nr " << lineNr << ": " << line << endl;
					if (!line.empty())
					{
						XboxButtonMapper xboxButtonMapper;
						XboxButtonMapperFactory xboxButtonMapperFactory(line);
						xboxButtonMapperFactory.Create(xboxButtonMapper);

						xboxButtonMapperCollection.push_back(xboxButtonMapper);
					}

					lineNr++;
				}

				CloseStream(stream);
			}
			catch (...)
			{
				CloseStream(stream);
			}
		};

	private:
		void OpenStream(ifstream& stream)
		{
			stream.open(this->_pathToMappingFile.data());
			if (!stream.rdbuf()->is_open())
			{
				throw "Cannot open file to read key mapping data";
			}				
		};

		void CloseStream(ifstream& stream)
		{
			if (stream)
			{
				stream.close();
			}
		};
};
