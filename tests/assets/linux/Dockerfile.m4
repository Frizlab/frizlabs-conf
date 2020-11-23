# Dockerfile (preprocessed w/ m4)
# vim: ts=3 sw=3 noet

ifdef(`M4_BASE_IMAGE', `', `errprint(`M4_BASE_IMAGE is not defined; exiting.
')m4exit(`1')')dnl
ifdef(`M4_USER', `', `errprint(`M4_USER is not defined; exiting.
')m4exit(`1')')dnl

FROM M4_BASE_IMAGE
LABEL maintainer="François Lamboley <fload@me.com>"
LABEL description="Test of Frizlab’s conf for M4_BASE_IMAGE`'ifelse(M4_USER, `root', `, installed for root', `, installed for a user named “M4_USER”')."


# Note: openssl is a dependency of ca-certificates and could be removed from the list
# Note: python (2) is needed only to activate the Python3 virtualenv (AFAICT)
# Note: gcc is for some pip installs. And it MUST be gcc, not clang *facepalm*
# Note: python3-dev is for some pip installs (obviously)
# Note: python3-venv is required to get the virtual env support in python3
# Note: man is apparently needed to setup Ansible
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	gcc \
	git \
	man \
	openssl \
	python \
	python3 \
	python3-dev \
	python3-venv \
&& rm -rf /var/lib/apt/lists/*


COPY test-frizlabs-conf.sh /usr/local/bin/test-frizlabs-conf.sh


ifelse(M4_USER, `root'dnl
, # Root install, we work in root home
WORKDIR /root
, `#' User install`,' we create an arbitrary user named "M4_USER"
RUN useradd "M4_USER" && mkdir "/home/M4_USER" && chown "M4_USER:users" "/home/M4_USER"
USER "M4_USER:users"

WORKDIR "/home/M4_USER"
)dnl


# We copy the inputs in tmp, they’ll be retrieved in the next step
COPY inputs /tmp/inputs

# In theory the first line of the run should be enough to checkout the repo, but
# it turns out git fails fetching the tags for submodules and thus fails the
# checkout of the submodules (might be a GitHub issue).
RUN \
	( \
		git clone --depth 1 --recursive "https://github.com/Frizlab/frizlabs-conf.git" || \
		( cd frizlabs-conf && git submodule foreach --recursive 'git fetch --tags' && git submodule update --recursive ) \
	) && \
	cd frizlabs-conf && \
	mkdir -p .cache && \
	cp /tmp/inputs/.vault-id .cache/.vault-id && \
	cp /tmp/inputs/ansible_group .cache/ansible_group

# We run ansible here in a separate step to avoid re-cloning the whole repo if
# Ansible fails.
# TODO: Re-fetch git because it might have changed since previous test was launched
RUN cd frizlabs-conf && ./run-ansible -vvvv


# We launch bash in non-login interactive mode by default. The caller can add -l
# when starting the docker to get a login shell and have the .bash_profile and
# .profile loaded (otherwise only the .bashrc and .shrc will be loaded).
ENTRYPOINT ["bash"]
