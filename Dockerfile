FROM ubuntu:23.10

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    curl \
    git 

RUN useradd -m dev && \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R dev:dev /home/linuxbrew/.linuxbrew && \
    chmod -R 755 /home/linuxbrew/.linuxbrew

USER dev

RUN yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH $PATH:/home/linuxbrew/.linuxbrew/bin

RUN brew install gcc fish && \
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

WORKDIR /home/dev/
RUN git clone https://github.com/kaiiy/dotfiles.git

WORKDIR /home/dev/dotfiles
RUN ./link.sh && \
    brew bundle --file=./etc/brew/Brewfile && \
    fish -c "fisher update" && \
    fish -c "tide configure --auto --style='Lean' --prompt_colors='True color' --show_time='No' --lean_prompt_height='One line' --prompt_spacing='Compact' --icons='Few icons' --transient='No'"

