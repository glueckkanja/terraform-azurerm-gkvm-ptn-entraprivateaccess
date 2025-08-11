SHELL := /bin/bash

$(shell curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/Azure/tfmod-scaffold/v0.69.0/avmmakefile" -o avmmakefile)
-include avmmakefile