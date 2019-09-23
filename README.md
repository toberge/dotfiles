```
         __      __  _____ __         
    ____/ /___  / /_/ __(_) /__  _____
   / __  / __ \/ __/ /_/ / / _ \/ ___/
 _/ /_/ / /_/ / /_/ __/ / /  __(__  ) 
(_)__,_/\____/\__/_/ /_/_/\___/____/  
                                      
```

# *totally qualified dotfiles*
## Using GNU stow with simple packages

## Naming convention:

```
package
_no-package
```
...just do
```bash
stow <package>
```
to install

## pywal pipeline

`wal -R` in i3conf to reload colors&wallpaper from cache, wal sets wallpaper by itself.

See [pywal's Getting Started page](https://github.com/dylanaraps/pywal/wiki/Getting-Started#applying-the-theme-to-new-terminals) for the two snippets I put in .bashrc to make terminals that do not fetch colors from .Xresources have pywal colors, including TTYs.  
Using [this script](https://github.com/GideonWolfe/Zathura-Pywal) to make Zathura comply.

When setting new theme (function in .bashrc):  
`wal -i <image>` obviously  
`wal_steam` if Steam is installed  

## *links and credits*

*Based on [F-dotfiles](https://github.com/Kraymer/F-dotfiles)*


[text to ASCII](http://www.patorjk.com/software/taag/#p=display&f=Slant&t=.dotfiles)  
