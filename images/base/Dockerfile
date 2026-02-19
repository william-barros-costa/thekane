FROM alpine

ENV HOME=/home/kane
ENV XDG_CONFIG_HOME=/home/kane/.config
ENV PATH="$HOME/.cargo/bin:${PATH}"
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

WORKDIR /tmp

# Install packages
COPY resources/packages.txt .
RUN apk add --no-cache $(tr '\n' ' ' < packages.txt)

# Install icons
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip \
    && mkdir -p /usr/share/fonts/opentype/nerd-fonts \
    && unzip /tmp/FiraCode.zip -d /usr/share/fonts/opentype/nerd-fonts/ \
    && fc-cache -fv

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install neovim
ARG NVIM_REF=HEAD
RUN git clone https://github.com/neovim/neovim.git \
 && cd neovim \
 && git checkout "$NVIM_REF"

WORKDIR /tmp/neovim

RUN make -j 20
RUN make install

RUN rm -rf /tmp/FiraCode.zip /tmp/FiraCode /tmp/neovim

WORKDIR $HOME
