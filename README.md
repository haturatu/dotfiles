# dotfiles

---

## 1. Check commands in `.bashrc`

Before installing, it's recommended to check whether the commands used in `.bashrc` exist on your system:

```sh
make checkcmd
```

This helps ensure there won’t be missing command errors after applying the configuration.

---

## 2. Backup existing configuration

Back up your current configuration files before installing:

```sh
make backup
```

This command backs up the following files to `~/.dotfiles_backup`:

- `.bashrc`
- `.bash_profile`
- `.vimrc`
- `.vim/` (directory)

---

## 3. Install configurations

Install both `bash` and `vim` configurations:

```sh
make install
```

To install only the `bash` configurations:

```sh
make bash
```

To install only the `vim` configurations:

```sh
make vim
```

---

## 4. Clean up

Remove the installed symbolic links:

```sh
make clean
```

---

## Available Makefile Commands

| Command         | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `make all`      | The default task. Executes `install`.                                       |
| `make install`  | Installs both `bash` and `vim` configurations.                              |
| `make bash`     | Installs only the `bash` configuration (`.bashrc`, `.bash_profile`).        |
| `make vim`      | Installs only the `vim` configuration (`.vimrc`, `.vim/`).                  |
| `make checkcmd` | Checks if the commands written in `.bashrc` exist on the system.            |
| `make clean`    | Removes the installed configuration files (symbolic links).                 |
| `make backup`   | Backs up existing configuration files to the `~/.dotfiles_backup` directory. |

