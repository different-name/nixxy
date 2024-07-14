# system

System level configuration

| Folder                    | Description                                       |
| ------------------------- | ------------------------------------------------- |
| [`hosts`](system/hosts)   | Host specific configuration                       |
| [`global`](system/global) | Configurations used on all hosts                  |
| [`extra`](system/extra)   | Optional configurations used on one or more hosts |

[`global`](system/global) & [`extra`](system/extra) folders are further divided into categories:

| Folder        | Description                                            |
| ------------- | ------------------------------------------------------ |
| `core`        | Core configurations, including boot, security, users   |
| `hardware`    | Controls hardware, such as Bluetooth, video cards, etc |
| `nix`         | Nix-related options                                    |
| `programs`    | `programs.*` configuration                             |
| `services`    | `services.*` configurtaion                             |