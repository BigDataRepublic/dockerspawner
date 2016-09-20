# Build as jupyterhub/systemuser
# Run with the DockerSpawner in JupyterHub

FROM jupyterhub/singleuser

MAINTAINER Project Jupyter <jupyter@googlegroups.com>

USER root
WORKDIR /home
RUN userdel jovyan && rm -rf /home/jovyan
ENV SHELL /bin/bash
ADD systemuser.sh /srv/singleuser/systemuser.sh
# smoke test entrypoint
RUN USER_ID=65000 USER=systemusertest sh /srv/singleuser/systemuser.sh -h && userdel systemusertest
# Added ssh client for github connect
RUN apt-get update && apt-get install -y openssh-client
# Install nb_conda for managing conda environments in jupyterhub
RUN conda install -y -c anaconda-nb-extensions nb_conda=1.0.0

#R kernel installion---------

#Removing lbxml2 from conda 
RUN conda remove -y libxml2

#add fork of debian mirror to source.list for r3.3.1
RUN echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list

#update library list with new mirror
RUN apt-get update
RUN apt-get install r-base -y --force-yes

#Install required external libs
RUN apt-get install curl libssl-dev libssh2-1-dev libcurl4-openssl-dev xml2 libxml2-dev libgmp3-dev pkg-config -y

#Install Required libs for jupyterhub integration
RUN R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'),  lib='/usr/lib/R/library', repos = 'http://cran.case.edu' )"

#Install R-essential package
RUN R -e "install.packages(c('caret', 'data.table', 'dplyr', 'ggplot2', 'glmnet', 'jsonlite', 'plyr','quantmod','randomForest','rbokeh','rmarkdown','shiny','tidyr','zoo'), lib='/usr/lib/R/library', repos = 'http://cran.case.edu' )"

#Install R-recommended package
RUN R -e "install.packages(c('boot', 'class', 'cluster', 'codetools', 'foreign', 'KernSmooth', 'lattice','MASS','Matrix','mgcv','nlme','nnet','rpart','spatial','survival'), lib='/usr/lib/R/library', repos = 'http://cran.case.edu' )"

#Install jupyterhub integration
RUN R -e "devtools::install_github('IRkernel/IRkernel')"
RUN R -e "IRkernel::installspec(user = FALSE)"

ADD user.sh /srv/singleuser/user.sh

CMD ["sh", "/srv/singleuser/user.sh"]

#Update sudo rights to all users
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN alias sudo='sudo env PATH=$PATH'
