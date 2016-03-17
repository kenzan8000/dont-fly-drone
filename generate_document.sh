#!/bin/bash

apidoc -i server/app/controllers -o document/API
chmod 755 document/API/index.html
