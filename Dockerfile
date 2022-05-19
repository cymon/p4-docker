# v 0.1
# Dockerfile for p4-phylogenetics
# Executable with an optional run file in the $(pwd) or will go interactive if
# not specified
# docker run -it --rm -v "$PWD:$PWD" -w "$PWD" cymon/p4-phylogenetics
# 19 May 2022

FROM alpine

# runtime dependencies
RUN set -eux; \
    apk add --no-cache \
        ca-certificates \
        tzdata \
        ;

RUN apk add --no-cache --update \
        bash \
        build-base \
        cmake \
        curl \
        python3 \
        python3-dev \
        py3-wheel \
        git \
        gsl \
        gsl-dev \
        libgcc \
        libquadmath \
        musl \
        libgfortran \
        lapack-dev \
        gfortran \
        py3-numpy-dev \
        py3-scipy \
        ; \
    \
    python3 -m ensurepip --upgrade; \
    pip3 install --upgrade pip; \
    pip3 install bitarray; \
    \
    mkdir /src && cd /src; \
    curl -L -O https://github.com/stevengj/nlopt/archive/refs/tags/v2.7.1.tar.gz; \
    tar zxvf v2.7.1.tar.gz; \
    cd nlopt-2.7.1 && mkdir build && cd build && cmake .. && make && make install; \
    \
    cd && mkdir src && cd src; \
    git clone https://github.com/pgfoster/p4-phylogenetics.git p4-git; \
    cd p4-git && python3 setup.py build_ext -i; \
    cd;

ENV PYTHONPATH /root/src/p4-git
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/src/p4-git/bin

ENTRYPOINT ["p4"]
