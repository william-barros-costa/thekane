ARG BUILD_IMAGE=ghcr.io/william-barros-costa/base:latest

FROM ${BUILD_IMAGE}

ARG MASON_TOOLS="yamlfmt,yamllint,gitlab-ci-ls,yq"

ENV PATH="/root/.cargo/bin:$PATH"
ENV MASON_TOOLS=${MASON_TOOLS}

COPY nvim $XDG_CONFIG_HOME/nvim
COPY tmux $XDG_CONFIG_HOME/tmux

RUN git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm

RUN nvim --headless +Lazy! sync +qa
RUN nvim --headless -c "MasonToolsInstallSync" -c 'qa'
