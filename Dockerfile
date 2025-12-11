FROM ghcr.io/swissdatasciencecenter/renku-frontend-buildpacks/run-image:0.2.2

ENV HOME=/home/renku
ARG VERSION=2.4.0
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    libudunits2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log
# RUN chown -R ${CNB_USER_ID} ${HOME}
# Install mamba
COPY _download_micromamba.sh _download_rstudio.sh /usr/local/bin/
RUN chmod uo+rx /usr/local/bin/_download_micromamba.sh /usr/local/bin/_download_rstudio.sh
# RUN chown ${CNB_USER_ID} /usr/local/bin/_download_micromamba.sh
RUN /usr/local/bin/_download_micromamba.sh
RUN /usr/local/bin/_download_rstudio.sh
USER ${CNB_USER_ID}

RUN micromamba shell init --shell bash --root-prefix=~/.local/share/mamba

# install the python dependencies
COPY environment.yml /tmp/
RUN micromamba env update -q -f /tmp/environment.yml && \
    micromamba clean -y --all && \
    micromamba env export -n "root"

USER root
RUN ln -s /home/renku/.local/share/mamba/bin/R /usr/local/bin
USER ${CNB_USER_ID}

# RUN micromamba env update -q -f /tmp/environment.yml && \
#     micromamba clean -y --all &&
#     micromamba env export -n "root" && \
#     rm -rf ${HOME}/.renku/venv
# RUN R -e "install.packages(c('sf', 'skimr'), repos='https://cloud.r-project.org')"

COPY rstudio-entrypoint.sh jupyterlab-entrypoint.sh /usr/local/bin/
# COPY opendata /usr/local/bin/opendata
# COPY templates /usr/local/bin/templates
