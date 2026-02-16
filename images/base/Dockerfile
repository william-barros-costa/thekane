FROM alpine

ARG NVIM_REF=HEAD
ENV HOME=/home/kane
ENV XDG_CONFIG_HOME=/home/kane/.config
ENV PATH="$HOME/.cargo/bin:${PATH}"

WORKDIR /tmp

COPY resources/packages.txt .
RUN apk add --no-cache $(tr '\n' ' ' < packages.txt)

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install neovim
RUN git clone https://github.com/neovim/neovim.git \
 && cd neovim \
 && git checkout "$NVIM_REF"

# RUN make -j 20
# RUN make install
