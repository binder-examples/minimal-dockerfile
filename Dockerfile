FROM python:3.6
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook
ENV HOME /tmp
