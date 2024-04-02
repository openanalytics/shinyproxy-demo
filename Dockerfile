FROM openanalytics/r-ver:4.3.3

LABEL maintainer="Tobias Verbeke <tobias.verbeke@openanalytics.eu>"

COPY Rprofile.site /usr/local/lib/R/etc/

# system libraries of general use
RUN apt-get update && apt-get install --no-install-recommends -y \
    pandoc \
    pandoc-citeproc \
    libcairo2-dev \
    libxt-dev \
    && rm -rf /var/lib/apt/lists/*

# system library dependency for the euler app
RUN apt-get update && apt-get install --no-install-recommends -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -q -e "options(warn=2); install.packages(c('shiny'))"

# install dependencies of the euler app
RUN R -q -e "options(warn=2); install.packages('Rmpfr')"

# install R code
COPY euler /build/euler
RUN R CMD INSTALL /build/euler

EXPOSE 3838

CMD ["R", "-q", "-e", "euler::runShiny()"]
