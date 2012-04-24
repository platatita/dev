#pragma once

#include "stdafx.h"
using namespace std;

class XboxButtonMapperFactory
{
	private:
		string line;

	public:
		XboxButtonMapperFactory(string line)
		{
			this->line = line;
		}

	public:
		bool Create(XboxButtonMapper &xboxButtonMapper)
		{
			basic_string <char>::size_type equalFirstIndex = line.find_first_of("=", 0);
			string gamepadMapperStr = line.substr(0, equalFirstIndex);
			string deviceMapperStr = line.substr(equalFirstIndex + 1);

			basic_string <char>::size_type colonFirstIndex = gamepadMapperStr.find_first_of(":", 0);
			string xinputGamepadTypeStr = gamepadMapperStr.substr(0, colonFirstIndex);
			string gamepadValueStr = gamepadMapperStr.substr(colonFirstIndex + 1);

			colonFirstIndex = deviceMapperStr.find_first_of(":", 0);
			string mappingDeviceTypeStr = deviceMapperStr.substr(0, colonFirstIndex);
			string assignedCodeStr = deviceMapperStr.substr(colonFirstIndex + 1);

			xboxButtonMapper.XinputGamepadType = (enum XinputGamepadType)atoi(xinputGamepadTypeStr.c_str());
			xboxButtonMapper.GamepadValue = atoi(gamepadValueStr.c_str());
			xboxButtonMapper.MappingDeviceType = (enum MappingDeviceType)atoi(mappingDeviceTypeStr.c_str());					
			xboxButtonMapper.AssignedCode = GetAssignedCode(assignedCodeStr);

			return true;
		};

	private:
		WORD GetAssignedCode(string &assignedCodeStr)
		{
			WORD code = 0;
			if (assignedCodeStr.size() == 1)
			{
				code = (WORD)assignedCodeStr.c_str()[0];
			}
			else
			{
				if (assignedCodeStr == "Enter")
				{
					code = VK_RETURN;
				}
			}

			return code;
		};
};