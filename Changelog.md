0.5.0
-----------
- MDB supports now start and stop commands
- fixed issue in slug building when .env file is appended into build env

0.4.1
-----------
- fix mar local:build_slug against remote docker
- allow to set personal access token via --token option

0.4.0
-----------
- Add support for slug upload & deploy functionality: qtc-cli mar slug:upload ...; qtc-cli mar slug:deploy v1.2

0.3.1
-----------
- Fix mar local:build_slug


0.3.0
-----------

- Add support for cloud vpn
- Add support for stack change
- Refactor cli to use cloud tokens
- Remove MWS support

0.2.0
-----------

- Add support for executing ad-hoc commands inside MAR applications: qtc-cli mar exec
- Add support for local debugging of MAR applications (using docker): qtc-cli mar local:run
- Add initial MDB commands: qtc-cli mdb list/logs
