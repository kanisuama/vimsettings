#! /bin/bash

if [ ! -e ~/.vimrc ]; then
    ln -s ~/vimsettings/_vimrc ~/.vimrc
else
    overwrite=""
    while [ "${overwrite}" != "y" -a "${overwrite}" != "Y" \
         -a "${overwrite}" != "n" -a "${overwrite}" != "N" \
    ]
    do
        echo "~/.vimrcが既に存在します．上書きしますか？(y/n)"
        read overwrite
    done

    if [ "${overwrite}" = "y" -o "${overwrite}" = "Y" ]; then
        rm ~/.vimrc
        ln -s ~/vimsettings/_vimrc ~/.vimrc
    fi
fi

# if [ ! -e ~/.gvimrc ]; then
#     ln -s ~/vimsettings/_gvimrc ~/.gvimrc
# else
#     overwrite=""
#     while [ "${overwrite}" != "y" -a "${overwrite}" != "Y" \
#          -a "${overwrite}" != "n" -a "${overwrite}" != "N" \
#     ]
#     do
#         echo "~/.gvimrcが既に存在します．上書きしますか？(y/n)"
#         read overwrite
#     done
# 
#     if [ "${overwrite}" = "y" -o "${overwrite}" = "Y" ]; then
#         rm ~/.gvimrc
#         ln -s ~/vimsettings/_gvimrc ~/.gvimrc
#     fi
# fi

