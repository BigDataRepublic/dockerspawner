#!/bin/sh
set -e
#Check if user home is already set
if [ -h /home/t1/data\ --\>\ Read-only ] ; then
  echo "$USER ($USER_ID) exists"
else
  #removing test user
  rm -rf /home/jovyan
  
  #adding symbolic link to data drive
  ln -s /mnt/data/ "/home/$USER/data --> Read-only"

  #echo "Creating default user environment settings for conda"
  conda config --add envs_dirs /home/$USER/.conda/envs
  conda config --add channels defaults
  conda config --add channels r

  #"Setting lib environment for user"
  mkdir /home/$USER/.R
  #Allow packages to be installed in the .R dir and found in conda and R
  echo ".libPaths(c('/home/$USER/.R'))" >> /etc/R/Rprofile.site
fi

notebook_arg=""
if [ -n "${NOTEBOOK_DIR:+x}" ]
then
    notebook_arg="--notebook-dir=${NOTEBOOK_DIR}"
fi

sudo -E PATH="${CONDA_DIR}/bin:$PATH" -u root jupyterhub-singleuser \
  --port=8888 \
  --ip=0.0.0.0 \
  --user=$USER \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  ${notebook_arg} \
  $@
