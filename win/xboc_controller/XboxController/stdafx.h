// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#include <string>
#include <fstream>
#include <iostream>
#include <stdio.h>
#include <new.h>
#include <tchar.h>
#include <windows.h>
#include <vector>

#include <windows.h>
#include <XInput.h>

#pragma comment(lib, "XInput.lib")

#include "Enums.h"
#include "XboxButtonMapper.h"
#include "XboxButtonMapperFactory.h"
#include "MappingManager.h"
#include "SendInputBase.h"
#include "KeyBoardSendInput.h"
#include "MouseSendInput.h"
#include "XboxButtonReader.h"