#pragma once

#include "stdafx.h"
using namespace std;

class MouseSendInput : public SendInputBase
{
	public:
		MouseSendInput(void) : SendInputBase()
		{
		};
		~MouseSendInput(void)
		{
		};

	public:
		void SendKey(XboxButtonMapper xboxButtonMapper, XINPUT_STATE xinputState, XboxButtonStateType xboxButtonStateType)
		{
			MOUSEINPUT mouseinput;
			ZeroMemory(&mouseinput, sizeof(MOUSEINPUT));

			if (xboxButtonMapper.XinputGamepadType == ::sThumbLX ||
				xboxButtonMapper.XinputGamepadType == ::sThumbRX)
			{
				if (xinputState.Gamepad.sThumbLX == 32767 ||
					xinputState.Gamepad.sThumbLX == -32768)
				{
					mouseinput.dx = xinputState.Gamepad.sThumbLX / 100;
				}
				else
				{
					mouseinput.dx = xinputState.Gamepad.sThumbLX / 1000;
				}
			}
			if (xboxButtonMapper.XinputGamepadType == ::sThumbLY ||
				xboxButtonMapper.XinputGamepadType == ::sThumbRY)
			{
				if (xinputState.Gamepad.sThumbLY == 32767 ||
					xinputState.Gamepad.sThumbLY == -32768)
				{
					mouseinput.dy = -(xinputState.Gamepad.sThumbLY / 100);
				}
				else
				{
					mouseinput.dy = -(xinputState.Gamepad.sThumbLY / 1000);
				}
			}
			
			mouseinput.dwFlags = MOUSEEVENTF_MOVE;

			INPUT input;
			input.type = INPUT_MOUSE;
			input.mi = mouseinput;

			bool result = SendInputBase::Send(input);
		};
};