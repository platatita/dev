#pragma once

enum MappingDeviceType
{
	MappingDeviceNone = 0,
	KeyBoard = 1,
	Mouse = 2
};

enum XboxButtonStateType
{
	Down = 0,
	Up = 1
};

enum XinputGamepadType
{
	XinputGamepadNone = 0,
	wButtons = 1,
	bLeftTrigger = 2,
	bRightTrigger = 4,
	sThumbLX = 8,
	sThumbLY = 16,
	sThumbRX = 32,
	sThumbRY = 64
};