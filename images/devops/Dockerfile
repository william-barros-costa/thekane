FROM alpine

ENV HOME=/home/kane
ENV XDG_CONFIG_HOME=/home/kane/.config

COPY ./images/devops/apk.txt /tmp/packages.txt
RUN apk add --no-cache $(tr '\n' ' ' < /tmp/packages.txt)

# Install neovim
RUN git clone 'https://github.com/neovim/neovim.git' "$HOME/neovim"
WORKDIR /home/kane/neovim
RUN make -j 20
RUN make install

