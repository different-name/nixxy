# home

Home level configuration

> [!WARNING]
> This configuration is only intended for use with a single user
> I do not need multiple users, and do not want to introduce unnecessary complexity

| Folder                  | Description                                            |
| ----------------------- | ------------------------------------------------------ |
| [`hosts`](home/hosts)   | Host specific home configuration                       |
| [`global`](home/global) | Home configurations used on all hosts                  |
| [`extra`](home/extra)   | Optional home configurations used on one or more hosts |

[`global`](home/global) & [`extra`](home/extra) folders are further divided into categories:

| Folder            | Description                                   |
| ----------------- | --------------------------------------------- |
| `programs`        | Programs, games, media, etc                   |
| `services`        | Services                                      |
| `terminal`        | Terminal programs, shells, emulators, etc     |