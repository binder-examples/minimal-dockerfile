# Minimal Dockerfiles for Binder

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/binder-examples/minimal-dockerfile/master)

Binder needs only one thing to work:

- to be able to launch `jupyter notebook` as a specified user (passed via docker build args as NB_UID/NB_USER)

What this means in practice is that the `notebook` package must be installed and on PATH:

```docker
RUN pip install --no-cache notebook
```

That's *almost* everything.

The remaining pieces is that the specified user must be able to *start* the notebook,
which requires certain permissions like being able to write to the home directory.

The absolute bare minimum for this is to set HOME to `/tmp` so that it's writable,
which would make the shortest, smallest dockerfile:

```docker
FROM python:3.7-slim
RUN pip install --no-cache notebook
ENV HOME=/tmp
```

which you can try out: [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/binder-examples/minimal-dockerfile/truly-minimal)

However, it would be better to consume the NB_UID/NB_USER arguments and create a real user:

```docker
# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
```
