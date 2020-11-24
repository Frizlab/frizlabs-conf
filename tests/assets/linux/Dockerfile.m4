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
# Note: locales is installed and the locale-gen command is run to get rid of the
#       “cannot change locale” warning when setup is done (we set LC_ALL to en_US.UTF-8)
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	gcc \
	git \
	locales \
	man \
	openssl \
	python \
	python3 \
	python3-dev \
	python3-venv \
&& rm -rf /var/lib/apt/lists/* && \
	sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen


COPY --chown=root:root test-frizlabs-conf.sh /usr/local/bin/test-frizlabs-conf.sh


ifelse(M4_USER, `root'dnl
, # Root install, we work in root home
WORKDIR /root
, `#' User install`,' we create an arbitrary user named "M4_USER"
RUN useradd "M4_USER" && mkdir "/home/M4_USER" && chown "M4_USER:users" "/home/M4_USER"
USER "M4_USER:users"

WORKDIR "/home/M4_USER"
)dnl


# Clone of the repositories
# TODO: Maybe find a way to automate update of branch for ansible clone when updated in run-ansible
RUN \
	git clone --depth 1 --recursive "https://github.com/Frizlab/frizlabs-conf.git" && \
	cd frizlabs-conf && \
	mkdir -p .cache && \
	git clone --depth=1 --branch="v2.9.15" "https://github.com/ansible/ansible.git" ".cache/ansible"

# We copy the inputs in tmp, they’ll be retrieved in the next step
COPY --chown=M4_USER:users inputs /tmp/inputs

# Config
RUN \
	cd frizlabs-conf && \
	cp /tmp/inputs/.vault-id .cache/.vault-id && \
	cp /tmp/inputs/ansible_group .cache/ansible_group && \
	rm -fr /tmp/inputs

# This is set to an arbitrary, always different, value in the docker build
# invocation to force re-building after this line.
ARG CACHEBUST=1

# We run ansible here in a separate step to avoid re-cloning the whole repo if
# Ansible fails.
# We run the script with the -i option to be sure the ansible version we get is
# the one we expect in the run-ansible script.
RUN cd frizlabs-conf && git fetch && git merge && ./run-ansible -i -vvvv


# We launch bash in non-login interactive mode by default. The caller can add -l
# when starting the docker to get a login shell and have the .bash_profile and
# .profile loaded (otherwise only the .bashrc and .shrc will be loaded).
ENTRYPOINT ["/bin/bash"]
