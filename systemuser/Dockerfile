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

CMD ["sh", "/srv/singleuser/systemuser.sh"]
