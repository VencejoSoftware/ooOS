[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/VencejoSoftware/ooOS.svg?branch=master)](https://travis-ci.org/VencejoSoftware/ooOS)

# ooOS - Object pascal operation system library
Code to get operation system information

### Example to get computer and user name
```pascal
  ShowMessage(TOSComputerName.New.Value + #13 + TOSUserName.New.Value);
```

### Example to get CPU speed
```pascal
  ShowMessage(FloatToStr(TOSCPUSpeed.New.Frequency));
```

### Example to get CPU vendor
```pascal
  ShowMessage(TOSCPUVendor.New.Value);
```

### Example to get hard drive serial number
```pascal
  ShowMessage(TOSDriveSerial.New('C').Value);
```

### Example to get environment variable
```pascal
  ShowMessage(TOSEnvironmentInfo.New.ValueByKey('COMPUTERNAME'));
```

### Example to get local IP address/MAC address
```pascal
  ShowMessage(TOSLocalIP.New.Value + #13 + TOSLocalMacAddress.New.Value);
```

### Documentation
If not exists folder "code-documentation" then run the batch "build_doc". The main entry is ./doc/index.html

### Demo
Before all, run the batch "build_demo" to build proyect. Then go to the folder "demo\build\release\" and run the executable.

## Dependencies
* [generics.collections](https://github.com/VencejoSoftware/generics.collections.git) - FreePascal Generics.Collections library

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*