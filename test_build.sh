#! /bin/sh

cd modules
rake clean
rake test_build
cd ..
