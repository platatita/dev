#pragma once

#include "stdafx.h"
using namespace std;

const int ExitCode = 16;

class XboxButtonReader
{
	private:
		vector<XboxButtonMapper> _xboxButtonMapperCollection;
		bool _xboxConnected;
		bool _xboxDisConnected;
		XINPUT_STATE _lastXinputState;

	public:
		XboxButtonReader(vector<XboxButtonMapper> &xboxButtonMapperCollection)
		{
			this->_xboxButtonMapperCollection = xboxButtonMapperCollection;
			this->_xboxConnected = false;
			this->_xboxDisConnected = false;
		};
		~XboxButtonReader(void)
		{
		};	

	public:
		void Start()
		{		
			DWORD dwResult;
			XINPUT_STATE state;
			
			while(true)
			{
				ZeroMemory(&state, sizeof(XINPUT_STATE));
				dwResult = XInputGetState(0, &state);				

				if (dwResult == ERROR_SUCCESS )
				{ 
					XboxControllerConnected();
					DisplayXinputStateDebugInfo(state);
					ProcessXboxButtonMapperCollection(state);
				}
				else
				{
					XboxControllerDisConnected();
				}

				if (Exit(state))
				{
					break;
				}
				else
				{
					SleepEx(25, true);

					this->_lastXinputState = state;
				}
			}
		};

	private:
		void XboxControllerConnected()
		{
			if (!this->_xboxConnected)
			{
				std::cout << "Xbox controller is connected" << endl;
				this->_xboxConnected = true;
				this->_xboxDisConnected = false;
			}
		};

		void DisplayXinputStateDebugInfo(XINPUT_STATE state)
		{
			if (state.Gamepad.wButtons != this->_lastXinputState.Gamepad.wButtons)
			{
				std::cout << "state.Gamepad.wButtons: " << state.Gamepad.wButtons << endl;
			}
			if (state.Gamepad.bLeftTrigger != this->_lastXinputState.Gamepad.bLeftTrigger)
			{
				std::cout << "state.Gamepad.bLeftTrigger: " << state.Gamepad.bLeftTrigger << endl;
			}
			if (state.Gamepad.bRightTrigger != this->_lastXinputState.Gamepad.bRightTrigger)
			{
				std::cout << "state.Gamepad.bRightTrigger: " << state.Gamepad.bRightTrigger << endl;
			}
			if (state.Gamepad.sThumbLX != this->_lastXinputState.Gamepad.sThumbLX)
			{
				std::cout << "state.Gamepad.sThumbLX: " << state.Gamepad.sThumbLX << endl;
			}
			if (state.Gamepad.sThumbLY != this->_lastXinputState.Gamepad.sThumbLY)
			{
				std::cout << "state.Gamepad.sThumbLY: " << state.Gamepad.sThumbLY << endl;
			}
			if (state.Gamepad.sThumbRX != this->_lastXinputState.Gamepad.sThumbRX)
			{
				std::cout << "state.Gamepad.sThumbRX: " << state.Gamepad.sThumbRX << endl;
			}
			if (state.Gamepad.sThumbRY != this->_lastXinputState.Gamepad.sThumbRY)
			{
				std::cout << "state.Gamepad.sThumbRY: " << state.Gamepad.sThumbRY << endl;
			}
		};

		void XboxControllerDisConnected()
		{
			if (!this->_xboxDisConnected)
			{
				std::cout << "Xbox controller is disconnected" << endl;
				this->_xboxConnected = false;
				this->_xboxDisConnected = true;
			}
		};

		bool Exit(XINPUT_STATE state)
		{
			bool result = state.Gamepad.wButtons == ExitCode;
			if (result)
			{
				std::cout << "XboxControllerReader will be stopped, becuse you pressed: " << state.Gamepad.wButtons << " button." << endl;
			}

			return result;
		};

		void ProcessXboxButtonMapperCollection(XINPUT_STATE xinputState)
		{
			for (unsigned int i = 0; i < this->_xboxButtonMapperCollection.size(); i++)
			{
				XboxButtonMapper xboxButtonMapper = this->_xboxButtonMapperCollection[i];
				if (xboxButtonMapper.XinputGamepadType == ::wButtons)
				{
					if ((xboxButtonMapper.GamepadValue & xinputState.Gamepad.wButtons) == xboxButtonMapper.GamepadValue)
					{
						std::cout << "You pressed button: " << xboxButtonMapper.GamepadValue << endl;
						if (xboxButtonMapper.MappingDeviceType == KeyBoard)
						{
							KeyBoardSendInput keyBoardSendInput;
							keyBoardSendInput.SendKey(xboxButtonMapper, ::Down);
						}
						else if (xboxButtonMapper.MappingDeviceType == Mouse)
						{
							MouseSendInput mouseSendInput;
							mouseSendInput.SendKey(xboxButtonMapper, xinputState, ::Down);
						}
					}
				}
				else if (xboxButtonMapper.XinputGamepadType >= ::sThumbLX && 
					xboxButtonMapper.XinputGamepadType <= ::sThumbRY)
				{
					if (xinputState.Gamepad.sThumbLX != this->_lastXinputState.Gamepad.sThumbLX ||
						xinputState.Gamepad.sThumbLY != this->_lastXinputState.Gamepad.sThumbLY ||
						xinputState.Gamepad.sThumbRX != this->_lastXinputState.Gamepad.sThumbRX ||
						xinputState.Gamepad.sThumbRY != this->_lastXinputState.Gamepad.sThumbRY)
					{
						std::cout << "You moved" << endl;
						if (xboxButtonMapper.MappingDeviceType == KeyBoard)
						{
							KeyBoardSendInput keyBoardSendInput;
							keyBoardSendInput.SendKey(xboxButtonMapper, ::Down);
						}
						else if (xboxButtonMapper.MappingDeviceType == Mouse)
						{
							MouseSendInput mouseSendInput;
							mouseSendInput.SendKey(xboxButtonMapper, xinputState, ::Down);
						}
					}
				}
				else
				{
					std::cout << "Wrong mapping definition in the mapping file. No action for defined MappingDeviceType: " << xboxButtonMapper.MappingDeviceType << endl;
				}
			}
		}
};