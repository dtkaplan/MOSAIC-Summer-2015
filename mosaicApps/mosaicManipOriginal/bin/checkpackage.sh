#! /bin/bash
export _R_CHECK_FORCE_SUGGESTS_=false
bin/roxy -p "." 
mv *_*.tar.gz builds/
R CMD build .
bin/do2all "R CMD check %p" *_*.tar.gz
