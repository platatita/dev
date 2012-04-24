#pragma once

#include "stdafx.h"
using namespace std;

class KeyBoardSendInput : public SendInputBase
{
	public:
		KeyBoardSendInput(void) : SendInputBase()
		{
		};
		~KeyBoardSendInput(void)
		{
		};

	public:
		void SendKey(XboxButtonMapper xboxButtonMapper, XboxButtonStateType xboxButtonStateType)
		{
			KEYBDINPUT keybdinput;
			ZeroMemory(&keybdinput, sizeof(KEYBDINPUT));

			keybdinput.wScan = this->GetHardwareScanCode(xboxButtonMapper.AssignedCode);
			keybdinput.dwFlags = this->GetDwFlags(xboxButtonStateType);

			INPUT input;
			input.type = INPUT_KEYBOARD;
			input.ki = keybdinput;

			bool result = SendInputBase::Send(input);
		};

	protected:
		virtual WORD GetHardwareScanCode(WORD assignedCode)
		{
			return (WORD)MapVirtualKey((BYTE)assignedCode, MAPVK_VK_TO_VSC);
		};

		virtual DWORD GetDwFlags(XboxButtonStateType xboxButtonStateType)
		{
			if (xboxButtonStateType == ::Up)
			{
				return KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP | 0;
			}
			else
			{
				return KEYEVENTF_SCANCODE | 0;
			}
		};
};