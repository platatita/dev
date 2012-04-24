#pragma once

#include "stdafx.h"

struct XboxButtonMapper
{	
	XinputGamepadType XinputGamepadType;
	int GamepadValue;
	MappingDeviceType MappingDeviceType;
	WORD AssignedCode;

	XboxButtonMapper(void)
	{
		this->XinputGamepadType = ::XinputGamepadNone;
		this->GamepadValue = 0;				
		this->MappingDeviceType = ::MappingDeviceNone;
		this->AssignedCode = 0;
	}
};