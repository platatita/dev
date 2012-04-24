#pragma once

#include "stdafx.h"
using namespace std;

class SendInputBase
{
	protected:
		SendInputBase(void)
		{
		};
		~SendInputBase(void)
		{
		};

	protected:
		bool Send(INPUT input)
		{
			UINT nInputs = 1;
			INPUT pInputs[1] = { input };

			UINT result = ::SendInput(nInputs, pInputs, sizeof(input));

			return result != 0;
		};
};