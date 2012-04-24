// XbocController.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

using namespace std;

void KeyStorkeWith_KeybdEvent()
{
	  BYTE keyState[256];
	  BYTE virtualKeyCode = 0x41;//VK_RETURN;//VK_NUMLOCK;
	  WORD hardwareScanCode = (WORD)MapVirtualKey(virtualKeyCode, MAPVK_VK_TO_VSC);//0x0D;//0x45;

	  GetKeyboardState((LPBYTE)&keyState);
	  if( (!(keyState[virtualKeyCode] & 1)) || ((keyState[virtualKeyCode] & 1)) )
	  {
			// Simulate a key press
			keybd_event(
				virtualKeyCode,
				(BYTE)hardwareScanCode,
				KEYEVENTF_EXTENDEDKEY | 0,
				0);

			// Simulate a key release
			keybd_event(
				virtualKeyCode,
				(BYTE)hardwareScanCode,
				KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP,
				0);
	  }
}

void KeyStorkeWith_SendInput()
{
	  BYTE keyState[256];
	  BYTE virtualKeyCode = 'A';//0x58;//VK_RETURN;//VK_NUMLOCK;
	  WORD hardwareScanCode = (WORD)MapVirtualKey(virtualKeyCode, MAPVK_VK_TO_VSC);//0x0D;//0x45;

	  GetKeyboardState((LPBYTE)&keyState);
	  if( (!(keyState[virtualKeyCode] & 1)) || ((keyState[virtualKeyCode] & 1)) )
	  {		
			UINT nInputs = 1;

			//KeyDown
			KEYBDINPUT keybdinput;
			//keybdinput.wVk = virtualKeyCode;
			keybdinput.wScan = hardwareScanCode;
			keybdinput.dwFlags = KEYEVENTF_SCANCODE | 0;

			INPUT input;
			input.type = INPUT_KEYBOARD;
			input.ki = keybdinput;

			INPUT pInputs[1] = { input };

			UINT result = SendInput(nInputs, pInputs, sizeof(input));

			//KeyUp			
			keybdinput.wVk = virtualKeyCode;
			keybdinput.wScan = hardwareScanCode;
			keybdinput.dwFlags = KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP;
			
			input.type = INPUT_KEYBOARD;
			input.ki = keybdinput;

			pInputs[0] = input;

			result = SendInput(nInputs, pInputs, sizeof(input));
	  }
}

void ReadGamepadButton()
{
	DWORD dwResult;
	XINPUT_STATE state;
	
	while(true)
	{
		ZeroMemory( &state, sizeof(XINPUT_STATE) );
		dwResult = XInputGetState( 0, &state );
		if( dwResult == ERROR_SUCCESS )
		{ 
			std::cout << "Xbox controller is connected" << endl;
			std::cout << "state.Gamepad.wButtons: " << state.Gamepad.wButtons << endl;
		}
		else
		{
			std::cout << "Xbox controller is disconnected" << endl;
		}

		SleepEx(100, true);
	}
}

int _tmain(int argc, _TCHAR* argv[])
{
	std::cout << "Start" << endl;

	try
	{
		//KeyStorkeWith_SendInput();

		//return 0;

		string path = "XboxButtonMapper.txt";
		vector<XboxButtonMapper> xboxButtonMapperCollection;

		MappingManager mappingManager(path);		
		mappingManager.ReadMapping(xboxButtonMapperCollection);

		XboxButtonReader xboxBurronReader(xboxButtonMapperCollection);
		xboxBurronReader.Start();


		std::cout << "Press 'enter' to end...";
		std::cin.get();

		return 0;
	}
	catch (char* exceptionMessage)
	{
		std::cout << "Occured exception" << endl;
		std::cout << exceptionMessage << endl;

		return -1;
	}
}

