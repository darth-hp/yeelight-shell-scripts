# Yeelight Shell Scripts

Control Xiaomi Mi Yeelight (RGB) with shell scripts. Should work under any recent Linux with a `bash` or `zsh` - sorry, don't know if that works under Windows/CygWin or Macos - you might need to rewrite the last line in the `yeelight.sh` script (e.g. by pipeing the output to `netcat`).

## License

Copyright [2016] [Heinz Peter Hippenstiel]

Licensed under the Apache License, Version 2.0 (the "License"); you may not use the files in this repository except in compliance with the License. You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>  
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Setup

You need to connect the light using the Yeelight app (or using any other appropriate way) to your network. Then enable `Developer Mode` (or `LAN Control Mode` in the current version of the app) for the light. This setting may need to be reset after a firmware update. You should also make sure that your DHCP server always assigns the same IP address to the light.

Now edit the `yeelight-ips` file and enter the IP address of each light you have, separated by a space.

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

## Integration with redshift

`yeelight-redshift.sh` is a script that allows your lamp to change color temperature simultaneously with your monitor if you use [redshift](http://jonls.dk/redshift/). Just like redshift, this script eases strain on your eyes if you use your computer at night. To use this script you need to copy `./samples/yeelight-redshift.timer` and `./samples/yeelight-redshift.service` to `/etc/systemd/system/`, change scrip location in `yeelight-redshift.service`. Then run `sudo systemctl daemon-reload`, `sudo systemctlt enable yeelight-redshift.timer`, `sudo systemctl start yeelight-redshift.timer`.

You can also change some values in `yeelight-redshift.sh` if you need warmer color. 

For the script to work you need to have redshift installed.

Contributed by [Maxim Mishukov](https://github.com/maksmeshkov)

## HA-Bridge and Amazon Alexa

I am personally using this scripts on a Synology NAS with a running [HA-Bridge](https://github.com/bwssytems/ha-bridge/).
Since the scripts don't require any additional tool or access rights you can just execute them directly from the HA-Bridge.
Make sure the scripts are executable (`chmod +x *.sh`) and either you are using the full path or put them somewhere inside $PATH, for example `/usr/local/bin/`.

I have setup different scenes as devices for the same light. There is a `bedroom` device which can be switched on/off and use the dim feature - this is just a normal setup. And there is also a `sleep` and a `rainbow` device that addresses the same light to apply this scenes.

`yeelight-disco.sh` is a wrapper that only accepts one value - I use `${intensity.percent}` from HA-Bridge. There is some math done with that value to fit into the 2-99% range (Strange: I can't tell Alexa to use 1 or 100%) and still have some 'disco-speed'. Adjust to your needs.
