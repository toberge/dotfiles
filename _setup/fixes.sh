echo "Fix IntelliJ's fishy problem"
sudo rm -r /opt/intellij-idea-ultimate-edition/plugins/terminal/fish
sudo ln -s ~/.config/fish/ /opt/intellij-idea-ultimate-edition/plugins/terminal/fish
