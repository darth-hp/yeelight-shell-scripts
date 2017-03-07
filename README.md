# yeelight-shell-scripts
Control Xiaomi Mi Yeelight (RGB) with bash scripts. Should work under any recent Linux with a `bash` - sorry, don't know if that works under CygWin - you might need to rewrite the last line in the `yeelight.sh` script (e.g. by pipeing the output to `netcat`).

## Setup
You need to connect the light using the Yeelight app (or using any other appropriate way) to your network. Then enable `Developer Mode` for the light. You should also make sure that your DHCP server always assigns the same IP address to the light.

Now edit the `yeelight.sh` script and enter the IP address of each light you have separated by a space.

## Running
Each of the `yeelight-*.sh` scripts has a specific function that is hopefully quite easy to guess from it's name. All the scripts call the `yeelight.sh` script that really does the job. Each script requires several parameters - calling them without any will give you a usage prompt. All scripts require the `ID` of a light - this is the position of the light you entered in the setup part. The first light has the `ID` 0.

## Examples
Switch on (to last used values)
```ShellSession
./yeelight-scene.sh 0 On
```

Switch on using 4300 Kelvin
```ShellSession
./yeelight-scene.sh 0 4300
```

Switch on Rainbow
```ShellSession
./yeelight-scene.sh 0 Rainbow
```

Switch on Disco
```ShellSession
./yeelight-scene.sh 0 Disco
```

Switch on Disco with 120ms
```ShellSession
DISCOSPEED=120 ./yeelight-scene.sh 0 Disco
```

Set brightness to 50%
```ShellSession
./yeelight-brightness.sh 0 50
```

Set RGB color to BLUE (using absolut number, decimal and hex triples)
```ShellSession
./yeelight-rgb.sh 0 255
./yeelight-rgb.sh 0 0,0,255
./yeelight-rgb.sh 0 x0,0,ff
```

Set hue (hsv) to 32 (yellow) with 80% brightness (of that color - 0 means full white)
```ShellSession
./yeelight-hue.sh 0 32 80
```

Set color temperature to 6500 Kelvin
```ShellSession
./yeelight-colortemp.sh 0 6500
```

## HA-Bridge and Amazon Alexa
I am personally using this scripts on a Synology NAS with a running [HA-Bridge](https://github.com/bwssytems/ha-bridge/).
Since the scripts don't require any additional tool or access rights you can just execute them directly from the HA-Bridge.
Make sure the scripts are executable (`chmod +x *.sh`) and either you are using the full path or put them somewhere inside $PATH, for example `/usr/local/bin/`.

I have setup different scenes as devices for the same light. There is a `bedroom` device which can be switched on/off and use the dim feature - this is just a normal setup. And there is also a `sleep` and a `rainbow` device that addresses the same light to apply this scenes.
