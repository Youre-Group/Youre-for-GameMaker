{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "cef",
  "androidactivityinject": "",
  "androidclassname": "",
  "androidcodeinjection": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidPermissions": [],
  "androidProps": false,
  "androidsourcedir": "",
  "author": "",
  "classname": "",
  "copyToTargets": 64,
  "date": "2023-07-14T13:39:49.7957507+02:00",
  "description": "",
  "exportToGame": true,
  "extensionVersion": "0.0.1",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"cefgml.dll","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_mouse_flag_raw","argCount":2,"args":[
            1,
            2,
          ],"documentation":"","externalName":"cef_mouse_flag_raw","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_mouse_event_raw","argCount":2,"args":[
            1,
            2,
          ],"documentation":"","externalName":"cef_mouse_event_raw","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_mouse_move_raw","argCount":2,"args":[
            1,
            2,
          ],"documentation":"","externalName":"cef_mouse_move_raw","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_get_focus","argCount":0,"args":[],"documentation":"","externalName":"cef_get_focus","help":"cef_get_focus()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_set_focus","argCount":1,"args":[
            2,
          ],"documentation":"","externalName":"cef_set_focus","help":"cef_set_focus(enable)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_set_size_raw","argCount":3,"args":[
            2,
            2,
            1,
          ],"documentation":"","externalName":"cef_set_size_raw","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_update_raw","argCount":0,"args":[],"documentation":"","externalName":"cef_update_raw","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_needs_redraw","argCount":0,"args":[],"documentation":"","externalName":"cef_needs_redraw","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_get_address","argCount":0,"args":[],"documentation":"","externalName":"cef_get_address","help":"cef_get_address()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_set_address","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"cef_set_address","help":"cef_set_address(url)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_get_build_time","argCount":0,"args":[],"documentation":"","externalName":"cef_get_build_time","help":"","hidden":true,"kind":11,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_set_cache_path","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"cef_set_cache_path","help":"cef_set_cache_path(path)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_set_persist_session_cookies","argCount":1,"args":[
            2,
          ],"documentation":"","externalName":"cef_set_persist_session_cookies","help":"cef_set_persist_session_cookies(set)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_init_raw","argCount":4,"args":[
            2,
            2,
            1,
            1,
          ],"documentation":"","externalName":"cef_init_raw","help":"","hidden":true,"kind":11,"returnType":2,},
      ],"init":"","kind":1,"order":[
        {"name":"cef_mouse_flag_raw","path":"extensions/cef/cef.yy",},
        {"name":"cef_mouse_event_raw","path":"extensions/cef/cef.yy",},
        {"name":"cef_mouse_move_raw","path":"extensions/cef/cef.yy",},
        {"name":"cef_get_focus","path":"extensions/cef/cef.yy",},
        {"name":"cef_set_focus","path":"extensions/cef/cef.yy",},
        {"name":"cef_set_size_raw","path":"extensions/cef/cef.yy",},
        {"name":"cef_update_raw","path":"extensions/cef/cef.yy",},
        {"name":"cef_needs_redraw","path":"extensions/cef/cef.yy",},
        {"name":"cef_get_address","path":"extensions/cef/cef.yy",},
        {"name":"cef_set_address","path":"extensions/cef/cef.yy",},
        {"name":"cef_get_build_time","path":"extensions/cef/cef.yy",},
        {"name":"cef_set_cache_path","path":"extensions/cef/cef.yy",},
        {"name":"cef_set_persist_session_cookies","path":"extensions/cef/cef.yy",},
        {"name":"cef_init_raw","path":"extensions/cef/cef.yy",},
      ],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"cef_surface","hidden":false,"value":"global.__cef_surf",},
      ],"copyToTargets":64,"filename":"cef.gml","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_preinit","argCount":0,"args":[],"documentation":"","externalName":"cef_preinit","help":"","hidden":true,"kind":11,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_init","argCount":3,"args":[
            2,
            2,
            2,
          ],"documentation":"","externalName":"cef_init","help":"cef_init(width, height, url)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_get_width","argCount":0,"args":[],"documentation":"","externalName":"cef_get_width","help":"cef_get_width()->","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_get_height","argCount":0,"args":[],"documentation":"","externalName":"cef_get_height","help":"cef_get_height()->","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_set_size","argCount":2,"args":[
            2,
            2,
          ],"documentation":"","externalName":"cef_set_size","help":"cef_set_size(width, height)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_update","argCount":-1,"args":[],"documentation":"","externalName":"cef_update","help":"cef_update(rel_mouse_x, rel_mouse_y, canmouseover = true)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_prepare_buffer","argCount":1,"args":[
            2,
          ],"documentation":"","externalName":"cef_prepare_buffer","help":"","hidden":true,"kind":11,"returnType":2,},
      ],"init":"cef_preinit","kind":2,"order":[
        {"name":"cef_preinit","path":"extensions/cef/cef.yy",},
        {"name":"cef_init","path":"extensions/cef/cef.yy",},
        {"name":"cef_get_width","path":"extensions/cef/cef.yy",},
        {"name":"cef_get_height","path":"extensions/cef/cef.yy",},
        {"name":"cef_set_size","path":"extensions/cef/cef.yy",},
        {"name":"cef_update","path":"extensions/cef/cef.yy",},
        {"name":"cef_prepare_buffer","path":"extensions/cef/cef.yy",},
      ],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"autogen.gml","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_mouse_flag","argCount":2,"args":[
            2,
            2,
          ],"documentation":"","externalName":"cef_mouse_flag","help":"cef_mouse_flag(rawFlag:int, enable:int)","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_mouse_event","argCount":2,"args":[
            2,
            2,
          ],"documentation":"","externalName":"cef_mouse_event","help":"cef_mouse_event(kind:int, time:int)->bool","hidden":false,"kind":2,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cef_mouse_move","argCount":4,"args":[
            2,
            2,
            2,
            2,
          ],"documentation":"","externalName":"cef_mouse_move","help":"cef_mouse_move(nx:int, ny:int, time:int, canmouseover:bool)->bool","hidden":false,"kind":2,"returnType":2,},
      ],"init":"","kind":2,"order":[
        {"name":"cef_mouse_flag","path":"extensions/cef/cef.yy",},
        {"name":"cef_mouse_event","path":"extensions/cef/cef.yy",},
        {"name":"cef_mouse_move","path":"extensions/cef/cef.yy",},
      ],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"chrome_100_percent.pak","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"cefgml_exe.lib","final":"","functions":[],"init":"","kind":3,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"chrome_200_percent.pak","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"cefgml_exe.exp","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"cefgml.exe","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"chrome_elf.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"libEGL.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"d3dcompiler_47.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"vk_swiftshader_icd.json","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"snapshot_blob.bin","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"vulkan-1.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"v8_context_snapshot.bin","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"resources.pak","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"vk_swiftshader.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"libGLESv2.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":64,"filename":"icudtl.dat","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"libcef.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
  ],
  "gradleinject": "",
  "hasConvertedCodeInjection": true,
  "helpfile": "",
  "HTML5CodeInjection": "",
  "html5Props": false,
  "IncludedResources": [],
  "installdir": "",
  "iosCocoaPodDependencies": "",
  "iosCocoaPods": "",
  "ioscodeinjection": "",
  "iosdelegatename": "",
  "iosplistinject": "",
  "iosProps": false,
  "iosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "license": "",
  "maccompilerflags": "",
  "maclinkerflags": "",
  "macsourcedir": "",
  "options": [],
  "optionsFile": "options.json",
  "packageId": "",
  "parent": {
    "name": "Extensions",
    "path": "folders/Extensions/YOURE/Extensions.yy",
  },
  "productId": "",
  "sourcedir": "",
  "supportedTargets": -1,
  "tvosclassname": null,
  "tvosCocoaPodDependencies": "",
  "tvosCocoaPods": "",
  "tvoscodeinjection": "",
  "tvosdelegatename": null,
  "tvosmaccompilerflags": "",
  "tvosmaclinkerflags": "",
  "tvosplistinject": "",
  "tvosProps": false,
  "tvosSystemFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
}