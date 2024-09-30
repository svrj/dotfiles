INSTALL_PATH="$HOME/.local/share"
LUA_VERSION="5.4.7"
LUAROCKS_VERSION="3.11.1"
LUAROCKS="$INSTALL_PATH/luarocks.tar.gz"
LUA="$INSTALL_PATH/lua.tar.gz"

if [ ! -d "$INSTALL_PATH" ]; then
    mkdir -p "$INSTALL_PATH"
fi

if [ -d "$INSTALL_PATH/lua-$LUA_VERSION" ]; then
    echo "Lua is already installed"
    echo "remove $INSTALL_PATH/lua-$LUA_VERSION to reinstall"
else
    wget https://www.lua.org/ftp/lua-"$LUA_VERSION".tar.gz -O "$LUA" --progress=bar
    (cd "$INSTALL_PATH" && tar --extract --gzip --file "$LUA" && cd "$INSTALL_PATH/lua-"$LUA_VERSION"/" && sudo make linux install)
fi

if [ -d "$INSTALL_PATH/luarocks-"$LUAROCKS_VERSION"" ]; then
    echo "Luarocks is already installed"
    echo "remove $INSTALL_PATH/luarocks-$LUAROCKS_VERSION to reinstall"
else
    wget http://luarocks.github.io/luarocks/releases/luarocks-"$LUAROCKS_VERSION".tar.gz -O "$LUAROCKS" --progress=bar
    (cd "$INSTALL_PATH" && tar --extract --gzip --file "$LUAROCKS" && cd "$INSTALL_PATH/luarocks-"$LUAROCKS_VERSION"/" && ./configure && make && sudo make install)
fi

INIT_LUA_PATH="$HOME/.config/nvim/init.lua"

if [ -L "$INIT_LUA_PATH" ] || [ -f "$INIT_LUA_PATH" ]
then
    echo "$INIT_LUA_PATH already exists"
else
    ln -sr init.lua "$INIT_LUA_PATH"
fi
