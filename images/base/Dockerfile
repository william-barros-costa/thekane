FROM alpine

ENV HOME=/home/kane
ENV XDG_CONFIG_HOME=/home/kane/.config

COPY apk.txt /tmp/packages.txt
RUN apk add --no-cache $(tr '\n' ' ' < /tmp/packages.txt)

# Install neovim
RUN git clone 'https://github.com/neovim/neovim.git' "/tmp/neovim"
WORKDIR /tmp/neovim
RUN make -j 20
RUN make install


