## SlimeVR patches

### make-support-helper-optional.patch

Patches the desktop file exec entry with a workaround for the SlimeVR GUI not launching when using an Nvidia GPU on Wayland

https://github.com/tauri-apps/tauri/issues/9394

> `Gdk-Message: 23:55:52.007: Error 71 (Protocol error) dispatching to Wayland display.`
> Requires to have WEBKIT_DISABLE_DMABUF_RENDERER=1 in the environment, it seems to happen on Wayland