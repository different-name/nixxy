# system

System level configuration

| Folder                    | Description                                       |
| ------------------------- | ------------------------------------------------- |
| [`hosts`](hosts)   | Host specific configuration                       |
| [`global`](global) | Configurations used on all hosts                  |
| [`extra`](extra)   | Optional configurations used on one or more hosts |

[`global`](global) & [`extra`](extra) folders are further divided into categories:

| Folder        | Description                                            |
| ------------- | ------------------------------------------------------ |
| `core`        | Core configurations, including boot, security, users   |
| `hardware`    | Controls hardware, such as Bluetooth, video cards, etc |
| `nix`         | Nix-related options                                    |
| `programs`    | `programs.*` configuration                             |
| `services`    | `services.*` configurtaion                             |