#!/bin/bash

repo_url=$(git config --get remote.origin.url)

if [[ "$repo_url" == git@github.com:* ]]; then
    repo_path=${repo_url#git@github.com:}
elif [[ "$repo_url" == https://github.com/* ]]; then
    repo_path=${repo_url#https://github.com/}
else
    echo "Error: Could not determine repository name from Git config."
    exit 1
fi

repo_path=${repo_path%.git}
repo_name=$(basename "$repo_path")

echo "Using repository path: github.com/$repo_path"
echo "Using executable name: $repo_name"

go mod init "github.com/$repo_path"

# Check if Makefile exists
sed -i "s|__GOMODNAME__ |github.com/$repo_path/cmd/$repo_name|g" "Makefile"
mv cmd/__EXECUTABLE__ cmd/$repo_name
mv .env.sample .env
sed -i "s|__EXECUTABLE__|$repo_name|g" "Makefile"
sed -i "s|__EXECUTABLE__|$repo_name|g" "README.md"
sed -i "s|__EXECUTABLE__|$repo_name|g" ".gitignore"

rm -rf $0
exit 0
