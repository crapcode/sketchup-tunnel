Ugly hack that makes use of the undocumented SKSocket class to communicate with standard IDEs.
Put the tunnel_skp.rb file into your Sketchup plugins directory.
Put the tunnel_ide.rb file somewhere in your IDE program folder.
Configure your IDE so that upon building scripts it issues system command like...

ruby [full_path]/tunnel_ide.rb [full path to your main script]

*Ruby must be installed on system
*localhost:1517 must be free

"print" and "p" are not captured by the plugin.  Use puts.
