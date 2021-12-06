#!/usr/bin/env bash

adb -d shell "run-as de.uni_marburg.ds.bluera cat /data/data/de.uni_marburg.ds.bluera/app_flutter/BlueRa.db" > BlueRa.db

echo Done.
