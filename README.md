# yeelight-shell-scripts
Control Xiaomi Mi Yeelight (RGB) with bash scripts. Should work under any recent Linux with a `bash` - sorry, don't know if that works under CygWin - you might need to rewrite the last line in the `yeelight.sh` script (e.g. by pipeing the output to `netcat`).

## Setup
You need to connect the light using the Yeelight app (or using any other appropriate way) to your network. Then enable `Developer Mode` for the light. You should also make sure that your DHCP server always assigns the same IP address to the light.

Now edit the `yeelight.sh` script and enter the IP address of each light you have separated by a space.

## Running
Each of the `yeelight-*.sh` scripts has a specific function that is hopefully quite easy to guess from it's name. All the scripts call the `yeelight.sh` script that really does the job. Each script requires several parameters - calling them without any will give you a usage prompt. All scripts require the `ID` of a light - this is the position of the light you entered in the setup part. The first light has the `ID` 0.

## Examples
Switch on (to last used values)
`./yeelight-scene.sh 0 On`

Switch on using 4300 Kelvin
`./yeelight-scene.sh 0 4300`

Switch on Rainbow
`./yeelight-scene.sh 0 Rainbow`

Set brightness to 50%
`./yeelight-brightness.sh 0 50`

Set RGB color to BLUE (using absolut number, decimal and hex triples)
`yeelight-rgb.sh 0 255`
`yeelight-rgb.sh 0 0,0,255`
`yeelight-rgb.sh 0 x0,0,ff`

Set hue (hsv) to 32 (yellow) with 80% brightness (of that color - 0 means full white)
`./yeelight-hue.sh 0 32 80`

Set color temperature to 6500 Kelvin
`./yeelight-colortemp.sh 0 6500`

