# processing-4-mode

**Note:** This is a fork of the original [processing-3-mode](https://github.com/motform/processing-3-mode) by Love Lagerkvist.
This mode has been upgraded for compatibility with Processing 4.
                                                                       
A minimalist major mode for Processing 4, leveraging the processing command line interface.
It provides convenient access to compiler features and some basic development 
niceties, such as p4-aware keyword font locking.


## Installation 

The mode requires [Processing 4.4](https://processing.org/) and was tested using Emacs 30 and Arch Linux.

If you want processing-4-mode to automatically start when opening `.pde` files,
add the following snippet to your init file.

```elisp
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-4-mode))
```


## Customization

You can enable any of the flags supported by `processing cli`.

| Flag                       | Values                                                                                                                    |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------|
| `processing-4-no-java`     | `nil` (default), `t`                                                                                                      |
| `processing-4-force`       | `nil` (default), `t`                                                                                                      |
| `processing-4-variant`     | `nil` (default), `'linux-amd64`, `'linux-arm'`, `'linux-aarch64'`, `'macosx-aarch64`, `'macosx-x86_64'`, `'windows-amd64` |
| `processing-4-compile-key` | `'run` (default), `'build`, `'present`, `'export`                                                                         |
| `processing-4-args`        | `""` (default), any string                                                                                                |

`processing-4-args` is a string used to add command-line arguments.
As this is most likely file-dependent, it can be useful to add these using buffer local variables.
Below is an example using the block quote syntax.

```processing
/* Local Variables:                   */
/* mode: processing-4                 */
/* processing-4-args: "300 400"       */
/* End:                               */

void setup() {

// etc
```

## Keymap

The following keybindings are provided out of the box.

| Function                | Keymap    |
| ---                     | ---       |
| run                     | `C-c C-r` |
| build                   | `C-c C-b` |
| present                 | `C-c C-p` |
| export                  | `C-c C-e` |
| compile-cmd             | `C-c C-c` |

`compile-cmd` (`C-c C-c`) is meant as a convenience bind to whatever build function you use the most. 
It is controlled by `processing-4-compile-cmd` and defaults to `'run`.


## Limitations
* There is currently no way to install libraries from the CLI tool, and thus no way to do that from within Emacs.
* Outputting to a directory other than the current one is not supported.
* There is only support for running Processing in Java mode.
* The export command only works correctly if the `processing-4-variant` custom variable is set to one of the options.
