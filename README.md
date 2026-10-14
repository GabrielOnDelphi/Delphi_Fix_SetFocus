# Alternative for Delphi's broken SetFocus

CanFocus is broken in Delphi. It has always been.

Try to set focus on a visual control that is disabled or is invisible or simply is not focusable, and the program will crash.
This tool batch replaces Delphi’s SetFocus with a safer alternative.

Full project description [here](https://gabrielmoraru.com/setfocus-is-broken-in-delphi/)

To compile it you need the [LightSaber](https://github.com/GabrielOnDelphi/Delphi-LightSaber) library and FastMM4. The Debug build also uses the optional [Autopilot for Delphi](https://gabrielmoraru.com/my-delphi-code/autopilot-for-delphi/) bridge, which lets an AI assistant drive the running app.

