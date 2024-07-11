# dotfiles

> [!WARNING]
> This configuration is a work in progress, and is intended for personal use only

## Quirks

- Trashing via Thunar will only work on persisted directories, else it will ask to permanently delete the file. This is because persisted directories are on their own zfs dataset. As the trash folder is a persisted directory, it is on the same filesystem as any other persisted directories. This means any ephemeral files / folders cannot be trashed via thunar, however these will be deleted next boot anyway. The `trash` command is able to delete across datasets it seems though

## Acknowledgements

[fufexan](https://github.com/fufexan/dotfiles)