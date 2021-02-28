# Dockerfile (preprocessed w/ m4)
# vim: ts=3 sw=3 noet

ifdef(`M4_BASE_IMAGE', `', `errprint(`M4_BASE_IMAGE is not defined; exiting.
')m4exit(`1')')dnl
ifdef(`M4_USER', `', `errprint(`M4_USER is not defined; exiting.
')m4exit(`1')')dnl

FROM M4_BASE_IMAGE
LABEL maintainer="François Lamboley <fload@me.com>"
LABEL description="Test of Frizlab’s conf for M4_BASE_IMAGE`'ifelse(M4_USER, `root', `, installed for root', `, installed for a user named “M4_USER”')."


# ca-certificates is needed to be able to clone the conf repo
# build-essential, clang and file are for brew (https://docs.brew.sh/Homebrew-on-Linux#debian-or-ubuntu)
RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	ccrypt \
	clang \
	curl \
	file \
	git \
	locales \
	m4 \
	zsh \
&& rm -rf /var/lib/apt/lists/*


COPY --chown=root:root test-frizlabs-conf.sh /usr/local/bin/test-frizlabs-conf.sh


ifelse(M4_USER, `root'dnl
, # Root install, we work in root home
WORKDIR /root
, `#' User install`,' we create an arbitrary user named "M4_USER"
RUN useradd "M4_USER" && mkdir "/home/M4_USER" && chown "M4_USER:users" "/home/M4_USER"
# Before changing user; we generate the locale for UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
USER "M4_USER:users"

WORKDIR "/home/M4_USER"
)dnl


# Clone of the repository
RUN git clone --depth 1 --recursive "https://github.com/Frizlab/frizlabs-conf.git"

# We copy the inputs in tmp, they’ll be retrieved in the next step
COPY --chown=M4_USER:users inputs /tmp/inputs

# Config
RUN \
	cd frizlabs-conf && \
	mkdir -p .cache && \
	cp /tmp/inputs/.pass1 .cache/.pass1 && \
	cp /tmp/inputs/.pass2 .cache/.pass2 && \
	cp /tmp/inputs/.pass3 .cache/.pass3 && \
	cp /tmp/inputs/computer_group .cache/computer_group && \
	rm -fr /tmp/inputs

# This is set to an arbitrary, always different, value in the docker build
# invocation to force re-building after this line.
ARG CACHEBUST=1

# We run the install here in a separate step to avoid re-cloning the whole repo
# if that fails.
RUN cd frizlabs-conf && git fetch && git merge && ./install


# We launch bash in non-login interactive mode by default. The caller can add -l
# when starting the docker to get a login shell and have the .bash_profile and
# .profile loaded (otherwise only the .bashrc and .shrc will be loaded).
ENTRYPOINT ["/bin/bash"]
