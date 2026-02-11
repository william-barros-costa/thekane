FROM ghcr.io/william-barros-costa/base:latest

ARG MASON_TOOLS="yamlfmt,yamllint,gitlab-ci-ls,yq"

ENV PATH="/root/.cargo/bin:$PATH"
ENV MASON_TOOLS=${MASON_TOOLS}

COPY nvim $XDG_CONFIG_HOME/nvim

RUN nvim --headless +Lazy! sync +qa
RUN nvim --headless -c "MasonToolsInstallSync" -c 'qa'
