LOCAL ?= /scratch/jtravis/packages
SRC ?= ${LOCAL}/src

CURL ?= curl --socks5-hostname localhost:1080
MVN ?= mvn -DsocksProxyHost=localhost -DsocksProxyPort=1080

include makefile.d/*.mk
