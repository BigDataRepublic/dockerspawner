#!/bin/sh
set -e
if getent passwd $USER_ID > /dev/null ; then
  echo "$USER ($USER_ID) exists"
else
  echo "Creating user $USER ($USER_ID)"
  useradd -u $USER_ID -s $SHELL $USER
  echo "Creating default user environment settings for conda"
  conda config --add envs_dirs /home/$USER/.conda/envs
  conda config --add channels defaults
  conda config --add channels r
  chown $USER:$USER /home/$USER/.condarc
  
  echo "Setting lib environment for user"
  echo .libPaths("/home/$USER/.R","/usr/local/lib/R/site-library" ) >> /etc/R/Rprofile.site
fi

notebook_arg=""
if [ -n "${NOTEBOOK_DIR:+x}" ]
then
    notebook_arg="--notebook-dir=${NOTEBOOK_DIR}"
fi

sudo -E PATH="${CONDA_DIR}/bin:$PATH" -u $USER jupyterhub-singleuser \
  --port=8888 \
  --ip=0.0.0.0 \
  --user=$JPY_USER \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  ${notebook_arg} \
  $@
