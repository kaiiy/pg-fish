FROM ubuntu:23.10

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y \
    build-essential \
    curl \
    git 

RUN yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH $PATH:/home/linuxbrew/.linuxbrew/bin

RUN brew install gcc fish
RUN fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

WORKDIR /
RUN git clone https://github.com/kaiiy/dotfiles.git

WORKDIR /dotfiles
RUN ./link.sh
RUN brew bundle --file=./etc/brew/Brewfile
RUN fish -c "fisher update"
RUN fish -c "tide configure --auto --style='Lean' --prompt_colors='True color' --show_time='No' --lean_prompt_height='One line' --prompt_spacing='Compact' --icons='Few icons' --transient='No'"