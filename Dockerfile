FROM ocaml/opam:debian-12-ocaml-4.04 AS build

USER root
RUN apt-get update && apt-get -y --no-install-recommends install \
    pkg-config \
    libgdbm-compat-dev \
    libgdbm-dev \
    libgmp-dev \
    libpcre3-dev \
    libsqlite3-dev \
    zlib1g-dev
RUN mkdir /opt/sulci && chown opam:opam /opt/sulci

USER opam
RUN opam install \
    ocamlfind.1.9.6 \
    oasis.0.4.11 \
    dbm.1.3 \
    ocamlnet.4.1.9-2 \
    ulex.1.2 \
    cryptokit.1.14 \
    json-static.0.9.8 \
    pcre.7.4.1 \
    sqlite3.4.3.2 \
    text.0.8.1 \
    erm_xml.0.3

RUN curl --location https://github.com/ermine/xmpp/archive/refs/tags/v0.4.tar.gz | tar xzf - \
    && cd xmpp-0.4 \
    && opam exec -- ocaml setup.ml -configure \
    && opam exec -- ocaml setup.ml -build \
    && opam exec -- ocaml setup.ml -install

COPY --chown=opam:opam \
    AUTHORS.txt \
    brb.conf \
    configure \
    Makefile \
    myocamlbuild.ml \
    _oasis \
    setup.ml \
    _tags \
    sulci.conf.example.ab \
    ./sulci/
COPY --chown=opam:opam fcgi ./sulci/fcgi
COPY --chown=opam:opam lang ./sulci/lang
COPY --chown=opam:opam libs ./sulci/libs
COPY --chown=opam:opam src ./sulci/src
COPY --chown=opam:opam tlds ./sulci/tlds
COPY --chown=opam:opam utils ./sulci/utils

RUN cd sulci \
    && opam exec -- oasis setup \
    && opam exec -- ocaml setup.ml -configure --prefix /opt/sulci \
    && opam exec -- ocaml setup.ml -build \
    && opam exec -- ocaml setup.ml -install

RUN curl --location https://raw.githubusercontent.com/0x6368656174/iqTranslate/45302cb3657442fd069f86d9670c1640011ec4ed/Mueller24.koi \
    --output /opt/sulci/share/sulci/Mueller24.koi


FROM debian:12-slim
LABEL org.opencontainers.image.source=https://github.com/selim13/sulci

RUN apt-get update && apt-get -y --no-install-recommends install \
    libgdbm-compat4 \
    libgdbm6 \
    libpcre3 \
    libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -d /var/sulci -s /bin/bash sulci
RUN mkdir -p /var/sulci && chown sulci:sulci /var/sulci
COPY --from=build /opt/sulci/bin/sulci /usr/bin/sulci
COPY --from=build /opt/sulci/share/sulci /usr/share/sulci
USER sulci
WORKDIR /var/sulci
CMD [ "/usr/bin/sulci", "-c", "/etc/sulci/sulci.conf" ]