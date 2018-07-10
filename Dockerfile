FROM gapsystem/gap-docker-master:francy

MAINTAINER Manuel Martins <manuelmachadomartins@gmail.com>

COPY --chown=1000:1000 . $HOME/subgrouplattice

RUN ln -s $HOME/subgrouplattice $HOME/inst/gap-master/pkg/subgrouplattice

USER gap

WORKDIR $HOME/subgrouplattice/notebooks
