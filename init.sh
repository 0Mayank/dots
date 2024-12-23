#!/bin/bash

DOTFILES_DIR="$1"  # First argument is the source dotfiles directory
CONFIG_LIST="$2"    # Second argument is the path to the list file
CONFIG_DIR="$HOME/.config"  # Target directory

if [ -z "$DOTFILES_DIR" ] || [ -z "$CONFIG_LIST" ]; then
    echo "Usage: $0 <dotfiles_directory> <list_file>"
    echo "Example: $0 ~/dotfiles config_list.txt"
    echo -e "\nList file should contain one filename/directory per line"
    exit 1
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Error: Directory '$DOTFILES_DIR' does not exist"
    exit 1
fi

if [ ! -f "$CONFIG_LIST" ]; then
    echo "Error: List file '$CONFIG_LIST' does not exist"
    exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating ~/.config directory..."
    mkdir -p "$CONFIG_DIR"
fi

# Convert to absolute paths
DOTFILES_DIR=$(cd "$DOTFILES_DIR" && pwd)

echo "Creating symlinks from $DOTFILES_DIR to $CONFIG_DIR"
echo "Using config list from: $CONFIG_LIST"
echo "---------------------------------------------------"

create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if target already exists
    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            echo "⚠️  Symlink already exists: $target"
            return
        else
            echo "⚠️  File/directory already exists: $target"
	    echo -n "Do you want to backup and replace it? (y/n): "
	    read  -n 1 -p "Input Selection:" ans < /dev/tty
	    if [[ $ans =~ ^[Yy]$ ]]; then
		mv "$target" "${target}.backup"
		echo "Created backup: ${target}.backup"
	    else
		echo "Skipping: $target"
		return
	    fi	
	fi
    fi 
    # Create the symlink
    ln -s "$source" "$target"
    echo "✅ Created symlink: $target -> $source"
}

# Read the list file and create symlinks
while IFS= read -r item || [ -n "$item" ]; do
    # Skip empty lines and comments
    [[ -z "$item" || "$item" =~ ^[[:space:]]*# ]] && continue
    
    # Remove any leading/trailing whitespace
    item=$(echo "$item" | xargs)
    
    source="$DOTFILES_DIR/$item"
    target="$CONFIG_DIR/$item"
    
    # Check if the source exists
    if [ ! -e "$source" ]; then
        echo "❌ Error: Source does not exist: $source"
        continue
    fi
    
    create_symlink "$source" "$target"
done < "$CONFIG_LIST"

echo "---------------------------------------------------"
echo "Done! Check above for any warnings or errors."
