#!/usr/bin/env bash

adb -d shell "run-as com.example.bluera cat /data/data/com.example.bluera/app_flutter/BlueRa.db" > BlueRa.db

echo Done.
